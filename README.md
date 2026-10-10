# Secure Password Manager

A local, offline password manager written in Python with a focus on practical security fundamentals.

> **Status:** Early development. Core vault creation, key derivation, encryption, storage, and unlocking are implemented. Entry management and further security hardening are in progress.

## Goals

This project is being built to develop and demonstrate a practical understanding of:

- Password-based key derivation
- Authenticated encryption
- Secure random number generation
- Encrypted local storage
- Vault lifecycle management
- Security testing
- Threat modeling

V1 is intentionally local and offline. It does not use cloud sync, FastAPI, React, JWT, or a remote database.

## Tech Stack

- Python 3.12
- Argon2id (`argon2-cffi`)
- AES-256-GCM (`cryptography`)
- `secrets`
- JSON/local storage
- pytest

## Architecture

```text
Application
     │
     ▼
  vault.py
     │
 ┌───┼──────────────┐
 ▼   ▼              ▼
KDF Crypto        Storage
 │    │              │
 ▼    ▼              ▼
Argon2 AES-GCM    vault.json
```

## Security Design

### Key Derivation

The master password is converted into a 32-byte encryption key using Argon2id.

Current parameters:

- Algorithm: Argon2id
- Time cost: `3`
- Memory cost: `65536 KiB`
- Parallelism: `4`
- Hash length: `32 bytes`
- Salt: `16 random bytes`

```text
master password + salt
          │
          ▼
       Argon2id
          │
          ▼
     32-byte key
```

### Encryption

Vault contents are encrypted using AES-256-GCM.

- Key: 32 bytes
- Nonce: 12 random bytes
- AAD: currently `None`

AES-GCM provides confidentiality and integrity. An incorrect key or tampered ciphertext causes decryption to fail.

### Randomness

The `secrets` module is used for security-sensitive random values, including:

- Vault salts
- AES-GCM nonces
- Entry IDs

## Vault Format

The encrypted vault is stored locally as JSON:

```json
{
    "version": 1,
    "salt": "BASE64_SALT",
    "nonce": "BASE64_NONCE",
    "ciphertext": "BASE64_CIPHERTEXT"
}
```

The salt and nonce are intentionally stored in the file. They are not secrets.

The actual vault contents are encrypted before being written to disk.

## Data Model

After successful decryption, the vault data currently has this structure:

```python
{
    "entries": [
        {
            "id": "random-id",
            "website": "github.com",
            "username": "...",
            "password": "...",
            "notes": "..."
        }
    ]
}
```

Each entry receives a unique identifier generated with:

```python
secrets.token_hex(16)
```

Entry operations use IDs rather than list indexes.

## Project Structure

```text
secure-password-manager/
│
├── src/
│   └── password_manager/
│       ├── authentication.py
│       ├── cryptography.py
│       ├── key_derivation.py
│       ├── storage.py
│       └── vault.py
│
├── tests/
├── playground.py
├── pyproject.toml
└── README.md
```

### Components

**`key_derivation.py`**

Derives the AES key from the master password and salt using Argon2id.

**`cryptography.py`**

Handles AES-256-GCM encryption and decryption.

**`storage.py`**

Handles reading and writing the local JSON vault file.

**`vault.py`**

Orchestrates vault creation, unlocking, encryption/decryption, vault-file representation, and entry operations.

**`authentication.py`**

Separate authentication functionality exists, but independent password verification is not currently part of the unlock flow. AES-GCM decryption failure handles an incorrect derived key.

## Current Progress

### Implemented

- [x] Argon2id key derivation
- [x] Random salt generation
- [x] AES-256-GCM encryption/decryption
- [x] Random nonce generation
- [x] Base64 encoding/decoding
- [x] JSON vault representation
- [x] Local vault storage
- [x] Vault creation
- [x] Vault unlocking/decryption

### In Progress

- [ ] Add entry
- [ ] Get entry by ID
- [ ] Update entry
- [ ] Delete entry
- [ ] Save/lock lifecycle
- [ ] Atomic file writes
- [ ] Argon2 benchmarking
- [ ] Focused security tests
- [ ] Threat model
- [ ] Security review
- [ ] Password generator

### Future Considerations

- [ ] Vault version handling
- [ ] AAD design
- [ ] Further memory-handling considerations
- [ ] Application/UI layer

## Development

Python 3.12 is required.

Install the project dependencies according to `pyproject.toml`, then run:

```bash
pytest
```

## Security Disclaimer

This is currently an educational and portfolio project and should not yet be considered production-grade password-management software.

Further work is required around threat modeling, key management, secure file handling, atomic writes, error handling, memory handling, dependency security, and broader security review.

## Roadmap

```text
Core primitives
      │
      ▼
Vault creation / unlocking
      │
      ▼
Entry CRUD
      │
      ▼
Save / lock lifecycle
      │
      ▼
Atomic persistence
      │
      ▼
Security-focused testing
      │
      ▼
Threat model + security review
      │
      ▼
Argon2 benchmarking
      │
      ▼
Application / UI layer
```

The project is intentionally scoped as a local/offline password manager rather than immediately expanding into a cloud-backed or web-based application.
