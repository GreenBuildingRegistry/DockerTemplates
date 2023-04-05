FROM ea-base

RUN apt-get update && apt-get install -y redis ssmtp mailutils && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
COPY redis.conf /etc/redis
RUN chmod 644 /etc/redis/redis.conf
# Conf file instructs Redis to run daemonized
# Final Docker config must run populate-config with params (redis_password)
# and redis.conf location and restart redis from entrypoint:
# /usr/local/bin/redis-server /etc/redis/redis.conf

COPY ssmtp.conf /etc/ssmtp
RUN chmod 640 /etc/ssmtp/ssmtp.conf
# Final Docker config must run populate-config with params and ssmtp.conf


