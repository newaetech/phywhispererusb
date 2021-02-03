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
parser.add_argument("--tests", help="Run all tests whose name contains TESTS", default='')
parser.add_argument("--list", help="List available tests.", action='store_true')
parser.add_argument("--dump", help="Enable waveform dumping.", action='store_true')
args = parser.parse_args()

random.seed()

# Define testcases:
tests = []
tests.append(dict(name  = 'short_timestamps',
             frequency = 5,
             description = 'Short timestamps only.',
             NUM_EVENTS = 50,
             NUM_REPEATS = 4,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 7))

tests.append(dict(name  = 'usb_autodetect',
             frequency = 100,
             description = 'Simple USB autodetect test.',
             TOP = 'tb_usb_autodetect'))

tests.append(dict(name  = 'stream_short',
             frequency = 5,
             description = 'Stream mode, test empty FIFO reads.',
             NUM_EVENTS = 100,
             TIMEOUT = 4000,
             NUM_REPEATS = 1,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             MIN_DELAY  = 0,
             MAX_DELAY  = 12))


tests.append(dict(name  = 'stream_long_nooverflow',
             frequency = 5,
             description = 'Stream mode longer than capture buffer without overflowing.',
             TIMEOUT = 400000,
             NUM_EVENTS = 8192*2,
             NUM_REPEATS = 1,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             MIN_DELAY  = 10,
             MAX_DELAY  = 16))

tests.append(dict(name  = 'stream_long_emptyreads',
             frequency = 10,
             description = 'Stream mode where host read rate is higher than target write rate.',
             TIMEOUT = 700000,
             NUM_EVENTS = 8192*2,
             NUM_REPEATS = 1,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             MIN_DELAY  = 20,
             MAX_DELAY  = 45))

tests.append(dict(name  = 'stream_long_overflow',
             frequency = 5,
             description = 'Stream mode, test overflow.',
             TIMEOUT = 300000,
             OVERFLOW = 1,
             NUM_EVENTS = 8192*2,
             NUM_REPEATS = 1,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             MAX_DELAY  = 2))

tests.append(dict(name  = 'stream_slow_overflow',
             frequency = 5,
             description = 'Stream mode, test overflow when reads and writes are slow.',
             TIMEOUT = 600000,
             OVERFLOW = 1,
             NUM_EVENTS = 8192*2,
             NUM_REPEATS = 1,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             SLOW_READS = 1,
             MIN_DELAY  = 10,
             MAX_DELAY  = 16))


tests.append(dict(name  = 'stream_vlong',
             #frequency = 20,
             frequency = 0,
             description = 'Stream mode, test overflow and repeat.',
             OVERFLOW = 1,
             NUM_EVENTS = 8192*4,
             NUM_REPEATS = 2,   # TODO: support repeats with streaming
             STREAM_MODE = 1,
             MAX_DELAY  = 1))

tests.append(dict(name  = 'long_timestamps',
             frequency = 2,
             description = 'Long timestamps only (but not too long).',
             NUM_EVENTS = 30,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 16,
             MAX_DELAY  = 64))

tests.append(dict(name  = 'overflow_timestamps',
             frequency = 1,
             description = 'Overflow timestamp counter.',
             NUM_EVENTS = 30,
             NUM_REPEATS = 2,
             MAX_TIMESTAMP = 64,
             DELAY_MODE = 0,
             MIN_DELAY  = 4,
             MAX_DELAY  = 128))

tests.append(dict(name  = 'lots_overflow_timestamps',
             frequency = 1,
             description = 'Overflow timestamp counter, consecutively.',
             NUM_EVENTS = 30,
             NUM_REPEATS = 2,
             MAX_TIMESTAMP = 32,
             DELAY_MODE = 0,
             MIN_DELAY  = 4,
             MAX_DELAY  = 128))



tests.append(dict(name  = 'burst_fifo_read',
             frequency = 2,
             description = 'Read capture FIFO in a single burst (after capture is complete).',
             #NUM_REPEATS = 4,  # TODO: fix (testbench)
             NUM_REPEATS = 1,
             NUM_EVENTS = 200,
             READ_CONCURRENTLY = 0,
             PRETRIG_MAX = 20))

tests.append(dict(name  = 'trigger',
             frequency = 5,
             description = 'Basic trigger test.',
             NUM_REPEATS = 10,
             TRIGGER_ENABLE = 1))

tests.append(dict(name  = 'trigger_corner',
             frequency = 2,
             description = 'Trigger test where capture data comes very soon after pattern match.',
             NUM_REPEATS = 10,
             TRIGGER_DELAY_MAX = 4,
             MAX_DELAY = 2,
             TRIGGER_ENABLE = 1))

tests.append(dict(name  = 'short_trigger',
             frequency = 5,
             description = 'Small trigger delay and width.',
             TRIGGER_DELAY_MIN = 0,
             TRIGGER_DELAY_MAX = 16,
             TRIGGER_WIDTH_MIN = 1,
             TRIGGER_WIDTH_MAX = 4,
             NUM_REPEATS = 10,
             TRIGGER_ENABLE = 1))

