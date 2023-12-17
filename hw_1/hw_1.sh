#! /bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

step_number=1;
declare -a numbers

hit=0
miss=0

while :
do
random_number=${RANDOM: -1};

echo "Please enter number from 0 to 9 (q - quit):  "  
read guess

case "$guess" in
 [0-9])
	if [[ $guess == $random_number ]]
  	then
    		echo "Hit! My number: $random_number"
		hit=$((hit+1))
		number_string="${GREEN}${random_number}${RESET}"
  	else
    		echo "Miss! My number is $random_number"
		miss=$((miss+1))
		number_string="${RED}${random_number}${RESET}"
	fi

	numbers+=("${number_string}")
	total=$(( hit + miss ))
	let hit_percent=hit*100/total
  let miss_percent=100-hit_percent
	echo "Hit: ${hit_percent}%" "Miss: ${miss_percent}%"
	
	if [[ ${#numbers[@]} -gt 10 ]]
                then
                  echo -e "Numbers: ${numbers[*]: -10}"
                else
                  echo -e "Numbers: ${numbers[*]}"
  fi
  step_number=$((step_number+1))

 ;;
 q)
         
          echo "Exit"
          break
 ;;
 *)
          echo "Not valid input"
          echo "Please repeat"
          continue
 ;;
esac

  echo ""
done

