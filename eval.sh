#!/bin/bash

problem=$(printenv PROBLEM)
time_limit=$(printenv TIME)

declare -A scores

if [ -e $problem ]; then
  echo "Missing parameter PROBLEM"
  exit
fi

if [ -e $time_limit ]; then
  echo "Missing parameter TIME"
  exit
fi

echo "Compiling checker code..."
g++ eval/$problem.cpp -o eval/$problem
echo "Done"

echo

max_size=0

for file in ./exec/*
do
  rm sandbox/*
  noext=$(basename $file .cpp)
  echo "Evaluare: $noext.cpp"

  if [ ${#noext} -gt $max_size ]; then
    max_size=${#noext}
  fi

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
    elif [ $exit_code != 0 ]; then
      cd ..
      echo -e "Test #$total: \e[31mNon-zero exit code!\e[0m"
      continue
    fi

    cd ..

    ok="$(basename $input .in).ok"
    cp "tests/$ok" sandbox/$problem.ok

    if [ ! -f ./sandbox/$problem.out ]; then
      echo -e "Test #$total: \e[31mFisier de iesire lipsa!\e[0m"
      continue
    fi

    evaluation_result=$(./eval/$problem ./sandbox/$problem.in ./sandbox/$problem.out ./sandbox/$problem.ok)

    if [ $evaluation_result -eq "1" ]
    then
      echo -e "Test #$total: \e[32mCorect!\e[0m"
      pct=$((pct+1))
    else
      echo -e "Test #$total: \e[31mGresit!\e[0m"
    fi

  done

  scores["$noext"]="$pct/$total"
  echo
done

echo "Rezultate: "

max_size=$((max_size+1))

for file in ./exec/*
do
  noext=$(basename $file .cpp)
  printf "%-${max_size}s: %s\n" "$noext" "${scores[$noext]}"
done
