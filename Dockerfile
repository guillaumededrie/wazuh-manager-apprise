FROM wazuh/wazuh-manager:4.14.4@sha256:20487bc98a1e80012f61618d448b34dfb99d2e1d6912ea3e7324a6ed96531d2f AS production

RUN \
        dnf install --assumeyes \
            python3 \
            python3-pip \
        && pip install apprise \
        && dnf clean all

# See: https://documentation.wazuh.com/current/user-manual/manager/integration-with-external-apis.html#creating-an-integration-script
COPY custom-apprise.py /var/ossec/integrations/custom-apprise
RUN \
        chmod 750 /var/ossec/integrations/custom-apprise \
        && chown root:wazuh /var/ossec/integrations/custom-apprise


FROM production AS test

COPY alert.json /var/ossec/integrations/.
