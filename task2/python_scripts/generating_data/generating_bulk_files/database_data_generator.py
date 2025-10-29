from faker import Faker
from helper_functions import phone_without_spaces_faker, generate_worker_role

fake = Faker('pl_PL')

print('WORKERS DATA:')
for _ in range(5):
    print({
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'phone': phone_without_spaces_faker(),
        'email': fake.email(),
        'role': generate_worker_role()
    })

print('\nCUSTOMERS DATA:')
for _ in range(5):
    print({
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'phone': phone_without_spaces_faker(),
        'email': fake.email(),
    })
