#!/bin/bash

. ./.local-settings

PATH=/usr/sbin:/sbin:$PATH

#get username list

wget -qN "$SRC_URL/usernames.txt"


for USERNAME in `cat usernames.txt`
do
#  echo "user $USERNAME"
  if [ ! -d /home/$USERNAME ]
  then

    echo "user $USERNAME does not exists"
    wget -qN "$SRC_URL/$USERNAME"
    
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
    echo "user $USERNAME created $?"
  fi

done

#nakonec zmenime hesla

wget -qN "$SRC_URL/passwords.txt"

chpasswd < passwords.txt
