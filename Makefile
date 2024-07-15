DB_URL=postgresql://postgres:cluster@1@localhost:5432/u_bank?sslmode=disable

postgres:
	docker run -it -d --name postgres_container --network springbankNet -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=cluster@1 -p 5432:5432 -v /var/lib/docker/basedata:/var/lib/postgresql/data -v d:/pgdata/largedb:/mnt/largedb postgres:latest
createdb:
	docker exec -it postgres_container createdb --username=postgres --owner=postgres u_bank

dropdb:
	docker exec -it postgres_container dropdb --username=postgres u_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/dbml.sql

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=u_bank \
	proto/*.proto
	statik -src=./doc/swagger -dest=./doc

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc db_docs db_schema test server new_migration proto
 