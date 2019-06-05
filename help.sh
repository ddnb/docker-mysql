#!/bin/bash

readonly FULL_PATH="$( cd "$( dirname "$0" )" && pwd )"
readonly NAME="ddnb"
readonly IMAGE="ddnb_mysql"
readonly REPO_NAME="docker-mysql"
readonly REPO="https://github.com/ddnb/$REPO_NAME"
readonly LIHO_PATH="/code"
readonly PUBLIC_PATH="/code/public_html"
readonly LOCALHOST="127.0.0.1"

run_help() {
	case $1 in
		all|*) run_help_details ;;
	esac
}

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

# Usage
run_usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# init env
run_init() {
	rsync -avz  ${FULL_PATH}/env ${FULL_PATH}/.env
	git submodule update --init --recursive
}

# Docker compose build
run_build() {
	docker-compose build
}

# Docker compose up
run_start() {
	docker-compose up -d
}

# Docker compose down
run_stop() {
	docker-compose down
}

# run restart
# docker compose restart
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

# Docker compose status
run_status() {
	docker-compose ps
}

# Docker compose logs
run_logs() {
	case $1 in
		web|nginx)  docker-compose logs web;;
		images|python)  docker-compose logs images;;
		all|*)  docker-compose logs ;;
	esac
}

# ssh cli
run_ssh() {
	case $1 in
		mysql) docker-compose exec mysql /bin/bash ;;
		images|vuejs|python) docker-compose exec images /bin/bash ;;
		*) docker-compose exec ${NAME} /bin/bash ;;
	esac
}

# run django
run_django() {
	case $1 in
	  init)
		  docker-compose run images django-admin.py startproject sample ./stable/django
		;;
		help|*)  ;;
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
		  docker-compose exec ${IMAGE} /bin/bash -c \
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
    connect)
		  docker-compose exec mysql sh -c "mysql -u${NAME} -p"
        ;;
	  dump)
      readonly DUMP_DB="mysqldump -ulehungio -plehungio lehungio > /code/sql/lehungio.sql"
			echo $DUMP_DB
      docker-compose exec mysql /bin/bash -c "$DUMP_DB"
    ;;
    restore)
      readonly RESTORE_DB="mysql -ulehungio -plehungio lehungio < /code/sql/lehungio.sql"
			echo $RESTORE_DB
      docker-compose exec mysql sh -c "$RESTORE_DB"
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
	init) run_init ${2:-v2};;
	build) run_build ;;
	start|up) run_start ;;
	stop|down) run_stop ;;
	restart|reboot) 
		run_restart \
			${1} ${2:-help} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		  ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		  ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		  ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;
	status|ps) run_status ;;
	logs) run_logs ${2:-all} ;;
	ssh) run_ssh ${2:-php} ;;
	django) run_django ${2} ;;

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