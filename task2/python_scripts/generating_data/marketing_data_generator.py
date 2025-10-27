import datetime
import random
import secrets
import string
from typing import Any

# TODO: musi byl polaczenie z baza danych poprzez trip_id - znalezc rozwiazanie do tego

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
    "Rodzinne wakacje",
    "Wakacje dla par",
    "Przygoda i eksploracja",
    "Luksusowe podróże",
    "Wakacje budżetowe",
    "Egzotyczne destynacje",
    "Relaks i wellness",
    "Wakacje dla seniorów",
    "Wakacje z dziećmi"
]

AD_GROUPS = [
    "Last Minute",
    "First Minute",
    "Oferty Specjalne",
    "Pakiety Wakacyjne",
    "All Inclusive",
    "Nowe Destynacje"
]

KEYWORDS_FOR_CAMPAIGNS = [
    ["rodzinne wakacje", "dla dzieci"], # Rodzinne wakacje
    ["dla par", "luksusowe podróże", "relaks i wellness", "romantyczne"], # Wakacje dla par
    ["przygoda", "egzotyka", "aktywne wakacje", "sport", "ekstremalne"], # Przygoda i eksploracja
    ["luksusowe podróże", "relaks", "5-gwiazdek", "wysoki standard"], # Luksusowe podróże
    ["budżetowe wakacje", "oferty specjalne", "oszczędne podróże"], # Wakacje budżetowe
    ["egzotyczne destynacje", "przygoda", "eksploracja", "dzika przyroda", "plaże", "nieodkryte miejsca"], # Egzotyczne destynacje
    ["relaks i wellness", "dla seniorów", "joga", "spa", "zdrowie"], # Relaks i wellness
    ["dla seniorów", "relaks i wellness", "spokojne wakacje"], # Wakacje dla seniorów
    ["dla dzieci", "rodzinne wakacje", "animacje dla dzieci"] # Wakacje z dziećmi
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


def random_unique_id(length: int = 8, existing_ids: set | None = None) -> str:
    """Generate a unique trip id of given length (fixed: loop zamiast rekursji)."""
    if existing_ids is None:
        existing_ids = set()
    alphabet = string.ascii_letters + string.digits
    for _ in range(100):  # max prób
        random_id = ''.join(secrets.choice(alphabet) for _ in range(length))
        if random_id not in existing_ids:
            existing_ids.add(random_id)
            return random_id
    raise RuntimeError("Unable to generate unique id after 100 attempts")

def get_keyword_for_campaign(campaign_name: str) -> Any | None:
    """ Get a random keyword for a given campaign name """
    try:
        idx = CAMPAIGNS.index(campaign_name)
        candidates = KEYWORDS_FOR_CAMPAIGNS[idx]
        if candidates:
            return random.choice(candidates)
    except ValueError:
        pass

# test - generate in console 10 random rows
if __name__ == "__main__":
    existing_ids = set()
    for _ in range(10):
        date = random_date(datetime.datetime(2023, 1, 1), datetime.datetime(2024, 12, 31)).strftime("%Y-%m-%d")
        campaign_name = random.choice(CAMPAIGNS)
        ad_group = random.choice(AD_GROUPS)
        trip_id = random_unique_id(8,existing_ids)
        keyword = get_keyword_for_campaign(campaign_name)
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
