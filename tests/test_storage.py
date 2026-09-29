from password_manager.storage import load_vault,save_vault
import pytest
import json






def test_vault():
    
    vault_data = {
    "version": 1,
    "salt": "test-salt",
    "nonce": "test-nonce",
    "ciphertext": "test-ciphertext"
}
    
    save_vault(vault_data)
    loaded=load_vault()
    assert vault_data == loaded


def test_malformed_vault():
    
    with open("data/vault.json", "w") as file:
        file.write("this is not valid json")

    with pytest.raises(json.JSONDecodeError):
        load_vault()                                                                                                                                