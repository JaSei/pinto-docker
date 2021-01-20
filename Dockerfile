FROM perl:5.30 

ENV PINTO_USERNAME pinto 
ENV USERNAME pinto
ENV HTTPS_CA_DIR /etc/ssl/certs

RUN cpanm -v Crypt::SSLeay Pinto LWP::Protocol::https

COPY ./docker_entrypoint.pl /docker_entrypoint.pl

ENTRYPOINT ["/docker_entrypoint.pl"]
