///usr/bin/env go run "$0" "$@"; exit $?

//
// TURN client script. Uses https://github.com/pion/turn/releases
// Run at a cygwin prompt: ./client-script.go
//

package main

import (
    "flag"
    "fmt"
    "log"
    "net"
    "strings"
    "strconv"
    "time"

    // https://stackoverflow.com/questions/41539909/cannot-find-package-github-com-gorilla-mux-in-any-of/41540554
    // cd %GOPATH%
    // go list ... | grep github.whatever
    // go get -v -u github.whatever
    "github.com/pion/logging"
    "github.com/pion/stun"
    "github.com/pion/turn"
)

// Human-readable Message
func MessageAsString(msg *stun.Message) (string) {
    retstr := msg.String() + "\n"

    //type RawAttribute struct {
    //    Type   AttrType //uint16
    //    Length uint16   // ignored while encoding
    //    Value  []byte
    //}

    attributes := msg.Attributes
    for _, attr := range attributes {
        var addrStr string

        if attr.Type == stun.AttrXORMappedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORPeerAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORRelayedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrAlternateServer {
            addr := new(stun.AlternateServer); addr.GetFrom(msg); addrStr = net.JoinHostPort(addr.IP.String(), strconv.Itoa(addr.Port))
        }
        if attr.Type == stun.AttrOtherAddress {
            addr := new(stun.OtherAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORMappedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORMappedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORMappedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }
        if attr.Type == stun.AttrXORMappedAddress {
            addr := new(stun.XORMappedAddress); addr.GetFrom(msg); addrStr = addr.String()
        }

        retstr += "  " + attr.String() + " [" + addrStr + "]\n"
    }

    return retstr
}

// stunLogger wraps a PacketConn and prints incoming/outgoing STUN packets
// This pattern could be used to capture/inspect/modify data as well
type stunLogger struct {
    net.PacketConn
}

func (s *stunLogger) WriteTo(p []byte, addr net.Addr) (n int, err error) {
    log.Printf("<<< to %s:\n", addr.String())

    msg := &stun.Message{Raw: p}
    if err = msg.Decode(); err != nil {
        log.Println(err)
        return
    }

    //[ Add an atttribute
	if err = stun.NewSoftware("CustomPionTurnClient").AddTo(msg); err != nil {
        log.Println(err)
		return
	}

	msg.Encode()
	p = msg.Raw
    //] Add an atttribute

    if n, err = s.PacketConn.WriteTo(p, addr); err == nil && stun.IsMessage(p) {
        log.Printf("%s\n", MessageAsString(msg))
    }

    if err != nil {
        log.Println(err)
    }
    return
}

func (s *stunLogger) ReadFrom(p []byte) (n int, addr net.Addr, err error) {
    if n, addr, err = s.PacketConn.ReadFrom(p); err == nil && stun.IsMessage(p) {
        log.Printf(">>> from %s:\n", addr.String())
        msg := &stun.Message{Raw: p}
        if err = msg.Decode(); err != nil {
            log.Println(err)
            return
        }

        log.Printf("%s\n", MessageAsString(msg))
    }

    if err != nil {
        log.Println(err)
    }
    return
}

func main() {
    host  := flag.String("host", "10.254.64.207", "TURN Server name.")
    port  := flag.Int("port", 3478, "Listening port.")
    user  := flag.String("user", "user=pass", "A pair of username and password (e.g. \"user=pass\")")
    realm := flag.String("realm", "pion.ly", "Realm (defaults to \"pion.ly\")")
    ping  := flag.Bool("ping", false, "Run ping test")

    flag.PrintDefaults()
    flag.Parse()

    if len(*host) == 0 {
        log.Fatalf("'host' is required")
    }

    if len(*user) == 0 {
        log.Fatalf("'user' is required")
    }

    cred := strings.Split(*user, "=")

    log.Println("Client connecting to ", *host, ":", *port)
    log.Println(flag.Args()) // Remaining args

    // TURN client won't create a local listening socket by itself.
    conn, err := net.ListenPacket("udp4", "0.0.0.0:0")
    if err != nil {
        panic(err)
    }
    defer func() {
        if closeErr := conn.Close(); closeErr != nil {
            panic(closeErr)
        }
    }()

    turnServerAddr := fmt.Sprintf("%s:%d", *host, *port)

    cfg := &turn.ClientConfig{
        STUNServerAddr: turnServerAddr,
        TURNServerAddr: turnServerAddr,
        Conn:           &stunLogger{conn},
        Username:       cred[0],
        Password:       cred[1],
        Realm:          *realm,
        LoggerFactory:  logging.NewDefaultLoggerFactory(),
    }

    client, err := turn.NewClient(cfg)
    if err != nil {
        panic(err)
    }
    defer client.Close()

    // Start listening on the conn provided.
    err = client.Listen()
    if err != nil {
        panic(err)
    }

    // Allocate a relay socket on the TURN server. On success, it
    // will return a net.PacketConn which represents the remote
    // socket.
    relayConn, err := client.Allocate()
    if err != nil {
        panic(err)
    }
    defer func() {
        if closeErr := relayConn.Close(); closeErr != nil {
            panic(closeErr)
        }
    }()

    // The relayConn's local address is actually the transport
    // address assigned on the TURN server.
    log.Printf("relayed-address=%s", relayConn.LocalAddr().String())

    // If you provided `-ping`, perform a ping test agaist the
    // relayConn we have just allocated.
    if *ping {
        err = doPingTest(client, relayConn)
        if err != nil {
            panic(err)
        }
    }
}

func doPingTest(client *turn.Client, relayConn net.PacketConn) error {
    // Send BindingRequest to learn our external IP
    mappedAddr, err := client.SendBindingRequest()
    if err != nil {
        return err
    }

    // Set up pinger socket (pingerConn)
    pingerConn, err := net.ListenPacket("udp4", "0.0.0.0:0")
    if err != nil {
        panic(err)
    }
    defer func() {
        if closeErr := pingerConn.Close(); closeErr != nil {
            panic(closeErr)
        }
    }()

    // Punch a UDP hole for the relayConn by sending a data to the mappedAddr.
    // This will trigger a TURN client to generate a permission request to the
    // TURN server. After this, packets from the IP address will be accepted by
    // the TURN server.
    _, err = relayConn.WriteTo([]byte("Hello"), mappedAddr)
    if err != nil {
        return err
    }

    // Start read-loop on pingerConn
    go func() {
        buf := make([]byte, 1500)
        for {
            n, from, pingerErr := pingerConn.ReadFrom(buf)
            if pingerErr != nil {
                break
            }

            msg := string(buf[:n])
            if sentAt, pingerErr := time.Parse(time.RFC3339Nano, msg); pingerErr == nil {
                rtt := time.Since(sentAt)
                log.Printf("%d bytes from from %s time=%d ms\n", n, from.String(), int(rtt.Seconds()*1000))
            }
        }
    }()

    // Start read-loop on relayConn
    go func() {
        buf := make([]byte, 1500)
        for {
            n, from, readerErr := relayConn.ReadFrom(buf)
            if readerErr != nil {
                break
            }

            // Echo back
            if _, readerErr = relayConn.WriteTo(buf[:n], from); readerErr != nil {
                break
            }
        }
    }()

    time.Sleep(500 * time.Millisecond)

    // Send 10 packets from relayConn to the echo server
    for i := 0; i < 10; i++ {
        msg := time.Now().Format(time.RFC3339Nano)
        _, err = pingerConn.WriteTo([]byte(msg), relayConn.LocalAddr())
        if err != nil {
            return err
        }

        // For simplicity, this example does not wait for the pong (reply).
        // Instead, sleep 1 second.
        time.Sleep(time.Second)
    }

    return nil
}
