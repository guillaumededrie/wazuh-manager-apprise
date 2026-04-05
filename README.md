This repository contains a Dockerfile to build a [Wazuh](https://wazuh.com/) Manager
Container image with an [Apprise](https://github.com/caronc/apprise)
[custom integration](https://documentation.wazuh.com/current/user-manual/manager/integration-with-external-apis.html#creating-an-integration-script)


# Requirements

   - [Just](https://github.com/casey/just), a command runner


# Test

```shell
$ just enter-local-image test

bash-5.2# cd /var/ossec/integrations/
bash-5.2# ./custom-apprise "" "pover://<user>@<token>"
wazuh-apprise - INFO - Initialize Apprise
wazuh-apprise - INFO - Read configuration parameters
wazuh-apprise - INFO - Read the alert file
wazuh-apprise - INFO - Extract issue fields
wazuh-apprise - INFO - Send notification
apprise - INFO - Sent Pushover notification to ALL_DEVICES.
```


# Debug

You can use the environment variable `WAZUH_APPRISE_LOGLEVEL` to set the
[Python Logging level](https://docs.python.org/3/library/logging.html#levels) for more
verbosity:

```shell
$ just enter-local-image test
[+] Building 2.5s (10/10) FINISHED
…
just enter-image wazuh-apprise:local-test
bash-5.2# cd /var/ossec/integrations/
bash-5.2# WAZUH_APPRISE_LOGLEVEL="debug" ./custom-apprise "" "pover://<user>@<token>"
wazuh-apprise - INFO - Initialize Apprise
apprise - DEBUG - Language set to en
apprise-wazuh - INFO - Read configuration parameters
apprise - DEBUG - 131 Notification Plugin(s) and 183 Schema(s) loaded in 0.1510s
apprise - DEBUG - Loaded Pushover URL: pover://<user>@<token>//?priority=normal&format=text&overflow=upstream
apprise-wazuh - INFO - Read the alert file
apprise-wazuh - INFO - Extract issue fields
apprise-wazuh - INFO - Send notification
apprise - DEBUG - Pushover POST URL: https://api.pushover.net/1/messages.json (cert_verify=True)
apprise - DEBUG - Pushover Payload: {'token': '<token>', 'user': '<user>', 'priority': '0', 'title': 'sshd: brute force trying to get access to the system. Non exist
ent user.', 'message': '- Rule ID: 5712\n- Alert level: 10\n- Agent: localhost.localdomain (000)', 'device': 'ALL_DEVICES', 'sound': 'pushover'}
urllib3.connectionpool - DEBUG - Starting new HTTPS connection (1): api.pushover.net:443
urllib3.connectionpool - DEBUG - https://api.pushover.net:443 "POST /1/messages.json HTTP/1.1" 200 None
apprise - INFO - Sent Pushover notification to ALL_DEVICES.
```
