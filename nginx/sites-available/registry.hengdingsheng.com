upstream registry {
    server localhost:5000       weight=5;
}

server {
	listen 80;
  server_name registry.hengdingsheng.com;

    listen 443 ssl; # managed by Certbot
ssl_certificate /etc/letsencrypt/live/registry.hengdingsheng.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/registry.hengdingsheng.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot


    if ($scheme != "https") {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  # disable any limits to avoid HTTP 413 for large image uploads
  client_max_body_size 0;

  # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
  chunked_transfer_encoding on;

  location /v2/ {
    # Do not allow connections from docker 1.5 and earlier
    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
    if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
      return 404;
    }

    # To add basic authentication to v2 use auth_basic setting plus add_header
    # auth_basic "registry.localhost";
    # auth_basic_user_file test.password;
    #add_header 'Docker-Distribution-Api-Version' 'registry/2.0' always;

    proxy_pass http://registry;
    proxy_set_header  Host              $http_host;  
    proxy_set_header  X-Real-IP         $remote_addr;
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    proxy_read_timeout                  900;
  }

  location / {
    proxy_pass http://registry;
    proxy_set_header  Host              $http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    #proxy_set_header  Authorization     ""; # For basic auth through nginx in v1 to work, please comment this line
    proxy_read_timeout                  900;
  }


}

