FROM alpine:3.3

RUN apk add --update-cache python py-pip ca-certificates tzdata && pip install s3cmd
RUN apk add --update bash && apk add --update mysql-client && rm -rf /var/cache/apk/*

ENV MYSQLDUMP_OPTIONS --extended-insert --replace --compress
ENV MYSQL_DATABASE None
ENV AWS_PATH None

ADD backup.sh /backup.sh
ADD s3cfg /root/.s3cfg
RUN chmod +x /backup.sh
ARG AWS_ACCESS_KEY_ID=""
ARG AWS_SECRET_ACCESS_KEY=""

WORKDIR /root/.aws/
RUN echo "[Credentials]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> credentials
