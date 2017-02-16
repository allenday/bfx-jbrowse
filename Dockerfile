FROM allenday/bfx-bioperl
MAINTAINER Allen Day "allenday@allenday.com"
EXPOSE 80

RUN apt-get update
RUN apt-get install -y less
RUN apt-get install -y wget unzip make gcc g++ libpng-dev
RUN apt-get install -y libjson-perl libheap-perl libperlio-gzip-perl liblocal-lib-perl libcapture-tiny-perl libdevel-size-perl libhash-merge-perl libfile-next-perl libfile-copy-recursive-perl libtest-warn-perl 
RUN apt-get install -y nginx
RUN apt-get install -y nodejs-legacy npm git
RUN npm install bower -g


ENV VER=1.12.1-release
ENV ZIP=$VER.zip
ENV URL=https://github.com/GMOD/jbrowse/archive/$ZIP
ENV FOLDER=jbrowse-$VER
ENV DST=/var/www


WORKDIR $DST
RUN rm -rf ./html
RUN mkdir -p $DST && \
    wget $URL -O $DST/$ZIP && \
    unzip $DST/$ZIP -d $DST && \
    rm $DST/$ZIP && \
    cd $DST && \
    mv $FOLDER html

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY bowerrc $DST/html/.bowerrc
COPY bower.json $DST/html/

WORKDIR $DST/html
RUN bower --allow-root -f install
RUN cat /dev/null | bin/cpanm -v --notest -l extlib/ --installdeps .
RUN cat /dev/null | ./setup.sh
CMD nginx
#CMD ["nginx", "-g", "daemon off;"]
