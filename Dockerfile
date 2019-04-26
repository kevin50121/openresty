FROM openresty/openresty:latest

RUN  apt-get update && apt-get install -y\
        lua5.1 \
        liblua5.1 \
        unzip \
        openssl \
        gcc \
        make \
        wget

RUN  wget http://luarocks.github.io/luarocks/releases/luarocks-2.4.2.tar.gz && \
        tar xzf luarocks-2.4.2.tar.gz && \
        cd luarocks-2.4.2 && \
        ./configure --prefix=/usr/local/openresty/luajit/ \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
        make build && make install 
RUN  /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl && \
        mkdir /etc/resty-auto-ssl && \
        chmod 777 -R /etc/resty-auto-ssl && \
        chmod +x \
        /usr/local/openresty/luajit/share/lua/5.1/resty/auto-ssl/vendor/*.lua
RUN  openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
        -subj '/CN=sni-support-required-for-valid-ssl' \
        -keyout /etc/ssl/resty-auto-ssl-fallback.key \
        -out /etc/ssl/resty-auto-ssl-fallback.crt    
COPY  ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf