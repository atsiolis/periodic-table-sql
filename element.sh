#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."
else
  
fi