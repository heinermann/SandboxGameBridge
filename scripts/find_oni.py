# Run in OxygenNotIncluded/OxygenNotIncluded_Data/StreamingAssets
# Note this only lists the elements, and not the other items

import os
import glob
import csv
import yaml
import polib
import re

out_data = []

translations = {}
po = polib.pofile('strings/strings_template.pot')
for entry in po:
    translations[entry.msgctxt] = entry.msgid

for elem_type in ["solid", "liquid", "gas"]:
    with open(f"elements/{elem_type}.yaml") as f:
        data = yaml.load(f, Loader=yaml.loader.FullLoader)

        for elem in data['elements']:
            elem['name'] = translations.get(elem['localizationID'], elem['localizationID'])
            elem['name'] = re.sub(r"<[^>]*>", "", elem['name'])
            
            out_data.append(elem)

with open("result.csv", 'w') as result:
    writer = csv.DictWriter(result, fieldnames=['elementId', 'name', 'state'], extrasaction='ignore')
    writer.writeheader()
    for item in out_data:
        writer.writerow(item)
