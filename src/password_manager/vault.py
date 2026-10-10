import json
import base64
import secrets

from .cryptography import encrypt, decrypt
from .key_derivation import derive_key
from .storage import save_vault, load_vault

class VaultSession:
    def __init__(self, vault_data, key):
        self.vault_data = vault_data
        self.key = key
                

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
    vault_data=decrypt_vault(ciphertext,nonce,key)
    return VaultSession(vault_data, key)


def add_entry(vault_data, website, username, password, notes):
    entry_id=secrets.token_hex(16)
    
    entry={

    }
    entry["entry_id"]=entry_id
    entry["website"]=website
    entry["username"]=username
    entry["password"]=password
    entry["notes"]=notes
    vault_data["entries"].append(entry)

    return entry

def get_entry(vault_data, entry_id):
    for entries in vault_data["entries"]:
        if entries["entry_id"]==entry_id:
            entry={

            }         
            entry["entry_id"]=entry_id
            entry["website"]=entries["website"]
            entry["username"]=entries["username"]
            entry["password"]=entries["password"]
            entry["notes"]=entries["notes"]

            return entry
    return None

def update_entry(vault_data, entry_id, website=None, username=None,password=None, notes=None):
    for entries in vault_data["entries"]:
        if entries["entry_id"]==entry_id:
            if website!=None:
                entries["website"]=website
            if username!=None:
                entries["username"]=username
            if password!=None:
                entries["password"]=password
            if notes!=None:
                entries["notes"]=notes

            return entries
                
    else:
        return None

def delete_entry(vault_data, entry_id):
    for entries in vault_data["entries"]:
            if entries["entry_id"]==entry_id:
                    vault_data["entries"].remove(entries)
                    return entries
    return None


def save_session(session):
    salt,_,_=parse_vault_data(load_vault())
    ciphertext,nonce=encrypt_vault(session.vault_data,session.key)
    save_vault(create_vault_file_data(salt,nonce,ciphertext))
