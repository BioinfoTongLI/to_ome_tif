FROM continuumio/miniconda3:latest

ENV version="0.5.0"
ENV version_suffix="rc1"

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps libblosc1 wget openjdk-11-jre unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN conda install -c ome raw2ometiff==${version}
