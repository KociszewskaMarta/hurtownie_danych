import os
from faker import Faker
from helper_functions import *

fake = Faker('pl_PL')

number_of_tour = 60
number_of_tour_editions=1000
number_of_workers=500
number_of_clients=250000
number_of_reservations=700000
number_of_payments=600000

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



def generate_worker_obj(existing_pesels=None):
    """Generate a worker with unique PESEL"""
    if existing_pesels is None:
        existing_pesels = set()
    
    # Keep generating until we get a unique PESEL
    while True:
        pesel = fake.pesel()
        if pesel not in existing_pesels:
            existing_pesels.add(pesel)
            break
    
    return {
        'pesel': pesel,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone_number': phone_without_spaces_faker(),
        'role': generate_worker_role()
    }

def generate_client_obj(existing_pesels=None):
    """Generate a client with unique PESEL"""
    if existing_pesels is None:
        existing_pesels = set()
    
    # Keep generating until we get a unique PESEL
    while True:
        pesel = fake.pesel()
        if pesel not in existing_pesels:
            existing_pesels.add(pesel)
            break
    
    return {
        'pesel': pesel,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone_number': phone_without_spaces_faker(),
    }

def generate_tour_obj(_id):

    # This function is now only used for structure, not for random name selection
    raise NotImplementedError("Use unique trip name logic in main block.")
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
def generate_reservation_obj(_id, tour_editions_count, reservation_date=None):
    """Generate a reservation with optional specific date"""
    if reservation_date is None:
        reservation_date = fake.date_between_dates(date(2000,1,1), date(2025,12,31)).isoformat()
    return {
        'id': _id,
        'reservation_date': reservation_date,
        'status': generate_reservation_status(),
        'tour_edition_id': random.randint(1, tour_editions_count)
    }
def generate_payment_obj(_id):
    return {
        'id': _id,
        'amount': generate_price(),
        'payment_method': generate_payment_form(),
        'payment_date': fake.date_between_dates(date(2000,1,1), date(2025,12,31)).isoformat(),
        'reservation_id': random.randint(1, number_of_reservations)
    }

def generate_unique_reservation_client_objs(_clients_pesels, _number_of_reservations):
    """Generate reservation-client pairs with even distribution across clients"""
    objs = []
    # Evenly distribute reservations across clients using round-robin
    for i in range(_number_of_reservations):
        reservation_id = i + 1
        client_pesel = _clients_pesels[i % len(_clients_pesels)]
        objs.append({'reservation_id': reservation_id, 'client_pesel': client_pesel})
    return objs

def generate_unique_reservation_worker_objs(_workers_pesels, _number_of_reservations):
    """Generate reservation-worker pairs with even distribution across workers"""
    objs = []
    # Evenly distribute reservations across workers using round-robin
    for i in range(_number_of_reservations):
        reservation_id = i + 1
        worker_pesel = _workers_pesels[i % len(_workers_pesels)]
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
        'reservation_date': fake.date_between_dates(date(2026,1,1), date(2026,12,31)).isoformat(),
        'status': generate_reservation_status(),
        'tour_edition_id': random.randint(1, tour_editions_count)
    }

