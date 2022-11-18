#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_RESULT(){
  echo "$SEARCH_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
    do
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      fi     
    done
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]{0,3}$ ]]
  then
    SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements LEFT JOIN properties using(atomic_number) LEFT JOIN types ON properties.type_id = types.type_id WHERE atomic_number = $1")
    PRINT_RESULT
  else
    if [[ $1 =~ ^[A-Z][a-zA-Z]?$ ]]
    then
      SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements LEFT JOIN properties using(atomic_number) LEFT JOIN types ON properties.type_id = types.type_id WHERE symbol = '$1'")
      PRINT_RESULT
    else
      if [[ $1 =~ ^[a-zA-Z]{3,}$ ]]
      then
        SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM elements LEFT JOIN properties using(atomic_number) LEFT JOIN types ON properties.type_id = types.type_id WHERE name = '$1'")
        PRINT_RESULT
      else
        echo "Please provide a valid Element"
      fi
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
