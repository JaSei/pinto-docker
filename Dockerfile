FROM perl:5.30 

ENV PINTO_USERNAME pinto 
ENV USERNAME pinto

RUN cpanm Crypt::SSLeay Pinto LWP::Protocol::https

COPY ./docker_entrypoint.pl /docker_entrypoint.pl

ENTRYPOINT ["/docker_entrypoint.pl"]
