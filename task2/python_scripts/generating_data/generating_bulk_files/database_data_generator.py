import os
from faker import Faker
from helper_functions import *

fake = Faker('pl_PL')

number_of_trips = 10
number_of_trip_editions=500
number_of_workers=100
number_of_customers=2000
number_of_reservations=1000000
number_of_payments=number_of_trip_editions*number_of_workers*number_of_customers*number_of_reservations*0.9


def _safe(value, delimiter='|'):
    if value is None:
        return ''
    if isinstance(value, (list, tuple, set)):
        value = ','.join(map(str, value))
    return str(value).replace(delimiter, ' ')


def export_objects_to_delimited_file(path, field_names, objects_iterable, delimiter='|', include_header=False,
                                     encoding='utf-8'):
    import os
    os.makedirs(os.path.dirname(path), exist_ok=True)
    rows = []
    if include_header:
        rows.append(delimiter.join(field_names))

    objects_list = list(objects_iterable)
    for obj in objects_list:
        rows.append(delimiter.join(_safe(obj.get(field), delimiter) for field in field_names))

    # Łączymy wiersze z podwójnym \r\n i dodajemy \r\n na końcu
    content = '\r\n'.join(rows)
    content += '\r\n'  # Dodaj zakończenie na końcu pliku

    with open(path, 'wb') as f:
        f.write(content.encode(encoding))

def generate_worker_obj():
    return {
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone_number': phone_without_spaces_faker(),
        'role': generate_worker_role()
    }

def generate_customer_obj():
    return {
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'phone': phone_without_spaces_faker(),
        'email': fake.email(),
    }

def generate_trip_obj():
    return {
        'trip_name': generate_trip_name(),
        'description': fake.text(max_nb_chars=200),
        'destination': generate_destination(),
        'tour_type': generate_tour_type(),
        'attractions': generate_attractions(),
        'price': generate_price()
    }

def generate_tour_edition_obj():
    start_date, end_date = generate_start_end_dates()
    return {
        'start_date': start_date,
        'end_date': end_date,
        'price': generate_price(),
        'available_seats': generate_available_slots()
    }

def generate_payment_obj():
    return {
        'amount': generate_price(),
        'payment_method': generate_payment_form(),
        'payment_date': fake.date_between_dates(date(2015,1,1), date(2025,12,31)).isoformat(),
    }

def generate_reservation_obj():
    return {
        'reservation_date': fake.date_between_dates(date(2015,1,1), date(2025,12,31)).isoformat(),
        'status': generate_reservation_status(),
    }

if __name__ == '__main__':
    export_objects_to_delimited_file(
            path='data/workers.bulk',
            field_names=['pesel','first_name','last_name','email','phone_number','role'],
            objects_iterable=(generate_worker_obj() for _ in range(10)),
            include_header=False
        )

    export_objects_to_delimited_file(
            path='task2\python_scripts\generating_data\generating_bulk_files\data\customers.bulk',
            field_names=['pesel','first_name','last_name','phone','email'],
            objects_iterable=(generate_customer_obj() for _ in range(5)),
            include_header=False
        )

    export_objects_to_delimited_file(
        path='task2\python_scripts\generating_data\generating_bulk_files\data\\trips.bulk',
        field_names=['trip_name','description','destination','tour_type','attractions','price'],
        objects_iterable=(generate_trip_obj() for _ in range(5)),
        include_header=False
    )

    export_objects_to_delimited_file(
        path='task2\python_scripts\generating_data\generating_bulk_files\data\\tour_editions.bulk',
        field_names=['start_date','end_date','price','available_seats'],
        objects_iterable=(generate_tour_edition_obj() for _ in range(5)),
        include_header=False
    )

    export_objects_to_delimited_file(
        path='task2\python_scripts\generating_data\generating_bulk_files\data\payments.bulk',
        field_names=['amount','payment_method','payment_date'],
        objects_iterable=(generate_payment_obj() for _ in range(5)),
        include_header=False
    )

    export_objects_to_delimited_file(
        path='task2\python_scripts\generating_data\generating_bulk_files\data\\reservations.bulk',
        field_names=['reservation_date','status'],
        objects_iterable=(generate_reservation_obj() for _ in range(5)),
        include_header=False
    ) 