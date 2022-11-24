#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPPGOALS

do
    # get team from winners
    TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ $WINNER != "winner" ]]
      then
    # if not found
      if [[ -z $TEAMS ]]
        then
      # insert team
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_TEAM == "INSERT 0 1" ]]
          then
            echo Inserted into teams, $WINNER
        fi
      fi
    fi
    
    # get team from opponent
    TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ $OPPONENT != "opponent" ]]
      then
    # if not found
      if [[ -z $TEAMS2 ]]
        then
      # insert team
        INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
          then
            echo Inserted into teams, $OPPONENT
        fi
      fi
    fi

    # get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert game
    if [[ -n $WINNER_ID || -n $OPPONENT_ID ]]
    then
      if [[ $YEAR != "year" ]]
      then
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINGOALS, $OPPGOALS)")
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
            echo Inserted into games, $YEAR
        fi
      fi
    fi
   
done
