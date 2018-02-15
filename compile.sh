#!/bin/bash

if [ "$(ls -A sources | grep -v ".gitkeep")" ]; then
  for file in ./sources/*
  do
    noext=$(basename $file .cpp)
    out_path="exec/$noext"
    error="$(g++ $file -std=c++11 -w -O2 -o $out_path 2>&1 > /dev/null)"

    if [ -z $error ]; then
      echo -e "$noext.cpp: \e[32mCompilat cu succes!\e[0m"
      system_calls=$(objdump -d exec/$noext | grep system@plt)
      if [ ! -z "$system_calls" ]; then
        echo -e "$noext.cpp: \e[31mUsage of system function not allowed!\e[0m"
        rm exec/$noext
      fi
    else
      echo -e "$noext.cpp: \e[31mEroare de compilare!\e[0m"
    fi
  done
else
  echo "Folderul sources este gol!"
  exit 1
fi

