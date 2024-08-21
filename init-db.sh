#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE TABLE agenda (
        id SERIAL PRIMARY KEY,
        data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        concluido BOOLEAN NOT NULL DEFAULT FALSE,
        data_finalizado TIMESTAMP,
        observacao TEXT NOT NULL
    );
EOSQL