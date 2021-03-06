FROM alpine:latest

RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories
RUN apk upgrade --update-cache --available
RUN apk --no-cache add \
	bash \
	tor

EXPOSE 9001

# copy in our torrc files
COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.middle /etc/tor/torrc.middle
COPY torrc.exit /etc/tor/torrc.exit

# copy the run script
COPY entrypoint.sh /entrypoint.sh
RUN chmod ugo+rx /entrypoint.sh

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

RUN mkdir /var/lib/tor/.tor
VOLUME /var/lib/tor/.tor
RUN chown -R tor /var/lib/tor

ENTRYPOINT [ "/entrypoint.sh" ]
