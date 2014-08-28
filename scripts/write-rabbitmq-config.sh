#!/bin/bash

# Adapted from tutumcloud/tutum-docker-rabbitmq

if [ -f /.rabbitmq_password_set ]; then
	echo "RabbitMQ password already set!"
	exit 0
fi

INET_DIST_LISTEN_MIN=${INET_DIST_LISTEN_MIN:-55950}
INET_DIST_LISTEN_MAX=${INET_DIST_LISTEN_MAX:-55954}

# todo: rename to write-rabbitmq-config
# todo: should we specify: "0.0.0.0"  as part of the tcp_listeners config?

# For reference: https://www.rabbitmq.com/configure.html

cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
	{rabbit, [{default_user, <<"$RABBITMQ_USER">>},
                  {default_pass, <<"$RABBITMQ_PASS">>},
                  {default_permissions, [<<".*">>, <<".*">>, <<".*">>]},
                  {tcp_listeners, [5672]},
                  {reverse_dns_lookups, true},
                  {loopback_users, []}
        ]},
        {kernel, [{inet_dist_listen_min, $INET_DIST_LISTEN_MIN},
                  {inet_dist_listen_max, $INET_DIST_LISTEN_MAX}
        ]}
].
EOF

touch /.rabbitmq_password_set

exit 0