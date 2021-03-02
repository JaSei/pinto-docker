FROM perl:5.30 AS builder

RUN cpanm --notest Dist::Zilla
RUN curl -L https://github.com/JaSei/Pinto/tarball/master -o /tmp/pinto.tar.gz
RUN tar -xzf /tmp/pinto.tar.gz -C /tmp
RUN cd /tmp/JaSei-Pinto-69c0b80 && dzil authordeps --missing | cpanm --notest && dzil build
RUN cd /tmp/JaSei-Pinto-69c0b80 && ls -la

FROM perl:5.30 

ENV PINTO_USERNAME pinto 
ENV USERNAME pinto
ENV HTTPS_CA_DIR /etc/ssl/certs

RUN cpanm -v LWP::Protocol::https YAML::XS
COPY --from=builder /tmp/JaSei-Pinto-69c0b80/Pinto-0.14.tar.gz /tmp/pinto.tar.gz
RUN cpanm --notest /tmp/pinto.tar.gz

COPY ./docker_entrypoint.pl /docker_entrypoint.pl

ENV PERL_YAML_BACKEND=YAML::XS

ENTRYPOINT ["/docker_entrypoint.pl"]
