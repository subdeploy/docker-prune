FROM docker:18.06

WORKDIR /docker-prune
COPY src ./
RUN chmod +x ./*.sh

ENTRYPOINT ["sh", "entrypoint.sh"]