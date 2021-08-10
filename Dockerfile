FROM python:3.7-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add linux-headers libffi-dev gcc make musl-dev py-pip mysql-client git openssl-dev   #这里注意1
RUN adduser -D -u 1001 -s /bin/bash ctfd

WORKDIR /opt/CTFd
RUN mkdir -p /opt/CTFd /var/log/CTFd /var/uploads

COPY requirements.txt .

RUN apk add gcc
RUN apk add musl-dev
RUN apk add libxslt-dev
RUN apk add g++
RUN apk add make
RUN apk add libffi-dev
RUN apk add openssl-dev
RUN apk add libtool

RUN pip install -r requirements.txt -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/   #这里注意2

COPY . /opt/CTFd

RUN for d in CTFd/plugins/*; do \
      if [ -f "$d/requirements.txt" ]; then \
        pip install -r $d/requirements.txt -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/ ; \
      fi; \
    done; #同样注意2

RUN chmod +x /opt/CTFd/docker-entrypoint.sh
RUN chown -R 1001:1001 /opt/CTFd
RUN chown -R 1001:1001 /var/log/CTFd /var/uploads

USER 1001
EXPOSE 8000
ENTRYPOINT ["/opt/CTFd/docker-entrypoint.sh"]


