#!/bin/bash


DIR=$(git rev-parse --show-toplevel)

#check if .env exists in the project's root
if [ ! -f "${DIR}/.env" ]; then
  echo ".env not found. Please create a .env file with the content GH_PAT=YOUR_ACCESS_TOKEN"
  exit 1
fi

#export github PAT as environment variable
export $(cat ${DIR}/.env | sed 's/#.*//g' | xargs)

#generate random number between 1-1000
RANDOM_NUM=$(( $RANDOM % 1000 + 1 ))

SRC_SHARK_FILE=${DIR}/content/sharks/whale.md

NEW_SHARK_FILE=${DIR}/content/sharks/shark-${RANDOM_NUM}.md

#make copy of whale.md
cp ${SRC_SHARK_FILE} ${NEW_SHARK_FILE}

#replace 'Whale' with shark-random_num
sed -i "s/Whale/shark-${RANDOM_NUM}/g" ${NEW_SHARK_FILE}

#replace date with current date
sed -i "s/date: .*/date: $(date -Iseconds)/g" ${NEW_SHARK_FILE}

#push the newly generated md file to github
git add ${NEW_SHARK_FILE}

git commit ${NEW_SHARK_FILE} -m 'added new shark'

git push --repo "https://${GH_PAT}@github.com/$(git remote -v | grep push | cut -d: -f2 | cut -d' ' -f1)"
