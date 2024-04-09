#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
$($PSQL "truncate table teams, games")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER'")"
OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT'")"

if [[ -z $WINNER_ID ]]
then
INSERT_WINNER="$($PSQL "insert into teams(name) values('$WINNER')")"
if [[ $INSERT_WINNER = 'INSERT 0 1' ]]
then
echo TEAM $WINNER INSERTED
fi
fi
WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER'")"

#INSERT THE OPPONENT DATA TO TEAMS TABLE
if [[ -z $OPPONENT_ID ]]
then
INSERT_OPPONENT="$($PSQL "insert into teams(name) values('$OPPONENT')")"
if [[ $INSERT_OPPONENT = 'INSERT 0 1' ]]
then
echo TEAM $OPPONENT INSERTED
fi
fi
OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT'")"




#echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
INSERT_DATA="$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")";
echo $INSERT_DATA
fi
done
