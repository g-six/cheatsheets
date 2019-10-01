#!/bin/bash
HEADER=$(cat ./header.txt)

SERVICE='ec2'
CMD="aws ${SERVICE}"
OPTS="--group-name "$1
COMMAND='describe-security-groups'
if [ -z $1 ]; then
  OPTS='';
fi

CMD="${CMD} ${COMMAND} ${OPTS}"

CYAN='\033[0;36m'
LCYAN='\033[1;36m'
LPURP='\033[1;35m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printf "${RED}"
printf "$HEADER"
printf "${NC}\n\n"
printf "\$ ${ORANGE}aws${NC} ${YELLOW}${SERVICE}${NC} "
printf "${LCYAN}${COMMAND}${NC} \\"
printf "\n  ${LPURP}${OPTS}${NC} \n"
printf "\n  One moment please....\n"

eval "$CMD"

printf "\n  ${LCYAN}Done!${NC}"
echo '\xf0\x9f\x9a\x80'
echo '\n'

