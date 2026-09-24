from password_manager.cryptography import decrypt,encrypt
import secrets
from cryptography.exceptions import InvalidTag
import pytest

def test_encrypt_decrypt():
    key=secrets.token_bytes(32)
    orignal_plaintext="watahhhh".encode()
    ciphertext,nonce=encrypt(key,orignal_plaintext)
    decrypted_plaintext=decrypt(key,ciphertext,nonce)
    
    assert decrypted_plaintext == orignal_plaintext

def test_wrong_key():
    key1=secrets.token_bytes(32)
    orignal_plaintext="watahhhh".encode()
    ciphertext,nonce=encrypt(key1,orignal_plaintext)
    key2=secrets.token_bytes(32)
    with pytest.raises(InvalidTag):
        decrypt(key2,ciphertext,nonce)

def test_modified_ciphertext():
    key1=secrets.token_bytes(32)
    orignal_plaintext="watahhhh".encode()
    ciphertext,nonce=encrypt(key1,orignal_plaintext)
    modified_ciphertext = bytearray(ciphertext)
    modified_ciphertext[0] ^= 1
    modified_ciphertext = bytes(modified_ciphertext)        
    with pytest.raises(InvalidTag):
        decrypt(key1, modified_ciphertext, nonce)

def test_unique_nonce():
    key1=secrets.token_bytes(32)
    orignal_plaintext="watahhhh".encode()
    _,nonce1=encrypt(key1,orignal_plaintext)
    _,nonce2=encrypt(key1,orignal_plaintext)
    assert nonce1 != nonce2