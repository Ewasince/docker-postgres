FROM postgres:14.5

RUN apt-get update && apt-get -y install git build-essential postgresql-server-dev-14

RUN git clone https://github.com/citusdata/pg_cron.git
RUN cd pg_cron && make && make install

RUN cd / && \
        rm -rf /pg_cron && \
        apt-get remove -y git build-essential postgresql-server-dev-14 && \
        apt-get autoremove --purge -y && \
        apt-get clean && \
        apt-get purge

COPY init-db /docker-entrypoint-initdb.d

RUN cd  /var/lib/postgresql && \
	mkdir /export
