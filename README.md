# Catena-X Portal static assets

Assets and test data used by the Catena-X Portal

### Publish assets to Catena-X NG

local build

    export NAME=cx-portal-assets
    export IMAGE=ghcr.io/catenax-ng/product-portal-common-assets
    docker build -t $IMAGE -f .conf/Dockerfile .
    docker run --rm -d -p 8080:8080 --name $NAME $IMAGE
    docker exec $NAME find /usr/share/nginx/html/
    docker stop $NAME
    docker tag $IMAGE $IMAGE:main
    docker push $IMAGE



### [deprecated] Publish assets to Catena-X Speedboat subscription

https://catenaxdev003util.blob.core.windows.net/assets/index.html

commands (bash)

    source ./scripts/util.sh
    list-container
    list-blobs
    create-index
    deploy-assets
