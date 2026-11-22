# Ports

Generated from the Core0 1.5.3 installer for its reference layouts. Do not edit by hand.

On every node, whatever its role:

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 22 | SSH | 10.60.0.21, 10.60.0.22 (operator slots), over WireGuard only |
| tcp | 7777 | Core0 agent | 10.60.0.21, 10.60.0.22 (operator slots), over WireGuard only |
| udp | 51820 | WireGuard | any |
| icmp | echo-request | ping | the mesh, 10.60.0.0/24 |

Anything else that reaches a node over WireGuard is logged with the prefix `obsydia-wg0-drop` and dropped. Anything else on other interfaces is dropped.

## Starter

| Node | Mesh address | Roles |
|---|---|---|
| node01 | 10.60.0.4 | KD+PL |
| node02 | 10.60.0.8 | KL+PD |
| node03 | 10.60.0.12 | BRG+WIT |

### node01 KD+PL, 10.60.0.4

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7401 | keys-data mTLS | 10.60.0.4 (node01 KD+PL), 10.60.0.8 (node02 KL+PD) |
| tcp | 7402 | keys-data certificate issuance | 10.60.0.4 (node01 KD+PL), 10.60.0.8 (node02 KL+PD), 10.60.0.12 (node03 BRG+WIT) |
| tcp | 7500 | pii-logic | 10.60.0.12 (node03 BRG+WIT) |
| tcp | 9104 | pii-logic metrics | 10.60.0.12 (node03 BRG+WIT) |
| tcp | 9101 | keys-data metrics and KEK | 10.60.0.12 (node03 BRG+WIT) |

### node02 KL+PD, 10.60.0.8

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7400 | keys-logic | 10.60.0.4 (node01 KD+PL), 10.60.0.8 (node02 KL+PD) |
| tcp | 7501 | pii-data | 10.60.0.4 (node01 KD+PL), 10.60.0.8 (node02 KL+PD) |
| tcp | 9103 | keys-logic metrics | 10.60.0.12 (node03 BRG+WIT) |
| tcp | 9102 | pii-data metrics | 10.60.0.12 (node03 BRG+WIT) |

### node03 BRG+WIT, 10.60.0.12

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 8080 | bridge API | 10.60.0.21 (operator slot), 10.60.0.22 (operator slot) |
| tcp | 7600 | audit collector | 10.60.0.4 (node01 KD+PL), 10.60.0.8 (node02 KL+PD) |
| tcp | 9090 | prometheus API | 10.60.0.12 (node03 BRG+WIT) |
| tcp | 9105 | bridge metrics | 10.60.0.12 (node03 BRG+WIT) |

## Pro

| Node | Mesh address | Roles |
|---|---|---|
| node01 | 10.60.0.4 | KD |
| node02 | 10.60.0.2 | KL |
| node03 | 10.60.0.8 | PD |
| node04 | 10.60.0.6 | PL |
| node05 | 10.60.0.12 | BRG |
| node06 | 10.60.0.10 | WIT |

### node01 KD, 10.60.0.4

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7401 | keys-data mTLS | 10.60.0.2 (node02 KL), 10.60.0.4 (node01 KD), 10.60.0.6 (node04 PL), 10.60.0.8 (node03 PD) |
| tcp | 7402 | keys-data certificate issuance | 10.60.0.2 (node02 KL), 10.60.0.4 (node01 KD), 10.60.0.6 (node04 PL), 10.60.0.8 (node03 PD), 10.60.0.10 (node06 WIT), 10.60.0.12 (node05 BRG) |
| tcp | 9101 | keys-data metrics and KEK | 10.60.0.10 (node06 WIT) |

### node02 KL, 10.60.0.2

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7400 | keys-logic | 10.60.0.6 (node04 PL), 10.60.0.8 (node03 PD) |
| tcp | 9103 | keys-logic metrics | 10.60.0.10 (node06 WIT) |

