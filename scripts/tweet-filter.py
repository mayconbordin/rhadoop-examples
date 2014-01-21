#!/usr/bin/python

import json
import sys

input_file = sys.argv[1]
filter_wrd = sys.argv[2]

with open(input_file) as f:
    for line in f:
        if len(line) > 1:
            try:
                obj = json.loads(line)
                if filter_wrd in obj and obj[filter_wrd] is not None:
                    print line
            except ValueError:
                None
