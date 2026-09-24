from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import secrets

def encrypt(key: bytes, plaintext: bytes) -> tuple[bytes, bytes]:
    nonce=secrets.token_bytes(12)
    aes=AESGCM(key)
    ciphertext=aes.encrypt(nonce,plaintext,None)
    return ciphertext,nonce

def decrypt(key: bytes, ciphertext: bytes, nonce: bytes) -> bytes:
    aes=AESGCM(key)
    plaintext=aes.decrypt(nonce,ciphertext,None)
    return plaintext
