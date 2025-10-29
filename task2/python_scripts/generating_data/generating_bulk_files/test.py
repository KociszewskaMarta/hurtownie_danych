from datetime import date, timedelta, datetime
import random
from faker import Faker

fake = Faker('pl_PL')  

def generate_realistic_pesel():
    # Zakres wiekowy: od 18 do 90 lat
    today = datetime.now()
    min_age = 18
    max_age = 90
    
    # Obliczanie dat granicznych
    min_birth_date = today - timedelta(days=max_age * 365.25)
    max_birth_date = today - timedelta(days=min_age * 365.25)
    
    # Generowanie losowej daty urodzenia w zakresie
    days_between = (max_birth_date - min_birth_date).days
    random_days = random.randint(0, days_between)
    birth_date = min_birth_date + timedelta(days=random_days)
    
    # Generowanie PESEL
    pesel = fake.pesel(date_of_birth=birth_date)
    return pesel

for _ in range(5):
    print({
        'pesel': generate_realistic_pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone': fake.phone_number(),
    })
