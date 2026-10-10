import pytest
from password_manager.vault import unlock_vault,save_vault
from password_manager.exceptions import VaultUnlockError
from password_manager.vault import create_vault, unlock_vault,add_entry,save_session,update_entry,delete_entry

def test_unlock_wrong_password():
    vault_data = {
  "version": 1,
  "salt": "JVMMIBWtICxi/7ByH4Z9Mg==",
  "nonce": "wEjuWQmO1E6d0WR/",
  "ciphertext": "cQHK7qR/CKrPlfz33IAE5qqb9d2Y08QLCT8fELRt5Q=="
}
        
    save_vault(vault_data)
    with pytest.raises(VaultUnlockError):
        unlock_vault("wrong_password")



def test_unlock_correct_password():
    password = "WATAH"
    create_vault(password)

    session = unlock_vault(password)

    assert session.vault_data == {"entries": []}

def test_entry_persists_after_saving():
    password="motherducker"
    create_vault(password)
    session=unlock_vault(password)
    
    add_entry(session.vault_data,"github","random6374","PASSSSS","you bore me ducker")
    save_session(session)
    reopened_session=unlock_vault(password)

    assert reopened_session.vault_data["entries"]==session.vault_data["entries"]

def test_update_entry():
    password="motherducker"
    session=unlock_vault(password)
    entry=add_entry(session.vault_data,"github","random6374","PASSSSS","you bore me ducker")
    print(entry)
    note="we going epic"
    x=update_entry(session.vault_data,entry["entry_id"],notes=note)
    print(x)
    
    save_session(session)
    reopened_session=unlock_vault(password)


    for entries in reopened_session.vault_data["entries"]:
        
        if entry["entry_id"]==entries["entry_id"]:
        
            updated_note=entries["notes"]
        print(entries["entry_id"])
    assert note==updated_note

def test_delete_entry():
    pasword="motherducker"
    session=unlock_vault(pasword)
    entry=add_entry(session.vault_data,"github","random6374","PASSSSS","you bore me ducker")
    id=entry["entry_id"]
    delete_entry(session.vault_data,id)
    save_session(session)
    new_session=unlock_vault(pasword)
    
