CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users(
    id              SERIAL                      PRIMARY KEY,    -- id пользователя
    version         BIGINT          NOT NULL    DEFAULT 1,      -- версия 
    full_name       VARCHAR(100)    NOT NULL,   CHECK (char_length(full_name) BETWEEN 3 AND 100), -- ФИО
    phone_number    VARCHAR(15)                 CHECK ( 
        phone_number ~ '^\+[0-9]+$' --проверка номера чтобы начиналось на + и (от 0 до 9 )  
        AND 
        char_length(phone_number)   BETWEEN 10 AND 15 
    )
);

CREATE TABLE todoapp.tasks(
    id              SERIAL                      PRIMARY KEY, -- id задачи
    version         BIGINT          NOT NULL    DEFAULT 1,
    title           VARCHAR(100)    NOT NULL    CHECK(char_length(title) BETWEEN 1 AND 100),        -- заголовок 
    description     VARCHAR(1000)               CHECK(char_length(description) BETWEEN 1 AND 1000), -- описание
    completed       BOOLEAN         NOT NULL,   -- завершена ли задача
    created_at      TIMESTAMPTZ     NOT NULL,   -- время создания
    completed_at    TIMESTAMPTZ,                -- время завершения

    CHECK( -- проверка на завершенное время выполнения задачи
        (completed = FALSE AND completed_at IS NULL)
        OR
        (completed = TRUE AND completed_at IS NOT NULL AND completed_at >= created_at)
    ),

    author_id       INTEGER         NOT NULL    REFERENCES todoapp.users(id) --вторичный ключ id автора
);