tests.append(dict(name  = 'long_trigger',
             frequency = 10,
             description = 'Large trigger delay and width.',
             TIMEOUT = 1000000,
             TRIGGER_DELAY_MIN = 256,
             TRIGGER_DELAY_MAX = 2**20-1,
             TRIGGER_WIDTH_MIN = 256,
             TRIGGER_WIDTH_MAX = 2**17-1,
             NUM_TRIGGERS_MAX = 2,
             NUM_REPEATS = 2,
             TRIGGER_ENABLE = 1))

tests.append(dict(name  = 'shortcorner_timestamps',
             frequency = 5,
             description = 'Constrain timestamps around the boundary between short and long timestamps',
             NUM_EVENTS = 10,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 12))

tests.append(dict(name  = 'corner_timestamps',
             frequency = 5,
             description = 'Corner-case timestamps (minimum long timestamps).',
             NUM_EVENTS = 10,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY  = 8,
             MAX_DELAY  = 9))

tests.append(dict(name  = 'bursts',
             frequency = 5,
             description = 'Bursty inputs, alternating between no delay and long delay.',
             NUM_EVENTS = 50,
             NUM_REPEATS = 2,
             DELAY_MODE = 1,
             MIN_DELAY  = 0,
             MAX_DELAY  = 16))

tests.append(dict(name  = 'shortpattern',
             frequency = 5,
             description = 'Pattern of 3 bytes or less.',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             TIMEOUT = 15000,
             DELAY_MODE = 0,
             PATTERN_MIN = 1,
             PATTERN_MAX = 3))

tests.append(dict(name  = 'longpattern',
             frequency = 5,
             description = 'Pattern of 16 bytes or more.',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PATTERN_MIN = 16,
             PATTERN_MAX = 64))

tests.append(dict(name  = 'vlongpattern',
             frequency = 5,
             description = 'Pattern of 60-64 bytes.',
             NUM_EVENTS = 10,
             NUM_REPEATS = 5,
             DELAY_MODE = 0,
             PATTERN_MIN = 60,
             PATTERN_MAX = 64))

tests.append(dict(name  = 'longcapture',
             frequency = 10,
             description = 'Read full FIFO.',
             TIMEOUT = 350000,
             NUM_EVENTS = 8192,
             NUM_REPEATS = 2,
             DELAY_MODE = 0,
             MIN_DELAY=0,
             MAX_DELAY=3))

tests.append(dict(name  = 'longcapture_burst_fifo_read',
             frequency = 10,
             description = 'Read full FIFO in a burst',
             TIMEOUT = 250000,
             NUM_EVENTS = 8192,
             READ_CONCURRENTLY = 0,
             #NUM_REPEATS = 2,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             MIN_DELAY=0,
             MAX_DELAY=3))

tests.append(dict(name  = 'no_capture_limits',
             frequency = 10,
             description = 'FIFO captures until overflow',
             TIMEOUT = 250000,
             OVERFLOW = 1,
             NUM_EVENTS = 8192*2,
             NO_CAPTURE_LIMIT = 1,
             #NUM_REPEATS = 2,
             NUM_REPEATS = 1,
             DELAY_MODE = 0,
             STREAM_MODE = 1,
             MIN_DELAY=0,
             MAX_DELAY=2))


""" 
These testcases are much longer and we don't yet care about the counter
overflow event that they cover:
"""
tests.append(dict(name  = 'vlong_timestamps',
             frequency = 0,
             description = 'Very long delay between events, to cause consecutive "Time" events.',
             TIMEOUT = 4000000,
             NUM_EVENTS = 5,
             DELAY_MODE = 0,
             PRETRIG_MAX = 2,
             PATTERN_MAX = 4,
             MIN_DELAY  = 2**16-2,
             MAX_DELAY  = 2**18))

tests.append(dict(name  = 'anything_goes',
             frequency = 0,
             description = 'Less constraints (long).',
             TIMEOUT = 800000,
             NUM_EVENTS = 20,
             PRETRIG_MAX = 10,
             PATTERN_MAX = 4,
             DELAY_MODE = 0,
             MIN_DELAY  = 0,
             MAX_DELAY  = 2**16+2))


def print_tests():
    print("Available tests:")
    for test in tests:
       print("%s:\t\t%s" % (test['name'], test['description']))
    quit()

if (args.list):
    print_tests()
    quit()

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
      print_tests()


pass_regex = re.compile(r'^Simulation passed')
fail_regex = re.compile(r'^SIMULATION FAILED \((\d+) errors\)')
seed_regex = re.compile(r'^Running with pSEED=(\d+)$')
test_regex = re.compile(args.tests)

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
   if args.tests:
      if test_regex.search(test['name']) == None:
          continue
   for i in range(args.runs):
      run_test = True
      # build make command:
      makeargs = ['make', 'all', 'VERBOSE=1']
      if args.dump:
         makeargs.append('DUMP=1')
      for key in test.keys():
         if key == 'name':
            logfile = "results/%s%d.log" % (test[key], i) 
            makeargs.append("LOGFILE=%s" % logfile)
         elif key == 'description':
            pass
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



