FROM nvidia/cuda:8.0-runtime-ubuntu16.04

ENV http_proxy=
ENV https_proxy=
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:graphics-drivers/ppa
RUN apt-get update && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    nvidia-opencl-icd-384

ENV HASHCAT_VERSION        hashcat-4.0.1
ENV HASHCAT_UTILS_VERSION  1.8

# Update & install packages for installing hashcat
RUN apt-get update && \
    apt-get install -y wget p7zip

RUN mkdir /hashcat

#Install and configure hashcat: it's either the latest release or in legacy files
RUN cd /hashcat && \
    wget --no-check-certificate https://hashcat.net/files_legacy/${HASHCAT_VERSION}.7z && \
    wget --no-check-certificate https://hashcat.net/files/${HASHCAT_VERSION}.7z && \
    7zr x ${HASHCAT_VERSION}.7z && \
    rm ${HASHCAT_VERSION}.7z

RUN cd /hashcat && \
    wget https://github.com/hashcat/hashcat-utils/releases/download/v${HASHCAT_UTILS_VERSION}/hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    7zr x hashcat-utils-${HASHCAT_UTILS_VERSION}.7z && \
    rm hashcat-utils-${HASHCAT_UTILS_VERSION}.7z

#Add link for binary
RUN ln -s /hashcat/${HASHCAT_VERSION}/hashcat64.bin /usr/bin/hashcat
RUN ln -s /hashcat/hashcat-utils-${HASHCAT_UTILS_VERSION}/bin/cap2hccapx.bin /usr/bin/cap2hccapx
