postgres:
	docker run -it -d --name postgres_container --network springbankNet -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=cluster@1 -p 5432:5432 -v /var/lib/docker/basedata:/var/lib/postgresql/data -v d:/pgdata/largedb:/mnt/largedb postgres:latest
createdb:
	docker exec -it postgres_container createdb --username=postgres --owner=postgres u_bank

dropdb:
	docker exec -it postgres_container dropdb --username=postgres u_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:cluster@1@localhost:5432/u_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://postgres:cluster@1@localhost:5432/u_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test
 