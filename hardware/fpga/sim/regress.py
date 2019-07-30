#!/usr/bin/env python3

import argparse
import subprocess
import random
import re
import time

parser = argparse.ArgumentParser()
parser.add_argument("--runs", type=int, help="Number of iterations.", default=1)
args = parser.parse_args()

random.seed()

# Define testcases:
tests = []
tests.append(dict(name  = 'short_timestamps',
             NUM_EVENTS = 50,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 7))

tests.append(dict(name  = 'long_timestamps',
             NUM_EVENTS = 50,
             DELAY_MODE = 0,
             MIN_DELAY  = 16,
             MAX_DELAY  = 64))

tests.append(dict(name  = 'shortcorner_timestamps',
             NUM_EVENTS = 50,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 12))

tests.append(dict(name  = 'corner1_timestamps',
             NUM_EVENTS = 10,
             DELAY_MODE = 0,
             MIN_DELAY  = 8,
             MAX_DELAY  = 8))

tests.append(dict(name  = 'corner2_timestamps',
             NUM_EVENTS = 10,
             DELAY_MODE = 0,
             MIN_DELAY  = 9,
             MAX_DELAY  = 9))

tests.append(dict(name  = 'bursts',
             NUM_EVENTS = 50,
             DELAY_MODE = 1,
             MIN_DELAY  = 0,
             MAX_DELAY  = 16))


""" 
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

# Run tests:
logfiles = []
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
      seed = random.randint(0, 2**31-1)
      makeargs.append("SEED=%d" % seed)

      # run:
      print("Running %s..." % logfile)
      subprocess.run(makeargs, stdout=outfile, stderr=outfile)

      logfiles.append(logfile)


# Check for pass/fail and summarize results:
print('\n*** RESULTS SUMMARY ***')
pass_regex = re.compile(r'^Simulation passed')
fail_regex = re.compile(r'^SIMULATION FAILED \((\d+) errors\)')
seed_regex = re.compile(r'^Running with pSEED=(\d+)$')
passed = 0
failed = 0
for logfile in logfiles:
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
         break
      elif fail_matches:
         failed += 1
         print("Test %s failed! %d errors. Seed = %d" % (logfile, int(fail_matches.group(1)), seed))
         break

print('\n*** Totals: %d tests passing, %d tests failing.' % (passed, failed))
print('Elapsed time: %d seconds' % (int(time.time() - start_time)))

