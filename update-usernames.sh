#!/bin/bash

. ./.local-settings

#get username list

wget -N "$SRC_URL/usernames.txt"


for USERNAME in `cat usernames.txt`
do
  echo "user $USERNAME"
  if [ ! -d /home/$USERNAME ]
  then

    echo "user does not exists"
    wget -N "$SRC_URL/$USERNAME"
    
  #pokud se nam podari najit cele jmeno, pouzijeme ho
    if [ -f $USERNAME ]
    then
	    FULLNAME=`cat $USERNAME`
    else
 #pokud ne, tak nic :-)
        FULLNAME=$USERNAME
    fi

#$    nakonec vytvorime uzivatele

    adduser --disabled-password --shell /bin/bash --quiet --gecos "$FULLNAME,,,"  $USERNAME
    echo "user created $?"
  fi

done


