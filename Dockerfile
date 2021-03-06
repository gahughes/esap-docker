# This is the Dockerfile to run Gammapy on Binder.
#

FROM continuumio/miniconda3:4.7.12
MAINTAINER Gammapy developers <gammapy@googlegroups.com>

RUN pip install --no-cache notebook jupyterlab

# compilers
RUN apt-get --allow-releaseinfo-change update
#RUN apt install -y curl

# install dependencies - including the stable version of Gammapy
COPY binder.py tmp/
COPY enviro.dat tmp/environment.yml 
#RUN curl -o tmp/environment.yml https://gammapy.org/download/install/gammapy-0.18.2-environment.yml

WORKDIR tmp/
RUN conda update conda
RUN conda install -c conda-forge mamba
RUN mamba install -q -y pyyaml
RUN python binder.py
#RUN conda env create -f environment.yml

# add gammapy user running the jupyter notebook process
ENV NB_USER gammapy
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}


# download tutorials and datasets
RUN gammapy download datasets --out=${HOME}/gammapy-datasets --release=0.18.1
RUN gammapy download notebooks --out=${HOME}/gammapy-tutorials --release=0.18.2

# setting ownerships
USER root
RUN chown -R gammapy:gammapy ${HOME}

# start JupyterLab server in tutorials dir
USER ${NB_USER}
WORKDIR ${HOME}
#COPY cta.ipynb ${HOME}

# env vars used in tutorials
ENV GAMMAPY_DATA ${HOME}/gammapy-datasets

#ENTRYPOINT bash
