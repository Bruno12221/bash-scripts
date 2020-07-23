#!/bin/bash
#
#script to check load averages and disk space utilization and send email if limits are exceeded
#
#automate with crontab
#
#specify email to send alerts to
email=""
#specify cpu load average limit
loadavg_limit="0.1"
#Specify mount point below (eg. /dev/sda1)
mount_point="/dev/sda5"
#specify alert disk usage percantage
disk_usage_limit="10"


current_loadavg=$(cat /proc/loadavg | awk '{print $3}')

current_disk_usage=$(df -h | grep "$mount_point" | awk '{print $5}' | sed 's/%//g')



if (( $(echo ""$current_loadavg" >= "$loadavg_limit"" | /usr/bin/bc -l))); #Piping through the basic calculator command bc returns either 1 or 0.
then echo "Subject: LOAD AVERAGE ALERT: 15 min load average on "$(hostname)" is "$current_loadavg" and grater than "$loadavg_limit", "$(date)" " | /usr/sbin/ssmtp "$email"
echo "LOADAVG ALERT: Sending email to "$email""

else echo "Load avg OK"
fi


if (( $(echo ""$current_disk_usage" >= "$disk_usage_limit"" | /usr/bin/bc -l)));
then echo "Subject: DISK SPACE ALERT: Disk usage on "$(hostname)", "$mount_point" is "$current_disk_usage" and grater than "$disk_usage_limit", "$(date)" " | /usr/sbin/ssmtp "$email"
echo "DISK USAGE ALERT: Sending email to "$email""

else echo "Disk usage OK"
fi


exit 0
