#!/usr/bin/env python3
# Find and identify duplicate reservations to remove

# Find the tour ID for 'National Parks Grand Tour'
tours = {}
with open('data/tours.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        tour_id = parts[0]
        tour_name = parts[1]
        if 'National Parks Grand Tour' in tour_name:
            print(f'Tour ID: {tour_id}, Name: {tour_name}')
            tours[tour_id] = tour_name

# Map tour editions to tours
tour_editions_to_tours = {}
with open('data/tour_editions.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        edition_id = parts[0]
        tour_id = parts[5]
        tour_editions_to_tours[edition_id] = tour_id

# Map reservations to clients
reservation_to_client = {}
with open('data/reservation_clients.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        res_id = parts[0]
        client_pesel = parts[1]
        reservation_to_client[res_id] = client_pesel

# Find reservations with date 2018-12-26 for the target tour
print('\nSearching for duplicate reservations...')
matching_reservations = []
client_pesel_partial = '330305'

with open('data/reservations.bulk', 'r', encoding='utf-8') as f:
    for line in f:
        parts = line.strip().split('|')
        res_id = parts[0]
        res_date = parts[1]
        status = parts[2]
        tour_edition_id = parts[3]
        
        tour_id = tour_editions_to_tours.get(tour_edition_id)
        client_pesel = reservation_to_client.get(res_id)
        
        if (res_date == '2018-12-26' and 
            tour_id in tours and 
            client_pesel and client_pesel.startswith(client_pesel_partial) and
            status in ['Unpaid', 'Nie']):  # Checking for "Nie" status
            
            matching_reservations.append({
                'res_id': res_id,
                'client_pesel': client_pesel,
                'status': status,
                'tour_edition_id': tour_edition_id,
                'line': line.strip()
            })

print(f'\nFound {len(matching_reservations)} matching reservations:')
for i, res in enumerate(matching_reservations, 1):
    print(f'{i}. Reservation ID: {res["res_id"]}, Client: {res["client_pesel"]}, Status: {res["status"]}')

if len(matching_reservations) >= 2:
    print(f'\n✓ Will remove reservation ID: {matching_reservations[0]["res_id"]}')
    print(f'  Keeping reservation ID: {matching_reservations[1]["res_id"]}')
    
    # Store the ID to remove
    res_to_remove = matching_reservations[0]['res_id']
    
    # Remove from reservations.bulk
    print('\nRemoving from reservations.bulk...')
    lines = []
    removed = False
    with open('data/reservations.bulk', 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().split('|')[0] == res_to_remove:
                removed = True
                continue
            lines.append(line)
    
    with open('data/reservations.bulk', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f'✓ Removed from reservations.bulk: {removed}')
    
    # Remove from reservation_clients.bulk
    print('Removing from reservation_clients.bulk...')
    lines = []
    removed = False
    with open('data/reservation_clients.bulk', 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().split('|')[0] == res_to_remove:
                removed = True
                continue
            lines.append(line)
    
    with open('data/reservation_clients.bulk', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f'✓ Removed from reservation_clients.bulk: {removed}')
    
    # Remove from reservation_workers.bulk
    print('Removing from reservation_workers.bulk...')
    lines = []
    removed = False
    with open('data/reservation_workers.bulk', 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().split('|')[0] == res_to_remove:
                removed = True
                continue
            lines.append(line)
    
    with open('data/reservation_workers.bulk', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f'✓ Removed from reservation_workers.bulk: {removed}')
    
    # Remove from payments.bulk
    print('Removing from payments.bulk...')
    lines = []
    removed_count = 0
    with open('data/payments.bulk', 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().split('|')[2] == res_to_remove:  # reservation_id is 3rd field
                removed_count += 1
                continue
            lines.append(line)
    
    with open('data/payments.bulk', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print(f'✓ Removed {removed_count} payment(s) from payments.bulk')
    
    print('\n✓ Duplicate removed successfully!')
else:
    print('\nNo duplicates found to remove.')
