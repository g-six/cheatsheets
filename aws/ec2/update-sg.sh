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
FROM_PORT=22
TO_PORT=22

case $2 in
  me)
    CIDR=$(curl -s ifconfig.co)'/32';
    ;;
  *)
    CIDR=$2
    ;;
esac

SERVICE='ec2'
COMMAND=''
CMD="aws ${SERVICE}"
OPTS="--group-name ${3}"
DESCRIPTION="Description=${4}"

echo $#
if [[ $# -eq 6 ]] ; then
  FROM_PORT=$5
  TO_PORT=$6
fi

if [ $DESCRIPTION = "Description=" ]; then
  printf "\n${WRONG} ${RED}You need to provide a description for IP: ${CIDR}${NC}\n\n"
  exit
fi

case $1 in
  add)
    COMMAND='authorize-security-group-ingress'
    OPTS=$OPTS' --ip-permissions'
    OPTS=$OPTS' FromPort='$FROM_PORT',ToPort='$TO_PORT',IpProtocol=tcp,IpRanges=['
    OPTS=$OPTS"'"'{CidrIp='$CIDR','$DESCRIPTION"'}]"
    ;;
  remove)
    COMMAND='revoke-security-group-ingress'
    OPTS="${OPTS} --port 22 --protocol tcp --cidr ${CIDR}"
    ;;
  *)
    echo $WRONG'invalid use of command\nplease choose from\nadd, or\nremove\n'
    exit
    ;;
esac

CMD="${CMD} ${COMMAND} ${OPTS}"

printf "${RED}"
printf "$HEADER"
printf "${NC}\n\n"
printf "\$ ${ORANGE}aws${NC} ${YELLOW}${SERVICE}${NC} "
printf "${LCYAN}${COMMAND}${NC} \\"
printf "\n  ${LPURP}${OPTS}${NC} \n"
printf "\n  One moment please...."

eval "$CMD"

printf "\n\n  ${LCYAN}Done!${NC}"
echo $ROCKET
echo '\n'

