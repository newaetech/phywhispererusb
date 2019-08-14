#!/usr/bin/env python3

import argparse
import subprocess
import random
import re
import time

parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group()
group.add_argument("--runs", type=int, help="Number of iterations.", default=1)
group.add_argument("--test", help="Testcase to run")
parser.add_argument("--seed", type=int, help="Seed to use when running a single test with --test.")
args = parser.parse_args()

random.seed()

# Define testcases:
tests = []
tests.append(dict(name  = 'short_timestamps',
             frequency = 1,
             NUM_EVENTS = 50,
             NUM_REPEATS = 4,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 63))

tests.append(dict(name  = 'long_timestamps',
             frequency = 1,
             NUM_EVENTS = 30,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 16,
             MAX_DELAY  = 64))

tests.append(dict(name  = 'trigger',
             frequency = 1,
             NUM_REPEATS = 10,
             ACTION = 2))

tests.append(dict(name  = 'long_trigger',
             frequency = 10,
             TIMEOUT = 500000,
             TRIGGER_DELAY_MIN = 256,
             TRIGGER_DELAY_MAX = 2**20-1,
             TRIGGER_WIDTH_MIN = 256,
             TRIGGER_WIDTH_MAX = 2**17-1,
             NUM_REPEATS = 2,
             ACTION = 2))

tests.append(dict(name  = 'shortcorner_timestamps',
             frequency = 1,
             NUM_EVENTS = 10,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 12))

tests.append(dict(name  = 'corner1_timestamps',
             frequency = 5,
             NUM_EVENTS = 10,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 8,
             MAX_DELAY  = 8))

tests.append(dict(name  = 'corner2_timestamps',
             frequency = 5,
             NUM_EVENTS = 10,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 9,
             MAX_DELAY  = 9))

tests.append(dict(name  = 'bursts',
             frequency = 1,
             NUM_EVENTS = 50,
             NUM_REPEATS = 2,
             DELAY_MODE = 1,
             MIN_DELAY  = 0,
             MAX_DELAY  = 16))

tests.append(dict(name  = 'rearm',
             frequency = 1,
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0))

tests.append(dict(name  = 'shortpattern',
             frequency = 1,
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PRETRIG_MAX = 0,
             PATTERN_MIN = 1,
             PATTERN_MAX = 3))

tests.append(dict(name  = 'longpattern',
             frequency = 1,
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PATTERN_MIN = 16,
             PATTERN_MAX = 64))

tests.append(dict(name  = 'longcapture',
             frequency = 10,
             TIMEOUT = 200000,
             NUM_EVENTS = 8192,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY=0,
             MAX_DELAY=3))


""" 
These testcases are much longer and we don't yet care about the counter
overflow event that they cover:
"""
tests.append(dict(name  = 'vlong_timestamps',
             frequency = 0,
             TIMEOUT = 400000,
             NUM_EVENTS = 5,
             DELAY_MODE = 0,
             PRETRIG_MAX = 2,
             PATTERN_MAX = 4,
             MIN_DELAY  = 2**16-2,
             MAX_DELAY  = 2**18))

tests.append(dict(name  = 'anything_goes',
             frequency = 0,
             TIMEOUT = 800000,
             NUM_EVENTS = 20,
             PRETRIG_MAX = 10,
             PATTERN_MAX = 4,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 2**16+2))


# if running a single testcase:
if (args.test):
   found = False
   for test in tests:
      if test['name'] == args.test:
         found = True
         tests = [test]
         break
   if not found:
      print("Error: test %s undefined." % args.test)
      print("Available tests:")
      for test in tests:
         print("%s" % test['name'])
      quit()

pass_regex = re.compile(r'^Simulation passed')
fail_regex = re.compile(r'^SIMULATION FAILED \((\d+) errors\)')
seed_regex = re.compile(r'^Running with pSEED=(\d+)$')

passed = 0
failed = 0

# Check once that compile passes:
outfile = open('regress.out', 'w')
makeargs = ['make', 'compile']
result = subprocess.run(makeargs, stdout=outfile, stderr=outfile)
if result.returncode:
   print ("Compilation failed (return code: %d), check regress.out." % result.returncode)
   quit()

# Run tests:
start_time = int(time.time())
for test in tests:
   for i in range(args.runs):
      run_test = True
      # build make command:
      makeargs = ['make', 'all', 'VERBOSE=1']
      for key in test.keys():
         if key == 'name':
            logfile = "results/%s%d.log" % (test[key], i) 
            makeargs.append("LOGFILE=%s" % logfile)
         elif key == 'frequency':
            if test[key] == 0:
               run_test = False
            elif i % test[key]:
               run_test = False
         else:
            makeargs.append("%s=%s" % (key, test[key]))
      if (args.seed):
         seed = args.seed
      else:
         seed = random.randint(0, 2**31-1)
      makeargs.append("SEED=%d" % seed)

      # run:
      if run_test:
         print("Running %s... " % logfile, end='', flush=True)
         subprocess.run(makeargs, stdout=outfile, stderr=outfile)

         # check pass/fail:
         log = open(logfile, 'r')
         seed = 0
         for line in log:
            pass_matches = pass_regex.search(line)
            fail_matches = fail_regex.search(line)
            seed_matches = seed_regex.search(line)
            if seed_matches:
               seed = int(seed_matches.group(1))
            elif pass_matches:
               passed += 1
               print("pass")
               break
            elif fail_matches:
               failed += 1
               print("FAILED! %d errors, seed = %d" % (int(fail_matches.group(1)), seed))
               break


# Summarize results:
print('\n*** RESULTS SUMMARY ***')
print('%d tests passing, %d tests failing.' % (passed, failed))
print('Elapsed time: %d seconds' % (int(time.time() - start_time)))

