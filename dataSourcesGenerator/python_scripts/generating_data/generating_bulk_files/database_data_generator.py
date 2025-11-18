import os
from faker import Faker
from helper_functions import *

fake = Faker('pl_PL')

number_of_tour = 30
number_of_tour_editions=500
number_of_workers=100
number_of_clients=1000
number_of_reservations=1000000
number_of_payments=900000
number_of_new_reservations=5000
number_of_new_clients=1000
number_of_new_workers=10


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

def generate_client_obj():
    return {
        'pesel': fake.pesel(),
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone_number': phone_without_spaces_faker(),
    }

def generate_tour_obj(_id):
    return {
        'id': _id,
        'trip_name': generate_trip_name(),
        'destination': generate_destination(),
        'tour_type': generate_tour_type(),
        'attractions': generate_attractions(),
    }
def generate_tour_edition_obj(_id):
    start_date, end_date = generate_start_end_dates()
    return {
        'id': _id,
        'start_date': start_date,
        'end_date': end_date,
        'price': generate_price(),
        'available_seats': generate_available_slots(),
        'tour_id': random.randint(1, number_of_tour)
    }
def generate_reservation_obj(_id,  tour_editions_count):
    return {
        'id': _id,
        'reservation_date': fake.date_between_dates(date(2015,1,1), date(2025,7,1)).isoformat(),
        'status': generate_reservation_status(),
        'tour_edition_id': random.randint(1, tour_editions_count)
    }
def generate_payment_obj(_id):
    return {
        'id': _id,
        'amount': generate_price(),
        'payment_method': generate_payment_form(),
        'payment_date': fake.date_between_dates(date(2015,1,1), date(2025,7,1)).isoformat(),
        'reservation_id': random.randint(1, number_of_reservations)
    }

def generate_unique_reservation_client_objs(_clients_pesels, _number_of_reservations):
    unique_pairs = set()
    objs = []
    while len(objs) < _number_of_reservations:
        reservation_id = random.randint(1, _number_of_reservations)
        client_pesel = random.choice(_clients_pesels)
        pair = (reservation_id, client_pesel)
        if pair not in unique_pairs:
            unique_pairs.add(pair)
            objs.append({'reservation_id': reservation_id, 'client_pesel': client_pesel})
    return objs

def generate_unique_reservation_worker_objs(_workers_pesels, _number_of_reservations):
    unique_pairs = set()
    objs = []
    while len(objs) < _number_of_reservations:
        reservation_id = random.randint(1, _number_of_reservations)
        worker_pesel = random.choice(_workers_pesels)
        pair = (reservation_id, worker_pesel)
        if pair not in unique_pairs:
            unique_pairs.add(pair)
            objs.append({'reservation_id': reservation_id, 'worker_pesel': worker_pesel})
    return objs

def generate_unique_new_reservation_client_objs(_clients_pesels, _number_of_reservations):
    unique_pairs = set()
    objs = []
    while len(objs) < _number_of_reservations:
        reservation_id = random.randint(number_of_reservations+1, number_of_reservations+_number_of_reservations)
        client_pesel = random.choice(_clients_pesels)
        pair = (reservation_id, client_pesel)
        if pair not in unique_pairs:
            unique_pairs.add(pair)
            objs.append({'reservation_id': reservation_id, 'client_pesel': client_pesel})
    return objs

def generate_unique_new_reservation_worker_objs(_workers_pesels, _number_of_reservations):
    unique_pairs = set()
    objs = []
    while len(objs) < _number_of_reservations:
        reservation_id = random.randint(number_of_reservations+1, number_of_reservations+_number_of_reservations)
        worker_pesel = random.choice(_workers_pesels)
        pair = (reservation_id, worker_pesel)
        if pair not in unique_pairs:
            unique_pairs.add(pair)
            objs.append({'reservation_id': reservation_id, 'worker_pesel': worker_pesel})
    return objs

def generate_new_reservation_obj(_id,  tour_editions_count):
    return {
        'id': _id,
        'reservation_date': fake.date_between_dates(date(2025,7,2), date(2025,10,28)).isoformat(),
        'status': generate_reservation_status(),
        'tour_edition_id': random.randint(1, tour_editions_count)
    }

if __name__ == '__main__':
    export_objects_to_delimited_file(
        path='data/workers.bulk',
        field_names=['pesel','first_name','last_name','email','phone_number','role'],
        objects_iterable=(generate_worker_obj() for _ in range(number_of_workers)),
        include_header=False
    )
    workers_pesels = extract_pesels('data/workers.bulk')
    export_objects_to_delimited_file(
        path='data/clients.bulk',
        field_names=['pesel', 'first_name', 'last_name', 'email', 'phone_number'],
        objects_iterable=(generate_client_obj() for _ in range(number_of_clients)),
        include_header=False
    )
    clients_pesels = extract_pesels('data/clients.bulk')
    export_objects_to_delimited_file(
        path='data/tours.bulk',
        field_names=['id', 'trip_name', 'destination', 'tour_type', 'attractions'],
        objects_iterable=(generate_tour_obj(l + 1) for l in range(number_of_tour)),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/tour_editions.bulk',
        field_names=['id', 'start_date', 'end_date', 'price', 'available_seats', 'tour_id'],
        objects_iterable=(generate_tour_edition_obj(k + 1) for k in range(number_of_tour_editions)),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/reservations.bulk',
        field_names=['id', 'reservation_date', 'status', 'tour_edition_id'],
        objects_iterable=(generate_reservation_obj(i + 1, number_of_tour_editions) for i in range(number_of_reservations)),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/payments.bulk',
        field_names=['id', 'amount', 'payment_method', 'payment_date', 'reservation_id'],
        objects_iterable=(generate_payment_obj(i + 1) for i in range(number_of_payments)),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/reservation_clients.bulk',
        field_names=['reservation_id', 'client_pesel'],
        objects_iterable=generate_unique_reservation_client_objs(clients_pesels, number_of_reservations),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/reservation_workers.bulk',
        field_names=['reservation_id', 'worker_pesel'],
        objects_iterable=generate_unique_reservation_worker_objs(workers_pesels, number_of_reservations),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/new_reservations.bulk',
        field_names=['id', 'reservation_date', 'status', 'tour_edition_id'],
        objects_iterable=(generate_new_reservation_obj(i+number_of_reservations + 1, number_of_tour_editions) for i in range(number_of_new_reservations)),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/new_workers.bulk',
        field_names=['pesel','first_name','last_name','email','phone_number','role'],
        objects_iterable=(generate_worker_obj() for _ in range(number_of_new_workers)),
        include_header=False
    )
    new_workers_pesels = extract_pesels('data/new_workers.bulk')
    export_objects_to_delimited_file(
        path='data/new_clients.bulk',
        field_names=['pesel', 'first_name', 'last_name', 'email', 'phone_number'],
        objects_iterable=(generate_client_obj() for _ in range(number_of_new_clients)),
        include_header=False
    )
    new_clients_pesels = extract_pesels('data/new_clients.bulk')
    export_objects_to_delimited_file(
        path='data/new_reservation_clients.bulk',
        field_names=['reservation_id', 'client_pesel'],
        objects_iterable=generate_unique_new_reservation_client_objs(new_clients_pesels, number_of_new_reservations),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/new_reservation_workers.bulk',
        field_names=['reservation_id', 'worker_pesel'],
        objects_iterable=generate_unique_new_reservation_worker_objs(new_workers_pesels, number_of_new_reservations),
        include_header=False
    )



