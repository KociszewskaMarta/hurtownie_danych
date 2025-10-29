from faker import Faker

from helper_functions import *

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

print('\nTRIP:')
for _ in range(5):
    print({
        'trip_name': generate_trip_name(),
        'description': fake.text(max_nb_chars=200),
        'destination': generate_destination(),
        'tour_type': generate_tour_type(),
        'attractions': generate_attractions(),
        'price': generate_price()
    })