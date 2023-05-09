FROM ea-base

RUN apt-get update && apt-get install -y redis ssmtp mailutils \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
COPY redis.conf ssmtp.conf /tmp/
RUN mv /tmp/redis.conf /etc/redis && chmod 644 /etc/redis/redis.conf \
    && mv /tmp/ssmtp.conf /etc/ssmtp && chmod 640 /etc/ssmtp/ssmtp.conf \
    && chown redis:redis /var/log/redis && chmod 770 /var/log/redis \
    && mkdir /var/log/rq && chown www-data:www-data /var/log/rq \
    && mkdir /var/redis && chown www-data:www-data /var/redis \
# Final Docker config must run populate-config with params (redis_password)
# and redis.conf location and restart redis from entrypoint:
# /usr/local/bin/redis-server /etc/redis/redis.conf

# Final Docker config must run populate-config with params and ssmtp.conf


