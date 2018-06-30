FROM ustclug/ubuntu
ENV user="tcs_git4xuan"
ENV password="password"
RUN apt-get update -y && apt-get install -y software-properties-common  wget python python3 git rsync dialog apt-utils && apt-get install python3-pip nmap -y && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip
COPY do.py /tmp/
RUN pip3 install linode
RUN pip3 install cloudflare

RUN mkdir ~/.ssh/
### Login gitlab first,Using SSH keys as a password.This password cannot upload to git repo
#RUN rm ~/.ssh/authorized_keys
#COPY gitlabGlobal.novcs  /root/.ssh/
#RUN cat ~/.ssh/gitlabGlobal.novcs > ~/.ssh/authorized_keys
#RUN chown -R root:root /root/.ssh && chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/authorized_keys
#RUN cat ~/.ssh/authorized_keys
RUN rm -rf ./ptsk
RUN ssh-keyscan -H git.cloud.tencent.com >> ~/.ssh/known_hosts \
 && mkdir ptsk && git clone https://$user:$password@git.qcloud.com/tcs/ptsk.git

RUN mv ./ptsk/config/linode-cli ~/.linode-cli && mkdir ~/.cloudflare/ && mv ./ptsk/config/cloudflare.cfg  ~/.cloudflare/cloudflare.cfg

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
