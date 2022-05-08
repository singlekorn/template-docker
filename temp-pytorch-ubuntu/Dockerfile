# Ubuntu:22.04
# Python:3.10
# PyTorch

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3.10 python3-distutils python3-pip python3-apt

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /opt
COPY ./scripts/ . 

CMD [ "python3" ]