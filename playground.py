from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import secrets
nonce=secrets.token_bytes(12)
key=secrets.token_bytes(32)
print(key)
aes=AESGCM(key)
data="hello".encode()
cipher=aes.encrypt(nonce,data,None)
plain=aes.decrypt(nonce,cipher,None)
plaintext=plain.decode()
print(plaintext)