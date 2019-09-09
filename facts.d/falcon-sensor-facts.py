#!/usr/bin/env python3

import json
import subprocess
import sys

cmd = "/opt/CrowdStrike/falconctl -g --aph --app --cid --aid --version".split()
try:
    output = subprocess.check_output(cmd)
except subprocess.CalledProcessError as err:
    print("falconctl returned errorcode {}: {}".format(err.returncode, 
          err.output), file=sys.stderr)
    sys.exit(err.returncode)

facts = {'falcon_sensor': {x.split('=')[0].strip('" '): x.split('=')[1].strip('" ')
    for x in output.decode('ascii')[:-1].split(', ')}}


print(json.dumps(facts, indent=2))
