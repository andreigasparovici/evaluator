#!/bin/bash

if [ -e $1 ]; then
  echo "Missing first parameter: problem name!!"
  exit
fi

if [ -e $2 ]; then
  echo "Missing first parameter: time limit!!"
  exit
fi

./compile.sh
PROBLEM=$1 TIME=$2 ./eval.sh
