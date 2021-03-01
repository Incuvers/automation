#!/bin/bash -x

source .env

REPO=icb
OWNER=Incuvers

# # create deploy key
# curl -X "POST" \
#     -H "Authorization: token $PA_TOKEN" \
#     -H "Accept: application/vnd.github.v3+json" \
#     https://api.github.com/repos/"$OWNER"/"$REPO"/keys \
#     -d "{'key':"$PUB_KEY", 'read_only': true, 'title': 'Test deploy'}"
# curl -X "GET" \
#     -H "Authorization: token $PA_TOKEN" \
#     -H "Accept: application/vnd.github.v3+json" \
#     https://api.github.com/repos/"$OWNER"/"$REPO"/keys



# # list keys
# KEY_ID=$(curl -X "GET" \
#             -H "Authorization: token $PA_TOKEN" \
#             -H "Accept: application/vnd.github.v3+json" \
#             https://api.github.com/repos/"$OWNER"/"$REPO"/keys | jq '.[] | .id ')
# KEY_ID=$(curl -X "GET" \
#             -H "Authorization: token $PA_TOKEN" \
#             -H "Accept: application/vnd.github.v3+json" \
#             https://api.github.com/repos/"$OWNER"/"$REPO"/keys | jq '.[] | .id ')
# echo $KEY_ID


# remove deploy key
# KEY_ID=50744166
# curl -X "DELETE" \
#     -H "Authorization: token $PA_TOKEN" \
#     -H "Accept: application/vnd.github.v3+json" \
#     https://api.github.com/repos/"$OWNER"/"$REPO"/keys/"$KEY_ID"

# intelligent key removal > compare against local public key
# First check if the deploy key is present locally; if not ignore step
LOCAL_KEY_PATH="$HOME/.ssh/id_rsa.pub"

if [ -f $LOCAL_KEY_PATH ]; then
    # save the deploy key for reference against deploy key list
    LOCAL_KEY=$( < $LOCAL_KEY_PATH)
    # get a list of all deploy keys
    curl -X "GET" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $PA_TOKEN" \
        https://api.github.com/repos/"$OWNER"/"$REPO"/keys | \
        jq '.[] | .id' | \
        while read _id; do
            # get deploy key @ id
            TEST_KEY=$(curl -X "GET" \
                -H "Authorization: token $PA_TOKEN" \
                -H "Accept: application/vnd.github.v3+json" \
                https://api.github.com/repos/"$OWNER"/"$REPO"/keys/$_id | \
                jq '.[] | .key')
            # validate against LOCAL_KEY if match then delete else skip
            if [ "$TEST_KEY" == "$LOCAL_KEY" ]; then
                printf "%b" "${OKB}Deploy key match found @ $_id${NC}"
                # curl -X "DELETE" \
                #     -H "Authorization: token $PA_TOKEN"\
                #     https://api.github.com/repos/"$OWNER"/"$REPO"/keys/$_id
                break
            fi
        done
else
    printf "%b" "${OKB}Expected key not found locally${NC}"
fi
