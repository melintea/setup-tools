///usr/bin/env go run "$0" "$@"; exit $?

// Sample go pseudo-script

// Another way:
//
// #!/bin/sh
// exec go run "$0" "$@"
// !#
//

package main

import "fmt"

func main() {
    fmt.Printf("Good script")
}

