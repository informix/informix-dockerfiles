
FROM debian:jessie
LABEL maintainer="brian.hughes@hcl.com"
LABEL vendor="HCL Technologies"
LABEL version="1.0"

#Install all required packages
RUN apt-get -y update && apt-get install -y \
    vim \
    curl \
    git \
    default-jdk \
    python-dev \
    && rm -rf /var/lib/apt/lists/*

#Install NodeJs version 8
RUN curl -sL https://deb.nodesource.com/setup_8.x| bash - && apt-get install -y nodejs

#Install Python 3
#RUN apt-get -y install python3-dev python3-pip build-essential

WORKDIR /sandbox
# Add the ODBC linux files
RUN mkdir -p /sandbox/odbc \
    && curl -o odbc.tar http://central.maven.org/maven2/com/ibm/informix/odbc/4.10.10/odbc-4.10.10-linux-x86_64.tar \
    && tar xf odbc.tar -C odbc \
    && rm odbc.tar \
    && curl -o ifxjdbc.jar http://central.maven.org/maven2/com/ibm/informix/jdbc/4.10.10.0/jdbc-4.10.10.0.jar

#This must be in the same directory as the python demos
RUN git clone https://github.com/OpenInformix/IfxPy.git \
    && tar xf IfxPy/prebuilt/27x/Linux64/IfxPy.so.tar

COPY env.sh /sandbox/env.sh
RUN git clone https://github.com/informix/client-sandbox.git