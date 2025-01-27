import os
import shutil
import json

def get_full_list(json_name, all_path):
    json_path = os.path.join(all_path, json_name)
    task_list = []
    with open(json_path) as f:
        for line in f:
            line_js = json.loads(line)
            task_list.append(line_js['instance_id'])
    return task_list

snow_all_path = "../snow-spider-agent/methods/spider-self-refine/examples"
lite_all_path = "../snow-spider-agent/methods/spider-self-refine/examples_lite"
snow_json_name = "spider2-snow.jsonl"
lite_json_name = "spider2-lite.jsonl"
snow_full_list = get_full_list(snow_json_name, snow_all_path)
lite_full_list = get_full_list(lite_json_name, lite_all_path)

intersect_list = list(set(lite_full_list) & set(snow_full_list))

snow_log_path = "../snow-spider-agent/methods/spider-self-refine/output/o1-preview-snow-log"
lite_log_path = "../snow-spider-agent/methods/spider-self-refine/output/o1-preview-lite-log"

for id in os.listdir(snow_log_path):
    if id in lite_full_list:
        shutil.copytree(os.path.join(snow_log_path, id), os.path.join(lite_log_path, id))