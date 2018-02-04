#!/usr/bin/env bash
usersandmails="./usersandmails.txt"
#input="./mail_test.txt"
todays=$(date --utc "+%FT%T.%N" | cut -d "T" -f1 | sed 's/\-//g')

while IFS= read -r var
do
echo "$var"
githubuser=$(echo "$var" | awk '{ print $1 }')
mail=$(echo "$var" | awk '{ print $2 }')
mkdir -p "$githubuser"
dir="./$githubuser/"

curl -s "https://api.github.com/users/${githubuser}/events" > "$dir$githubuser.log"
cat "$dir$githubuser.log" | jq '.[] | .created_at' > "$dir$githubuser.createdat"
head -1 "$dir$githubuser.createdat" > "$dir$githubuser.latest"

file=$dir$githubuser.plain
createdat=$dir$githubuser.createdat
if [ -s $createdat ]; then
  if [ -f $file ]; then
  #if file plain exists
    cat "$dir$githubuser.latest" | sed 's/T.*//' | sed 's/-//g' | sed 's/\"//' > $dir$githubuser.test
    if diff $dir$githubuser.test $dir$githubuser.plain >/dev/null ; then
      echo same
    else
      echo different
      mv $dir$githubuser.test $dir$githubuser.plain
      cont=$(cat $file)
      d1=`date -d "$todays" "+%s"`
      d2=`date -d "$cont" "+%s"`
      diff=$(($d1-$d2))
      days=$(($diff/(60*60*24)))
      out="Last active: "$days" days ago"
      subject="$githubuser"
      email="$mail"
      emailmessage="./activity.txt"
      echo "$out" > $emailmessage
      mail -s "$subject" "$email" < $emailmessage
    fi
  elif [ ! -f $file ]; then
    cat "$dir$githubuser.latest" | sed 's/T.*//' | sed 's/-//g' | sed 's/\"//' > $dir$githubuser.plain
    cont=$(cat $file)
    d1=`date -d "$todays" "+%s"`
    d2=`date -d "$cont" "+%s"`
    diff=$(($d1-$d2))
    days=$(($diff/(60*60*24)))
    out="Last active: "$days" day(s) ago"
    subject="$githubuser"
    email="$mail"
    emailmessage="./activity.txt"
    echo "$out" > $emailmessage
    mail -s "$subject" "$email" < $emailmessage
  fi
else
out="Github barely remembers "$githubuser". It's been >90 days!"
subject="$githubuser"
email="$mail"
emailmessage="./activity.txt"
echo "$out" > $emailmessage
mail -s "$subject" "$email" < $emailmessage
fi
done< "$usersandmails"