### node03 PD, 10.60.0.8

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7501 | pii-data | 10.60.0.6 (node04 PL), 10.60.0.8 (node03 PD) |
| tcp | 9102 | pii-data metrics | 10.60.0.10 (node06 WIT) |

### node04 PL, 10.60.0.6

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7500 | pii-logic | 10.60.0.12 (node05 BRG) |
| tcp | 9104 | pii-logic metrics | 10.60.0.10 (node06 WIT) |

### node05 BRG, 10.60.0.12

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 8080 | bridge API | 10.60.0.21 (operator slot), 10.60.0.22 (operator slot) |
| tcp | 9105 | bridge metrics | 10.60.0.10 (node06 WIT) |

### node06 WIT, 10.60.0.10

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7600 | audit collector | 10.60.0.2 (node02 KL), 10.60.0.4 (node01 KD), 10.60.0.6 (node04 PL), 10.60.0.8 (node03 PD) |
| tcp | 9090 | prometheus API | 10.60.0.12 (node05 BRG) |

## Enterprise

| Node | Mesh address | Roles |
|---|---|---|
| node01 | 10.60.0.2 | KL |
| node02 | 10.60.0.3 | KL |
| node03 | 10.60.0.4 | KD |
| node04 | 10.60.0.5 | KD |
| node05 | 10.60.0.6 | PL |
| node06 | 10.60.0.7 | PL |
| node07 | 10.60.0.8 | PD |
| node08 | 10.60.0.9 | PD |
| node09 | 10.60.0.12 | BRG |
| node10 | 10.60.0.10 | WIT |

### node01 KL, 10.60.0.2

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7400 | keys-logic | 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 9103 | keys-logic metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |

### node02 KL, 10.60.0.3

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7400 | keys-logic | 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 9103 | keys-logic metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |

### node03 KD, 10.60.0.4

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7401 | keys-data mTLS | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 7402 | keys-data certificate issuance | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 9101 | keys-data metrics and KEK | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8300 | consul server RPC | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
| udp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |

### node04 KD, 10.60.0.5

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7401 | keys-data mTLS | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 7402 | keys-data certificate issuance | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 9101 | keys-data metrics and KEK | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8300 | consul server RPC | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
| udp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |

### node05 PL, 10.60.0.6

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7500 | pii-logic | 10.60.0.12 (node09 BRG) |
| tcp | 9104 | pii-logic metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |

### node06 PL, 10.60.0.7

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7500 | pii-logic | 10.60.0.12 (node09 BRG) |
| tcp | 9104 | pii-logic metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |

### node07 PD, 10.60.0.8

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7501 | pii-data | 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 9102 | pii-data metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8300 | consul server RPC | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
| udp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |

### node08 PD, 10.60.0.9

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7501 | pii-data | 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 9102 | pii-data metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8300 | consul server RPC | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
| udp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |

### node09 BRG, 10.60.0.12

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 8080 | bridge API | 10.60.0.21 (operator slot), 10.60.0.22 (operator slot) |
| tcp | 9105 | bridge metrics | 10.60.0.10 (node10 WIT) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |

### node10 WIT, 10.60.0.10

| Protocol | Port | Service | Allowed from |
|---|---|---|---|
| tcp | 7600 | audit collector | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD) |
| tcp | 9090 | prometheus API | 10.60.0.12 (node09 BRG) |
| tcp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| udp | 8301 | consul gossip | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8300 | consul server RPC | 10.60.0.2 (node01 KL), 10.60.0.3 (node02 KL), 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.6 (node05 PL), 10.60.0.7 (node06 PL), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT), 10.60.0.12 (node09 BRG) |
| tcp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
| udp | 8302 | consul server gossip | 10.60.0.4 (node03 KD), 10.60.0.5 (node04 KD), 10.60.0.8 (node07 PD), 10.60.0.9 (node08 PD), 10.60.0.10 (node10 WIT) |
