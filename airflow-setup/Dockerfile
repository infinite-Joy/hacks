# ORIGINAL SOURCE:
#   https://github.com/puckel/docker-airflow
#   https://github.com/docker-library/python/blob/master/3.5/Dockerfile
FROM python:3.6.7

# Get all development dependencies
RUN apt-get update
ENV pyBuildDeps python-dev libkrb5-dev libsasl2-dev libssl-dev libffi-dev build-essential libblas-dev liblapack-dev libxml2-dev libxslt1-dev default-libmysqlclient-dev build-essential libffi-dev libssl-dev libbz2-dev libsqlite3-dev
RUN apt-get install -yqq $pyBuildDeps

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
		tcl \
		tk \
	&& rm -rf /var/lib/apt/lists/*

# install libh deps for python-ldap
RUN apt-get update
RUN apt-get install libsasl2-dev python-dev libldap2-dev libssl-dev -y

# If you change the python version, update this GPG key, you can download it from the python
# repo containing the version and run:
# gpg --verify Python-<MY_VERSION>.tar.xz.asc
ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.6.7

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 18.0

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Define en_US
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Airflow
ARG AIRFLOW_VERSION=1.10.0
ENV AIRFLOW_HOME /usr/local/airflow
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes

RUN echo "deb http://http.debian.net/debian jessie-backports main" >/etc/apt/sources.list.d/backports.list \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        apt-utils \
        curl \
        netcat \
        locales \
        git \
    && apt-get install -yqq -t jessie-backports python-requests libpq-dev \
    && apt-get install -yqq -t jessie-backports openssl \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

RUN pip install Cython \
    && pip install pytz==2015.7 \
    && pip install cryptography \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install psycopg2 \
    && pip install redis \
    && pip install config

RUN pip install apache-airflow[async,crypto,jdbc,ldap,postgres,s3,password,celery]==$AIRFLOW_VERSION \
    && pip install celery==4.2.1 \
    && pip install flower==0.9.2

RUN pip install -U pip
RUN pip install setuptools

# clean up
RUN apt-get remove --purge -yqq $buildDeps libpq-dev \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base


# Prep log file location
RUN mkdir -p /var/log/airflow \
    && chown airflow /var/log/airflow

# Prep airflow log location and dag location (for local dev - this folder should be mapped to host instance for persistence)
RUN mkdir -p /data/airflow/logs \
    && mkdir -p /data/airflow/dags \
    && chown -R airflow /data/airflow

# Copy configuration
COPY config_files/airflow.cfg.template ${AIRFLOW_HOME}/airflow.cfg.template
COPY config_files/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
RUN mkdir ${AIRFLOW_HOME}/config/
RUN touch ${AIRFLOW_HOME}/config/__init__.py

RUN chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}

RUN ls -ltr

# Configure and start the stack using supervisor
ENTRYPOINT ["./entrypoint.sh"]