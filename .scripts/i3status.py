#!/usr/bin/env python
import json
import signal
import sys
from subprocess import Popen, PIPE


def json_dumpu(data):
    return json.dumps(data, ensure_ascii=False)


def printf(data):
    print(data, flush=True)


cnt = 0
skip = 2
old_line = ''
raw_line = ''
work = True
i3s = None


def handle_line():
    global raw_line
    
    line = raw_line[:-1].decode('utf-8')
    
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
            percent = '{}%'.format(percent)        
            
            new_parts = [parts[0], percent]
            if parts[2:]:
                new_parts.append('({})'.format(parts[2]))
            
            line[i]["full_text"] = ' '.join(new_parts)

    light = Popen(["light", "-G"], stdout=PIPE)
    light_out = light.stdout.read()
    light_out = int(float(light_out))
    light_bar = dict(name="brightness", full_text="☀️ {}%".format(light_out))
    line = [line[0], light_bar] + line[1:]

    layout = Popen(["xkblayout-state", "print", "%s"], stdout=PIPE)
    layout_out = layout.stdout.read()
    layout_out = layout_out.decode('utf-8')
    layout_bar = dict(name="keyboard_layout", full_text='⌨️ {}'.format(layout_out))
    line = [layout_bar] + line

    try:
        updates_num = open(".updates").read()
        updates_num = int(updates_num)
    
    except (ValueError, FileNotFoundError) as e:
        updates_num = 0

    if updates_num > 0:
        updates = dict(name="pacman", full_text="📦 {}".format(updates_num))
        line = [updates] + line

    print_data = json_dumpu(line)
    if not first:
        print_data = ',' + print_data
    
    printf(print_data)


def main():
    global cnt, skip, i3s, old_line, raw_line

    i3s = Popen(["i3status"], stdout=PIPE)
    while work:
        raw_line = i3s.stdout.readline()
        
        if not raw_line:
            sys.exit()

        if raw_line != old_line:
            if cnt < skip:
                line = raw_line[:-1].decode('utf-8')
                printf(line)
            else:
                handle_line()

        old_line = raw_line
        cnt += 1


def handle_sighup(sig, frame):
    global cnt, skip
    
    if cnt >= skip:
        handle_line()


def handle_sigint(sig, frame):
    global work, i3s
    
    work = False
    i3s.terminate()


if __name__ == '__main__':
    signal.signal(signal.SIGHUP, handle_sighup) 
    signal.signal(signal.SIGINT, handle_sigint)
    main()
