#!/bin/bash
#storing command to access database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#checking if user has given an argument
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #argument is atomic number?
  ATOMIC_N=$1
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_N")
  #check if query was successful
  if [[ -z $NAME ]]
  then
	  #argument is symbol?
	  SYMBOL=$1
  	ATOMIC_N=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
	  #check if query was successful
    if [[ -z $ATOMIC_N ]]
	  then
		  #argument is name?
		  NAME=$1
		  ATOMIC_N=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
      #check if the query was successful
      if [[ -z $ATOMIC_N ]]
		  then
			  #could not find an entry, exiting
			  echo "I could not find that element in the database."
			  exit
		  fi
	  fi
  fi
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_N")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_N")
  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_N")
  ATOMIC_M=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_N")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_N")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_N")
  echo "The element with atomic number $ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_M amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

  
fi
