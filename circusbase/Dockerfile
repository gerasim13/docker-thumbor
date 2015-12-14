FROM frolvlad/alpine-python2
MAINTAINER Pavel Litvinenko <gerasim13@gmail.com>
# install dependencies
RUN apk add --update git unzip wget sqlite build-base gcc python-dev linux-headers
RUN apk add --update-cache py-psutil --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
# circus + circus-web + envtpl depends
COPY requirements.txt /tmp/
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt
# circus conf
ADD conf/circus.ini.tpl /etc/
# start script
ADD start.sh /bin/
RUN mkdir /etc/circus.d && \
    mkdir /etc/setup.d
# cleanup
RUN apk del build-base gcc python-dev linux-headers && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
EXPOSE 8888
CMD ["/bin/start.sh"]
