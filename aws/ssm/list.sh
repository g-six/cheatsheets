#!/bin/bash
HEADER=$(cat ./header.txt)

# Color definitions
CYAN='\033[0;36m'
LCYAN='\033[1;36m'
LPURP='\033[1;35m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Emojis
ROCKET='\xf0\x9f\x9a\x80'
WRONG='\xe2\x9d\x8c'

if [ -z $1 ]; then
  printf "\n${WRONG} ${RED}Please provide key name.${NC}\n\n"
  exit
fi

SERVICE='ssm'
COMMAND='get-parameters'
CMD="aws ${SERVICE}"
OPTS="--names ${1}"

CMD="${CMD} ${COMMAND} ${OPTS}"

printf "${RED}"
printf "$HEADER"
printf "${NC}\n\n"
printf "\$ ${ORANGE}aws${NC} ${YELLOW}${SERVICE}${NC} "
printf "${LCYAN}${COMMAND}${NC} \\"
printf "\n  ${LPURP}${OPTS}${NC} \n"
printf "\n  One moment please...\n"

eval "$CMD"

printf "\n\n  ${LCYAN}Done!${NC}"
echo $ROCKET
echo '\n'

