#!/bin/bash

. ./.local-settings

PATH=/usr/sbin:/sbin:$PATH

#get username list

wget -qN "$SRC_URL/users.txt"


for USERNAME in `cat users.txt`
do
#  echo "user $USERNAME"
  if [ ! -d /home/$USERNAME ]
  then

    echo "user $USERNAME does not exists"
    wget -qN -O $USERNAME.txt "$SRC_URL/$USERNAME/user.txt"
    
  #pokud se nam podari najit cele jmeno, pouzijeme ho
    if [ -f $USERNAME.txt ]
    then
	    FULLNAME=`cat $USERNAME.txt`
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
