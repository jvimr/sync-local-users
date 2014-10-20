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


  if [ ! -d  /home/$USERNAME/Desktop ]
  then
	mkdir /home/$USERNAME/Desktop
        chown $USERNAME:$USERNAME /home/$USERNAME/Desktop
  fi

  if [ ! -f /home/$USERNAME/Desktop/Změna_hesla.desktop ]
  then
        cat << EOF > /home/$USERNAME/Desktop/Změna_hesla.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Link
Icon[en_US]=gnome-panel-launcher
Name[en_US]=Změna hesla
URL=http://estu.platformx.org/setup/pc_accounts/$USERNAME/chpw
Comment[en_US]=Změna hesla pro přihlašování k tomuto počítači
Name=Změna hesla
Comment=Změna hesla pro přihlašování k tomuto počítači
Icon=gnome-panel-launcher
EOF

  fi

done

#nakonec zmenime hesla

wget -qN "$SRC_URL/passwords.txt"

chpasswd < passwords.txt
