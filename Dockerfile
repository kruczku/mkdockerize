#the image needs a solid python base as mkdocs may require additional python packages
FROM python:3.6-slim
#adding git in case mkdocs requires a git package for extra plugins
RUN apt update && apt install -y git
RUN pip install -U mkdocs
ADD entrypoint.sh /docker-entrypoint.sh
WORKDIR /mkdocs
ENTRYPOINT ["/docker-entrypoint.sh"]
