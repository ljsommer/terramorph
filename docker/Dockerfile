FROM ljsommer/python-base

ARG terraform_version
ADD "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" /tmp
RUN mkdir -p /opt/terramorph/code
RUN unzip /tmp/terraform_${terraform_version}_linux_amd64.zip -d /opt/terramorph

WORKDIR "/opt/terramorph/code"
ENTRYPOINT ["/opt/terramorph/terraform"]
