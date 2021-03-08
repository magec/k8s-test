FROM ubuntu:20.04 AS cli-base
ARG user=ubuntu
ARG extra_packages='ssh curl wget ruby sudo unzip locales gcc libffi-dev libxml2-dev ruby-dev awscli make'

# Common tools
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ${extra_packages}

# Add an unprivileged user with sudo
RUN apt-get update \
	&& apt-get install -y sudo \
	&& useradd -m ${user} \
	&& adduser ${user} sudo \
	&& echo "${user} ALL=NOPASSWD: ALL" > /etc/sudoers.d/${user}

# Install kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl -O /usr/bin/kubectl \
    && chmod a+x /usr/bin/kubectl

RUN wget -q --show-progress --https-only --timestamping \
    https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl -O /usr/bin/cfssl \
    && chmod a+x /usr/bin/cfssl \
    && wget -q --show-progress --https-only --timestamping \
    https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson -O /usr/bin/cfssljson \
    && chmod a+x /usr/bin/cfssljson

# Terraform
ARG terraform_version='0.14.7'
RUN wget "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" \
	&& unzip "terraform_${terraform_version}_linux_amd64.zip" -d /usr/bin/ \
	&& rm "terraform_${terraform_version}_linux_amd64.zip"

# Locale setup
RUN /usr/sbin/locale-gen en_US.UTF-8

# Install ruby dependencies
RUN gem update --system 3.2.13  && gem install bundler -v 2.2.13

COPY docker/cli/Gemfile /tmp/
COPY docker/cli/Gemfile.lock /tmp/
RUN bundle install --gemfile /tmp/Gemfile

USER root
ENTRYPOINT ["/opt/k8s-test/bin/cli_wrapper"]
