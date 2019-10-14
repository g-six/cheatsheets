#/bin/bash
printf "+----------------------------------------------+\n"
printf "| WARNING: You are running as $AWS_DEFAULT_PROFILE"
CHARS=$((17-${#AWS_DEFAULT_PROFILE}))
for i in $(seq $CHARS); do echo -n ' '; done
printf '|\n'
printf "+----------------------------------------------+\n"
