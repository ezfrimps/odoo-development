FROM odoo:15.0
ADD . /tmp
RUN pip3 install -r /tmp/requirements.txt
