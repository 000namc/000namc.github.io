FROM ruby:3.0

ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN echo "${SSH_PUBLIC_KEY}" >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/authorized_keys

RUN mkdir /app
RUN mkdir /app/blog/
WORKDIR /app/blog/
COPY . ./

RUN apt update

RUN apt install -y emacs openssh-server
RUN gem install bundler
RUN bundle install

ENTRYPOINT ["sh", "start.sh"]