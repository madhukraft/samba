FROM alpine:3.21.3
RUN apk add --no-cache samba
COPY create-users.sh /create-users.sh
RUN chmod 500 /create-users.sh
EXPOSE 139 445
ENTRYPOINT ["/create-users.sh"]
