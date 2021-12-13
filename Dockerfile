FROM debian:bullseye-slim
SHELL [ "/bin/bash", "-xo", "pipefail", "-c" ]

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git python3 python3-pip build-essential wget python3-dev python3-venv \
    python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev \
    python3-setuptools node-less libjpeg-dev gdebi nodejs npm curl \
    libpq-dev python-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev xfonts-75dpi \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

RUN npm install -g rtlcss
# RUN groupadd -r odoo && useradd -m -d /opt/odoo15 -U -r -s /bin/bash odoo
ENV ODOO_VERSION 15.0
RUN mkdir -p /mnt/extra-addons \
    mkdir /opt/odoo15 \
    # && chown -R odoo /mnt/extra-addons \
    && mkdir /opt/odoo15/log
    # && chown -R /opt/odoo15/
ADD ./my_addons /mnt/extra-addons
RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch ${ODOO_VERSION} /opt/odoo15/odoo
COPY ./config/odoo.conf /etc/odoo/odoo.conf
RUN pip3 install wheel
RUN pip3 install -r /opt/odoo15/odoo/requirements.txt

# VOLUME [ "/mnt/extra-addons" ]

EXPOSE 8069 8071 8072
ENV ODOO_RC /etc/odoo/odoo.conf
WORKDIR /opt/odoo15/odoo/
# CMD [ "./odoo-bin", "-c", "/etc/odoo/odoo.conf" ]