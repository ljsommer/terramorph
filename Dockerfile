ARG alpine_version

FROM alpine:${alpine_version}

RUN apk add --no-cache --update \
  bash \
        build-base \
  git \
        libffi-dev \
  openssh \
        openssl-dev \
        python3 \
        python3-dev

RUN python3 -m ensurepip && \
  rm -r /usr/lib/python*/ensurepip && \
  pip3 install --upgrade pip setuptools && \
  if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip; fi && \
  if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
  rm -r /root/.cache

RUN pip3 install --upgrade pip \
  awscli --upgrade --user \
  boto3 \
        cffi \
  pyyaml

RUN mkdir /root/.aws/ && chmod 0700 /root/.aws/
RUN mkdir /root/.ssh/ && chmod 0700 /root/.ssh/

ONBUILD ADD . /app/src

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
