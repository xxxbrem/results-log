import os
import shutil
import json

snow_close_list = [
    "sf_bq002", "sf_bq007", "sf_bq011", "sf_bq028", "sf_bq033", "sf_bq039", "sf_bq062", "sf_bq098", "sf_bq099", "sf_bq112", "sf_bq113", "sf_bq119", "sf_bq123", "sf_bq150", 
    "sf_bq160", "sf_bq166", "sf_bq175", "sf_bq185", "sf_bq198", "sf_bq208", "sf_bq215", "sf_bq218", "sf_bq219", "sf_bq229", "sf_bq283", "sf_bq293", "sf_bq294", 
    "sf_bq309", "sf_bq321", "sf_bq330", "sf_bq338", "sf_bq346", "sf_bq350", "sf_bq354", "sf_bq356", "sf_bq363", "sf_bq374", "sf_bq380", "sf_bq383", "sf_bq400", 
    "sf_bq442", "sf_bq460", "sf_bq461", "sf_ga006", "sf_ga008", "sf_ga013", "sf_ga017", "sf_local004", "sf_local032", 
    "sf_local049", "sf_local059", "sf_local066", "sf_local068", "sf_local081", "sf_local085", "sf_local114", "sf_local130", "sf_local132", "sf_local152", 
    "sf_local195", "sf_local196", "sf_local197", "sf_local201", "sf_local212", "sf_local219", "sf_local220", "sf_local264", "sf_local272", "sf_local300", "sf_local311", "sf_local330"
]

snow_correct_list = [
    "sf_bq001", "sf_bq006", "sf_bq010", "sf_bq018", "sf_bq021", "sf_bq025", "sf_bq032", "sf_bq034", "sf_bq035", "sf_bq056", "sf_bq059", "sf_bq060", "sf_bq061", "sf_bq066", "sf_bq076", 
    "sf_bq077", "sf_bq081", "sf_bq085", "sf_bq090", "sf_bq091", "sf_bq097", "sf_bq103", "sf_bq109", "sf_bq115", "sf_bq121", "sf_bq126", "sf_bq130", "sf_bq135", "sf_bq143", "sf_bq151", 
    "sf_bq158", "sf_bq161", "sf_bq172", "sf_bq176", "sf_bq210", "sf_bq211", "sf_bq213", "sf_bq214", "sf_bq216", "sf_bq224", "sf_bq227", "sf_bq228", "sf_bq235", "sf_bq252", "sf_bq255", "sf_bq279",
    "sf_bq280", "sf_bq281", "sf_bq282", "sf_bq284", "sf_bq285", "sf_bq286", "sf_bq289", "sf_bq300", "sf_bq302", "sf_bq303", "sf_bq308", "sf_bq310", "sf_bq327", "sf_bq328", "sf_bq341", "sf_bq345", "sf_bq352", 
    "sf_bq355", "sf_bq357", "sf_bq359", "sf_bq361", "sf_bq362", "sf_bq375", "sf_bq377", "sf_bq379", "sf_bq389", "sf_bq392", "sf_bq394", "sf_bq396", "sf_bq398", "sf_bq399", "sf_bq406", "sf_bq414", 
    "sf_bq421", "sf_bq444", "sf_ga001", "sf_ga002", "sf_ga003", "sf_ga004", "sf_ga007", "sf_ga010", "sf_ga020", "sf_local008", "sf_local017", "sf_local019", "sf_local022", "sf_local023", "sf_local026", "sf_local028", "sf_local031", 
    "sf_local038", "sf_local039", "sf_local041", "sf_local054", "sf_local056", "sf_local058", "sf_local065", "sf_local067", "sf_local071", "sf_local072", "sf_local074", "sf_local075", "sf_local078", "sf_local099", 
    "sf_local131", "sf_local141", "sf_local163", "sf_local193", "sf_local198", "sf_local199", "sf_local202", "sf_local210", "sf_local218", "sf_local221", "sf_local244", 
    "sf_local274", "sf_local284", "sf_local301", "sf_local309", "sf_local329", "sf001", "sf010", "sf014", "sf044"
]

