uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lowercase = "abcdefghijklmnopqrstuvwxyz"
digits = "0123456789"
symbols = "@#$"

import secrets

def generate_password(length=20):
    if length<6:
        raise ValueError ("length must be grater than OR EQUAL TO 6")
    generated_password=[]
    generated_password.append(secrets.choice(uppercase))
    generated_password.append(secrets.choice(lowercase))
    generated_password.append(secrets.choice(digits))
    generated_password.append(secrets.choice(symbols))

    for i in range(0,length-4):
        
        mini_list=[]
        mini_list.append(secrets.choice(uppercase))
        mini_list.append(secrets.choice(lowercase))
        mini_list.append(secrets.choice(digits))
        mini_list.append(secrets.choice(symbols))
        generated_password.append(secrets.choice(mini_list))
    secrets.SystemRandom().shuffle(generated_password)
    return "".join(generated_password)        