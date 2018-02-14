#!/bin/bash
for file in ./sources/*
do
  noext=$(basename $file .cpp)
  out_path="exec/$noext"
  error="$(g++ $file -std=c++11 -w -O2 -o $out_path 2>&1 > /dev/null)"

  if [ -z $error ]; then
    echo -e "$noext.cpp: \e[32mCompilat cu succes!\e[0m"
  else
    echo -e "$noext.cpp: \e[31mEroare de compilare!\e[0m"
  fi
done
