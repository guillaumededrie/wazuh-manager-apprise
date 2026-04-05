FROM wazuh/wazuh-manager:4.14.4@sha256:20487bc98a1e80012f61618d448b34dfb99d2e1d6912ea3e7324a6ed96531d2f AS production

# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/permanent_data.env
COPY resources/permanent_data.env /

# Use the already available pip3 package, used by `apprise` bash script
RUN /var/ossec/framework/python/bin/pip3 install "apprise==1.9.9"

# See: https://documentation.wazuh.com/current/user-manual/manager/integration-with-external-apis.html#creating-an-integration-script
# The documention doesn't apply totaly to Docker container, as some file are copied from
# `data_tmp` folder.
# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/permanent_data.sh
# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/etc/cont-init.d/0-wazuh-init#L61
COPY resources/apprise resources/apprise.py /var/ossec/data_tmp/exclusion/var/ossec/integrations/.
RUN \
        chmod 750 /var/ossec/data_tmp/exclusion/var/ossec/integrations/apprise* \
        && chown root:wazuh /var/ossec/data_tmp/exclusion/var/ossec/integrations/apprise*


FROM production AS test

COPY resources/alert.json /tmp/.
