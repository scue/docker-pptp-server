FROM alpine:edge

RUN apk --update --no-cache add pptpd ppp iptables && \
    rm -rf /var/cache/apk/* && \
    echo 'option /etc/ppp/pptpd-options' > /etc/pptpd.conf && \
    echo 'pidfile /var/run/pptpd.pid' >> /etc/pptpd.conf && \
    echo 'localip 10.99.99.1' >> /etc/pptpd.conf && \
    echo 'remoteip 10.99.99.100-199' >> /etc/pptpd.conf && \
    echo 'name pptpd' > /etc/ppp/pptpd-options && \
    echo 'refuse-pap' >> /etc/ppp/pptpd-options && \
    echo 'refuse-chap' >> /etc/ppp/pptpd-options && \
    echo 'refuse-mschap' >> /etc/ppp/pptpd-options && \
    echo 'require-mschap-v2' >> /etc/ppp/pptpd-options && \
    echo 'require-mppe-128' >> /etc/ppp/pptpd-options && \
    echo 'proxyarp' >> /etc/ppp/pptpd-options && \
    echo 'nodefaultroute' >> /etc/ppp/pptpd-options && \
    echo 'lock' >> /etc/ppp/pptpd-options && \
    echo 'nobsdcomp' >> /etc/ppp/pptpd-options && \
    echo 'novj' >> /etc/ppp/pptpd-options && \
    echo 'novjccomp' >> /etc/ppp/pptpd-options && \
    echo 'nologfd' >> /etc/ppp/pptpd-options

EXPOSE 1723/tcp

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0700 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD sh -c "pptpd && syslogd -n -O /dev/stdout" 
