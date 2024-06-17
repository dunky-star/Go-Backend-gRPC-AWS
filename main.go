package main

import (
	"database/sql"
	"log"

	"github.com/dunky-star/u_bank/api"
	db "github.com/dunky-star/u_bank/sqlc"
	"github.com/dunky-star/u_bank/util"
	_ "github.com/lib/pq"
)

// const (
// 	dbDriver      = "postgres"
// 	dbSource      = "postgresql://postgres:cluster@1@localhost:5432/u_bank?sslmode=disable"
// 	serverAddress = "0.0.0.0:9090"
// )

func main() {
	config, err := util.LoadConfig(".")
	if err != nil{
		log.Fatal("Cannot load configuration. ", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil{
		log.Fatal("Cannot connect to DB: ", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil{
		log.Fatal("Cannot start server ", err)
	}
}
