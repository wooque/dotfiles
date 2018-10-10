#!/usr/bin/env python
from json import dumps, loads
from os.path import exists
from signal import signal, SIGHUP, SIGINT
from subprocess import Popen, PIPE
from sys import stdin, exit
from threading import Thread


def json_dumpu(data):
    return dumps(data, ensure_ascii=False)


def printf(data):
    print(data, flush=True)


cnt = 0
skip = 2
raw_line = ''
brightness = None
layout = None
work = True
i3s = None


def handle_line(interrupt=False):
    global raw_line, brightness, layout

    line = raw_line[:-1].decode('utf-8')

    first = False
    if line[0] == ',':
        line = line[1:]
    else:
        first = True

    line = loads(line)

    for i, elem in enumerate(line):
        if elem["name"] == 'battery':

            full_text = line[i]["full_text"]
            parts = full_text.split()
            percent = int(round(float(parts[1][:-1])))
            percent = '{}%'.format(percent)

            new_parts = [parts[0], percent]
            if parts[2:]:
                new_parts.append('({})'.format(parts[2]))

            line[i]["full_text"] = ' '.join(new_parts)

        if elem["name"] == "wireless":
            if '%' in elem["full_text"]:
                del line[i]['color']

    if not brightness or interrupt:
        backlight = Popen(["xbacklight"], stdout=PIPE)
        backlight_out = backlight.stdout.read()
        backlight_out = int(round(float(backlight_out)))
        brightness_data = dict(name="brightness", full_text="☀️ {}%".format(backlight_out))
        brightness = brightness_data

    line = [line[0], brightness] + line[1:]

    if not layout or interrupt:
        layout_state = Popen(["xkblayout-state", "print", "%s"], stdout=PIPE)
        layout_out = layout_state.stdout.read()
        layout_out = layout_out.decode('utf-8')
        layout_data = dict(name="keyboard_layout", full_text='⌨️ {}'.format(layout_out))
        layout = layout_data

    line = [layout] + line

    try:
        updates_num = open(".updates").read()
        updates_num = int(updates_num)

    except (ValueError, FileNotFoundError):
        updates_num = 0

    if updates_num > 0:
        updates = dict(name="pacman", full_text="📦 {}".format(updates_num))
        line = [updates] + line

    if exists('backup.txt'):
        processes = Popen(["ps", "aux"], stdout=PIPE)
        processes = processes.stdout.read().decode('utf-8')

        backup_text = "☁️ "
        if "backup.sh" in processes:
            backup_text += "🔄"
        else:
            backup_text += "ℹ️"

        backup = dict(name="backup", full_text=backup_text)
        line = [backup] + line

    print_data = json_dumpu(line)
    if not first:
        print_data = ',' + print_data

    printf(print_data)


def handle_input():
    network = None
    calendar = None

    while work:
        line = stdin.readline()

        if "wireless" in line:
            if not network or network.poll() is not None:
                network = Popen(["i3-sensible-terminal", "-e", "nmtui"])

        if "tztime" in line:
            if not calendar or calendar.poll() is not None:
                calendar = Popen(["i3-sensible-terminal", "-e", "sh", "-c", "cal -y && sleep 60"])

        if "volume" in line:
            Popen(["pamixer", "-t"])

def main():
    global cnt, skip, i3s, raw_line

    i3s = Popen(["i3status"], stdout=PIPE)
    while work:
        raw_line = i3s.stdout.readline()

        if not raw_line:
            exit()

        if cnt < skip:
            line = raw_line[:-1].decode('utf-8')

            if cnt == 0:
                line = loads(line)
                line["click_events"] = True
                line = dumps(line)

            printf(line)
        else:
            handle_line()

        cnt += 1


def handle_sighup(sig, frame):
    global cnt, skip

    if cnt >= skip:
        handle_line(interrupt=True)


def handle_sigint(sig, frame):
    global work, i3s

    work = False
    i3s.terminate()


if __name__ == '__main__':
    signal(SIGHUP, handle_sighup)
    signal(SIGINT, handle_sigint)
    thread = Thread(target=handle_input, daemon=True)
    thread.start()
    main()
