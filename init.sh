#!/bin/bash

cd ../snow-spider-agent/methods/spider-self-refine

pip install --upgrade pip
pip install -r "requirements.txt"

sudo ln -sf /bin/python3.11 /usr/bin/python

python spider_agent_setup_snow.py
python reconstruct_data.py --example_folder examples

gdown 'https://drive.google.com/uc?id=1coEVsCZq-Xvj9p2TnhBFoFTsY-UoYGmG' -O ../../spider2-lite/resource/
rm -rf ../../spider2-lite/resource/databases/spider2-localdb
mkdir -p ../../spider2-lite/resource/databases/spider2-localdb
unzip ../../spider2-lite/resource/local_sqlite.zip -d ../../spider2-lite/resource/databases/spider2-localdb
python spider_agent_setup_lite.py
python reconstruct_data.py --example_folder examples_lite

cd ~/results-log
python get_subset.py

cp -r ./output ../snow-spider-agent/methods/spider-self-refine