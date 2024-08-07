package gapi

import (
	"fmt"

	db "github.com/dunky-star/u_bank/db/sqlc"
	"github.com/dunky-star/u_bank/pb"
	"github.com/dunky-star/u_bank/token"
	"github.com/dunky-star/u_bank/util"
	"github.com/dunky-star/u_bank/worker"
	//"github.com/dunky-star/u_bank/worker"
)

// Server serves gRPC requests for our banking service.
type Server struct {
	pb.UnimplementedSimpleBankServer
	config          util.Config
	store           db.Store
	tokenMaker      token.Maker
	taskDistributor worker.TaskDistributor
}

// NewServer creates a new gRPC server.
func NewServer(config util.Config, store db.Store, taskDistributor worker.TaskDistributor) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:          config,
		store:           store,
		tokenMaker:      tokenMaker,
		taskDistributor: taskDistributor,
	}

	return server, nil
}