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
             NUM_EVENTS = 50,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 7))

tests.append(dict(name  = 'long_timestamps',
             NUM_EVENTS = 50,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY  = 16,
             MAX_DELAY  = 64))

tests.append(dict(name  = 'shortcorner_timestamps',
             NUM_EVENTS = 50,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 12))

tests.append(dict(name  = 'corner1_timestamps',
             NUM_EVENTS = 10,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY  = 8,
             MAX_DELAY  = 8))

tests.append(dict(name  = 'corner2_timestamps',
             NUM_EVENTS = 10,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY  = 9,
             MAX_DELAY  = 9))

tests.append(dict(name  = 'bursts',
             NUM_EVENTS = 50,
             NUM_REPEATS = 1,
             DELAY_MODE = 1,
             MIN_DELAY  = 0,
             MAX_DELAY  = 16))

tests.append(dict(name  = 'rearm',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0))

tests.append(dict(name  = 'shortpattern',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PRETRIG_MAX = 0,
             PATTERN_MIN = 1,
             PATTERN_MAX = 3))

tests.append(dict(name  = 'longpattern',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PATTERN_MIN = 16,
             PATTERN_MAX = 64))

""" 
tests.append(dict(name  = 'longcapture',
             NUM_EVENTS = 4096,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY=0,
             MAX_DELAY=5))


These testcases are much longer and we don't yet care about the counter
overflow event that they cover:
tests.append(dict(name  = 'vlong_timestamps',
             NUM_EVENTS = 5,
             DELAY_MODE = 0,
             MIN_DELAY  = 2**16-2,
             MAX_DELAY  = 2**18))

tests.append(dict(name  = 'anything_goes',
             NUM_EVENTS = 20,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 2**16+2))
"""

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

# Run tests:
start_time = int(time.time())
outfile = open('regress.out', 'w')
for test in tests:
   for i in range(args.runs):
      # build make command:
      makeargs = ['make', 'all', 'VERBOSE=1']
      for key in test.keys():
         if key == 'name':
            logfile = "%s%d.log" % (test[key], i) 
            makeargs.append("LOGFILE=%s" % logfile)
         else:
            makeargs.append("%s=%s" % (key, test[key]))
      if (args.seed):
         seed = args.seed
      else:
         seed = random.randint(0, 2**31-1)
      makeargs.append("SEED=%d" % seed)

      # run:
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
            print("pass");
            break
         elif fail_matches:
            failed += 1
            print("FAILED! %d errors, seed = %d" % (int(fail_matches.group(1)), seed))
            break


# Summarize results:
print('\n*** RESULTS SUMMARY ***')
print('%d tests passing, %d tests failing.' % (passed, failed))
print('Elapsed time: %d seconds' % (int(time.time() - start_time)))

