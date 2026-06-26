CREATE SCHEMA timebookapp;   

CREATE TABLE timebookapp.users (
    id                SERIAL               PRIMARY KEY,
    version           BIGINT      NOT NULL DEFAULT 1,
    nickname          VARCHAR(25) NOT NULL UNIQUE CHECK(char_length(nickname) BETWEEN 1 AND 25),  
    password          VARCHAR     NOT NULL,  
    registrated_at    TIMESTAMP   NOT NULL,
    is_admin          BOOLEAN, 
    avatar            VARCHAR
);

CREATE TABLE timebookapp.slots (
    id             SERIAL         PRIMARY KEY,
    version        BIGINT         NOT NULL     DEFAULT 1,
    time           TIMESTAMP      NOT NULL,
    name           VARCHAR (100)  CHECK(char_length(name) BETWEEN 1 AND 100),
    description    VARCHAR (1000) CHECK(char_length(description) BETWEEN 1 AND 1000),
    is_booked      BOOLEAN        NOT NULL     DEFAULT FALSE,
    booked_at      TIMESTAMP

    CHECK (
        (is_booked=FALSE AND booked_at IS NULL)
        OR
        (is_booked=TRUE AND booked_at IS NOT NULL)
    ),

    user_id_booked INTEGER REFERENCES timebookapp.users(id)

);

CREATE TABLE timebookapp.slot_participants (
    id             SERIAL           PRIMARY KEY,
    version        BIGINT  NOT NULL DEFAULT 1,
    slot_id        INTEGER NOT NULL REFERENCES timebookapp.slots(id),
    participant_id INTEGER NOT NULL REFERENCES timebookapp.users(id)
);