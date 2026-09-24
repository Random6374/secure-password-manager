from argon2.low_level import hash_secret_raw, Type

def derive_key(password:str,salt:bytes)->bytes:
    key=hash_secret_raw(password.encode(),salt,3,65536,4,32,Type.ID)
    return key