import json
import base64
import secrets

from password_manager.cryptography import encrypt, decrypt
from password_manager.key_derivation import derive_key
from password_manager.storage import save_vault, load_vault

def encrypt_vault(vault_data, key):
    json_data = json.dumps(vault_data)
    plaintext = json_data.encode()

    ciphertext, nonce = encrypt(key, plaintext)

    return ciphertext, nonce

def decrypt_vault(ciphertext, nonce, key):
    plaintext=decrypt(key,ciphertext,nonce).decode()
    vault_data=json.loads(plaintext)
    return vault_data

def encode_bytes(data):
    encoded=(base64.b64encode(data)).decode()
    return encoded

def decode_bytes(data):
    decoded=base64.b64decode(data)
    return decoded


def create_vault_file_data(salt, nonce, ciphertext):
    vault_file={
        "version":1
    }
    vault_file["salt"]=encode_bytes(salt)
    vault_file["nonce"]=encode_bytes(nonce)
    vault_file["ciphertext"]=encode_bytes(ciphertext)
    return vault_file

def parse_vault_data(vault_file):
    salt=decode_bytes(vault_file["salt"])
    nonce=decode_bytes(vault_file["nonce"])
    ciphertext=decode_bytes(vault_file["ciphertext"])
    return salt,nonce,ciphertext

def create_vault(password):
    salt=secrets.token_bytes(16)
    key=derive_key(password,salt)
    
    vault_data = {
        "entries": []
    }
    ciphertext,nonce=encrypt_vault(vault_data,key)
    vault_file=create_vault_file_data(salt,nonce,ciphertext)
    save_vault(vault_file)

def unlock_vault(password):
    vault_file=load_vault()
    salt,nonce,ciphertext=parse_vault_data(vault_file)
    key=derive_key(password,salt)
    plaintext=decrypt_vault(ciphertext,nonce,key)
    return plaintext
