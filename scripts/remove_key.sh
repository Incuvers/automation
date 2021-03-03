#!/bin/bash -l

source .env

trap 'handler $? $LINENO' ERR

handler() {
    printf "%b" "${FAIL} ✗ ${NC} key removal failed with error code $1 on line $2\n"
    exit $1
}

usage() {
  cat <<EOF
Usage: ./deploy.sh [arg1] [arg2] [arg3]

Remove matching local and upstream deploy key from a repository. 

Required arguments:
[arg1]      Repository owner
[arg2]      Repository
[arg3]      Local key filename
EOF
}

# arg 1: REPO name
if [ "$#" -ne 3 ]; then
    printf "%b" "${FAIL}Missing required arguments${NC}\n"
    printf "%b" "$(usage)\n"
    exit 1
fi

gen_payload(){
    cat <<EOF
{
    "key": "$PUB_KEY",
    "read_only": true,
    "title": "Test deploy"
}
EOF
}

# resolve vars
OWNER="$1"
REPO="$2"
LOCAL_KEY_PATH="$HOME/.ssh/$3.pub"

# save target pub key
PUB_KEY=$(< "$LOCAL_KEY_PATH")

# list deploy keys
printf "%b" "${OKB}Fetching repository deploy keys:${NC}\n"
curl -X "GET" \
     -H "Authorization: token $PA_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/repos/"$OWNER"/"$REPO"/keys

# intelligent key removal > compare against local public key
# First check if the deploy key is present locally; if not ignore step
printf "%b" "${OKB}Starting deploy key teardown${NC}\n"
# save the deploy key for reference against deploy key list
LOCAL_KEY=$( < "$LOCAL_KEY_PATH")
# cut hostname out of key to match return format from api
LOCAL_KEY="$(echo "$LOCAL_KEY" | cut -d ' ' -f -2)"
# get a list of all deploy keys
curl -X "GET" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $PA_TOKEN" \
        https://api.github.com/repos/"$OWNER"/"$REPO"/keys | \
    jq '.[] | .id' | \
    while read -r _id; do
        # get deploy key @ id
        TEST_KEY=$(curl -X "GET" \
            -H "Authorization: token $PA_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/"$OWNER"/"$REPO"/keys/"$_id" | \
            jq '.key')
    # remove "" for string comparison
    TEST_KEY=$(echo "$TEST_KEY" | tr -d \")
        # validate against LOCAL_KEY if match then delete else skip
        if [ "$TEST_KEY" == "$LOCAL_KEY" ]; then
            printf "%b" "${OKB}Deploy key match found @ $_id${NC}"
            curl -X "DELETE" \
                    -H "Authorization: token $PA_TOKEN"\
                    https://api.github.com/repos/"$OWNER"/"$REPO"/keys/"$_id"
            break
        fi
    done
fi

printf "%b" "${OKG} ✓ ${NC} key removal complete\n"