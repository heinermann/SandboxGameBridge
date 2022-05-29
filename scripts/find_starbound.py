# 1. Run asset_unpacker on Starbound/assets/packed.pak
# 2. Run this script in Starbound/assets/packed/

import os
import glob
import csv
import json

out_data = []

for filename in glob.iglob("./**/*.*", recursive=True):
    if filename.endswith('.png'):
        continue

    with open(filename, 'r') as f:
        data = {}
        try:
            data = json.load(f)
        except Exception as e:
            continue

        if "itemName" in data and "shortdescription" in data:
            out_data.append(data)

with open("result.csv", 'w') as result:
    writer = csv.DictWriter(result, fieldnames=['itemName', 'shortdescription', 'description', 'price', 'category'], extrasaction='ignore')
    writer.writeheader()
    writer.writerows(out_data)
