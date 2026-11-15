# taiko-sn

Docker Compose setup for running a Taiko proposer and prover, built on
[taikoxyz/simple-taiko-node](https://github.com/taikoxyz/simple-taiko-node) (pulled in as a submodule).
Written for the 2024 testnets (the `hekla` branch targets Hekla) and not maintained since November 2024.

## Layout

| Path | What |
|---|---|
| `services/rpc` | L2 node (taiko-geth engine and driver), Prometheus, Grafana, peer save/load scripts |
| `services/proposer` | Proposer |
| `services/prover` | Prover |
| `services/united` | Proposer and prover in one compose project |
| `scripts/` | Host preparation and setup helpers |

## Usage

```sh
./manage.sh ubuntu.prepare   # swap file and kernel settings
./manage.sh proposer.setup
./manage.sh prover.setup
./manage.sh prover.up
```

Each service reads its own `.env`; start from the `.env.example` next to its `compose.yml`.
