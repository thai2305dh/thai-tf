#!/bin/bash -ex
                  sudo rm -rf /var/lib/apt/lists/lock
                  sudo apt update
                  sudo apt install nginx -y