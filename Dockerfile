FROM odoo:14.0
ADD . /tmp
RUN pip3 install -r /tmp/requirements.txt
