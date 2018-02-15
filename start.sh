#!/bin/bash

if [ -e $1  ] || [ -e $2 ] ; then
  echo "Usage: ./start.sh [problem name] [time limit] [optional: csv file name]"
  exit
fi

csv_file=$3


rm exec/*
./compile.sh
echo

if [ -e $csv_file ]; then
  PROBLEM=$1 TIME=$2 ./eval.sh
else
  PROBLEM=$1 TIME=$2 CSV_FILE=$csv_file ./eval.sh
fi
