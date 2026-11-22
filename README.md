# core0-install

The scripts that install Core0 and the firewall rules Core0 puts on every node. They are published here so you can read what will run on your machines before you run it.

## Install scripts

| File | Served at | Installs |
|---|---|---|
| `install.sh` | https://obsydia.tech/install.sh | Core0 connector for Starter, Pro and Enterprise |
| `install-ce.sh` | https://obsydia.tech/install-ce.sh | Core0 Community Edition on one Ubuntu 22.04 or 24.04 host |

At each tag, the files in this repository are byte-identical to the copies served at those addresses. To check a download against them:

```sh
curl -fsSLO https://obsydia.tech/install.sh
sha256sum install.sh
```

`install.sh` reads the published connector version and its SHA-256 from `https://updates.obsydia.tech/versions.json`, downloads that connector, and stops without installing anything if the checksum does not match. It then installs `/usr/local/bin/obsydia-connector` with a systemd unit and prints the address of the installation wizard and a one-time installer access code. Apart from that it changes nothing on the machine.

The cluster nodes are prepared later by the connector, from the wizard. The connector connects to each node once over SSH with the password you enter, installs its own per-install SSH key, pins the node's host key, and starts the Core0 agent. From then on it talks only to the agent.

`install-ce.sh` does the same for Community Edition, using `https://updates.obsydia.tech/public/connector-ce/latest.json`. Run again on a configured host, it updates the connector and keeps the configuration and data. Community Edition runs on one host and does not change its firewall.

The connector binaries are verified by SHA-256 only. Signed binaries will follow.

## Node firewall

The Core0 agent manages the node firewall with nftables. The firewall has two states.

**Bootstrap** (`nftables/bootstrap.nft`). Loaded during System Prep. SSH (tcp 22) and the agent (tcp 7777) answer only the address of the connector, `192.0.2.10` in the example. WireGuard (udp 51820) is open, and traffic arriving over WireGuard is accepted until the mesh rules replace these. Everything else is dropped.

**Mesh** (`nftables/<tier>/<node>.nft`). Loaded in the Nftables phase, once the WireGuard mesh is up and the connector has reached every agent over it:

- SSH and the agent answer only the two operator slots, `10.60.0.21` and `10.60.0.22`, over WireGuard. They are closed on every other interface.
- Over WireGuard, a node accepts only the ports its roles need, from the nodes that need them. Everything else arriving over WireGuard is logged with the prefix `obsydia-wg0-drop` and dropped.
- The new rules are loaded with a 60-second rollback. The node goes back to its previous rules unless the connector confirms over the mesh that it can still reach the node.
- Until the installation is sealed at Handoff, the closure is provisional. A node that hears nothing from the connector for 10 minutes goes back to the bootstrap rules, so an interrupted installation cannot leave nodes that nobody can reach. At Handoff the connector seals every node and removes its installation SSH key.

The files are produced by the same connector and agent code that runs during an installation, from the commits of the tagged Core0 release, for the reference layout of each tier. Every file is checked with `nft -c`. The reference layouts use the documentation range `192.0.2.0/24` for LAN addresses. Mesh addresses are assigned by the installer by role, so they are the same in a real installation.

The File Storage add-on is not covered by these rules yet.

[PORTS.md](PORTS.md) lists every open port by tier, node and role.

## Versions

Tags follow Core0 releases. Tag `v1.5.3` is Core0 1.5.3.

## Security

To report a vulnerability, follow the [security policy](https://github.com/obsydia-tech/.github/blob/main/SECURITY.md).

## Licence

Apache License 2.0. See [LICENSE](LICENSE).
