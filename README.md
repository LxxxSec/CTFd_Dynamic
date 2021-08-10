# 【CTFd搭建&虚拟机版本下载】CTFd动态靶机搭建（详细总结&虚拟机版本提供下载）

[TOC]



## 成品展示：

![image-20210809171013233](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809171013.png)

![image-20210809171028620](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809171028.png)

![image-20210809171045466](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809171045.png)



## 环境：

- 主机：Ubuntu 20.10 
  - 本篇文章使用的机器的IP：192.168.2.151

- Docker版本：20.10.2
- Docker-compose版本：1.25.0



## 搭建步骤：

### 系统环境配置：

#### 安装vim：

```
apt-get install vim
```

![image-20210809172800050](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809172800.png)

因为是官方源，所以会比较慢，后面会进行换源。



#### 切换镜像源：

这里以**Ubuntu20.10**为例：[ubuntu | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/)

```
vim /etc/apt/sources.list
```

将原有的内容删除，往**source.list**里面加入以下内容，加完之后保存退出。

```
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ groovy-proposed main restricted universe multiverse
```

**注意：**一定要更新一下镜像源！！（不然后面没法安装包）

```
apt-get update
```



#### 安装docker：

```
apt-get install docker.io
```

![image-20210809173246259](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809173246.png)

输入**y**后回车



#### 安装docker-compose：

```
apt-get install docker-compose
```

![image-20210809173406530](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809173406.png)

同样按**y**后回车



#### 安装git：

```
apt-get intsall git
```

![image-20210809173913319](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809173913.png)

一般来说，安装过docker之后，git也已经安装好了，不过我们还是再确认一下。



#### docker镜像加速：

