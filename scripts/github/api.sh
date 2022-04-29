#!/bin/bash

export API=https://api.github.com
export AUTH=oyo:$CR_PAT
export ORG=catenax-ng
export REPO=product-portal-common-assets
export REF=refs/heads/main
export AUTHOR='{"name":"Martin Rohrmeier","email":"martin.ra.rohrmeier@bmw.de"}'

#curl -su $AUTH $API/orgs/$ORG
#curl -su $AUTH $API/orgs/$ORG/repos
#curl -su $AUTH $API/repos/$ORG/$REPO
#curl -su $AUTH $API/repos/$ORG/$REPO/branches
#curl -su $AUTH $API/repos/$ORG/$REPO/commits
#curl -su $AUTH $API/repos/$ORG/$REPO/contents
curl -su $AUTH $API/repos/$ORG/$REPO/contents | jq '.[] | "\(.type) \(.name)"'

last-commit() {
    curl -su $AUTH $API/repos/$ORG/$REPO/branches/main \
        | jq .commit.sha
}

get-blob() {
    BLOB=$1
    curl -su $AUTH $API/repos/$ORG/$REPO/branches/main \
        | jq .commit.sha
}

create-blob() {
    CONTENT=$(</dev/stdin)
    echo '{"encoding":"base64","content":"'$(echo $CONTENT | base64)'"}' \
        | curl -su $AUTH $API/repos/$ORG/$REPO/git/blobs --data-binary @- \
        | jq .sha
}

create-tree() {
    LAST=$1
    BLOB=$2
    FILE=$3
    echo '{"base_tree":'$LAST',"tree":[{"path": "'$FILE'","mode":"100644","type":"blob","sha":'$BLOB'}]}' \
        | curl -su $AUTH $API/repos/$ORG/$REPO/git/trees --data-binary @- \
        | jq .sha
}

create-commit() {
    LAST=$1
    TREE=$2
    MESSAGE=$3
    echo '{"message":"'$MESSAGE'","author":'$AUTHOR',"parents":['$LAST'],"tree":'$TREE'}' \
        | curl -s -u $AUTH $API/repos/$ORG/$REPO/git/commits --data-binary @- \
        | jq .sha
}

update-ref() {
    COMMIT=$1
    echo '{"sha":'$COMMIT'}' \
        | curl -s -u $AUTH $API/repos/$ORG/$REPO/git/$REF --data-binary @- \
        | jq
}

push-single-file() {
    FILE=$1
    MESSAGE=$2
    LAST=$(last-commit)
    BLOB=$(cat $FILE | create-blob)
    TREE=$(create-tree $LAST $BLOB $FILE)
    COMMIT=$(create-commit $LAST $TREE $MESSAGE)
    update-ref $COMMIT
}