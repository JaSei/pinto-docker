# pinto in docker

![Docker Automated build](https://img.shields.io/docker/automated/jasei/pinto?style=plastic)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/jasei/pinto?sort=date&style=plastic)


[Pinto](https://metacpan.org/pod/distribution/Pinto/bin/pinto) is a custom repository of Perl modules

## Synopsis

run pintod server

(`pinto init` is called before automatically)
```
docker run \
    -v PINTO_REPO:/pinto \
    -e PINTO_REPOSITORY_ROOT=/pinto \
    -p 3111:3111
    jasei/pinto \
    pintod
```

pull MODULE from CPAN to pinto repository

I really recommend to use `--skip-all-missing-prerequisites` or `-K` more in [issue #1](https://github.com/JaSei/pinto-docker/issues/1)
and
`--use-default-message` or `-M` because in docker isn't set editor properly.
```
docker run \
    -e PINTO_REPOSITORY_ROOT=https://PINTO_SERVER_URL \
    jasei/pinto \
    pinto -v -K -M --user pinto --password PASSWORD pull MODULE
```

push MODULE to pinto repository
```
docker run \
    -e PINTO_REPOSITORY_ROOT=https://PINTO_SERVER_URL \
    jasei/pinto \
    pinto -v -M --user pinto --password PASSWORD push MODULE
```

## Placeholders exaplanation

* `PINTO_REPO` - directory/volume where pinto data are persisted, eg. `/var/lib/pinto` - on docker host machine
* `PINTO_SERVER_URL` - URL to pintod instance

## How to use?

I strongly encourage use pinto in docker as is mentioned in Synopsis part and proxy with basic authentication at lest.

Nginx example configuration

```
server {
  listen       *:443 ssl;

  server_name  PINTO_SERVER_URL;

  ssl on;
  ssl_certificate           /etc/nginx/pinto.crt;
  ssl_certificate_key       /etc/nginx/pinto.key;
  ssl_client_certificate    /etc/nginx/pinto.crt;
  ssl_verify_client         on;

  index  index.html index.htm index.php;
  access_log            /var/log/nginx/ssl-PINTO_SERVER_URL.access.log combined;
  error_log             /var/log/nginx/ssl-PINTO_SERVER_URL.error.log;


  location / {
    limit_except GET HEAD {
      auth_basic           "pinto admin";
      auth_basic_user_file /etc/nginx/htpasswd;
    }

    proxy_pass            http://localhost:3111;
    proxy_set_header      Host $host;
    proxy_set_header      X-Real-IP $remote_addr;
    proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header      Proxy "";
  }
}
```

(this configuration have a anonymize access for GET (cpan like API) and authenticated access to pinto API (eg. pull/push))

Don't use passwords without SSL/TLS encryption!
