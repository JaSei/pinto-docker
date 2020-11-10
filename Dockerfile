FROM perl:5.30 

ENV PINTO_USERNAME pinto 
ENV USERNAME pinto

RUN cpanm Pinto
