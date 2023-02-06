import os
import logging
import argparse
import textwrap
from opencensus.ext.azure.log_exporter import AzureLogHandler

parser = argparse.ArgumentParser(
  formatter_class=argparse.RawDescriptionHelpFormatter,
  description=textwrap.dedent('''\
This script Logs a message at a given level to application insights!
--------------------------------
You must supply the proper application insights key, logging levels and message
  Set the LOGGING_INSIGHTS_KEY environment variable with the Instrumentation Key for the target Application Insights instance.
  Set the LOGGING_INSIGHTS_LEVEL environment variable to the minimum logging level you want to log messages for.
  Pass the desired logging level of the message as the first command line argument to the script
  Pass the message to log (in quotes) as the second command line argument to the script

Logging Levels are Integers, from the following list:

  INT NAME     App Insights Severity
  --- -----    ---------------------
  10  DEBUG                        0
  20  INFO                         1
  30  WARN                         2
  40  ERROR                        3
  50  CRITICAL                     4 

Here is an example call to log a DEBUG (level 10) message with your current host name, user name, date, and time:

python3 log_to_app_insights.py 10 "$(hostname) $(whoami) $(date +'%Y%m%d %H%M%S')"
'''))
  
parser.add_argument('level', type=int, choices=[10,20,30,40,50], help='Logging level of the message as an integer: 10 (DEBUG),20 (INFO),30 (WARNING),40 (ERROR) or 50 (CRITICAL)')
parser.add_argument('message', type=str, help='Message to be written')
args = parser.parse_args()

level = args.level
message = args.message.strip()

logging_insights_key = os.getenv("LOGGING_INSIGHTS_KEY")
try:
  logging_insights_level = int(os.getenv("LOGGING_INSIGHTS_LEVEL","10"))
  if logging_insights_level not in [10,20,30,40,50]:
    logging_insights_level = 10 # Default to 10 (DEBUG) if an invalid level was set
except Exception as e:
  print(
    f'An invalid value was retrieved for the logging level ({" ".join(os.getenv("LOGGING_INSIGHTS_LEVEL","10"))})\n\n'
    f"{e}\n\n"
    f"Defaulting to 10 (DEBUG)"
  )
  logging_insights_level = 10

# Uncomment the following to show the app insights key and logging level with spaces between each character
# So the azure devops log doesn't mask the values with asterisks
# if level == 10:
#   print(f'Using App Insights Instrumentation Key: {" ".join(logging_insights_key)}')
#   print(f'Using App Insights Logging Level:       {" ".join(str(logging_insights_level))}')

logging.root.addHandler(logging.NullHandler())

logger = logging.getLogger('eitc')
logger.setLevel(logging_insights_level)

if (logging_insights_key != None and logging_insights_level != logging.NOTSET):
  if(level == 10):
    print(f"Setting up logging to app insights with key '{logging_insights_key}'")
  insights_handler = AzureLogHandler(
    connection_string=f'InstrumentationKey={logging_insights_key}')
  insights_handler.setLevel(logging_insights_level)
  insights_handler.setFormatter(logging.Formatter("%(message)s"))
  logger.addHandler(insights_handler)

def createCustomDimensions():
  envvars = [
    "HOSTNAME","AGENT_ID","AGENT_JOBNAME","AGENT_JOBSTATUS","AGENT_MACHINENAME", "AGENT_NAME",
    "AGENT_OS","AGENT_OSARCHITECTURE","AGENT_VERSION","BUILD_BUILDID","BUILD_BUILDNUMBER",
    "BUILD_BUILDURI","BUILD_CONTAINERID","BUILD_DEFINITIONNAME","BUILD_DEFINITIONVERSION",
    "BUILD_QUEUEDBY","BUILD_QUEUEDBYID","BUILD_REASON","BUILD_REPOSITORY_NAME",
    "BUILD_REPOSITORY_URI","BUILD_REQUESTEDFOR","BUILD_REQUESTEDFOREMAIL","BUILD_REQUESTEDFORID",
    "BUILD_SOURCEBRANCH","BUILD_SOURCEBRANCHNAME","BUILD_SOURCEVERSION","BUILD_SOURCEVERSIONAUTHOR",
    "BUILD_SOURCEVERSIONMESSAGE","ImageOS","ImageVersion","LOGGING_INSIGHTS_LEVEL",
    "SYSTEM_DEFINITIONID","SYSTEM_DEFINITIONNAME","SYSTEM_PHASEATTEMPT","SYSTEM_PHASEDISPLAYNAME",
    "SYSTEM_PHASENAME","SYSTEM_PIPELINESTARTTIE","SYSTEM_PLANID","SYSTEM_SERVERTYPE",
    "SYSTEM_STAGEATTEMPT","SYSTEM_STAGEDISPLAYNAME","SYSTEM_STAGEID","SYSTEM_STAGENAME",
    "SYSTEM_TASKDEFINITIONURI","SYSTEM_TASKDISPLAYNAME","SYSTEM_TASKINSTANCEID",
    "SYSTEM_TASKINSTANCENAME","SYSTEM_TEAMFOUNDATIONCOLLECTIONURI","SYSTEM_TEAMFOUNDATIONSERVERRI",
    "SYSTEM_TEAMPROJECT","SYSTEM_TEAMPROJECTID","SYSTEM_TIMELINEID","SYSTEM_TOTALJOBSINPHASE",
    "TASK_DISPLAYNAME"]
  data={}
  for envvar in envvars:
    value = os.getenv(envvar,"")
    if value != "":
      data[envvar] = value

  customDimensions ={"custom_dimensions": data}
  return customDimensions

def main():
  if insights_handler is None or message == "":
    parser.print_help()
  else:
    if level == 10 and level < logging_insights_level:
      print(f"The minimum logging level has been set to {logging_insights_level} \n" 
            f"via the `LOGGING_INSIGHTS_LEVEL` environment variable, \n"
            f"this level {level} message will not be logged to application insights")
    else:
      if level == 10:
        print(f"Logging at level {level} the message '{message}'")
      customDimensions = createCustomDimensions()
      logger.log(level=level, msg=message, extra=customDimensions)

if __name__ == "__main__":
    main()