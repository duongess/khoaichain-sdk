# KhoaiChain SDK

A comprehensive toolkit for building, deploying, and managing Khoai Chain nodes and smart contracts. This SDK simplifies the process of generating node artifacts, building executables, and running local development environments.

## 🚀 Installation

You can install the `khoai` CLI tool directly into your system using the following command. This will automatically detect your OS (Linux, macOS, or Windows Git Bash) and install the appropriate binary.

```bash
curl -fsSL https://raw.githubusercontent.com/duongess/khoaichain-sdk/main/install.sh | bash
````

After installation, verify it by running:

```bash
khoai version
```

-----

## 🛠 Configuration

To create a new node, you first need a configuration file (typically named `khoai-config.yaml`). This file defines your node's identity, network settings, and peer connections.

**Example `khoai-config.yaml`:**

```yaml
# --- Global Network Settings ---
network_name: "My_Private_Blockchain" # Name of the Docker network
domain: "khoai.local"                 # Internal domain for DNS resolution

# --- Docker Image Settings ---
image_base: "golang:1.22-alpine"      # Base image for the builder stage
image_tag: "v1.0.0"                   # Tag for the generated images
registry: "my.registry.com/khoai"     # (Optional) Container registry prefix

# --- Node Definitions ---
nodes:
  # 1. The Genesis Node (Owner/Root)
  - name: "node_owner"
    port: 9000
    db_path: "/data/owner_db"
    peers: [] # The first node usually has no initial peers
    chaincodes:
      - name: "token_contract"

  # 2. A Member Node (e.g., Supplier)
  - name: "node_supplier"
    port: 9001
    db_path: "/data/supplier_db"
    peers:
      - "node_owner:9000" # Connects to the Owner
    chaincodes:
      - name: "supply_chain_contract"

  # 3. Another Member Node (e.g., Logistics)
  - name: "node_logistics"
    port: 9002
    db_path: "/data/logistics_db"
    peers:
      - "node_supplier:9001" # Connects to the Supplier
    chaincodes: []

```

-----

## 💻 CLI Usage

The `khoai` tool provides two main commands to manage your node lifecycle: `gen` and `build`.

### 1\. Generate Artifacts (`gen`)

This command parses your configuration file and generates all necessary build artifacts (Dockerfiles, entry scripts, source code scaffolding).

```bash
khoai gen
```

**Output:** A `build/` directory containing your node's specific build environment.

### 2\. Build Binary (`build`)

This command compiles the source code into an executable binary (`.exe` on Windows or a standard binary on Unix).

```bash
# Build the node in the current directory or a specific build folder
khoai build ./build/my-node
```

-----

## ⚙️ Running the Node

You can run your Khoai Node in two different modes: **Development** (for local testing) and **Production** (Docker).

### Option A: Development Mode (`dev`)

Use this mode when you are coding or debugging on your local machine.

  - **Feature:** It automatically overrides the `db_path` config to store data in a local folder next to the executable (e.g., `build/node_coteccons/data`).
  - **Feature:** It automatically redirects peer connections (like `node_vingroup:9000`) to `localhost:9000`.

<!-- end list -->

```bash
# Run the built binary with the 'dev' command
./build/node_coteccons/khoai-node dev
```

### Option B: Docker / Production (`run`)

This mode respects the absolute paths in your config and is optimized for containerized environments.

1.  **Generate Docker artifacts:**
    Ensure you have run `khoai gen` first.

2.  **Build & Run with Docker Compose:**
    The `gen` command creates a `docker-compose.yaml` file for you (usually in `build/` or the build folder).

<!-- end list -->

```bash
# Build the node image
docker compose -f build/docker-compose.yaml build

# Start the network
docker compose -f build/docker-compose.yaml up -d
```

-----

## 📝 Smart Contract Development

Contracts are written in Go and live in the `contract/` directory.
1.  Import base contract from `github.com/duongess/khoaichain-sdk/contract`
1.  Create a new struct embedding `contract.BaseContract`.
2.  Implement your logic.
3.  Use `Save()` and `Get()` to persist state.

**Example:**

```go
type MyContract struct {
    contract.BaseContract
}

func (c *MyContract) DoSomething(args [][]byte) error {
    key := args[0]
    value := args[1]
    return c.Save(key, value)
}
```

## 📜 License

This project is licensed under the [MIT License](https://github.com/duongess/khoaichain-sdk/blob/main/LICENSE).
