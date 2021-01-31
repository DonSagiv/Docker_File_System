#!/bin/bash

if [ ! -f /init/init.d ]; then
    mkdir $FILE_SYSTEM_DIR
    useradd -d $FILE_SYSTEM_DIR -s /bin/bash -G fileSystem -u 1000 $USER_NAME
    echo $USER_NAME:$USER_PASSWORD | chpasswd
    sudochmod 0766 $FILE_SYSTEM_DIR
    chown $USER_NAME:fileSystem $FILE_SYSTEM_DIR

    # echo '' >> /etc/ssh/sshd_config
    # echo Match Group fileSystem >> /etc/ssh/sshd_config
    # echo '    ChrootDirectory '$FILE_SYSTEM_DIR >> /etc/ssh/sshd_config
    # echo '    ForceCommand internal-sftp' >> /etc/ssh/sshd_config
    # echo '    X11Forwarding no' >> /etc/ssh/sshd_config
    # echo '    AllowTcpForwarding no' >> /etc/ssh/sshd_config

    service ssh restart

    cp /etc/samba/smb.conf /etc/samba/smb_backup.conf
    sed -e s/__smb_name__/$FILE_SYSTEM_NAME/ -e s/__fileSystemDir__/"\\$FILE_SYSTEM_DIR"/ /etc/samba/smb_backup.conf > /etc/samba/smb.conf
    rm /etc/samba/smb_backup.conf

    (echo $USER_PASSWORD; echo $USER_PASSWORD) | smbpasswd -a $USER_NAME

    service smbd restart
    service nmbd restart
    
    echo true > /init/init.d
    
    echo initialized
fi

echo awaiting user input

tail -f /dev/null