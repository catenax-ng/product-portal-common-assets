#!/bin/bash

#
# bash functions to manage the catena-x assets
# usage:
#    source ./scripts/util.sh
#    create-storage
#    create-container
#    list-container
#    list-blobs
#    deploy-assets
#

export CX_ENV=${CX_ENV:-dev003}
export CX_RG=catenax-${CX_ENV}-rg
export CX_ACCOUNT=catenax${CX_ENV}util
export CX_CONTAINER=assets
export LOCATION=germanywestcentral
export CX_BASE=https://${CX_ACCOUNT}.blob.core.windows.net/

get-account-key() {
    az storage account keys list \
        --resource-group $CX_RG \
        --account-name $CX_ACCOUNT \
        --query '[0].value' -o tsv
}

export CX_ACCOUNT_KEY=$(get-account-key)

create-account() {
    az storage account create \
        --name ${CX_ACCOUNT} \
        --resource-group ${CX_RG} \
        --kind StorageV2 \
        --location ${LOCATION} \
        --allow-blob-public-access true \
        -o table
    export CX_ACCOUNT_KEY=$(get-account-key)
}

create-container() {
    az storage container create \
        --name ${1:-$CX_CONTAINER} \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        --public-access blob \
        -o table
}

add-cors() {
    az storage \
        cors add \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        --origins 'https://*.demo.catena-x.net,http://localhost:3000' \
        --methods GET \
        --max-age 200 \
        --services b
}

create-share() {
    az storage share create \
        --name ${1:-$CX_CONTAINER} \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        -o table
}

list-container() {
    az storage container list \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        -o table
}

list-blobs() {
    az storage blob list \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        --container-name ${1:-$CX_CONTAINER} \
        -o table
}

delete-blob() {
    az storage blob delete \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        --container-name $1 \
        --name $2 \
        -o table
}

delete-all() {
    list-blobs \
        | tail +3 \
        | cut -d' ' -f1 \
        | sed -e 's/^/delete-blob assets /g'
}

deploy-assets() {
    az storage blob upload-batch \
        --account-name ${CX_ACCOUNT} \
        --account-key ${CX_ACCOUNT_KEY} \
        --destination ${CX_CONTAINER} \
        --destination-path / \
        --source ./public/assets \
        --overwrite \
        -o table
}

create-index() {
    (cd public/assets && find . -type f) \
        | cut -c 3- \
	| sort \
        > public/assets/index.txt
}
