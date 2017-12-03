#!/bin/bash

add_cron_part_netre(){
    echo "#!/bin/bash" >> /etc/cron.daily/netreset
    echo "ifconfig eth0 down && ifconfig eth0 up" >> /etc/cron.daily/netreset
}

add_cron_part_reboot(){
    echo "#!/bin/bash" >> /etc/cron.weekly/reboot
    echo "systemctl reboot"
}