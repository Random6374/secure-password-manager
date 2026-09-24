from password_manager.key_derivation import derive_key
import secrets

password="its jover"

def test_same_password_and_salt():
    
    salt=secrets.token_bytes(16)
    key1=derive_key(password,salt)
    key2=derive_key(password,salt)

    assert key1 == key2

def test_different_salt():
    
    salt1=secrets.token_bytes(16)
    key1=derive_key(password,salt1)
    salt2=secrets.token_bytes(16)
    key2=derive_key(password,salt2)

    assert key1 != key2

def test_key_length():
    
    salt=secrets.token_bytes(16)
    key=derive_key(password,salt)

    assert len(key) == 32