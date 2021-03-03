#!/bin/bash -x

source .env

REPO=icb
OWNER=Incuvers
LOCAL_KEY_PATH="$HOME/.ssh/test_key.pub"

gen_payload(){
    cat <<EOF
{
    "key": "$PUB_KEY",
    "read_only": true,
    "title": "Test deploy"
}
EOF
}

# generate deploy key
ssh-keygen -b 4096 -t rsa -f "$HOME"/.ssh/test_key -q -N ""

# save pub key
PUB_KEY=$(< "$LOCAL_KEY_PATH")

# create deploy key
printf "%b" "${OKB}Starting post request for deploy key creation${NC}:\n"
curl -X "POST" \
     -H "Authorization: token $PA_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -d "$(gen_payload)" \
     https://api.github.com/repos/"$OWNER"/"$REPO"/keys
# list deploy keys
printf "%b" "${OKB}Fetching repository deploy keys:${NC}\n"
curl -X "GET" \
     -H "Authorization: token $PA_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/repos/"$OWNER"/"$REPO"/keys

# intelligent key removal > compare against local public key
# First check if the deploy key is present locally; if not ignore step

printf "%b" "${OKB}Simulating deploy key teardown${NC}\n"
if [ -f "$LOCAL_KEY_PATH" ]; then
    printf "%b" "${OKB}Found expected key locally${NC}"
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
else
    printf "%b" "${OKB}Expected key not found locally${NC}\n"
fi

printf "%b" "${OKB}Removing keygen${NC}\n"
rm -f "$HOME/.ssh/test_key.pub" "$HOME/.ssh/test_key"