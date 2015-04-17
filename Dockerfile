FROM python:2.7
ADD docker-hook .
ENTRYPOINT ./docker-hook
