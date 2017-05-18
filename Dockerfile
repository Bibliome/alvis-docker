#FROM maven:3.2-jdk-7-onbuild
FROM ubuntu:14.04 # need a more 
MAINTAINER Mouhamadou Ba <mouhamadou.ba@inra.fr>

RUN apt-get -yqq update

RUN apt-get -yqq install maven

RUN apt-get -yqq install git

RUN apt-get -yqq install wget

RUN apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

ENV java_version oracle-java8

WORKDIR /opt/

RUN git clone https://github.com/Bibliome/alvisnlp.git

VOLUME /opt/alvisnlp/data

WORKDIR /opt/alvisnlp

RUN mvn clean install

RUN ./install.sh .

ENV PATH /opt/alvisnlp/bin:$PATH

# create the external soft dir
RUN mkdir psoft
WORKDIR /opt/alvisnlp/psoft
# install TEES
RUN git clone https://github.com/jbjorne/TEES.git && \
    cd TEES/ && \
    apt-get install -y python && \
    apt-get install -y python-numpy && \
    apt-get install -y make && \
    apt-get install -y ruby && \
    apt-get install -y g++ && \
    apt-get install -y flex && \
    # python configure.py && \ # have to answer multiple choice questions during installation
    cd ../ 


# SPECIES
RUN wget http://download.jensenlab.org/species_tagger.tar.gz && \
    tar xvf species_tagger.tar.gz && \
    rm  species_tagger.tar.gz && \
    cd ../


# install biolg
RUN wget http://staff.cs.utu.fi/~spyysalo/biolg/biolg-1.1.12.tar.gz && \
    tar xvf biolg-1.1.12.tar.gz && \
    rm biolg-1.1.12.tar.gz && \
    # make && \
    cd ..\

# install CCGParser 1.00
RUN wget http://www.cl.cam.ac.uk/%7Esc609/resources/candc-downloads/candc-linux-1.00.tgz && \
    tar xvf candc-linux-1.00.tgz && \
    rm candc-linux-1.00.tgz && \
    #make && \
    cd ..\

# CCGPosTagger 1.00 /!\ seem to be the same as CGParser 1.00

# enju parser /!\ download link does work

# enju parser 2 /!\ download link does work

# install geniatagger
RUN wget http://www.nactem.ac.uk/tsujii/GENIA/tagger/geniatagger-3.0.2.tar.gz && \
    tar -xvf geniatagger-3.0.2.tar.gz && \
    rm geniatagger-3.0.2.tar.gz && \
    cd geniatagger-3.0.2 && \
    make && \
    cd ../

# StanfordNER 2014-06-16*
RUN wget https://nlp.stanford.edu/software/stanford-ner-2016-10-31.zip && \
    unzip stanford-ner-2016-10-31.zip && \
    rm stanford-ner-2016-10-31.zip && \
    cd ..\

# TEES see above

# treeTagger
 RUN wget http://www.cis.uni-muenchen.de/%7Eschmid/tools/TreeTagger/data/tree-tagger-linux-3.2.1.tar.gz && \
     tar xvf tree-tagger-linux-3.2.1.tar.gz && \
     rm tree-tagger-linux-3.2.1.tar.gz && \
     cd ..\

# WapitiLabel 1.5.0

# WapitiTrain 1.5.0

# YateaExtractor 0.5*

WORKDIR /opt/alvisnlp

# ENTRYPOINT ["/opt/alvisnlp/bin/alvisnlp"]

CMD ["alvisnlp"]
