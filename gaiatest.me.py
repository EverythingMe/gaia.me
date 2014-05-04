import os
from runtests import GaiaTestRunner

os.environ['GAIATEST_ACKNOWLEDGED_RISKS'] = os.environ['GAIATEST_SKIP_WARNING']= 'True'

runner = GaiaTestRunner(address='localhost:2828')

runner.run_tests(['tests/functional/homescreen/test_homescreen_launch_app.py'])
# runner.run_tests(['tests/functional/everythingme/test_everythingme_add_collection.py'])