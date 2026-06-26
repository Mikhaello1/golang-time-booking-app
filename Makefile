include .env
export 

export PROJECT_ROOT := $(shell pwd)


env-up:
	docker compose up -d timebookingapp-postgres

env-down:
	docker compose down timebookingapp-postgres

env-cleanup:
		@read -p "Очистить все volume файлы окружения? Опасность утери данных. [y/n]: " ans; \
		if [ "$$ans" = "y" ]; then \
			docker compose down timebookingapp-postgres && \
			sudo rm -rf out/pgdata && \
			echo "Файлы окружения очищены"; \
		else \
			echo "Очистка окружения отменена"; \
		fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Отсутствует параметр seq. Пример make migrate-create seq=ВАШЕ_ЗНАЧЕНИЕ"; \
		exit 1; \
	fi; \
	docker compose run --rm timebookingapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down

force-dirty-db:
	docker compose run --rm timebookingapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@timebookingapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		force 1


migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Отсутствует параметр action. Пример make migrate-action action=ВАШЕ_ЗНАЧЕНИЕ"; \
		exit 1; \
	fi; \
	docker compose run --rm timebookingapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@timebookingapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"

make-port-forward:
	@docker compose up -d port-forwarder

make-port-close:
	@docker compose down port-forwarder

down-all:
	@make env-down 
	@make env-cleanup 
	@make make-port-close
