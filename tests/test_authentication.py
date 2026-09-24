from password_manager.authentication import create_password_verifier, verify_password

def test_correct_password():
    verifier = create_password_verifier("hello123")

    assert verify_password(verifier, "hello123") is True