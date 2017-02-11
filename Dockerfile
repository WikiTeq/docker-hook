FROM python:2.7-alpine
RUN pip install requests && apk add --update bash && rm -rf /var/cache/apk/*
ADD docker-hook .
ENTRYPOINT ["./docker-hook"]
