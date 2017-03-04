#!/bin/bash


apt-get install python python-pip 
pip install ansible ansible-lint ansible-review markupsafe

mkdir -p /etc/ansible/{files,roles,playbooks,vars,inventory}

