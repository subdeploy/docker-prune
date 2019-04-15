FROM docker:18.06

RUN apk update && apk add jq

WORKDIR /docker-prune
COPY src ./
RUN chmod +x ./*.sh

ENTRYPOINT ["sh", "entrypoint.sh"]