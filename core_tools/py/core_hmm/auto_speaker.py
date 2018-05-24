#!/usr/bin/env python3.6
# auto_speaker.py, a_pinyin/core_tools/py/core_hmm/
import os, sys
import json
import random


def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)


class AutoSpeaker(object):

    _char_map = ''
    _A = []
    _I = []
    _al = []
    _count_I = 0

    def load_data(self, data):
        self._char_map = data['char_map']
        self._A = data['A']
        self._I = data['I']
        self._al = data['al']
        # _count_I
        self._count_I = sum(self._I)

    def _random_select(self, data, count):
        r = random.randrange(count)
        i = 0
        for j in range(len(data)):
            i += data[j]
            if i > r:
                return j
        # select failed !
        raise Exception("can not select, len(data) = " + str(len(data)) + ", count = " + str(count) + ", i = " + str(i) + ", r = " + str(r))

    # speak once
    def speak(self):
        # TODO max length limit
        o = ''
        # get first char
        last = self._random_select(self._I, self._count_I)
        o += self._char_map[last]
        # get next char until END
        while last != 0:  # 0 means 'E'
            last = self._random_select(self._A[last], self._al[last])
            o += self._char_map[last]
        return o


def speak(s, n, m):
    # n: speak n times
    # m: max length limit of each output
    i = 0
    while i < n:
        o = s.speak()[:-1]  # remove last 'E' char
        if len(o) < m:
            print("  " + o, end="")
            i += 1
    print("")

def main(args):
    f_data, n, m = args[0], int(args[1]), int(args[2])

    data = load_json(f_data)
    s = AutoSpeaker()
    s.load_data(data)

    speak(s, n, m)

if __name__ == '__main__':
    main(sys.argv[1:])
