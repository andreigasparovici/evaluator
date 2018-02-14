#!/bin/bash

if [ -e $1  ] || [ -e $2 ] ; then
  echo "Usage: ./start.sh [problem name] [time limit]"
  exit
fi


./compile.sh
echo
PROBLEM=$1 TIME=$2 ./eval.sh
