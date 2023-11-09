#!/bin/bash

echo "Updating and Installing"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
echo "Finished updating"
sleep 10
sudo reboot
