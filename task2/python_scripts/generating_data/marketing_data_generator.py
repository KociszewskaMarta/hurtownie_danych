import datetime
import random
import secrets
import string

HEADER = [
    "Date",
    "Campaing_Name",
    "Ad-group",
    "Trip_id",
    "Keyword",
    "Impressions",
    "Clicks",
    "CTR",
    "Cost",
    "Conversion Rate",
]

CAMPAIGNS=[
    "Lato 2026 Hiszpania",
    "Aktywna wiosna",
    "Black Friday 2025",
]

AD_GROUPS = [
    "Grupa 1",
    "Grupa 2"
]

KEYWORDS = [
    "wakacje w Hiszpanii",
    "last minute Hiszpania",
    "oferty na lato 2026"
]

def random_date(start: datetime, end: datetime) -> datetime:
    """Generate a random datetime between `start` and `end`"""
    delta = end - start
    if delta.days < 0:
        return start
    return start+ datetime.timedelta(days=random.randint(0,delta.days))

def format_float(value: float) -> str:
    """Format float to string with 2 decimal places and replace dot with comma"""
    return f"{value:.2f}".replace(".", ",")

def random_conversion_rate() -> str:
    """Generate a random conversion rate between 0 and 30%"""
    return format_float(random.uniform(0, 30))

def random_number(min_value: int, max_value: int) -> int:
    """Generate a random integer between min_value and max_value"""
    return random.randint(min_value, max_value)

def random_cost(min_value: float, max_value: float) -> str:
    """Generate a random cost between min_value and max_value"""
    return format_float(random.uniform(min_value, max_value))
#
# def generate_unique_id(existing_ids: set) -> str:
#     """Generate a unique trip id"""
#     while True:
#         trip_id = f"TRIP{random.randint(100000, 999999)}"
#         if trip_id not in existing_ids:
#             existing_ids.add(trip_id)
#             return trip_id
#         else :
#             generate_unique_id(existing_ids) # recursive call in case of collision

def random_unique_id(length:int=8, existing_ids: set=None) -> str | None:
    """Generate a unique trip id of given length"""
    alphabet = string.ascii_letters + string.digits #a-z A-Z 0-9
    chars = []
    for _ in range(length):
        chars.append(secrets.choice(alphabet))
    random_id = ''.join(chars)
    if random_id not in existing_ids:
        existing_ids.add(random_id)
        return random_id
    else:
        random_unique_id(length=length, existing_ids=existing_ids)



# test - generate in console 10 random rows
if __name__ == "__main__":
    existing_ids = set()
    for _ in range(10):
        date = random_date(datetime.datetime(2023, 1, 1), datetime.datetime(2024, 12, 31)).strftime("%Y-%m-%d")
        campaign_name = random.choice(CAMPAIGNS)
        ad_group = random.choice(AD_GROUPS)
        trip_id = random_unique_id(8,existing_ids)
        keyword = random.choice(KEYWORDS)
        impressions = random_number(1000, 100000)
        clicks = random_number(100, impressions)
        ctr = format_float((clicks / impressions) * 100)
        cost = random_cost(50.0, 5000.0)
        conversion_rate = random_conversion_rate()

        row = [
            date,
            campaign_name,
            ad_group,
            trip_id,
            keyword,
            str(impressions),
            str(clicks),
            ctr,
            cost,
            conversion_rate,
        ]
        print(" , ".join(row))
