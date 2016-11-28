FROM alpine:3.3

RUN apk add --update-cache python py-pip ca-certificates tzdata && pip install s3cmd
RUN apk add --update bash && apk add --update mysql-client && rm -rf /var/cache/apk/*

ENV MYSQLDUMP_OPTIONS --single-transaction --lock-tables=false
ENV MYSQL_DATABASE None

ENV AWS_ACCESS_KEY_ID None
ENV AWS_SECRET_ACCESS_KEY None
ENV AWS_PATH None

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
