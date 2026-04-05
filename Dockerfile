FROM wazuh/wazuh-manager:4.14.4@sha256:5a065930682d728e3939a3a34b7c9bc28d55b22d3d93c2fe3cc19cf76d67e8e8 AS production

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
