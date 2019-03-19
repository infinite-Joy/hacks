#!/usr/bin/env bash
set -e

if [ -z "$CONTAINER_COMMAND" ]; then
  echo "ERROR: Airflow container command is missing, aborting..."
fi

echo "COMMAND: $CONTAINER_COMMAND $CONTAINER_ARGS"
echo "this is the ip: ${LOCAL_IP4}"

AIRFLOW_HOME="/usr/local/airflow"
CMD="airflow"
TRY_LOOP="10"

echo "${AIRFLOW_HOME}, ${CMD}, ${TRY_LOOP}"

# The following is true for safety. Just override it locally
: ${AIRFLOW_AUTHENTICATE:="True"}

: ${REMOTE_LOG_PATH:=""}
: ${DB_HOST:="postgres"}
: ${DB_PORT:="5432"}
: ${DB_USERNAME:="airflow"}
: ${DB_PASSWORD:="airflow"}
: ${DB_NAME:="airflow"}
# : ${QUEUE_HOST:="redis"}
: ${QUEUE_HOST:="$LOCAL_IP4"}
: ${QUEUE_PORT:="6379"}
: ${QUEUE_NAME:="0"}
: ${QUEUE_PASSWORD:=""}
: ${QUEUE_USERNAME:=""}
: ${FLASK_SECRET_KEY:="FLASK_SECRET_PLACEHOLDER"}
: ${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}
: ${BASE_URL:="http://localhost:8080"}

# Use variables to construct certain replacement strings
SQL_ALCHEMY_CONN="postgresql+psycopg2://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
BROKER_URL="redis://:${QUEUE_PASSWORD}@${QUEUE_HOST}:${QUEUE_PORT}/${QUEUE_NAME}"
CELERY_RESULT_BACKEND="db+postgresql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"

echo "${SQL_ALCHEMY_CONN}, ${BROKER_URL}, ${CELERY_RESULT_BACKEND}"

sed "s*<AIRFLOW_HOME>*$AIRFLOW_HOME*g; s*<AIRFLOW_AUTHENTICATE>*$AIRFLOW_AUTHENTICATE*g; s*<REMOTE_LOG_PATH>*$REMOTE_LOG_PATH*g; s*<SQL_ALCHEMY_CONN>*$SQL_ALCHEMY_CONN*g; s*<FERNET_KEY>*$FERNET_KEY*g; s*<BASE_URL>*$BASE_URL*g; s*<FLASK_SECRET_KEY>*$FLASK_SECRET_KEY*g; s*<BROKER_URL>*$BROKER_URL*g; s*<CELERY_RESULT_BACKEND>*$CELERY_RESULT_BACKEND*g;" < ${AIRFLOW_HOME}/airflow.cfg.template > ${AIRFLOW_HOME}/airflow.cfg

if [ "$CONTAINER_COMMAND" = "webserver" ] || [ "$CONTAINER_COMMAND" = "worker" ] || [ "$CONTAINER_COMMAND" = "scheduler" ] ; then
  # Wait for DB
  i=0
  while ! nc $DB_HOST $DB_PORT >/dev/null 2>&1 < /dev/null; do
    i=$((i+1))
    if [ $i -ge $TRY_LOOP ]; then
      echo "$(date) - ERROR: ${DB_HOST}:${DB_PORT} still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for ${DB_HOST}:${DB_PORT}... $i/$TRY_LOOP"
    sleep 5


    sleep 5
  done
fi

if [ "$CONTAINER_COMMAND" = "webserver" ]; then
  # echo "Generating webserver config"
  echo "Initializing airflow database..."
  $CMD initdb
  echo "CREATING USER......"
  $CMD webserver
fi

echo "USER created..."
echo "$QUEUE_HOST $QUEUE_PORT"

if [ "$CONTAINER_COMMAND" = "webserver" ] || [ "$CONTAINER_COMMAND" = "worker" ] || [ "$CONTAINER_COMMAND" = "scheduler" ] ; then
  # Wait for redis
  i=0
  while ! ((printf "PING\r\n"; sleep 1) | nc -w 1 $QUEUE_HOST $QUEUE_PORT); do
    i=$((i+1))
    if [ $i -ge $TRY_LOOP ]; then
      echo "$(date) - ERROR: ${QUEUE_HOST}:${QUEUE_PORT} still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for ${QUEUE_HOST}:${QUEUE_PORT}... $i/$TRY_LOOP"
    sleep 5
  done
fi

if [ "$CONTAINER_COMMAND" != "webserver" ] ; then
    exec $CMD $CONTAINER_COMMAND $CONTAINER_ARGS
fi
