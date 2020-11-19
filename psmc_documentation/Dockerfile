#This Dockerfile installs all dependencies for the PSMC analysis in Powell et al.

FROM ubuntu:16.04

#install libs/dependencies
RUN apt-get update && apt-get install -y \
    bzip2 \
    cmake \
    curl \
    gcc \
    git \
    g++ \
    libboost-all-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libffi-dev \
    libhdf5-cpp-11 \
    liblzma-dev \
    libncurses5-dev \
    libssl-dev \
    libzmq5 \
    openjdk-8-jdk \
    openjdk-8-jre \
    parallel \
    pigz \
    python3-all-dev \
    python3-pip \
    tabix \
    wget \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir /tools


#install
RUN git clone https://github.com/ucdavis-bioinformatics/proc10xG.git \
 && cd proc10xG \
 && git reset --hard 6de559a3a03997ba6829569ce4f6b1afe3744eb5 \
 && cp ./process_10xReads.py /usr/local/bin \
 && cd .. \
 && rm -r proc10xG

#install bwa
RUN git clone --branch 'v0.7.17' https://github.com/lh3/bwa \
 && cd /bwa \
 && make -j \
 && cp ./bwa /usr/local/bin \
 && rm -r /bwa

#install SAMtools, etc.
RUN wget -q https://github.com/samtools/samtools/releases/download/\
1.8/samtools-1.8.tar.bz2 \
 && tar -xjf samtools-1.8.tar.bz2 \
 && cd /samtools-1.8 \
 && ./configure \
 && make -j \
 && make install \
 && rm -r /samtools-1.8*

RUN wget -q https://github.com/samtools/htslib/releases/download/\
1.8/htslib-1.8.tar.bz2 \
 && tar -xjf htslib-1.8.tar.bz2 \
 && cd /htslib-1.8 \
 && ./configure \
 && make -j \
 && make install \
 && rm -r /htslib-1.8*

RUN wget -q https://github.com/samtools/bcftools/releases/download/\
1.8/bcftools-1.8.tar.bz2 \
 && tar -xjf bcftools-1.8.tar.bz2 \
 && cd /bcftools-1.8 \
 && ./configure \
 && make -j \
 && make install \
 && rm -r /bcftools-1.8*

#Download Picard tools
RUN wget -q https://sourceforge.net/projects/picard/files/picard-tools/1.118/picard-tools-1.118.zip/download -O picard-tools-1.118.zip \
 && unzip -q picard-tools-1.118.zip \
 && rm picard-tools-1.118.zip

 #Install gsutil (needed to get GATK 3)
 RUN wget -q https://storage.googleapis.com/pub/gsutil.tar.gz \
 && tar -xf gsutil.tar.gz \
 && rm gsutil.tar.gz

#Install GATK 3.4.46-gbc02625
RUN gsutil/gsutil cp gs://gatk-software/package-archive/gatk/\
GenomeAnalysisTK-3.4-46-gbc02625.tar.bz2 GenomeAnalysisTK-3.4-46-gbc02625.tar.bz2 \
  && tar -xf GenomeAnalysisTK-3.4-46-gbc02625.tar.bz2 \
  && rm GenomeAnalysisTK-3.4-46-gbc02625.tar.bz2 \
  && rm -r gsutil

#Install seqtk
RUN git clone https://github.com/lh3/seqtk.git \
  && cd seqtk \
  && make \
  && cp ./seqtk /usr/local/bin \
  && rm -r /seqtk

#Install psmc
RUN git clone --branch '0.6.5' https://github.com/lh3/psmc.git \
  && cd psmc \
  && make \
  && cd utils \
  && make \
  && cd \
  && cp /psmc/psmc /usr/local/bin \
  && cp /psmc/utils/fq2psmcfa /usr/local/bin \
  && cp /psmc/utils/splitfa /usr/local/bin \
  && cp /psmc/utils/psmc_plot.pl /usr/local/bin \
  && rm -r /psmc
