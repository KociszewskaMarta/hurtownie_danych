#!/usr/bin/env python3
# Check for duplicate composite keys that would be generated in Rezerwacja_F

print("Analyzing potential composite key duplicates...")
print("This simulates how many reservations would map to the same fact table row\n")

# Read tours
tours = {}
with open('data/tours.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        tour_id = parts[0]
        tour_name = parts[1]
        tours[tour_id] = tour_name

print(f"Tours: {len(tours)}")

# Read clients
clients = set()
with open('data/clients.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        pesel = line.strip().split('|')[0]
        clients.add(pesel)

print(f"Clients: {len(clients)}")

# Sample reservations and count unique composite keys
composite_keys = {}
dates = set()
statuses = set()
tour_editions_to_tours = {}

# Read tour editions to map to tours
with open('data/tour_editions.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        edition_id = parts[0]
        tour_id = parts[5]
        tour_editions_to_tours[edition_id] = tour_id

# Read reservation_clients to map reservations to clients
reservation_to_client = {}
with open('data/reservation_clients.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        res_id = parts[0]
        client_pesel = parts[1]
        reservation_to_client[res_id] = client_pesel

# Process reservations and build composite keys
print("\nProcessing reservations...")
sample_size = 0
with open('data/reservations.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        res_id = parts[0]
        res_date = parts[1]
        status = parts[2]
        tour_edition_id = parts[3]
        
        tour_id = tour_editions_to_tours.get(tour_edition_id, 'UNKNOWN')
        client_pesel = reservation_to_client.get(res_id, 'UNKNOWN')
        
        dates.add(res_date)
        statuses.add(status)
        
        # Composite key: (tour_id, client_pesel, date, campaign_name, junk_status)
        # Note: campaign_name depends on tour_id from marketing data
        # For simplicity, we'll use a placeholder or assume 1 campaign per tour
        composite_key = (tour_id, client_pesel, res_date, 'Paid' if status == 'Paid' else 'Nie')
        
        if composite_key in composite_keys:
            composite_keys[composite_key] += 1
        else:
            composite_keys[composite_key] = 1
        
        sample_size += 1

print(f"\nResults:")
print(f"Total reservations analyzed: {sample_size}")
print(f"Unique dates: {len(dates)}")
print(f"Unique statuses: {len(statuses)}")
print(f"Unique composite key combinations: {len(composite_keys)}")
print(f"Duplicate composite keys: {sample_size - len(composite_keys)}")

# Find most duplicated keys
duplicated = [(key, count) for key, count in composite_keys.items() if count > 1]
duplicated.sort(key=lambda x: x[1], reverse=True)

if duplicated:
    print(f"\nTop 10 most duplicated composite keys:")
    for i, (key, count) in enumerate(duplicated[:10], 1):
        tour_id, client, date, status = key
        tour_name = tours.get(tour_id, 'Unknown')
        print(f"  {i}. Tour: {tour_name}, Client: {client[:6]}..., Date: {date}, Status: {status} - {count} occurrences")
    
    print(f"\n⚠️  WARNING: With {len(duplicated)} duplicate composite keys,")
    print(f"   loading into Rezerwacja_F will fail due to PRIMARY KEY violation!")
else:
    print("\n✓ No duplicate composite keys found")
