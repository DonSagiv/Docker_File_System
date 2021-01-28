#!/bin/bash

mkdir $FILE_SYSTEM_DIR
useradd -d $FILE_SYSTEM_DIR  -s /bin/false -G fileSystem -u 1000 $USER_NAME
echo $USER_NAME:$USER_PASSWORD | chpasswd
chmod 0666 $FILE_SYSTEM_DIR

echo '' >> /etc/ssh/sshd_config
echo Match User $USER_NAME >> /etc/ssh/sshd_config
echo ChrootDirectory /$FILE_SYSTEM_DIR >> /etc/ssh/sshd_config

service ssh restart

cp /etc/samba/smb.conf /etc/samba/smb_backup.conf
sed -e s/__smb_name__/$FILE_SYSTEM_NAME/ -e s/__fileSystemDir__/"\\$FILE_SYSTEM_DIR"/ /etc/samba/smb_backup.conf > /etc/samba/smb.conf
rm /etc/samba/smb_backup.conf

(echo $USER_PASSWORD; echo $USER_PASSWORD) | smbpasswd -a $USER_NAME

service smbd restart
service nmbd restart

tail -f /dev/null