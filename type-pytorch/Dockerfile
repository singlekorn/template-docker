# Official Python image
FROM bitnami/pytorch:latest

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /opt
COPY ./scripts/ . 

CMD [ "sh" ]