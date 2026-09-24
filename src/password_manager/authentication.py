from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

ph=PasswordHasher()

def create_password_verifier(password:str)-> str:
    hashed_password=ph.hash(password)
    return hashed_password

def verify_password(stored_verifier:str, password:str) -> bool:

    try:
        return ph.verify(stored_verifier, password)

    except VerifyMismatchError:
        return False