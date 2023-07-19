#!/bin/bash

usage() 
{
    echo "-1 install_monitor_tools" 
    echo "-2 install_misc" 
    echo "-3 sync_configs" 
    echo "-4 pyload_mgr" 
   
    exit 1;
}

install_monitor_tools() 
{
    # rpi monitor
    sudo wget http://goo.gl/vewCLL -O /etc/apt/sources.list.d/rpimonitor.list
    sudo apt-get update

    sudo apt-get install rpimonitor
}

install_misc()
{
    # tightvnc
    sudo apt-get install tightvncserver
}

sync_configs()
{
    sudo cp -v /home/gobbi/projects/my_pi_configs/boot_config.txt /boot/config.txt
    sudo cp -v /home/gobbi/projects/my_pi_configs/boot_cmdline.txt /boot/cmdline.txt

    # misc
    sudo ln -s /home/gobbi/projects/my_pi_configs/vnc_service.service /etc/systemd/system/vnc_service.service
    sudo systemctl daemon-reload
    sudo systemctl enable vnc.service
}

pyload_mgr()
{
    if [ -d "/home/gobbi/projects/pyload_mgr" ]; then
        cd /home/gobbi/projects/pyload_mgr
        git pull
    else
        git clone https://github.com/losgobbi/pyload_mgr.git /home/gobbi/projects/
    fi

    sudo ln -s /home/gobbi/projects/pyload_mgr/misc/my_py_mgr.service /etc/systemd/system/my_py_mgr.service
    sudo systemctl daemon-reload
    sudo systemctl enable my_py_mgr
}

while getopts '1234' opt; do
  case "$opt" in
    1)
      install_monitor_tools
      exit 0
      ;;

    2)
      install_misc
      exit 0
      ;;

    3)
      sync_configs
      exit 0
      ;;

    4)
      pyload_mgr
      exit 0
      ;;
   
    *)
      usage
      exit 1
      ;;
  esac
done

usage
exit 1