#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
	# ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1 OR name = '$1' OR symbol = '$1'")
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi
  fi
  
  ATOMIC_NUMBER_FORMATED=$(echo $ATOMIC_NUMBER | sed 's/^ *//')
  
	if [[ -z $ATOMIC_NUMBER ]]
	then
		echo "I could not find that element in the database."
  else
		NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME_FORMATED=$(echo $NAME | sed 's/^ *//')
		SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL_FORMATED=$(echo $SYMBOL | sed 's/^ *//')
		TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE_FORMATED=$(echo $TYPE | sed 's/^ *//')
		ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS_FORMATED=$(echo $ATOMIC_MASS | sed 's/^ *//')
		MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT_FORMATED=$(echo $MELTING_POINT | sed 's/^ *//')
		BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT_FORMATED=$(echo $BOILING_POINT | sed 's/^ *//')

    echo "The element with atomic number $ATOMIC_NUMBER_FORMATED is $NAME_FORMATED ($SYMBOL_FORMATED). It's a $TYPE_FORMATED, with a mass of $ATOMIC_MASS_FORMATED amu. $NAME_FORMATED has a melting point of $MELTING_POINT_FORMATED celsius and a boiling point of $BOILING_POINT_FORMATED celsius."
  fi
else
	echo "Please provide an element as an argument."
fi
