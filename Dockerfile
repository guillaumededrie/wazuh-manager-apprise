FROM wazuh/wazuh-manager:4.14.5@sha256:3b2b7aae2daf696071ecc8b32a5d1e65e5c2a625291afc434bd20171a9d41109 AS production

ARG WAZUH_VERSION
ARG APPRISE_VERSION

LABEL org.opencontainers.image.version="${WAZUH_VERSION}-apprise${APPRISE_VERSION}"
LABEL com.wazuh.manager.version="${WAZUH_VERSION}"
LABEL com.apprise.version="${APPRISE_VERSION}"

# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/permanent_data.env
COPY resources/permanent_data.env /

# Install requirements
# We need to use the already available pip3 package as it will the one used by
# `src/apprise` bash script.
COPY src/requirements.txt /tmp/.
RUN \
        /var/ossec/framework/python/bin/pip3 install --require-hashes --requirement /tmp/requirements.txt \
        && rm /tmp/requirements.txt

# See: https://documentation.wazuh.com/current/user-manual/manager/integration-with-external-apis.html#creating-an-integration-script
# The documention doesn't apply totaly to Docker container, as some file are copied from
# `data_tmp` folder.
# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/permanent_data.sh
# See: https://github.com/wazuh/wazuh-docker/blob/7af31ddfb4d7dd72acbd0789728185c525a64755/build-docker-images/wazuh-manager/config/etc/cont-init.d/0-wazuh-init#L61
COPY src/custom-apprise src/custom-apprise.py /var/ossec/data_tmp/exclusion/var/ossec/integrations/.
RUN \
        chmod 750 /var/ossec/data_tmp/exclusion/var/ossec/integrations/custom-apprise* \
        && chown root:wazuh /var/ossec/data_tmp/exclusion/var/ossec/integrations/custom-apprise*


FROM production AS test

COPY resources/alert.json /tmp/.
