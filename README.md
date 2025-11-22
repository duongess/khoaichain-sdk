# KhoaiChain SDK

Lightweight Go SDK for building smart contracts on Khoai Chain. The chain runtime and node logic live in the main repository; this repo focuses on the embeddable contract primitives customers extend.

## Requirements
- Go 1.22+
- Node.js + npm (used to fetch the packaged node builder executable from the main repo)

## Getting Started
1) Install the packaged node builder (downloads the `.exe` built from the main repo). Use your published package name once available:
```bash
npm install --global khoai-chain-builder
```

2) Create a node config under `configs/`. Example `configs/node_contractor.yaml`:
```yaml
node_name: "TongThau_Coteccons"
host: "127.0.0.1"
port: "9001"

db_path: "./data/db_contractor"

peers:
  - "127.0.0.1:9000" # Connect to Owner
  - "127.0.0.1:9002" # Connect to Supplier
```

3) Generate build artifacts from the config (command name can be updated later):
```bash
npm run khoai -- --input configs/node_contractor.yaml
```

4) Author contracts in `contract/`. Embed `BaseContract`, set a name, wire a `StateContext`, then call `Save`/`Get` to persist data.

## Data Flow
Khoai Chain keeps business data localized: contracts supply logic, and synchronization happens only across a customer's internal peers. For scenarios such as multi-supplier material procurement, each supplier and buyer node shares data solely within that private peer group.

## Repository Layout
- `contract/`: Contract helpers (`BaseContract`, `StateContext`, `SmartContract`).
- `configs/`: Place node configuration files used by the builder CLI.
- `README.md`: This guide for integrators and customers.
