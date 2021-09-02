FROM alpine:3.14.2

RUN apk add --update-cache python3 py-pip ca-certificates tzdata && pip install s3cmd
RUN apk add --update bash && apk add --update mysql-client && rm -rf /var/cache/apk/*

ENV MYSQLDUMP_OPTIONS --extended-insert --replace --compress
ENV MYSQL_DATABASE None
ENV AWS_PATH None

ADD backup.sh /backup.sh
ADD s3cfg /root/.s3cfg
RUN chmod +x /backup.sh
