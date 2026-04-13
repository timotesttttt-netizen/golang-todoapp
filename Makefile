include .env #подключаем env с user password и db от postgres
export

export PROJECT_ROOT=$(CURDIR) #$(CURDIR) = print working directory, shell = выполни команду


#запуск сервиса
# -d это detech mode
env-up:
	@docker compose up -d todoapp-postgres

#остановка сервиса
env-down: 
	@docker compose down todoapp-postgres 


# очистка volumes postgres
#rm - это shell команда удалить файл или директорию 
#-rf, здесь r рекурсировное удаление f это выполнение без подтверждения
# fi это конец ветвления 
env-cleanup:
	@bash -c '\
	read -r -p "Clean environment files? Risk of data loss. [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "Environment files cleaned"; \
	else \
		echo "Cleanup cancelled"; \
	fi'



env-port-forward:
	@docker compose up -d port-forwarder


env-port-close:
	@docker compose down port-forwarder



# использовать можно так make migrate-create seq=значение
migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Not have param seq. Example:  make migrate-create seq=version imigration"; \
		exit 1; \
	fi; \
	MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL="*" docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"
	

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down


migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Missing param action. Example: make migrate-action action=up"; \
		exit 1; \
	fi; \
	MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL="*" docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable" \
		$(action)


todoapp-run:
	@go run cmd/todoapp/main.go