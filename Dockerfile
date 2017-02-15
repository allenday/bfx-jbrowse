FROM nginx
MAINTAINER Allen Day "allenday@allenday.com"
EXPOSE 80

ENV IMAGE_PACKAGES="perl libbio-perl-perl nodejs-legacy npm samtools libxml2 libpng-dev libexpat-dev libpq-dev zlib1g-dev"
ENV BUILD_PACKAGES="gcc git make postgresql-client unzip wget"

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install $BUILD_PACKAGES $IMAGE_PACKAGES
RUN npm install bower -g

WORKDIR /var/www
RUN rm -rf /var/www/html
RUN git clone --recursive https://github.com/gmod/jbrowse html
WORKDIR /var/www/html
RUN bower --allow-root -f install
RUN bash ./setup.sh

## cleanup
#RUN apt-get -y remove --purge $BUILD_PACKAGES
#RUN apt-get -y remove --purge $(apt-mark showauto)
#RUN rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
CMD ["/docker-entrypoint.sh"]
