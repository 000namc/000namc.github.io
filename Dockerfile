FROM ruby:3.0

ARG SSH_PRIVATE_KEY

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
RUN chmod 600 ~/.ssh/id_rsa

RUN mkdir /app
RUN mkdir /app/blog/
WORKDIR /app/blog/
COPY . ./

RUN apt update

RUN apt install -y emacs openssh-server
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0847t6O7K9dEwUOm8gJ8Ov0501lCF8w5mBzzlb53VhB/HmGqqPrJdS9WEEZqB/GqAM/HWBCobAcZhqpEAvLqWVjPBxeni9vHQ6iEzalBLpY0GQ8MeqC/8Ah5EY+Cp9EEt9IvcLi9X2PDj3YfMh8AwiW+Klj1ixuEI7/Pwg+CVNkJOu+OdYq/4BgQbr9MJZqmE/3V4WcdYf2v3Z+VCnTk9XsQQcLpSS+2CP1gs1qanWu3knRMSIeZv5Szf0o4ReOa3SSDMP/9EEAg6wgRUHFT91clXDC/zTFBr2hTY2RTKPvCklsEIstxCxln6VetUXkRgoVEB+Sm8wnxsf8rSt/D5gyk26QZgoYBbT69Bf7ic4XRmK+u9Za4yp7z4G9N+Ikn7bXQ9o4UzfrJUT4vxVpGC6AP9kASLSWFRFAJ27suT7W5xS9+EDD4t3aZpBTdfaGZobJ1KA24MAia/K4hoiZ/rtw8ruzqX2yoVQHtwDcfjYgY16RfaJnzqINxX2vp4QYc= 000namc@namseong-ugs-MacBook-Air.local" >> /root/.ssh/authorized_keys
RUN gem install bundler
RUN bundle install

ENTRYPOINT ["sh", "start.sh"]