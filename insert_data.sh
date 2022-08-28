#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
  $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
  $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
  fi
  
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  if [[ $WINNER != winner && $OPPONENT != opponent && $YEAR != year && $ROUND != round && $WINNER_G != winner_goals && $OPPONENT_G != opponent_goals ]]
  then
  $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
           VALUES ($YEAR, '$ROUND', $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'"), $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'"), 
           $WINNER_G, $OPPONENT_G )")

  #echo "$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  #echo "$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

  
  fi
done 


