#
# usage:
#       export IMAGE=ghcr.io/catenax-ng/product-portal-common-assets
#       docker build -t $IMAGE -f .conf/Dockerfile .
#       docker run --rm -d -p 8080:8080 --name cx-portal-assets $IMAGE
#
# Step 1
FROM alpine as build-step
COPY public /public
WORKDIR /public
RUN find . -type f | cut -c 3- | sort > index.txt

# Step 2
FROM nginxinc/nginx-unprivileged:alpine
COPY .conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-step /public /usr/share/nginx/html
