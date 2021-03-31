#!/usr/bin/env bash
OPTION="${1}"
export SUPERVISORD_CONFIGS=${SUPERVISORD_CONFIGS:-cron coturn rsyslog}
generate_turn_key() {
    local turnkey="${1}"
    local filepath="${2}"
    if [ -e "${filepath}" ];then return;fi

    echo "-=> generate turn config"
    pwgen -s 64 1>$turnkey
    chmod 600 $turnkey

    echo "lt-cred-mech" > "${filepath}"
    echo "use-auth-secret" >> "${filepath}"
    echo "static-auth-secret=$(cat ${turnkey})" >> "${filepath}"
    echo "realm=turn.${SERVER_NAME}" >> "${filepath}"
    echo "cert=/data/${SERVER_NAME}.tls.crt" >> "${filepath}"
    echo "pkey=/data/${SERVER_NAME}.tls.key" >> "${filepath}"
    echo "dh-file=/data/${SERVER_NAME}.tls.dh" >> "${filepath}"
    echo "cipher-list=\"HIGH\"" >> "${filepath}"
}

case $OPTION in
    "start")
        echo "-=> start turn"
        if [ -f /conf/supervisord-turnserver.conf.deactivated ]; then
            mv -f /conf/supervisord-turnserver.conf.deactivated /conf/supervisord-turnserver.conf
        fi
        groupadd -r -g $MATRIX_GID matrix
        useradd -r -d /data -M -u $MATRIX_UID -g matrix matrix
        chown -R $MATRIX_UID:$MATRIX_GID /data
        chmod a+rwx /run
        exec supervisord.sh
        ;;

    "stop")
        echo "-=> stop matrix"
        echo "-=> via docker stop ..."
        ;;

    "version")
        echo "-=> coturn Version"
        cat /coturn.version
        ;;
    "generate")
        breakup="0"

        [[ "${breakup}" == "1" ]] && exit 1
        generate_turn_key /data/turnserver.auth /data/turnserver.conf
        ;;

    *)
        echo "-=> unknown \'$OPTION\'"
        ;;
esac
