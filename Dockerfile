# This is the Dockerfile to run Gammapy on Binder.
#

FROM continuumio/miniconda3:4.10.3
MAINTAINER Gammapy developers <gammapy@googlegroups.com>

# add gammapy user running the jupyter notebook process
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN pip install --no-cache-dir notebook
RUN pip install --no-cache-dir jupyterhub

# compilers
##TEMP RUN apt-get --allow-releaseinfo-change update
#RUN apt install -y curl

# install dependencies - including the stable version of Gammapy
#COPY binder.py tmp/
COPY ghbinder.py tmp/
COPY enviro.dat tmp/environment.yml 

WORKDIR tmp/
#RUN conda update conda
#RUN conda install -c conda-forge mamba 
#RUN mamba install -q -y pyyaml
#RUN python binder.py

RUN python -m pip install pyyaml
RUN python ghbinder.py
#RUN gammapy download datasets  --out=${HOME}/gammapy-datasets --release=0.18.2

USER ${NB_USER}
WORKDIR ${HOME}

