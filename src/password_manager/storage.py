from pathlib import Path
import json

path = Path("data/vault.json")


def save_vault(vault_data):
    json_data=json.dumps(vault_data)
    with open (path,"w") as file:
        file.write(json_data)
    
def load_vault():
    with open(path,"r") as file:
        vault_data=json.load(file)
    return vault_data