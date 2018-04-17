FROM ljsommer/python-base

ARG terraform_version
RUN wget "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" -O /tmp/terraform.zip
RUN mkdir -p /opt/terramorph/code/
RUN unzip /tmp/terraform.zip -d /opt/terramorph/

ARG ansible_version
RUN pip3 install --upgrade pip \
    ansible==${ansible_version}

ENV ANSIBLE_CONFIG="/app/src/terramorph/ansible/ansible.cfg"

ADD . /app/src
RUN chmod +x /app/src/terramorph/entrypoint.sh

WORKDIR '/opt/terramorph/code'
ENTRYPOINT ["/bin/sh", "/app/src/terramorph/entrypoint.sh"]
