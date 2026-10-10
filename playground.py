import password_manager.vault as pmv

test_password = "test-master-password"

pmv.create_vault(test_password)
session = pmv.unlock_vault(test_password)

print(type(session))
print(session.vault_data)
print(len(session.key))