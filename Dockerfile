FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs, aptalca"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

# install software
RUN \
 echo "**** add repositories ****" && \
 apt-get update && \
 apt-get install -y \
	gnupg && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C && \
 echo "deb http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
	/etc/apt/sources.list.d/deluge.list && \
 echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> \
	/etc/apt/sources.list.d/deluge.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	deluged \
	deluge-console \
	deluge-web \
	p7zip-full \
	python-pip \
	git \
	python3-pip \
	nano \
	ffmpeg \
	unrar \
	unzip && \
 pip3 install --no-cache-dir \
    apprise \
    chardet \
    pynzb \
    requests \
	requests[security] \
	requests-cache \
	babelfish \
	tmdbsimple \
	idna \
	mutagen \
	guessit \
	subliminal \
	python-dateutil \
	stevedore \
	qtfaststart \
    sabyenc && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*


#mp4automator
RUN git clone https://github.com/pazport/sickbeard_mp4_automator.git mp4automator
RUN chmod -R 777 /mp4automator
RUN chown -R 1000:1000 /mp4automator

#update ffmpeg
RUN apt-get update && apt-get upgrade -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:savoury1/graphics -y
RUN add-apt-repository ppa:savoury1/multimedia -y
RUN add-apt-repository ppa:savoury1/ffmpeg4 -y
RUN apt-get update && apt-get upgrade -y
RUN apt-get install ffmpeg -y
RUN apt-get update && apt-get upgrade -y


# add local files
COPY root/ /

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads
