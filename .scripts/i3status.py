#!/usr/bin/env python
from json import dumps, loads
from os import remove
from os.path import exists
from signal import signal, SIGHUP, SIGINT
from subprocess import Popen, PIPE
from sys import stdin, exit
from time import sleep
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
        try:
            backlight_out = int(round(float(backlight_out)))

            brightness_data = dict(name="brightness", full_text="☀️ {}%".format(backlight_out))
            brightness = brightness_data
        except ValueError:
            pass

    if brightness:
        line = [line[0], brightness] + line[1:]

    if not layout or interrupt:
        layout_state = Popen(["xkblayout-state", "print", "%s"], stdout=PIPE)
        layout_out = layout_state.stdout.read()
        layout_out = layout_out.decode('utf-8')

        layout_data = dict(name="keyboard_layout", full_text='⌨️ {}'.format(layout_out))
        layout = layout_data

    line = [layout] + line

    music_status = Popen(['cmus-remote', '-Q'], stdout=PIPE)
    music_status = music_status.stdout.read().decode('utf-8')
    if music_status:
        status, artist, title = None, None, None

        for l in music_status.split('\n'):
            if l.startswith('status'):
                status = l.split()[1]
                status = {
                    "playing": "▶️",
                    "paused": "⏸️",
                    "stopped": "⏹️",
                }[status]

            if l.startswith('tag artist'):
                artist = l.replace('tag artist ', '')

            if l.startswith('tag title'):
                title = l.replace('tag title ', '')
                if len(title) > 30:
                    title = title[:30] + '...'

            if l.startswith('file') and 'http' in l:
                    status += ' 📻'

        if title:
            if artist:
                full_text = "{} {} - {}".format(status, artist, title)
            else:
                full_text = "{} {}".format(status, title)

            music = dict(name="music", full_text=full_text)
            line = [music] + line

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
            instance = "running"
        else:
            backup_text += "ℹ️"
            instance = "info"

        backup = dict(name="backup", instance=instance, full_text=backup_text)
        line = [backup] + line

    print_data = json_dumpu(line)
    if not first:
        print_data = ',' + print_data

    printf(print_data)


def term_open(*args):
    Popen(["i3-sensible-terminal", "-e"] + list(args))


def is_open(process):
    processes = Popen(["ps", "aux"], stdout=PIPE)
    processes = processes.stdout.read().decode('utf-8')
    return process in processes


def is_left_click(line):
    return '"button":1' in line


def is_middle_click(line):
    return '"button":2' in line


def is_right_click(line):
    return '"button":3' in line


def is_scroll_up(line):
    return '"button":4' in line


def is_scroll_down(line):
    return '"button":5' in line


def handle_input():
    while work:
        line = stdin.readline()

        if "wireless" in line and is_left_click(line):
            if not is_open("nmtui"):
                term_open("nmtui")

        if "tztime" in line and is_left_click(line):
            if not is_open("sleep 60"):
                term_open("sh", "-c", "cal -m -y && sleep 60")

        if "volume" in line:
            if is_scroll_up(line):
                Popen(["pulsemixer", "--change-volume", "+5"])
                handle_line()

            if is_scroll_down(line):
                Popen(["pulsemixer", "--change-volume", "-5"])
                handle_line()

            if is_middle_click(line):
                Popen(["pulsemixer", "--toggle-mute"])

            elif is_left_click(line):
                if not is_open("pulsemixer"):
                    term_open("pulsemixer")

        if "music" in line:
            if is_left_click(line):
                Popen(["cmus-remote", '-u'])

            elif is_right_click(line):
                Popen(["cmus-remote", "-n"])

            elif is_middle_click(line):
                Popen(["pkill", "cmus"])
                sleep(0.1)

            handle_line()

        if "brightness" in line:
            if is_scroll_up(line):
                Popen(["xbacklight", "-inc", "10", "-time", "0"])
                handle_line(interrupt=True)

            if is_scroll_down(line):
                Popen(["xbacklight", "-dec", "10", "-time", "0"])
                handle_line(interrupt=True)

        if "layout" in line and is_left_click(line):
            Popen(["xkblayout-state", "set", "+1"])
            handle_line(interrupt=True)

        if 'pacman' in line and is_left_click(line):
            if not is_open("yaupg.sh"):
                term_open("yaupg.sh")

        if 'backup' in line:
            if is_middle_click(line):
                try:
                    remove('backup.txt')
                except:
                    pass
                handle_line()

            elif is_left_click(line):
                if "running" in line:
                    if not is_open("tail -f backup.txt"):
                        term_open("tail", "-f", "backup.txt")

                elif "info" in line:
                    if not is_open("vim backup.txt"):
                        term_open("vim", "backup.txt")


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
