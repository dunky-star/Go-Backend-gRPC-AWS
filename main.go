package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

const (
	dbDriver      = "postgres"
	dbSource      = "postgresql://postgres:cluster@1@localhost:5432/u_bank?sslmode=disable"
	serverAddress = "0.0.0.:9090"
)

func main() {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil{
		log.Fatal("Cannot connect to DB: ", err)
	}

	store := db.NewStore(conn)
}
