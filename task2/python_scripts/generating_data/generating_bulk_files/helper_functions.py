import random
from datetime import date, timedelta

from faker import Faker

fake = Faker('pl_PL')

def phone_without_spaces_faker():
    return fake.numerify('#########')

def generate_worker_role():
    roles=['Manager', 'Sales Manager', 'Travel Consultant', 'Customer Service Representative', 'Marketing Specialist', 'Finance Officer',
           'HR Coordinator', 'Operations Manager', 'Tour Guide', 'Logistics Coordinator']
    return random.choice(roles)

def generate_trip_name():
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
        "Art and Architecture Walk"
    ]
    return random.choice(trip_names)

def generate_destination():
    destinations = [
        "Rome, Italy",
        "Bali, Indonesia",
        "Kyoto, Japan",
        "Swiss Alps, Switzerland",
        "New York City, USA",
        "Serengeti, Tanzania",
        "Cairo, Egypt",
        "Maldives",
        "Barcelona, Spain",
        "Paris, France"
    ]
    return random.choice(destinations)

def generate_tour_type():
    tour_types = [
        "Relax",
        "Active",
        "Family",
        "City-break"
    ]
    return random.choice(tour_types)

def generate_attractions():
    attractions_list = [
        "Ancient Ruins, Museums, Local Markets",
        "Beaches, Coral Reefs, Tropical Forests",
        "Historical Sites, Cultural Festivals, Local Cuisine",
        "Hiking Trails, Mountain Peaks, Scenic Views",
        "City Landmarks, Nightlife Spots, Shopping Districts",
        "Wildlife Reserves, Safari Drives, Bird Watching",
        "Castles, Monuments, Heritage Sites",
        "Resorts, Spas, Beach Activities",
        "Food Tours, Cooking Classes, Local Restaurants",
        "Art Galleries, Architectural Tours, Street Art"
    ]
    return random.choice(attractions_list)

def generate_start_end_dates(start_year, end_year, min_days=5, max_days=20):
    if start_year > end_year:
        raise ValueError("start_year must be <= end_year")

    duration = random.randint(min_days, max_days)
    earliest_start = date(start_year, 1, 1)
    latest_start = date(end_year, 12, 31) - timedelta(days=duration)

    if latest_start < earliest_start:
        raise ValueError("Year range too small for requested duration")

    start_date = fake.date_between(start_date=earliest_start, end_date=latest_start)
    end_date = start_date + timedelta(days=duration)
    return start_date, end_date

def generate_price(min_price=1500, max_price=10000):
    return round(random.uniform(min_price, max_price), 2)

def generate_available_slots(min_slots=5, max_slots=30):
    return random.randint(min_slots, max_slots)

def generate_payment_form():
    payment_forms = ['Paid', 'Unpaid', 'Processing']
    return random.choice(payment_forms)