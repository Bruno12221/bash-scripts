#!/bin/bash
#
#usage : ./ssh_script.sh [-u user] [-h IP] [-i pub_key_path]
#
#requirements:
#sudo apt-get install openssh-server (on remote machine)
#
#script is meant to be run from local machine to enable ssh access to remote machine 
#checks for exsisting public key, if the key does not exist creates one 
#uses ssh-copy-id for copying the pub key to remote machine
#
# defaults
user="user"
host="1.2.3.4"
public_key_path="$HOME/.ssh/id_rsa.pub"

#read CLI args
OPTIND=1
# Reset in case getopts has been used previously in the shell

while getopts ":u:h:i:" arg; 
do 
	case "$arg" in 
	u) user="$OPTARG" 
	;;
	h) host="$OPTARG"
	;;
	i) public_key_path="$OPTARG"
	;;
	esac
done

echo "USER: $user"
echo "HOST: $host"
echo "PUBLIC KEY PATH: $public_key_path"


#check if id file exsists
#-f true if file exsists

if [ ! -f "$public_key_path" ]; then
	echo "public key does not exsist!"
	echo "generating new keys..."

# -x True if file exists and is executable.
	if [ -x "$(command -v /usr/bin/ssh-keygen)" ]; then
	
		key_path=${public_key_path%".pub"}
		/usr/bin/ssh-keygen -t rsa -N '' -f "$key_path" <<< y &>/dev/null
	
	else echo "Cant generate key!"; exit 1
	fi
fi

public_key=$(/bin/cat "$public_key_path")
echo "PUBLIC KEY: $public_key"


#check for ssh-copy-id and copy pub key

#kopira public key  
if [ -x "$(command -v /usr/bin/ssh-copy-id)" ]; then
	echo "copying with ssh-copy-id..."

	/usr/bin/ssh-copy-id -i "$public_key_path" "$user"@"$host"
	return_code="$?"

# $? exit status of last task 


	if [ "0" -eq "$return_code" ]; then
		echo "ssh-copy-id sucess!"; exit 0
	else 
		echo "ssh-copy-id failed!"; exit 1
	fi

fi
exit 0