FROM gerasim13/circusbase
MAINTAINER Pavel Litvinenko <gerasim13@gmail.com>
# install dependencies
RUN apk add --update-cache py-numpy --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
RUN apk add --update mercurial curl bash wget tar libdc1394 libdc1394-dev \
    libjpeg-turbo libjpeg-turbo-dev tiff-dev py-curl \
    libpng libpng-dev libjasper jasper-dev libwebp-dev \
    build-base gcc g++ clang cmake libgcc python-dev linux-headers
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++
# export python paths
RUN export PYTHONPATH=$PYTHONPATH:/usr/lib/pymodules/python2.7/
RUN export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/dist-packages
RUN export PYTHONPATH=$PYTHONPATH:/usr/lib/pyshared/python2.7/
RUN export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages/
# compile opencv
ENV OPENCV 2.4.11
ADD https://github.com/Itseez/opencv/archive/${OPENCV}.tar.gz /tmp/${OPENCV}.tar.gz
ADD https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk /tmp/glibc-2.21-r2.apk
ADD https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk /tmp/glibc-bin-2.21-r2.apk
RUN cd /tmp/ && \
    apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk && \
    /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf glibc-2.21-r2.apk && \
    rm -rf glibc-bin-2.21-r2.apk
RUN tar -xzvf /tmp/${OPENCV}.tar.gz -C /tmp
RUN cd /tmp/opencv-${OPENCV} && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_FFMPEG=NO -D WITH_IPP=NO -D WITH_OPENEXR=NO -D WITH_XINE=NO -D WITH_TBB=NO \
    -D WITH_JPEG=ON /tmp/opencv-${OPENCV} && \
    make && make install
# virtualenv
RUN pip install --upgrade pip
RUN pip --no-input install virtualenv==1.11.6 pew==0.1.14 chaussette==1.2 PyYAML==3.11
# remotecv user and dirs
RUN addgroup -S -g 500 remotecv;\
    adduser -S -s /bin/bash -g 'Remotecv app user' -u 500 -g 500 -D -h /code remotecv
# remotecv conf
COPY circus.d/remotecv.ini.tpl /etc/circus.d/
COPY setup.d/remotecv /etc/setup.d/30-remotecv
# create Virtualenv
ENV HOME /code
ENV SHELL bash
ENV WORKON_HOME /code
WORKDIR /code
VOLUME /logs
# install remotecv
COPY requirements.txt /tmp/
RUN su -c "pew-new env -i ipython" remotecv
RUN su -c "pew-in env pip install -r /tmp/requirements.txt" remotecv
# include opencv in virtualenv
RUN su -c "ln -s /usr/lib/python2.7/dist-packages/cv2.so /code/env/lib/python2.7/site-packages/cv2.so" remotecv
RUN su -c "ln -s /usr/lib/python2.7/dist-packages/cv.py /code/env/lib/python2.7/site-packages/cv.py" remotecv
# cleanup
RUN apk del build-base gcc g++ clang cmake libgcc python-dev linux-headers && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
