import os
import shutil

snow_close_list = [
    "sf_bq002", "sf_bq007", "sf_bq028", "sf_bq033", "sf_bq039", "sf_bq062", "sf_bq098", "sf_bq112", "sf_bq119", "sf_bq123", 
    "sf_bq160", "sf_bq166", "sf_bq175", "sf_bq185", "sf_bq198", "sf_bq208", "sf_bq215", "sf_bq219", "sf_bq229", "sf_bq283", "sf_bq293", "sf_bq294", 
    "sf_bq321", "sf_bq330", "sf_bq338", "sf_bq350", "sf_bq354", "sf_bq356", "sf_bq363", "sf_bq374", "sf_bq380", "sf_bq383", "sf_bq400", 
    "sf_bq442", "sf_bq460", "sf_bq461", "sf_ga006", "sf_ga008", "sf_ga013", "sf_ga017", "sf_local004", "sf_local032", 
    "sf_local049", "sf_local059", "sf_local066", "sf_local068", "sf_local081", "sf_local085", "sf_local114", "sf_local130", "sf_local132", "sf_local152", 
    "sf_local195", "sf_local196", "sf_local201", "sf_local212", "sf_local219", "sf_local220", "sf_local264", "sf_local272", "sf_local300", "sf_local311", "sf_local330"
]

snow_correct_list = [
    "sf_bq001", "sf_bq006", "sf_bq010", "sf_bq011", "sf_bq018", "sf_bq021", "sf_bq025", "sf_bq032", "sf_bq034", "sf_bq035", "sf_bq056", "sf_bq059", "sf_bq060", "sf_bq061", "sf_bq066", "sf_bq076", 
    "sf_bq077", "sf_bq081", "sf_bq085", "sf_bq090", "sf_bq091", "sf_bq097", "sf_bq099", "sf_bq103", "sf_bq109", "sf_bq113", "sf_bq115", "sf_bq121", "sf_bq126", "sf_bq130", "sf_bq135", "sf_bq143", "sf_bq150", "sf_bq151", 
    "sf_bq158", "sf_bq161", "sf_bq172", "sf_bq176", "sf_bq210", "sf_bq211", "sf_bq213", "sf_bq214", "sf_bq216", "sf_bq218", "sf_bq224", "sf_bq227", "sf_bq228", "sf_bq235", "sf_bq252", "sf_bq255", "sf_bq268", "sf_bq279",
    "sf_bq280", "sf_bq281", "sf_bq282", "sf_bq284", "sf_bq285", "sf_bq286", "sf_bq289", "sf_bq300", "sf_bq302", "sf_bq303", "sf_bq308", "sf_bq309", "sf_bq310", "sf_bq327", "sf_bq328", "sf_bq341", "sf_bq345", "sf_bq346", "sf_bq352", 
    "sf_bq355", "sf_bq357", "sf_bq359", "sf_bq361", "sf_bq362", "sf_bq375", "sf_bq377", "sf_bq379", "sf_bq389", "sf_bq392", "sf_bq394", "sf_bq396", "sf_bq398", "sf_bq399", "sf_bq406", "sf_bq414", 
    "sf_bq421", "sf_bq444", "sf_ga001", "sf_ga002", "sf_ga003", "sf_ga004", "sf_ga007", "sf_ga010", "sf_ga020", "sf_local008", "sf_local017", "sf_local019", "sf_local022", "sf_local023", "sf_local026", "sf_local028", "sf_local031", 
    "sf_local038", "sf_local039", "sf_local041", "sf_local054", "sf_local056", "sf_local058", "sf_local065", "sf_local067", "sf_local071", "sf_local072", "sf_local074", "sf_local075", "sf_local078", "sf_local099", 
    "sf_local131", "sf_local141", "sf_local163", "sf_local193", "sf_local197", "sf_local198", "sf_local199", "sf_local202", "sf_local210", "sf_local218", "sf_local221", "sf_local244", 
    "sf_local274", "sf_local284", "sf_local301", "sf_local309", "sf_local329", "sf001", "sf010", "sf014", "sf044"
]


json_name = "spider2-snow.jsonl"
def mv(all_path, target_path, sql_list):
    if os.path.exists(target_path):
        shutil.rmtree(target_path)
    os.mkdir(target_path)
    for i in sql_list:
        source = os.path.join(all_path, i)
        sql_path = os.path.join(target_path, i)
        shutil.copytree(source, sql_path)
    shutil.copy(os.path.join(all_path, json_name), os.path.join(target_path, json_name))

snow_close_path = "../snow-spider-agent/methods/spider-self-refine/examples-close"
snow_correct_path = "../snow-spider-agent/methods/spider-self-refine/examples-correct"
snow_all_path = "../snow-spider-agent/methods/spider-self-refine/examples"


mv(snow_all_path, snow_close_path, snow_close_list)
mv(snow_all_path, snow_correct_path, snow_correct_list)


