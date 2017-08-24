package main

import (
	"keyserver/keyapi"
	"log"
	"os"
)

func main() {
	_, onstop, err := keyapi.Run("/etc/hyades/keyserver/keyserver.conf", ":20557", log.New(os.Stderr, "[keyserver] ", log.LstdFlags))
	if err != nil {
		log.Fatal(err)
	} else {
		log.Fatal(<-onstop)
	}
}