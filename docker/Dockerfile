FROM ustclug/ubuntu
RUN apt-get update -y && apt-get install -y software-properties-common  wget python python3 rsync dialog apt-utils && rm -rf /var/lib/apt/lists/*
COPY . /tmp/
RUN cd /tmp/ptzip && bash package_minimal.sh && python3 get-pip.py && rm -rf /var/lib/apt/list/* && rm -rf get-pip.py