lite_close_list = [
    "bq002", "bq011", "bq039", "bq098", "bq112", "bq113", "bq119", "bq123", 
    "bq185", "bq198", "bq208", "bq218", "bq229", "bq235", "bq293", 
    "bq309", "bq330", "bq338", "bq350", "bq354", "bq356", "bq363", "bq374", "bq383", "bq400", 
    "bq442", "bq461", "ga006", "ga008", "ga013", "ga017", "local004", "local032", 
    "local049", "local059", "local066", "local068", "local081", "local085", "local114", "local130", "local132", "local152", 
    "local195", "local196", "local197", "local201", "local212", "local219", "local220", "local264", "local272", "local300", "local311", "local330"
]
# lite_close = [
#     "sf_bq007", "sf_bq028", "sf_bq033", "sf_bq062", "sf_bq099", "sf_bq150", "sf_bq160", "sf_bq166", "sf_bq175", "sf_bq215", "sf_bq219", "sf_bq283", "sf_bq294", "sf_bq321", "sf_bq346", "sf_bq380", "sf_bq460"
# ]
# lite_correct_list = [
#     "sf_bq056", "sf_bq091", "sf_bq121", "sf_bq135", "sf_bq158", "sf_bq176", "sf_bq210", "sf_bq211", "sf_bq213", "sf_bq214", "sf_bq216", "sf_bq224", 
#     "sf_bq235", "sf_bq252", "sf_bq255", "sf_bq289", "sf_bq341", "sf_bq345",
#     "sf_bq359", "sf_bq361", "sf_bq375", "sf_bq377",
#     "sf_bq421", "sf_bq444", "sf001", "sf010", "sf014", "sf044"
# ]
lite_correct_list = [
    "bq001", "bq006", "bq010", "bq018", "bq021", "bq025", "bq032", "bq034", "bq035", "bq059", "bq060", "bq061", "bq066", "bq076", 
    "bq077", "bq081", "bq085", "bq090", "bq097", "bq103", "bq109", "bq115", "bq126", "bq130", "bq143", "bq151", 
    "bq161", "bq172", "bq227", "bq228", "bq268", "bq279",
    "bq280", "bq281", "bq282", "bq284", "bq285", "bq286", "bq300", "bq302", "bq303", "bq308", "bq310", "bq327", "bq328", "bq352"
    "bq355", "bq357", "bq362", "bq379", "bq389", "bq392", "bq394", "bq396", "bq398", "bq399", "bq406", "bq414", 
    "ga001", "ga002", "ga003", "ga004", "ga007", "ga010", "ga020", "local008", "local017", "local019", "local022", "local023", "local026", "local028", "local031", 
    "local038", "local039", "local041", "local054", "local056", "local058", "local065", "local067", "local071", "local072", "local074", "local075", "local078", "local099", 
    "local131", "local141", "local163", "local193", "local198", "local199", "local202", "local210", "local218", "local221", "local244", 
    "local274", "local284", "local301", "local309", "local329"
]


def mv(all_path, target_path, sql_list, json_name):
    if os.path.exists(target_path):
        shutil.rmtree(target_path)
    os.mkdir(target_path)
    for i in sql_list:
        source = os.path.join(all_path, i)
        sql_path = os.path.join(target_path, i)
        shutil.copytree(source, sql_path)
    shutil.copy(os.path.join(all_path, json_name), os.path.join(target_path, json_name))

def get_full_list(json_name, all_path):
    json_path = os.path.join(all_path, json_name)
    task_list = []
    with open(json_path) as f:
        for line in f:
            line_js = json.loads(line)
            task_list.append(line_js['instance_id'])
    return task_list


snow_close_path = "../snow-spider-agent/methods/spider-self-refine/examples-close"
snow_correct_path = "../snow-spider-agent/methods/spider-self-refine/examples-correct"
snow_all_path = "../snow-spider-agent/methods/spider-self-refine/examples"
snow_complement_path = "../snow-spider-agent/methods/spider-self-refine/examples-complement"
snow_json_name = "spider2-snow.jsonl"

lite_close_path = "../snow-spider-agent/methods/spider-self-refine/examples_lite-close"
lite_correct_path = "../snow-spider-agent/methods/spider-self-refine/examples_lite-correct"
lite_all_path = "../snow-spider-agent/methods/spider-self-refine/examples_lite"
lite_complement_path = "../snow-spider-agent/methods/spider-self-refine/examples_lite-complement"
lite_json_name = "spider2-lite.jsonl"

mv(snow_all_path, snow_close_path, snow_close_list, snow_json_name)
mv(snow_all_path, snow_correct_path, snow_correct_list, snow_json_name)
mv(lite_all_path, lite_close_path, lite_close_list, lite_json_name)
mv(lite_all_path, lite_correct_path, lite_correct_list, lite_json_name)

snow_full_list = get_full_list(snow_json_name, snow_all_path)
lite_full_list = get_full_list(lite_json_name, lite_all_path)

lite_full_list_no_sf = list(set(lite_full_list) - set(snow_full_list))

snow_complement_list = list(set(snow_full_list) - (set(snow_close_list) | set(snow_correct_list)))
lite_complement_list = list(set(lite_full_list_no_sf) - (set(lite_close_list) | (set(lite_correct_list))))

mv(snow_all_path, snow_complement_path, snow_complement_list, snow_json_name)
mv(lite_all_path, lite_complement_path, lite_complement_list, lite_json_name)