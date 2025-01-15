#!/bin/bash

cd ../snow-spider-agent/methods/spider-self-refine

pip install --upgrade pip
pip install -r "requirements.txt"

sudo ln -sf /bin/python3.11 /usr/bin/python

python spider_agent_setup_snow.py
python reconstruct_data.py --example_folder examples

cd ~/results-log
python get_subset.py

cp -r ./output ../snow-spider-agent/methods/spider-self-refine

echo "*/10 * * * * /root/results-log/auto_push.sh" | crontab -