if __name__ == '__main__':
    # Track all generated PESELs to ensure uniqueness
    all_pesels = set()
    
    # Generate workers with unique PESELs
    export_objects_to_delimited_file(
        path='data/workers.bulk',
        field_names=['pesel','first_name','last_name','email','phone_number','role'],
        objects_iterable=(generate_worker_obj(all_pesels) for _ in range(number_of_workers)),
        include_header=False
    )
    workers_pesels = extract_pesels('data/workers.bulk')
    
    # Generate clients with unique PESELs (separate from workers)
    export_objects_to_delimited_file(
        path='data/clients.bulk',
        field_names=['pesel', 'first_name', 'last_name', 'email', 'phone_number'],
        objects_iterable=(generate_client_obj(all_pesels) for _ in range(number_of_clients)),
        include_header=False
    )
    clients_pesels = extract_pesels('data/clients.bulk')

    # Ensure unique trip names for tours
    from helper_functions import generate_trip_name
    trip_names = [
        "Discover the Ancient Ruins",
        "Tropical Paradise Getaway",
        "Cultural Heritage Tour",
        "Mountain Adventure Expedition",
        "City Lights Exploration",
        "Wildlife Safari Experience",
        "Historical Landmarks Journey",
        "Beachside Relaxation Retreat",
        "Gastronomic Delights Tour",
        "Art and Architecture Walk",
        "Scenic Nature Trails",
        "Desert Discovery Expedition",
        "Northern Lights Adventure",
        "Island Hopping Experience",
        "Volcano Explorer Tour",
        "Rainforest Wildlife Safari",
        "Mediterranean Culinary Journey",
        "Historic Castles and Palaces",
        "Lakes and Waterfalls Retreat",
        "Wine Country Exploration",
        "Coastal Road Trip",
        "Mountain Biking Challenge",
        "Winter Wonderland Escape",
        "Sunset Sailing Cruise",
        "Ancient Temples Trail",
        "National Parks Grand Tour",
        "Hot Springs Relaxation",
        "Cultural Capitals Tour",
        "Photography Expedition",
        "Adventure Sports Getaway",
        "Luxury Spa Retreat",
        "Fjord Exploration Journey",
        "Countryside Cycling Tour",
        "Cave and Cavern Adventure",
        "Historic Battlefields Tour",
        "Treetop Canopy Walk",
        "Wildflower Meadow Hike",
        "Cultural Festivals Experience",
        "Architectural Marvels Tour",
        "Seaside Village Exploration",
        "Island Adventure Escape",
        "Cultural Immersion Journey",
        "Historic City Exploration",
        "Nature and Wildlife Expedition",
        "Gourmet Food and Wine Tour",
        "City of Angels Experience",
        "Safari in the Heart of Africa",
        "Ancient Wonders of the World",
        "Tropical Island Escape",
        "Cultural Treasures of Europe",
        "Mountain Majesty Tour",
        "Sun-Kissed Shores Journey",
        "Heritage and History Expedition",
        "Jungle Trekking Adventure",
        "Cultural Capitals of the World",
        "Island Paradise Exploration",
        "Epic Road Trip Across Continents",
        "Underwater Wonders Dive Tour",
        "Cultural Odyssey Experience",
        "Scenic Railway Journey",
    ]
    assert len(trip_names) == number_of_tour, "Trip names count must match number_of_tour!"
    random.shuffle(trip_names)
    def unique_tour_objs():
        for i, trip_name in enumerate(trip_names):
            yield {
                'id': i + 1,
                'trip_name': trip_name,
                'destination': generate_destination(),
                'tour_type': generate_tour_type(),
                'attractions': generate_attractions(),
            }
    export_objects_to_delimited_file(
        path='data/tours.bulk',
        field_names=['id', 'trip_name', 'destination', 'tour_type', 'attractions'],
        objects_iterable=unique_tour_objs(),
        include_header=False
    )
    export_objects_to_delimited_file(
        path='data/tour_editions.bulk',
        field_names=['id', 'start_date', 'end_date', 'price', 'available_seats', 'tour_id'],
        objects_iterable=(generate_tour_edition_obj(k + 1) for k in range(number_of_tour_editions)),
        include_header=False
    )
    # Generate evenly distributed dates for reservations
    from datetime import datetime, timedelta
    start_date = datetime(2000, 1, 1)
    end_date = datetime(2025, 12, 31)
    total_days = (end_date - start_date).days
    
    # Create a list of evenly distributed dates
    date_list = []
    days_per_reservation = total_days / number_of_reservations
    for i in range(number_of_reservations):
        offset_days = int(i * days_per_reservation)
        reservation_date = (start_date + timedelta(days=offset_days)).strftime('%Y-%m-%d')
        date_list.append(reservation_date)
    
    # Shuffle dates to add some randomness while keeping them evenly distributed
    random.shuffle(date_list)
    
    def reservation_with_date(i):
        return generate_reservation_obj(i + 1, number_of_tour_editions, date_list[i])
    
    export_objects_to_delimited_file(
        path='data/reservations.bulk',
        field_names=['id', 'reservation_date', 'status', 'tour_edition_id'],
        objects_iterable=(reservation_with_date(i) for i in range(number_of_reservations)),
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
    # Generate new workers and clients with unique PESELs (continuing from existing set)
    export_objects_to_delimited_file(
        path='data/new_workers.bulk',
        field_names=['pesel','first_name','last_name','email','phone_number','role'],
        objects_iterable=(generate_worker_obj(all_pesels) for _ in range(number_of_new_workers)),
        include_header=False
    )
    new_workers_pesels = extract_pesels('data/new_workers.bulk')
    export_objects_to_delimited_file(
        path='data/new_clients.bulk',
        field_names=['pesel', 'first_name', 'last_name', 'email', 'phone_number'],
        objects_iterable=(generate_client_obj(all_pesels) for _ in range(number_of_new_clients)),
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



