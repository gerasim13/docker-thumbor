FROM apsl/circusbase
MAINTAINER Justin Tulloss <justin.tulloss@gmail.com>

#nginx
RUN \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install nginx-full && \
    apt-get clean

# Things required to build python 2.7.10
RUN \
    apt-get update && \
    apt-get -y -q install --no-install-recommends \
    gcc-multilib g++-multilib libffi-dev libffi6 libffi6-dbg python-crypto python-mox3 python-pil python-ply libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libgdbm-dev dpkg-dev quilt autotools-dev libreadline-dev libtinfo-dev libncursesw5-dev tk-dev blt-dev libbluetooth-dev libsqlite3-dev libgpm2 mime-support netbase net-tools bzip2

# compile python
RUN \
    wget -q https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && \
    tar xfz Python-2.7.10.tgz
WORKDIR /Python-2.7.10
RUN \
    ./configure --prefix /usr/local/lib/python2.7.10 --enable-unicode=ucs4 --enable-ipv6 && \
    make && \
    make install

# Things required for a python/pip environment
RUN  \
    apt-get update && \
    apt-get -y -q install --no-install-recommends git \
        libcurl4-openssl-dev \
        python-opencv \
        libopencv-dev \
        libjpeg-dev \
        libpng-dev \
        libx264-dev \
        libass-dev \
        libvpx1 \
        libvpx-dev \
        libwebp-dev \
        webp \
        gifsicle && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# thumbor user and dirs
RUN \
    addgroup --system --gid 500 thumbor;\
    adduser --system --shell /bin/bash --gecos 'Thumbor app user' --uid 500 --gid 500 --disabled-password --home /code thumbor ;\
    mkdir -p /data;\
    chown thumbor.thumbor /data -R

# thumbor conf
COPY setup.d/thumbor /etc/setup.d/40-thumbor
COPY circus.d/thumbor.ini.tpl /etc/circus.d/

RUN set -x && \
    python2_7_10='/usr/local/lib/python2.7.10/bin/python' && \
    pip2_7_10='/usr/local/lib/python2.7.10/bin/pip' && \
    wget 'https://bootstrap.pypa.io/get-pip.py' -O - | $python2_7_10 && \
    pip --no-input install virtualenv==1.11.6 && \
    $pip2_7_10 --no-input install pew==0.1.14 && \
    $pip2_7_10 --no-input install chaussette==1.2 && \
    $pip2_7_10 --no-input install PyYAML==3.11 # needed for install_crons

ENV HOME /code
ENV SHELL bash
ENV WORKON_HOME /code
WORKDIR /code

RUN rm -rf /Python2.7.10*

COPY requirements.txt /code/requirements.txt
RUN set -x && \
    pybin='/usr/local/lib/python2.7.10/bin' && \
    su -c "$pybin/pew-new env -p $pybin/python" thumbor &&\
    su -c "ln -s /usr/lib/python2.7/dist-packages/cv2.so /code/env/lib/python2.7/site-packages/cv2.so" thumbor && \
    su -c "ln -s /usr/lib/python2.7/dist-packages/cv.py /code/env/lib/python2.7/site-packages/cv.py" thumbor && \
    su -c "$pybin/pew-in env pip install -r /code/requirements.txt" thumbor
COPY conf/thumbor.conf.tpl /code/thumbor.conf.tpl


COPY circus.d/nginx.ini.tpl /etc/circus.d/
COPY setup.d/nginx /etc/setup.d/30-nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

VOLUME /logs
VOLUME /data

# nginx thumbor
EXPOSE 80 8000
