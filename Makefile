createMigration:
	migrate create -ext sql -dir db/migration -seq init_schema

postgres:
	docker run --name postgresdb1 -p 5440:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
interactdb:
	docker exec -it postgresdb1 psql -U root
logdb:
	docker logs postgresdb1
stopDb:
	docker stop postgresdb1
shellDb:
	docker exec -it postgresdb1 /bin/sh
	# inside container shell
	# createdb --username=root --owner=root simple_bank
	# psql simple_bank
# enters psql and \q to exit. Then...
	# dropdb simple_bank
	# exit 
createdb:
	docker exec -it postgresdb1 createdb --username=root --owner=root simple_bank
dropdb:
	docker exec -it postgresdb1 dropdb simple_bank

accessdbpsql:
	docker exec -it postgresdb1 psql -U root simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" -verbose down
sqlc:
	sqlc generate
	
.PHONY: postgres createdb dropdb migrateup migratedown sqlc
