FROM python:2.7
RUN pip install requests
ADD docker-hook .
ENTRYPOINT ["./docker-hook"]
