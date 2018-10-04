#!/usr/bin/env python

import json
from subprocess import Popen, PIPE
import sys


def json_dumpu(data):
    return json.dumps(data, ensure_ascii=False)


def printf(data):
    print(data, flush=True)


i3s = Popen(["i3status"], stdout=PIPE)

skip = 2
cnt = 0
while True:
    line = i3s.stdout.readline()
    if not line:
        sys.exit()

    line = line[:-1].decode('utf-8')
    if cnt < skip:
        printf(line)
    else:
        first = False
        if line[0] == ',':
            line = line[1:]
        else:
            first = True

        line = json.loads(line)

        for i, elem in enumerate(line):
            if elem["name"] == 'battery':
                full_text = line[i]["full_text"]
                parts = full_text.split()
                percent = int(float(parts[1][:-1]))
                line[i]["full_text"] = '{} {}%'.format(parts[0], percent)

        light = Popen(["light", "-G"], stdout=PIPE)
        light_out = light.stdout.read()
        light_out = int(float(light_out))
        light = dict(name="brightness", full_text="☀️ {}%".format(light_out))
        line = [light] + line

        updates_num = open(".updates").read()
        updates_num = int(updates_num)
        if updates_num > 0:
            updates = dict(name="pacman", full_text="📦 ⚠️ {}".format(updates_num))
            line = [updates] + line

        print_data = json_dumpu(line)
        if not first:
            print_data = ',' + print_data
        printf(print_data)

    cnt += 1
