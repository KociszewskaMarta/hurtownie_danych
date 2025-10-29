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

print('\nTOUREDITION:')
for _ in range(5):
    start_date, end_date = generate_start_end_dates()
    print({
        'start_date': start_date,
        'end_date': end_date,
        'price': generate_price(),
        'available_seats': generate_available_slots()
    })

print('\nPAYMENT:')
for _ in range(5):
    print({
        'amount': generate_price(),
        'payment_method': generate_payment_form(),
        'payment_date': fake.date_between_dates(date(2015,1,1), date(2025,12,31)).isoformat(),
    })

print('\nRESERVATION:')
for _ in range(5):
    print({
        'reservation_date': fake.date_between_dates(date(2015,1,1), date(2025,12,31)).isoformat(),
        'status': generate_reservation_status(),
    })