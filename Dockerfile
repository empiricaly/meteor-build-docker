FROM ubuntu:18.04

# meteor consists of a runtime shell (the meteor executable) and a meteor tool.
# This allows a single meteor executable to operate with a variety of different meteor releases.
# In this docker image we ensure that both the executable and the tool for respetive meteor release are installed.

# Install all the stuff meteor needs to install itself and execute meteor build
RUN set -ex \
    && apt-get update \
    && apt-get install -y curl python build-essential

ARG METEOR_RELEASE=1.10.2

# install the meteor runtime shell executable
RUN set -ex \
    && curl https://install.meteor.com/?release=$METEOR_RELEASE | sh

# Trigger meteor to download and store the respective meteor tool
RUN set -ex \
    && meteor --allow-superuser --release $METEOR_RELEASE --version