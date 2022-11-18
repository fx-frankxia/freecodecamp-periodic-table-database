#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PROPERTIES=$($PSQL "SELECT atomic_number, atomic_mass::REAL FROM properties")
echo "$PROPERTIES" | while read ID BAR ATOMIC_MASS
do
  echo "$ID, $ATOMIC_MASS"
  UPDATE=$($PSQL "UPDATE properties SET atomic_mass = $ATOMIC_MASS WHERE atomic_number = $ID")
done