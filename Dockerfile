FROM ljsommer/python-base

ARG terraform_version
ADD "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" /tmp/
RUN mkdir -p /opt/terramorph/code
RUN unzip /tmp/terraform_${terraform_version}_linux_amd64.zip -d /opt/terramorph/

ARG ansible_version
RUN pip3 install --upgrade pip \
    ansible==${ansible_version}

RUN alias terramorph="python /app/src/terramorph/main.py"
RUN alias tm="python /app/src/terramorph/main.py"

ENV ANSIBLE_CONFIG="/app/src/terramorph/ansible/ansible.cfg"

ENTRYPOINT ["/bin/sh", "/app/src/terramorph/entrypoint.sh"]
