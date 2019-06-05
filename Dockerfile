FROM mysql:5.7.17

LABEL MAINTAINER="admin@diendannhatban.info"

# MySQL plugin mecab 
# https://hub.docker.com/r/flrngel/mysql-mecab-ko/~/dockerfile/
RUN apt-get update && apt-get install -yq mecab libmecab-dev unzip curl g++ make && \
    curl -sSL -o /tmp/mecab-ko.tar.gz https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.0.1-20150920.tar.gz && \
    cd /tmp/ && tar xvzf mecab-ko.tar.gz && cd mecab-ko-dic-2.0.1-20150920 && \
    ./configure && make && make install

RUN echo "dicdir=/usr/lib/mecab/dic/mecab-ko-dic" > /etc/mecabrc