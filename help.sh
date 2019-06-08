#!/bin/bash

readonly FULL_PATH="$( cd "$( dirname "$0" )" && pwd )"
readonly NAME="docker-mysql"
readonly DOCKER_IMAGE_NAME="ddnb-mysql"
readonly PATH_REPO="/repo"
readonly PATH_CODE=""
readonly LOCALHOST="127.0.0.1"

# run help
run_help() {
	case $1 in
		all|*) run_help_details ;;
	esac
}

# run help details
run_help_details() {
cat <<EOF
Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[Commands]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
EOF
}

# run usage
run_usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# run init
run_init() {
	rsync -avz  ${FULL_PATH}/env ${FULL_PATH}/.env
	git submodule update --init --recursive
}

# run build
run_build() {
	docker-compose build
}

# run start
run_start() {
	docker-compose up -d
}

# run stop
run_stop() {
	docker-compose down
}

# run restart
run_restart() {
	case $2 in
	  php)
		  docker-compose restart php
		;;
		*)
			docker-compose restart
		;;
	esac
}

# run status
run_status() {
	docker-compose ps
}

# run logs
run_logs() {
	case $1 in
		web|nginx)  docker-compose logs web;;
		python)  docker-compose logs python;;
		mysql)  docker-compose logs mysql;;
		all|*)  docker-compose logs ;;
	esac
}

# ssh ssh
run_ssh() {
	case $1 in
		mysql) docker-compose exec mysql /bin/bash ;;
		images|vuejs|python) docker-compose exec images /bin/bash ;;
		*) docker-compose exec ${DOCKER_IMAGE_NAME} /bin/bash ;;
	esac
}

# run cli
run_cli() {
	echo "Bash version ${BASH_VERSION}..."
	for i in {1..40}
	do
		echo "${!i}"
	done

	case $2 in
		images|mysql|*) 
		  docker-compose exec ${DOCKER_IMAGE_NAME} /bin/bash -c \
			" \
        ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
        ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
        ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
        ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
			"
		;;
	esac
}

# run mysql
run_mysql() {
	echo "Bash version ${BASH_VERSION}..."
	for i in {1..40}
	do
		echo "${!i}"
	done

	case $2 in
    reset)
      readonly RESET_DB="mysql -uroot -p < ${PATH_REPO}/sql/reset.sql"
			echo $RESET_DB
      docker-compose exec ${DOCKER_IMAGE_NAME} sh -c "$RESET_DB"
    ;;
    init)
      readonly INIT_DB="mysql -uroot -p < ${PATH_REPO}/sql/init.sql"
			echo $INIT_DB
      docker-compose exec ${DOCKER_IMAGE_NAME} sh -c "$INIT_DB"
    ;;
    connect)
		  docker-compose exec ${DOCKER_IMAGE_NAME} sh -c "mysql -uroot -p"
    ;;
	  dump)
      readonly DUMP_DB="mysqldump -uroot -p > ${PATH_REPO}/sql/backup/`date +%Y%m%d`_ddnb-mysql-dump.sql"
			echo $DUMP_DB
      docker-compose exec ${DOCKER_IMAGE_NAME} /bin/bash -c "$DUMP_DB"
    ;;
    restore)
      readonly RESTORE_DB="mysql -uroot -p < ${PATH_REPO}/docker/mysql/mysql.init/1_create.sql"
			echo $RESTORE_DB
      docker-compose exec ${DOCKER_IMAGE_NAME} sh -c "$RESTORE_DB"
    ;;
		help|*)
			echo "💡 Usage:"
	        echo "${1} help"
cat <<EOF
▶︎ CLI
${1} dump
${1} restore
${1} connect
EOF
		;;
	esac
}

case $1 in
	init) 
    run_init ${2:-v2}
  ;;

	build)
    run_build
  ;;

	start|up) 
    run_start 
  ;;

	stop|down)
    run_stop
  ;;

	restart|reboot) 
		run_restart \
			${1} ${2:-help} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		  ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		  ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		  ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	status|ps) 
    run_status
  ;;

	logs)
    run_logs ${2:-all}
  ;;

	ssh)
    run_ssh ${2:-php}
  ;;

	cli) 
	  run_cli \
		  ${1} ${2:-images} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		  ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		  ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		  ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	db|mysql)
	  run_mysql \
	    ${1} ${2:-help} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		  ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		  ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		  ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	*) run_help ;;
esac