#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^-?[0-9]+$ ]]
  then
    ELEMENT_SEARCH_RESULT=$($PSQL "select atomic_number, symbol, name from elements where atomic_number=$1")
    if [[ -z $ELEMENT_SEARCH_RESULT ]] 
    then 
      echo "I could not find that element in the database."
    else
      echo $ELEMENT_SEARCH_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT
      do
        PROPERTIES=$($PSQL "select atomic_mass, melting_point_celsius,boiling_point_celsius, type_id  from properties where atomic_number=$1")

        echo $PROPERTIES | while IFS='|' read ATOMIC_MASS MELTING_POINT BOIL_POINT TYPE_ID
        do
          TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")
          echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOIL_POINT celsius."
        done
      done
    fi
  else
    ELEMENT_SEARCH_RESULT=$($PSQL "select atomic_number, symbol, name from elements where name='$1' or symbol='$1'")
    if [[ -z $ELEMENT_SEARCH_RESULT ]] 
    then 
      echo "I could not find that element in the database."
    else
      echo $ELEMENT_SEARCH_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT
      do
        PROPERTIES=$($PSQL "select atomic_mass, melting_point_celsius,boiling_point_celsius, type_id  from properties where atomic_number=$ATOMIC_NUMBER")

        echo $PROPERTIES | while IFS='|' read ATOMIC_MASS MELTING_POINT BOIL_POINT TYPE_ID
        do
          TYPE=$($PSQL "select type from types where type_id=$TYPE_ID")
          echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOIL_POINT celsius."
        done
      done
    fi
  fi
fi