进入阿里云镜像服务官网：[容器镜像服务 (aliyun.com)](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

根据下方教程配置自己的Docker静态加速器。

![image-20210809174611880](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809174611.png)

镜像地址每个人都不一样，根据每个人的情况设置。

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://xxxxxxxx.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```



#### 下载CTFd：

这一个CTFd是赵师傅改写的，链接在下方。之所以要使用赵师傅改写的CTFd，是因为官方CTFd可能会与动态靶机插件ctf-whale冲突。

- https://github.com/glzjin/CTFd.git

```
git clone https://github.com/glzjin/CTFd.git
```

![image-20210809174821617](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809174821.png)

如果clone的过程中卡住了，可以尝试Ctrl+C将命令掐断，然后重新执行，实在不行的话，可以挂代理。

![image-20210809175516849](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809175516.png)



#### 下载frpc：

下载frpc：

```
wget https://github.com/fatedier/frp/releases/download/v0.29.0/frp_0.29.0_linux_amd64.tar.gz
```

同样的，如果clone的过程中卡住了，可以尝试Ctrl+C将命令掐断，然后重新执行，实在不行的话，可以挂代理。

将下载下来的frpc解压：

```
tar -zxvf frp_0.29.0_linux_amd64.tar.gz
```



#### 下载ctfd-whale：

地址：https://github.com/glzjin/CTFd-Whale

```
git clone https://github.com/glzjin/CTFd-Whale.git
```

![image-20210809175838840](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809175838.png)

**注意：**这个时候要将CTFd-Whale文件夹重命名为小写。

```
mv CTFd-Whale/ ctfd-whale
```

![image-20210809175958517](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809175958.png)



#### 下载docker版本的frps：

地址：https://github.com/glzjin/Frp-Docker-For-CTFd-Whale

```
git clone https://github.com/glzjin/Frp-Docker-For-CTFd-Whale
```

**注意：**将Frp-Docker-For-CTFd-Whale也重命名为小写

```
mv Frp-Docker-For-CTFd-Whale/ frp-docker-for-ctfd-whale
```

![](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809180305.png)



### CTFd环境配置：

接下来就开始配置CTFd的一些文件了！



#### Docker集群设置：

先初始化：

```
docker swarm init
```

![image-20210809180635805](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809180635.png)

将刚刚初始化的这个集群加入到节点当中，命令执行后，返回的就是节点ID了，暂时不用管这个节点ID。

```
docker node update --label-add='name=linux-1' $(docker node ls -q)
```

![image-20210809180924866](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809180924.png)



#### 将ctfd-whale放入CTFd的插件目录中：

如下图所示：

![image-20210809181217953](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809181218.png)

```
mv ctfd-whale/ CTFd/CTFd/plugins/
```

![image-20210809181608444](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809181608.png)

![image-20210809181700881](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809181700.png)



#### 启动docker版本的frps及frps配置：

进入该目录：

```
cd frp-docker-for-ctfd-whale/
```

启动该docker：

```
docker-compose up -d
```

![image-20210809181951245](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809181951.png)

耐心等待镜像构建。

![image-20210809182036960](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809182037.png)

完成以后，可以使用`docker ps`查看是否正在运行。

这个时候我们查看一下frps的配置。

frps/frps.ini文件如下：

```
[common]
bind_port = 6490
token = randomme
```

这里的token可以改也可以不改，一般也就不改了。



#### 将frpc传入CTFd中：

这一步骤实际上就是：将frpc，frpc.ini，frpc_full.ini，LICENSE这四个文件放在CTFd/frpc文件夹中。

进入CTFd目录中，新建一个frpc文件夹

```
cd CTFd/
mkdir frpc
```

![image-20210809182726024](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809182726.png)

进入frpc的目录（frp_0.29.0_linux_amd64）

```
cd ../frp_0.29.0_linux_amd64
```

将上述四个文件移动到frpc文件夹中

```
mv frpc.ini ../CTFd/frpc/
mv frpc_full.ini ../CTFd/frpc/
mv frpc ../CTFd/frpc/
mv LICENSE ../CTFd/frpc/
```

![image-20210809183010741](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809183010.png)



#### 修改frpc.ini文件：

进入frpc目录中，修改frpc.ini文件

```
[common]
token = randomme
server_addr = 172.1.0.4
server_port = 6490
pool_count = 200
tls_enable = true

admin_addr = 172.1.0.3
admin_port = 7400
```



#### 配置Dockerfile：

进入ctfd目录，将下方内容复制到Dockerfile中

```
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


```







#### 配置docker-compose.yml文件：

```
version: '2.2'

services:
  ctfd-nginx:
    image: nginx:1.17
    volumes:
      - ./nginx/http.conf:/etc/nginx/nginx.conf   #这里注意
    user: root
    restart: always
    ports:
      #- "85:80"     #我将这里注释掉了，这里通过nginx转发感觉速度访问速度会变慢，可能因为我的配置问题，多次尝试之后直接开8000端口访问不会对服务造成影响
      - "443:443"
    networks:
        default:
        internal:
    depends_on:
      - ctfd
    cpus: '1.00'  #可改
    mem_limit: 150M     #可改
  ctfd:
    build: .
    user: root
    restart: always
    ports:
      - "8000:8000"     #这里原本没开端口，直接打开访问网站速度会加快
    environment:
      - UPLOAD_FOLDER=/var/uploads
      - DATABASE_URL=mysql+pymysql://root:ctfd@db/ctfd
      - REDIS_URL=redis://cache:6379
      - WORKERS=1
      - LOG_FOLDER=/var/log/CTFd
      - ACCESS_LOG=-
      - ERROR_LOG=-
      - REVERSE_PROXY=true
    volumes:
      - .data/CTFd/logs:/var/log/CTFd
      - .data/CTFd/uploads:/var/uploads
      - .:/opt/CTFd:ro
      - /var/run/docker.sock:/var/run/docker.sock     #这里是添加的
    depends_on:
      - db
    networks:
        default:
        internal:
        frp:
            ipv4_address: 172.1.0.2
    cpus: '1.00'     #可改
    mem_limit: 450M     #可改

  db:
    image: mariadb:10.4
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=ctfd
      - MYSQL_USER=ctfd
      - MYSQL_PASSWORD=ctfd
    volumes:
      - .data/mysql:/var/lib/mysql
    networks:
        internal:
    # This command is required to set important mariadb defaults
    command: [mysqld, --character-set-server=utf8mb4, --collation-server=utf8mb4_unicode_ci, --wait_timeout=28800, --log-warnings=0]
    cpus: '1.00'     #可改
    mem_limit: 750M     #可改

  cache:
    image: redis:4
    restart: always
    volumes:
      - .data/redis:/data
    networks:
        internal:
    cpus: '1.00'     #可改
    mem_limit: 450M     #可改

  frpc:    
    image: glzjin/frp:latest     #赵师傅tql
    restart: always
    volumes:
      - ./frpc:/conf/     #这里注意
    entrypoint:
        - /usr/local/bin/frpc
        - -c
        - /conf/frpc.ini
    networks:
        frp:
            ipv4_address: 172.1.0.3  #记住此处
        frp-containers:
    cpus: '1.00'     #可改
    mem_limit: 250M     #可改

networks:
    default:
    internal:
        internal: true
    frp:
        driver: bridge
        ipam:
            config:
                - subnet: 172.1.0.0/16
    frp-containers:
        driver: overlay
        internal: true
        ipam:
            config:
                - subnet: 172.2.0.0/16


```



#### 配置requirements.txt

这里主要是修改gevent的版本号，原本是1.4.0的，我这边修改成了20.9.0

```
Flask==1.1.1
Werkzeug==0.16.0
Flask-SQLAlchemy==2.4.1
Flask-Caching==1.4.0
Flask-Migrate==2.5.2
Flask-Script==2.0.6
SQLAlchemy==1.3.11
SQLAlchemy-Utils==0.36.0
passlib==1.7.2
bcrypt==3.1.7
six==1.13.0
itsdangerous==1.1.0
requests>=2.20.0
PyMySQL==0.9.3
gunicorn==19.9.0
normality==2.0.0
dataset==1.1.2
mistune==0.8.4
netaddr==0.7.19
redis==3.3.11
datafreeze==0.1.0
python-dotenv==0.10.3
flask-restplus==0.13.0
pathlib2==2.3.5
flask-marshmallow==0.10.1
marshmallow-sqlalchemy==0.17.0
boto3==1.10.39
marshmallow==2.20.2
gevent==20.9.0
```



#### 配置nginx：

在docker-compose.yml的目录下，新建一个nginx文件夹

```
mkdir nginx
```

进入nginx文件夹

```
cd nginx
```

创建一个文件http.conf，输入以下内容：

```
worker_processes 4;
events {
  worker_connections 1024;
}
http {
  # Configuration containing list of application servers
  upstream app_servers {
    server ctfd:8000;
  }
  server {
    listen 80;
    client_max_body_size 4G;
    # Handle Server Sent Events for Notifications
    location /events {
      proxy_pass http://app_servers;
      proxy_set_header Connection '';
      proxy_http_version 1.1;
      chunked_transfer_encoding off;
      proxy_buffering off;
      proxy_cache off;
      proxy_redirect off;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $server_name;
    }
    # Proxy connections to the application servers
    location / {
      proxy_pass http://app_servers;
      proxy_redirect off;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $server_name;
    }
  }
}

```

保存后退出。



#### 开始构建：

进入docker-compose.yml所在的文件目录下

```
docker-compose up -d
```

![image-20210809185343226](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809185343.png)

耐心等待。。。

完成后应该是这个样子

![image-20210809190706688](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809190706.png)



#### 配置网络：

我们先看一下现在的容器状态：

```
docker ps -a
```

![image-20210809190843808](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809190843.png)

可以看到**ctfd_frpc_1**这个容器的状态是退出状态。

我们再看一下现在docker的网络：

```
docker network ls
```

![image-20210809191011910](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809191011.png)

一会我们需要将ctfd_frpc_1，frp-docker-for-ctfd-whale_frps_1，ctfd_ctfd_1这三个容器加入到ctfd_frp网络中

并且这三个容器的IP如下：

- ctfd_ctfd_1：172.1.0.2

- ctfd_frpc_1：172.1.0.3
- frp-docker-for-ctfd-whale_frps_1：172.1.0.4

查看一下ctfd_frp网络

```
docker network inspect ctfd_frp
```

![image-20210809191343024](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809191343.png)

这个时候只有ctfd_ctfd_1这个容器是在ctfd_frp网络里的。

注意要指定IP：

```
docker network connect --ip 172.1.0.3 ctfd_frp ctfd_frpc_1
```

```
docker network connect --ip 172.1.0.4 ctfd_frp frp-docker-for-ctfd-whale_frps_1
```

然后重启一下这两个容器：

```
docker restart ctfd_frpc_1 frp-docker-for-ctfd-whale_frps_1
```

![image-20210809191949960](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809191950.png)

重启完成之后再查看一下ctfd_frp网络

```
docker network inspect ctfd_frp
```

![image-20210809192710662](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809192710.png)

可以看到，这个时候，ctfd_frpc_1，frp-docker-for-ctfd-whale_frps_1，ctfd_ctfd_1这三个容器已经加入到ctfd_frp网络中

**查看ctfd_frpc_1容器日志：**

```
docker logs ctfd_frpc_1
```

![image-20210809192844207](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809192844.png)

这样就算已经配置好了。

接下来就是ctfd-whale配置。



### ctfd-whale配置：

在浏览器中访问**IP：8000**

我这台机器就是http://192.168.2.151:8000

![image-20210809193930753](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809193930.png)

这一块就是ctfd的前置配置，按照自己的需求配置一下就好了

网站初步配置完成之后，开始配置ctfd-whale插件。

设置方面，就按照赵总的配置就好了，我这边参考error师傅的。

| 属性                                             | 配置                                  |
| ------------------------------------------------ | ------------------------------------- |
| Docker API URL                                   | unix://var/run/docker.sock            |
| Frp API IP                                       | frpc的ip配置                          |
| Frp API Port                                     | frpc的端口配置                        |
| Frp Http Domain Suffix                           | Docker API URL to connect（可填None） |
| Frp Http Port                                    | 80                                    |
| Frp Direct IP Address                            | 你的公网ip，本机即为127.0.0.1         |
| Frp Direct Minimum Port                          | 与之前frps最小端口呼应                |
| Frp Direct Minimum Port                          | 与之前frps最大端口呼应                |
| Max Container Count                              | 不超过最大-最小                       |
| Max Renewal Times                                | 最大实例延时次数                      |
| Frp config template                              | 填入frps的配置，只需填[common]        |
| Docker Auto Connect Containers                   | ctfd_frpc_1                           |
| Docker Dns Setting                               | 可填机器内DNS，没有可填个外网DNS      |
| Docker Swarm Nodes                               | linux-1 与前面swarm集群呼应           |
| Docker Multi-Container Network Subnet            | 内网题大子网ip配置/CIDR               |
| Docker Multi-Container Network Subnet New Prefix | 每个内网题实例的CIDR                  |
| Docker Container Timeout                         | 单位为秒                              |

其中Frp config template配置内容如下：

```
[common]
token = randomme
server_addr = 172.1.0.4
server_port = 6490
pool_count = 200
tls_enable = true

admin_addr = 172.1.0.3
admin_port = 7400
```

其他的按照下面这张图片配置就好

**注意：**

**Frp Direct IP Address**这个一定要修改成自己的IP，如果是云服务器就输入公网IP，如果是虚拟机那就输入虚拟机的IP。

![image-20210809194948251](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809194948.png)



### 添加一道题目：

添加的题目如下：

![image-20210809195220878](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809195221.png)

其中Docker image里就输入题目的tag就好了

测试开启题目：

![image-20210809195339093](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809195339.png)

![image-20210809195351713](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809195351.png)

可以看到，已经正确分配IP了

第一次获取题目要等一会，因为要拉题目镜像，等一会后就可以访问题目了。

![image-20210809195603412](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809195603.png)

在Docker里也可以看到相应的题目容器。

![image-20210809195647525](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809195647.png)



## 问题报错以及踩坑：

### frpc日志报错：

**报错：**

如果日志像下方这样，那么就是网络没有配置好

![](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809192958.png)

**解决方案：**

仔细配置网络，网络配置的要求如下：

- 将ctfd_frpc_1，frp-docker-for-ctfd-whale_frps_1，ctfd_ctfd_1这三个容器加入到ctfd_frp网络中

- 这三个容器对应的IP如下：

  - ctfd_ctfd_1：172.1.0.2

  - ctfd_frpc_1：172.1.0.3

  - frp-docker-for-ctfd-whale_frps_1：172.1.0.4

活用docker的日志功能：

```
docker logs <容器ID或名称>
```

活用docker的网络配置功能：

查看网络

```
docker network ls
```

给容器分配指定IP

```
docker network connect --ip 172.1.0.4 <网络名称> <容器ID或名称>
```



### Dockerfile的gevent报错：

**报错：**

![img](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809185515.png)

![image-20210809185634787](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809185634.png)

**解决方案：**

其他Dockerfile在构建的时候可能会出现gevent构建不成功的问题，有以下几种解决办法：

1. 将镜像源替换为清华源

2. 替换gevent版本

3. 将Dockerfile文件中添加以下内容

   ![image-20210809183837993](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809184950.png)

（这篇文章的搭建方法，已经把坑都踩了，所以前面的教程是没有问题的）



### Dockerfile的world模块报错：

**报错：**

![image-20210725213508507](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809185841.png)



**解决方案：**

将Dockerfile中的python和python-dev删掉，或者修改成python2或python3，python2-dev或python3-dev都可以。



### 构建的时候，ctfd镜像无法启动：

**报错：**

![image-20210809213914063](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809213914.png)

**解决方案：**

将docker-entrypoint.sh第一行修改为：

```
#!/bin/bash
```

![image-20210809214025863](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809214025.png)

修改后，重新build即可



## 虚拟机版本：

### 下载地址：

链接：https://pan.baidu.com/s/11FLyPOKHzpLNBUfuxwJmag 
提取码：flag

链接如果挂了，可以到我的个人博客联系我：https://www.xiinnn.com

### 虚拟机相关信息：

- 虚拟机用户：

  - 用户名：ctf

  - 密码：root

  - 用户名：root

  - 密码：root

- CTFd后台管理员：

  - 用户名：admin

  - 密码：password



### 使用方法：

导入虚拟机后启动

选中ctf用户，输入密码root后登陆

打开终端，切换为root用户，密码为root

```
su root
```

配置自己的网络（这里看自己的情况）

进入CTFd文件夹

```
cd CTFd
```

启动docker

```
docker-compose up -d
```

![image-20210809203500882](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809203500.png)

进入frp-docker-for-ctfd-whale文件夹：

```
cd ../frp-docker-for-ctfd-whale/
```

启动docker

```
docker-compose up -d
```

![image-20210809203521442](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809203521.png)

查看自己的IP：

```
ifconfig
```

![image-20210809203553451](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809203553.png)

一般是ens33或者eth0网卡

访问ip:8000即可

![image-20210809203714349](https://lxxx-markdown.oss-cn-beijing.aliyuncs.com/pictures/20210809203714.png)



## 参考资料：

- [CTFd/CTFd: CTFs as you need them (github.com)](https://github.com/CTFd/CTFd)
- [CTFD支持动态靶机的搭建笔记（docker：ctfd+ctf-whale）2020.10.17 - 灰信网（软件开发博客聚合） (freesion.com)](https://www.freesion.com/article/86941391842/)
- [glzjin/CTFd-Whale: A plugin for CTFd which allow your users to deploy a standalone instance for challenges. (github.com)](https://github.com/glzjin/CTFd-Whale)
- [CTFD支持动态靶机的搭建笔记（docker：ctfd+ctf-whale） | Err0r](https://err0r.top/article/CTFD/)
- [手把手教你如何建立一个支持ctf动态独立靶机的靶场（ctfd+ctfd-whale）_fjh1997的博客-CSDN博客](https://blog.csdn.net/fjh1997/article/details/100850756)
- [ctfd使用ctfd-whale动态靶机插件搭建靶场指南 | VaalaCat](https://vaala.cat/2020/09/21/ctfd使用ctfd-whale动态靶机插件搭建靶场指南/)

