FROM ustclug/ubuntu
RUN apt-get update -y && apt-get install -y software-properties-common  wget python python3 rsync dialog apt-utils &&  apt-get install python3-pip -y && rm -rf /var/lib/apt/lists/*
COPY . /tmp/
RUN cd /tmp/ptzip && bash package_minimal.sh && rm -rf /var/lib/apt/list/* && rm -rf get-pip.py
RUN apt-get update -y && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
RUN bash /tmp/ptzip/base/goinstall.sh --64
