# Demyx
# https://demyx.sh

demyx_env() {
    demyx_app_config

    [[ -z "$DEMYX_APP_CONTAINER" ]] && DEMYX_APP_CONTAINER="$(echo "$DEMYX_TARGET" | sed 's/[^a-z 0-9 A-Z]/_/g')"

    if [[ "$DEMYX_RUN_TYPE" = wp || "$DEMYX_APP_TYPE" = wp ]]; then
        [[ -z "$DEMYX_APP_COMPOSE_PROJECT" ]] && DEMYX_APP_COMPOSE_PROJECT="$(echo "$DEMYX_TARGET" | sed 's/[^a-z 0-9 A-Z -]//g')"
        [[ -z "$DEMYX_APP_ID" ]] && DEMYX_APP_ID="$(demyx util --id --raw)"
        [[ -z "$DEMYX_APP_WP_IMAGE" ]] && DEMYX_APP_WP_IMAGE=demyx/wordpress
        [[ -z "$DEMYX_APP_BEDROCK_MODE" ]] && DEMYX_APP_BEDROCK_MODE=production
        [[ -z "$DEMYX_APP_NX_CONTAINER" ]] && DEMYX_APP_NX_CONTAINER="$DEMYX_APP_COMPOSE_PROJECT"_nx_"$DEMYX_APP_ID"_1
        [[ -z "$DEMYX_APP_WP_CONTAINER" ]] && DEMYX_APP_WP_CONTAINER="$DEMYX_APP_COMPOSE_PROJECT"_wp_"$DEMYX_APP_ID"_1
        [[ -z "$DEMYX_APP_DB_CONTAINER" ]] && DEMYX_APP_DB_CONTAINER="$DEMYX_APP_COMPOSE_PROJECT"_db_"$DEMYX_APP_ID"_1
        [[ -n "$DEMYX_RUN_USER" ]] && WORDPRESS_USER="$DEMYX_RUN_USER"
        [[ -n "$DEMYX_RUN_PASSWORD" ]] && WORDPRESS_USER_PASSWORD="$DEMYX_RUN_PASSWORD"
        [[ -n "$DEMYX_RUN_EMAIL" ]] && WORDPRESS_USER_EMAIL="$DEMYX_RUN_EMAIL"
        [[ -z "$DEMYX_APP_TYPE" ]] && DEMYX_APP_TYPE=wp
        [[ -z "$DEMYX_APP_PATH" ]] && DEMYX_APP_PATH="$DEMYX_WP"/"$DEMYX_TARGET"
        [[ -z "$WORDPRESS_USER" ]] && WORDPRESS_USER="$(demyx util --user --raw)"
        [[ -z "$WORDPRESS_USER_PASSWORD" ]] && WORDPRESS_USER_PASSWORD="$(demyx util --pass --raw)"
        [[ -z "$WORDPRESS_USER_EMAIL" ]] && WORDPRESS_USER_EMAIL="info@$DEMYX_TARGET"
        [[ -z "$WORDPRESS_DB_HOST" ]] && WORDPRESS_DB_HOST="$DEMYX_APP_DB_CONTAINER"
        [[ -z "$WORDPRESS_DB_NAME" ]] && WORDPRESS_DB_NAME="$DEMYX_APP_CONTAINER"
        [[ -z "$WORDPRESS_DB_USER" ]] && WORDPRESS_DB_USER="$(demyx util --user --raw)"
        [[ -z "$WORDPRESS_DB_PASSWORD" ]] && WORDPRESS_DB_PASSWORD="$(demyx util --pass --raw)"
        [[ -z "$MARIADB_ROOT_PASSWORD" ]] && MARIADB_ROOT_PASSWORD="$(demyx util --pass --raw)"
        [[ -n "$DEMYX_RUN_SSL" ]] && DEMYX_APP_SSL="$DEMYX_RUN_SSL"
        [[ -n "$DEMYX_RUN_RATE_LIMIT" ]] && DEMYX_APP_RATE_LIMIT=false
        [[ -z "$DEMYX_APP_CACHE" ]] && DEMYX_APP_CACHE=false
        [[ -z "$DEMYX_APP_CDN" ]] && DEMYX_APP_CDN=false
        [[ -z "$DEMYX_APP_AUTH" ]] && DEMYX_APP_AUTH=false
        [[ -z "$DEMYX_APP_AUTH_WP" ]] && DEMYX_APP_AUTH_WP=false
        [[ -z "$DEMYX_APP_DEV" ]] && DEMYX_APP_DEV=false
        [[ -z "$DEMYX_APP_HEALTHCHECK" ]] && DEMYX_APP_HEALTHCHECK=true
        [[ -z "$DEMYX_APP_WP_UPDATE" ]] && DEMYX_APP_WP_UPDATE=false
        [[ -z "$DEMYX_APP_UPLOAD_LIMIT" ]] && DEMYX_APP_UPLOAD_LIMIT=128M
        [[ -z "$DEMYX_APP_PHP_PM" ]] && DEMYX_APP_PHP_PM=ondemand
        [[ -z "$DEMYX_APP_PHP_PM_MAX_CHILDREN" ]] && DEMYX_APP_PHP_PM_MAX_CHILDREN=100
        [[ -z "$DEMYX_APP_PHP_PM_START_SERVERS" ]] && DEMYX_APP_PHP_PM_START_SERVERS=10
        [[ -z "$DEMYX_APP_PHP_PM_MIN_SPARE_SERVERS" ]] && DEMYX_APP_PHP_PM_MIN_SPARE_SERVERS=5
        [[ -z "$DEMYX_APP_PHP_PM_MAX_SPARE_SERVERS" ]] && DEMYX_APP_PHP_PM_MAX_SPARE_SERVERS=25
        [[ -z "$DEMYX_APP_PHP_PM_PROCESS_IDLE_TIMEOUT" ]] && DEMYX_APP_PHP_PM_PROCESS_IDLE_TIMEOUT=5s
        [[ -z "$DEMYX_APP_PHP_PM_MAX_REQUESTS" ]] && DEMYX_APP_PHP_PM_MAX_REQUESTS=500
        [[ -z "$DEMYX_APP_PHP_MEMORY" ]] && DEMYX_APP_PHP_MEMORY=256M
        [[ -z "$DEMYX_APP_PHP_MAX_EXECUTION_TIME" ]] && DEMYX_APP_PHP_MAX_EXECUTION_TIME=300
        [[ -z "$DEMYX_APP_PHP_OPCACHE" ]] && DEMYX_APP_PHP_OPCACHE=true
        [[ -z "$DEMYX_APP_XMLRPC" ]] && DEMYX_APP_XMLRPC=false
        [[ -z "$DEMYX_APP_WP_CPU" ]] && DEMYX_APP_WP_CPU="$DEMYX_CPU"
        [[ -z "$DEMYX_APP_WP_MEM" ]] && DEMYX_APP_WP_MEM="$DEMYX_MEM"
        [[ -z "$DEMYX_APP_DB_CPU" ]] && DEMYX_APP_DB_CPU="$DEMYX_CPU"
        [[ -z "$DEMYX_APP_DB_MEM" ]] && DEMYX_APP_DB_MEM="$DEMYX_MEM"

        cat > "$DEMYX_WP"/"$DEMYX_TARGET"/.env <<-EOF
            # AUTO GENERATED
            DEMYX_APP_ID=$DEMYX_APP_ID
            DEMYX_APP_TYPE=$DEMYX_APP_TYPE
            DEMYX_APP_WP_IMAGE=$DEMYX_APP_WP_IMAGE
            DEMYX_APP_BEDROCK_MODE=$DEMYX_APP_BEDROCK_MODE
            DEMYX_APP_PATH=$DEMYX_APP_PATH
            DEMYX_APP_CONTAINER=$DEMYX_APP_CONTAINER
            DEMYX_APP_COMPOSE_PROJECT=$DEMYX_APP_COMPOSE_PROJECT
            DEMYX_APP_DOMAIN=$DEMYX_TARGET
            DEMYX_APP_SSL=$DEMYX_APP_SSL
            DEMYX_APP_RATE_LIMIT=$DEMYX_APP_RATE_LIMIT
            DEMYX_APP_AUTH=$DEMYX_APP_AUTH
            DEMYX_APP_AUTH_WP=$DEMYX_APP_AUTH_WP
            DEMYX_APP_CACHE=$DEMYX_APP_CACHE
            DEMYX_APP_CDN=$DEMYX_APP_CDN
            DEMYX_APP_DEV=$DEMYX_APP_DEV
            DEMYX_APP_HEALTHCHECK=$DEMYX_APP_HEALTHCHECK
            DEMYX_APP_WP_UPDATE=$DEMYX_APP_WP_UPDATE
            DEMYX_APP_UPLOAD_LIMIT=$DEMYX_APP_UPLOAD_LIMIT
            DEMYX_APP_PHP_MEMORY=$DEMYX_APP_PHP_MEMORY
            DEMYX_APP_PHP_MAX_EXECUTION_TIME=$DEMYX_APP_PHP_MAX_EXECUTION_TIME
            DEMYX_APP_PHP_OPCACHE=$DEMYX_APP_PHP_OPCACHE
            DEMYX_APP_PHP_PM=$DEMYX_APP_PHP_PM
            DEMYX_APP_PHP_PM_MAX_CHILDREN=$DEMYX_APP_PHP_PM_MAX_CHILDREN
            DEMYX_APP_PHP_PM_START_SERVERS=$DEMYX_APP_PHP_PM_START_SERVERS
            DEMYX_APP_PHP_PM_MIN_SPARE_SERVERS=$DEMYX_APP_PHP_PM_MIN_SPARE_SERVERS
            DEMYX_APP_PHP_PM_MAX_SPARE_SERVERS=$DEMYX_APP_PHP_PM_MAX_SPARE_SERVERS
            DEMYX_APP_PHP_PM_PROCESS_IDLE_TIMEOUT=$DEMYX_APP_PHP_PM_PROCESS_IDLE_TIMEOUT
            DEMYX_APP_PHP_PM_MAX_REQUESTS=$DEMYX_APP_PHP_PM_MAX_REQUESTS
            DEMYX_APP_XMLRPC=$DEMYX_APP_XMLRPC
            DEMYX_APP_WP_CPU=$DEMYX_APP_WP_CPU
            DEMYX_APP_WP_MEM=$DEMYX_APP_WP_MEM
            DEMYX_APP_DB_CPU=$DEMYX_APP_DB_CPU
            DEMYX_APP_DB_MEM=$DEMYX_APP_DB_MEM
            DEMYX_APP_MONITOR_THRESHOLD=3
            DEMYX_APP_MONITOR_SCALE=5
            DEMYX_APP_MONITOR_CPU=25
            DEMYX_APP_NX_CONTAINER=$DEMYX_APP_NX_CONTAINER
            DEMYX_APP_WP_CONTAINER=$DEMYX_APP_WP_CONTAINER
            DEMYX_APP_DB_CONTAINER=$DEMYX_APP_DB_CONTAINER
            WORDPRESS_USER=$WORDPRESS_USER
            WORDPRESS_USER_PASSWORD=$WORDPRESS_USER_PASSWORD
            WORDPRESS_USER_EMAIL=$WORDPRESS_USER_EMAIL
            WORDPRESS_DB_HOST=db_${DEMYX_APP_ID}
            WORDPRESS_DB_NAME=$WORDPRESS_DB_NAME
            WORDPRESS_DB_USER=$WORDPRESS_DB_USER
            WORDPRESS_DB_PASSWORD=$WORDPRESS_DB_PASSWORD
            MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD
            MARIADB_DEFAULT_CHARACTER_SET=utf8
            MARIADB_CHARACTER_SET_SERVER=utf8
            MARIADB_COLLATION_SERVER=utf8_general_ci
            MARIADB_KEY_BUFFER_SIZE=32M
            MARIADB_MAX_ALLOWED_PACKET=16M
            MARIADB_TABLE_OPEN_CACHE=2000
            MARIADB_SORT_BUFFER_SIZE=4M
            MARIADB_NET_BUFFER_SIZE=4M
            MARIADB_READ_BUFFER_SIZE=2M
            MARIADB_READ_RND_BUFFER_SIZE=1M
            MARIADB_MYISAM_SORT_BUFFER_SIZE=32M
            MARIADB_LOG_BIN=mysql-bin
            MARIADB_BINLOG_FORMAT=mixed
            MARIADB_SERVER_ID=1
            MARIADB_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend
            MARIADB_INNODB_BUFFER_POOL_SIZE=32M
            MARIADB_INNODB_LOG_FILE_SIZE=5M
            MARIADB_INNODB_LOG_BUFFER_SIZE=8M
            MARIADB_INNODB_FLUSH_LOG_AT_TRX_COMMIT=1
            MARIADB_INNODB_LOCK_WAIT_TIMEOUT=50
            MARIADB_INNODB_USE_NATIVE_AIO=1
            MARIADB_READ_BUFFER=2M
            MARIADB_WRITE_BUFFER=2M
            MARIADB_MAX_CONNECTIONS=100
EOF
        sed -i 's/            //' "$DEMYX_WP"/"$DEMYX_TARGET"/.env
    fi
}
demyx_stack_env() {
    if [[ -z "$DEMYX_INSTALL_FORCE" ]]; then
        if [[ -f "$DEMYX_STACK"/.env ]]; then
            DEMYX_PARSE_BASIC_AUTH="$(grep -s DEMYX_STACK_AUTH "$DEMYX_STACK"/.env | awk -F '[=]' '{print $2}')"
            demyx_source stack
            DEMYX_STACK_AUTH="$DEMYX_PARSE_BASIC_AUTH"
        fi
    fi

    [[ -z "$DEMYX_STACK_SERVER_API" ]] && DEMYX_STACK_SERVER_API=false
    [[ -z "$DEMYX_STACK_SERVER_IP" ]] && DEMYX_STACK_SERVER_IP="$(curl -s https://ipecho.net/plain)"
    [[ -z "$DEMYX_STACK_API" ]] && DEMYX_STACK_API=false
    [[ -z "$DEMYX_STACK_TELEMETRY" ]] && DEMYX_STACK_TELEMETRY=true
    [[ -z "$DEMYX_STACK_AUTO_UPDATE" ]] && DEMYX_STACK_AUTO_UPDATE=true
    [[ -z "$DEMYX_STACK_MONITOR" ]] && DEMYX_STACK_MONITOR=true
    [[ -z "$DEMYX_STACK_OUROBOROS" ]] && DEMYX_STACK_OUROBOROS=true
    [[ -z "$DEMYX_STACK_OUROBOROS_IGNORE" ]] && DEMYX_STACK_OUROBOROS_IGNORE=
    [[ -z "$DEMYX_STACK_HEALTHCHECK" ]] && DEMYX_STACK_HEALTHCHECK=true
    [[ -z "$DEMYX_STACK_HEALTHCHECK_TIMEOUT" ]] && DEMYX_STACK_HEALTHCHECK_TIMEOUT=5
    [[ -z "$DEMYX_STACK_BACKUP" ]] && DEMYX_STACK_BACKUP=true
    [[ -z "$DEMYX_STACK_BACKUP_LIMIT" ]] && DEMYX_STACK_BACKUP_LIMIT=30
    [[ -z "$DEMYX_STACK_ACME_STORAGE" ]] && DEMYX_STACK_ACME_STORAGE=/demyx/acme.json
    [[ -z "$DEMYX_STACK_CLOUDFLARE" ]] && DEMYX_STACK_CLOUDFLARE=false
    [[ -z "$DEMYX_STACK_LOG_LEVEL" ]] && DEMYX_STACK_LOG_LEVEL=INFO
    [[ -z "$DEMYX_STACK_CPU" ]] && DEMYX_STACK_CPU="$DEMYX_CPU"
    [[ -z "$DEMYX_STACK_MEM" ]] && DEMYX_STACK_MEM="$DEMYX_MEM"

    echo "# AUTO GENERATED
        DEMYX_STACK_SERVER_IP=$DEMYX_STACK_SERVER_IP
        DEMYX_STACK_SERVER_API=$DEMYX_STACK_SERVER_API
        DEMYX_STACK_AUTH=$DEMYX_PARSE_BASIC_AUTH
        DEMYX_STACK_API=$DEMYX_STACK_API
        DEMYX_STACK_TELEMETRY=$DEMYX_STACK_TELEMETRY
        DEMYX_STACK_DOMAIN=$DEMYX_STACK_DOMAIN
        DEMYX_STACK_AUTO_UPDATE=$DEMYX_STACK_AUTO_UPDATE
        DEMYX_STACK_MONITOR=$DEMYX_STACK_MONITOR
        DEMYX_STACK_HEALTHCHECK=$DEMYX_STACK_HEALTHCHECK
        DEMYX_STACK_HEALTHCHECK_TIMEOUT=$DEMYX_STACK_HEALTHCHECK_TIMEOUT
        DEMYX_STACK_BACKUP=$DEMYX_STACK_BACKUP
        DEMYX_STACK_BACKUP_LIMIT=$DEMYX_STACK_BACKUP_LIMIT
        DEMYX_STACK_CPU=$DEMYX_STACK_CPU
        DEMYX_STACK_MEM=$DEMYX_STACK_MEM
        DEMYX_STACK_OUROBOROS=$DEMYX_STACK_OUROBOROS
        DEMYX_STACK_OUROBOROS_IGNORE=\"$DEMYX_STACK_OUROBOROS_IGNORE\"
        DEMYX_STACK_ACME_EMAIL=$DEMYX_STACK_ACME_EMAIL
        DEMYX_STACK_ACME_STORAGE=$DEMYX_STACK_ACME_STORAGE
        DEMYX_STACK_CLOUDFLARE=$DEMYX_STACK_CLOUDFLARE
        DEMYX_STACK_CLOUDFLARE_EMAIL=$DEMYX_STACK_CLOUDFLARE_EMAIL
        DEMYX_STACK_CLOUDFLARE_KEY=$DEMYX_STACK_CLOUDFLARE_KEY
        DEMYX_STACK_LOG_LEVEL=$DEMYX_STACK_LOG_LEVEL" | sed 's|        ||g' > "$DEMYX_STACK"/.env
}
