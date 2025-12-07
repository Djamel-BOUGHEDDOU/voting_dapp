# Decentralized Voting DApp

A simple decentralized voting system built with **Flutter**, **Solidity**, and **Ganache**. Users can view candidates, cast a vote, and see live results — all stored on a local Ethereum blockchain.

## 🛠 Tech Stack
- Flutter (frontend)
- Solidity (smart contract)
- Ganache (local blockchain)
- Web3dart (Flutter–Ethereum interaction)

## 🚀 Setup Instructions

### 1. Install Requirements
- Flutter SDK
- Ganache
- Node.js + Truffle (optional but recommended)

### 2. Start Ganache
- Open Ganache  
- Create a new workspace  
- Copy the RPC URL (e.g., `http://127.0.0.1:7545`)  
- Copy the first account’s private key (used for deployment)

### 3. Deploy the Smart Contract
```bash
truffle init
# Add Voting.sol in contracts/
truffle migrate --reset
