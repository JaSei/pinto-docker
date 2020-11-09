FROM perl:5.30 

ENV PINTO_USERNAME=pinto 

RUN cpanm --notest Pinto
