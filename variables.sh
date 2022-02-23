#!/bin/bash
 a=100
 b=apple
 c=true

 echo a = $a
 echo a in currency = ${a}USD

# shellcheck disable=SC1068
DATE=12-08-2021
echo "Good morning Today date is ${DATE}"

DATE=$(date +%D)
echo "Good morning Today date is ${DATE}"

ADD=$((2+3))
echo ADD = ${ADD}

echo user=${USER}
echo A=$A


read -p "enter your name :" username
read -p "enter your age :" age

echo "username is : ${username} age is ${age}"