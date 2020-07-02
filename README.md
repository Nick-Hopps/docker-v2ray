# 使用Docker一键部署V2ray

## 方案介绍

此次部署使用的是 Vmess + TCP + TLS + Web 的方案，参考[新 V2Ray 白话文指南](https://guide.v2fly.org/advanced/tcp_tls_web.html)中给出的配置，并将该套配置容器化，以便实现一键部署。其中 Vmess + TCP 是 V2ray 的默认配置，在这基础上对流量进行 TLS 加密，并配合一个 Web 页面进行伪装，以便实现速度和安全的平衡。

该方案的工作流程：HAProxy 监听本地 443 端口，对收到的所有流量进行分流，其中 HTTP 流量转发到 Nginx，其他的 TCP 流量转发到 V2ray。

## 部署方法

首先下载配置文件：[docker-v2ray](https://github.com/Nick-Hopps/docker-v2ray)

配置的目录结构如下：

```
├── etc/
│   ├── haproxy/
│   │   └── haproxy.cfg       # haproxy 的配置
│   ├── nginx/
│   │   ├── conf.d/
│   │   │   └── default.conf  # nginx 的配置
│   │   └── nginx.conf
│   └── v2ray/
│       └── config.json       # v2ray 的配置
├── www/                      # 网站根目录
├── .env                      # 环境变量
├── deploy.sh                 # 部署脚本
└── docker-compose.yml        # docker-compose 配置
```

需要把 `.env`，`deploy.sh`，`haproxy.cfg`，`default.conf` 中的 "example.com" 改成自己的域名，`.env` 中的 "test@test.com" 改成自己的邮箱

### 安装 docker-ce 和 docker-compose

1. 安装 docker-ce（以 Ubuntu 为例，其余发行版见官网文档）

```bash
$ curl -fsSL https://get.docker.com -o get-docker.sh

$ sudo sh get-docker.sh
```

2. 安装 docker-compose（linux）

```bash
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

$ sudo chmod +x /usr/local/bin/docker-compose
```

### 运行部署脚本

```bash
$ sudo sh deploy.sh
```
