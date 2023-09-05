///usr/bin/env go run "$0" "$@"; exit $?

//
// Parse pcap data to a plantuml sequence diagram of ICE packets
// Run at a cygwin prompt: 
//    ./ice-pcap2uml.go -pcapfile ./edge-relay.pcap > ice.uml
//    _plantuml ice.uml ==> result is ice.svg
//

package main

import (
    "flag"
    "fmt"
    "log"
    "net"
    //"io"
    //"regexp"
    "strings"
    "strconv"

    // https://stackoverflow.com/questions/41539909/cannot-find-package-github-com-gorilla-mux-in-any-of/41540554
    // cd %GOPATH%
    // go list ... | grep github.whatever
    // go get -v -u github.whatever
    "github.com/pion/stun"
    "github.com/google/gopacket"
    "github.com/google/gopacket/layers"
    "github.com/google/gopacket/pcap"
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
            // Some TURN servers do not XOR Peer Addresses?
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

        retstr += "  " + attr.String() + " [" + addrStr + "]\n"
    }

    return retstr
}

func handlePacket(numPacket int, packet gopacket.Packet) {
    // https://www.devdungeon.com/content/packet-capture-injection-and-analysis-gopacket

    ipLayer  := packet.Layer(layers.LayerTypeIPv4)
    udpLayer := packet.Layer(layers.LayerTypeUDP)
    if ipLayer == nil || udpLayer == nil {
        //log.Printf("-- %v no ip/udp layer\n", numPacket);
        return
    }

    applicationLayer := packet.ApplicationLayer()
    if applicationLayer == nil {
        //log.Printf("-- %v no app layer\n", numPacket);
        return
    }

    payload := applicationLayer.Payload()
    if !stun.IsMessage(payload) {
        //log.Printf("-- %v not STUN\n", numPacket);
        return
    }

    var src, dst string

    //log.Printf("-- %v ------------\n", numPacket);
    //fmt.Println(packet)

    ip, _  := ipLayer.(*layers.IPv4)
    udp, _ := udpLayer.(*layers.UDP)
    src = fmt.Sprintf("%s:%v", ip.SrcIP, udp.SrcPort)
    dst = fmt.Sprintf("%s:%v", ip.DstIP, udp.DstPort)
    log.Printf("-- %v:  %s => %s ------------\n", numPacket, src, dst);

    var msg stun.Message
    stun.Decode(payload, &msg)

    var arrowType string
    arrowType = "->"

    var textColor string

    useCandidate := msg.Contains(stun.AttrUseCandidate)
    if useCandidate {
        arrowType = "-[#000080]>"
        textColor = "<color:blue>"
    }

    var msgStr string
    msgStr = MessageAsString(&msg)
    //log.Printf("%s\n", msgStr)

    var label string
    label = msg.String()

    if msg.Contains(stun.AttrData) {
        data, err := msg.Get(stun.AttrData)
        if err != nil {
            label  = label + " (" + err.Error() + ")"
        } else {
            var msg2 stun.Message
            stun.Decode(data, &msg2)
            msgStr = msgStr + "\\n" + MessageAsString(&msg2)
            label  = label + " (" + msg2.String() + ")"

            if msg2.Contains(stun.AttrUseCandidate) {
                arrowType = "-[#000080]>"
                textColor = "<color:blue>"
            }
        }
    }

    tooltip := strings.ReplaceAll(msgStr, "\n", "\\n")

    umlArrow := fmt.Sprintf("\"%s\" %s \"%s\" [[{{ From %s\\n To %s\\n %s }}]] : %s %v %s", src, arrowType, dst, src, dst, tooltip, textColor, numPacket, label)
    fmt.Printf("%s\n", umlArrow)
}

func main() {
    pcapFile := flag.String("pcapfile", "", ".pcap file.")

    flag.PrintDefaults()
    flag.Parse()

    if *pcapFile == "" {
        log.Fatalf("'pcapfile' is required")
    }
    log.Printf("File: ", pcapFile, "\n")

    var handle   *pcap.Handle
    var err      error

    handle, err = pcap.OpenOffline(*pcapFile)
    if err != nil {
        log.Fatalf("Cannot open ", pcapFile, ":\n", err)
    }
    defer handle.Close()

    //err = handle.SetBPFFilter("udp")
    //if err != nil { 
    //    log.Fatalf("Cannot apply the stun filter:\n", err)
    //}

    packetSource := gopacket.NewPacketSource(handle, handle.LinkType())

    fmt.Printf("'\n' Plantuml sequence diagram. \n'\n@startuml\n\n")

    numPacket := 1
    for packet := range packetSource.Packets() {
        handlePacket(numPacket, packet)  
        numPacket = numPacket + 1
    }

    fmt.Printf("\n@enduml\n")
}
