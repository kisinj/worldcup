#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams CASCADE;")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
# year,round,winner,opponent,winner_goals,opponent_goals
do
  if [[ $YEAR != 'year' ]]
  then 
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    if [[ -z $TEAM_ID ]]
    then
      TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    else
      WINNER_ID=$TEAM_ID
    fi
    SND_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $SND_TEAM_ID ]]
    then
      TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    else
      OPPONENT_ID=$SND_TEAM_ID
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done
