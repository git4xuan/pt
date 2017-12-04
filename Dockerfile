FROM ustclug/ubuntu
RUN apt-get update -y && apt-get install -y software-properties-common  wget python python3 rsync dialog apt-utils && rm -rf /var/lib/apt/lists/*
COPY . /tmp/
RUN cd /tmp/ptzip && bash package_minimal.sh && rm -rf /var/lib/apt/list/* && rm -rf get-pip.py
RUN  wget https://bootstrap.pypa.io/get-pip.py && chmod +x get-pip.py && python3 get-pip.py && rm -rf get-pip.py
RUN apt-get update -y && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
RUN bash /tmp/ptzip/base/goinstall.sh --64
