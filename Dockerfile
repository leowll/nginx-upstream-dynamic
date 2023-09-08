# Use the official Nginx alpine image as the base image
FROM nginx:1.25.2-alpine

# Install build tools and dependencies
RUN apk add --no-cache --virtual .build-deps  \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev \
  git 

# Clone the Nginx source code from the official repository
WORKDIR /usr/src
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz && mv nginx-${NGINX_VERSION} nginx


RUN git clone https://github.com/zhaofeng0019/nginx-upstream-dynamic-resolve-servers.git

# Copy your modified ngx_http_upstream.c into the Nginx source code
COPY ngx_http_upstream.c /usr/src/nginx/src/http/

# Build Nginx with the custom module
WORKDIR /usr/src/nginx
RUN ./configure --add-module=../nginx-upstream-dynamic-resolve-servers && make && make install

# Remove the default Nginx configuration
RUN rm -f /etc/nginx/conf.d/* 

# Replace the default Nginx binary with the custom one
RUN cp /usr/local/nginx/sbin/nginx /usr/sbin/nginx

# Copy your custom Nginx configuration if needed
COPY nginx.conf /usr/local/nginx/conf/nginx.conf 


# Expose the HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
