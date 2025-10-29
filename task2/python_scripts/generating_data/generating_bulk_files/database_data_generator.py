import os

from faker import Faker
from helper_functions import *

fake = Faker('pl_PL')

def _safe(value, delimiter='|'):
    if value is None:
        return ''
    if isinstance(value, (list, tuple, set)):
        value = ','.join(map(str, value))
    return str(value).replace(delimiter, ' ')

def export_objects_to_delimited_file(path, field_names, objects_iterable, delimiter='|', include_header=False, encoding='utf-8'):
    import os
    os.makedirs(os.path.dirname(path), exist_ok=True)
    rows = []
    if include_header:
        rows.append(delimiter.join(field_names))
    for obj in objects_iterable:
        rows.append(delimiter.join(_safe(obj.get(field), delimiter) for field in field_names))
        rows.append('\n')


def generate_worker_obj():
    return {
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone_number': phone_without_spaces_faker(),
        'role': generate_worker_role()
    }

if __name__ == '__main__':
    export_objects_to_delimited_file(
            path='data/workers.bulk',
            field_names=['pesel','first_name','last_name','email','phone_number','role'],
            objects_iterable=(generate_worker_obj() for _ in range(5)),
            include_header=False
        )

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