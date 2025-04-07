#!/bin/bash

# Define the PostgreSQL command with flags for formatting
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."

else
  # Check if the input is a number (atomic number)
  if [[ "$1" =~ ^-?[0-9]+$ ]]
  then
    # Search by atomic number
    ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")

    # If the element is not found
    if [[ -z $ELEMENT_SEARCH_RESULT ]] 
    then 
      echo "I could not find that element in the database."
    else
      # Read the search result into variables
      echo $ELEMENT_SEARCH_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT
      do
        # Query the element's properties using the atomic number
        PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$1")

        # Read the properties into variables
        echo $PROPERTIES | while IFS='|' read ATOMIC_MASS MELTING_POINT BOIL_POINT TYPE_ID
        do
          # Get the element type name using the type_id
          TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

          # Print the full description
          echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOIL_POINT celsius."
        done
      done
    fi

  else
    # Input is not a number, so treat it as a symbol or name
    ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name='$1' OR symbol='$1'")

    # If the element is not found
    if [[ -z $ELEMENT_SEARCH_RESULT ]] 
    then 
      echo "I could not find that element in the database."
    else
      # Read the search result into variables
      echo $ELEMENT_SEARCH_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL ELEMENT
      do
        # Query the element's properties using the atomic number
        PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

        # Read the properties into variables
        echo $PROPERTIES | while IFS='|' read ATOMIC_MASS MELTING_POINT BOIL_POINT TYPE_ID
        do
          # Get the element type name using the type_id
          TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

          # Print the full description
          echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOIL_POINT celsius."
        done
      done
    fi
  fi
fi
