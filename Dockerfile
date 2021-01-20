FROM perl:5.30 

ENV PINTO_USERNAME pinto 
ENV USERNAME pinto
ENV HTTPS_CA_DIR /etc/ssl/certs

RUN cpanm -v LWP::Protocol::https
RUN cpanm https://github.com/JaSei/Pinto/tarball/master

COPY ./docker_entrypoint.pl /docker_entrypoint.pl

ENTRYPOINT ["/docker_entrypoint.pl"]
