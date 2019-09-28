#!/bin/bash
HEADER=$(cat ./header.txt)

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
case $1 in
  add)
    COMMAND='authorize-security-group-ingress'
    OPTS='--ip-permissions'
    OPTS=$OPTS' FromPort=22,ToPort=22,IpProtocol=tcp,IpRanges=['
    OPTS=$OPTS"'"'{CidrIp=${CidrIp='$CIDR',Description='$4"'}]"
    ;;
  remove)
    COMMAND='revoke-security-group-ingress'
    OPTS="${OPTS} --port 22 --protocol tcp --cidr ${CIDR}"
    ;;
  *)
    echo 'invalid use of command\nplease choose from\nadd, or\nremove\n'
    exit
    ;;
esac

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
printf "\n  One moment please...."

eval "$CMD"

printf "\n\n  ${LCYAN}Done!${NC}"
echo '\xf0\x9f\x9a\x80'
echo '\n'

