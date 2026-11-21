include .env
export

pg-up:
	docker compose up -d todoapp-postgres

pg-down:
	docker compose down todoapp-postgres

pg-cleanup:
	docker compose down todoapp-postgres && rmdir /s /q "out/data"

migrate-create:
	docker compose run --rm todoapp-postgres-migrate create -ext sql -dir /migrations -seq "$(seq)"

migrate-action:
	docker compose run --rm todoapp-postgres-migrate -path /migrations -database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable "$(action)"

migrate-up:
	$(MAKE) migrate-action action=up

migrate-down:
	$(MAKE) migrate-action action=down 1

migrate-force:
	docker compose run --rm todoapp-postgres-migrate -path /migrations -database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable force "$(version)"

port-forward:
	docker compose up -d port-forwarder

port-close:
	docker compose down -d port-forwarder