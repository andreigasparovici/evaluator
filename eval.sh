#!/bin/bash

problem=$(printenv PROBLEM)
time_limit=$(printenv TIME)

g++ eval/$problem.cpp -o eval/$problem

if [ -e $problem ]; then
  echo "Missing parameter PROBLEM"
  exit
fi

if [ -e $time_limit ]; then
  echo "Missing parameter PROBLEM"
  exit
fi

for file in ./exec/*
do
  noext=$(basename $file .cpp)
  echo "Evaluare: $noext.cpp"

  pct=0
  total=0

  for input in $(ls tests/$problem*.in)
  do
    total=$((total + 1))
    cp "./exec/$noext" ./sandbox/$noext
    cp $input ./sandbox/$problem.in
    cd sandbox

    rm ./sandbox/$problem.out &> /dev/null

    { timeout ${time_limit}s ./$noext &> /dev/null; } &> /dev/null

    exit_code=$?

    if [ $exit_code == 124 ]; then
      echo -e "Test #$total: \e[31mLimita de timp depasita!\e[0m"
      cd ..
      continue
    elif [ $exit_code == 139 ]; then
      cd ..
      echo -e "Test #$total: \e[31mSegmentation fault!\e[0m"
      continue
    fi

    cd ..

    ok="$(basename $input .in).ok"
    cp "tests/$ok" sandbox/$problem.ok

    evaluation_result=$(./eval/$problem ./sandbox/$problem.in ./sandbox/$problem.out ./sandbox/$problem.ok)

    if [ $evaluation_result -eq "1" ]
    then
      echo -e "Test #$total: \e[32mCorect!\e[0m"
      pct=$((pct+10))
    else
      echo -e "Test #$total: \e[31mGresit!\e[0m"
    fi

  done

  total=$((total * 10))
  echo "Rezultat: $pct/$total puncte"
  echo
done
