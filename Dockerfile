FROM python:2

MAINTAINER Name <brice.aminou@gmail.com>

RUN apt-get update && apt-get install -y git && apt-get install -y wget
RUN wget -m ftp://ftp.ncbi.nlm.nih.gov/sra/reports/Assembly/GRCh37-HG19_Broad_variant/Homo_sapiens_assembly19.fasta -O /Homo_sapiens_assembly19.fasta
RUN git clone https://github.com/ICGC-TCGA-PanCancer/pcawg-minibam.git /pcawg-minibam

RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer && \
  apt-get clean all


RUN mkdir /icgc-storage-client
RUN wget -O icgc-storage-client.tar.gz https://dcc.icgc.org/api/v1/ui/software/icgc-storage-client/latest
RUN tar -zxvf icgc-storage-client.tar.gz -C /icgc-storage-client --strip-components=1

RUN git clone https://github.com/icgc-dcc/icgconnect.git /icgconnect
RUN git clone https://github.com/baminou/SongAdpater.git /songadapter

RUN pip install -e /icgconnect
RUN pip install -r /songadapter/requirements.txt


RUN wget https://artifacts.oicr.on.ca/artifactory/dcc-release/org/icgc/dcc/song-client/[RELEASE]/song-client-[RELEASE]-dist.tar.gz
RUN mkdir /song-client
RUN tar zxvf song-client-*.tar.gz -C /song-client --strip-components=1
RUN export SING_HOME="/song-client"


ENV PATH="/icgc-storage-client/bin:${PATH}"
ENV PATH="/songadapter/:${PATH}"
ENV PATH="/song-client/bin/:${PATH}"
