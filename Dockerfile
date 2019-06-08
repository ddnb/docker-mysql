FROM mysql:5.7.17

LABEL MAINTAINER="admin@diendannhatban.info"

RUN apt-get update 

# Dependencies
RUN apt-get install -yq mecab libmecab-dev unzip curl g++ make 