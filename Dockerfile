FROM alpine:latest
COPY create-users.sh /create-users.sh
RUN apk update && apk add samba samba-common-tools && chmod +x /create-users.sh
CMD ["sh", "-c", "sh /create-users.sh && chmod -R 777 /mnt && sleep infinity"]
