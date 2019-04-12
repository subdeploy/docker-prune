FROM docker:18.06

RUN apk add --update tzdata

WORKDIR /docker-prune
COPY src ./
RUN chmod +x ./*.sh

ENTRYPOINT ["sh", "entrypoint.sh"]