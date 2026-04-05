#!/usr/bin/env python3
import json
import logging
import os
import sys
from pathlib import Path

from apprise import Apprise, AppriseAsset


logging.basicConfig(
    level=os.environ.get("WAZUH_APPRISE_LOGLEVEL", "INFO").upper(),
    format="%(name)s - %(levelname)s - %(message)s",
)
LOGGER = logging.getLogger("wazuh-apprise")

ALERT_INDEX = 1
WEBHOOK_INDEX = 3


def main(args):
    """
    Custom Integration of Apprise for Wazuh.

    Resources:
        - https://github.com/caronc/apprise/wiki/Development_API#the-apprise-asset-object
        - https://documentation.wazuh.com/current/user-manual/manager/integration-with-external-apis.html#creating-an-integration-script
    """

    LOGGER.info("Initialize Apprise")
    apprise_asset = AppriseAsset(
        app_id="Wazuh",
        app_desc=(
            "Wazuh is an open-source platform for threat detection and"
            " incident response"
        ),
        app_url="https://wazuh.com/",
    )
    apobj = Apprise(asset=apprise_asset)

    LOGGER.info("Read configuration parameters")
    try:
        alert_file = Path(args[ALERT_INDEX])
        hook_url = args[WEBHOOK_INDEX]
    except IndexError as e:
        LOGGER.error("CLI argument(s) missing!")
        raise e

    apobj.add(hook_url)

    LOGGER.info("Read the alert file")
    try:
        alert_json = json.loads(alert_file.read_text(encoding="utf-8"))
    except Exception as e:
        LOGGER.error("Impossible to read the alert file")
        raise e

    LOGGER.info("Extract issue fields")
    notification_title = alert_json["rule"]["description"] or "Undefined"
    notification_body = (
        f"- Rule ID: {alert_json['rule']['id']}"
        f"\n- Alert level: {alert_json['rule']['level']}"
        f"\n- Agent: {alert_json['agent']['name']} ({alert_json['agent']['id']})"
    )

    LOGGER.info("Send notification")
    apobj.notify(
        title=notification_title,
        body=notification_body,
    )


if __name__ == "__main__":
    main(sys.argv)
