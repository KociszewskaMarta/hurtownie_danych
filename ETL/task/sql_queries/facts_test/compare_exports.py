#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Skrypt porównujący dane z hurtowni ze źródłem
Porównuje eksportowane pliki CSV: zrodlo_export.csv i hurtownia_export.csv
z folderu facts_test
"""

import pandas as pd
import os

# Ścieżki do plików
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
FACTS_TEST_DIR = os.path.join(os.path.dirname(SCRIPT_DIR), 'facts_test')
ZRODLO_FILE = os.path.join(FACTS_TEST_DIR, 'zrodlo_export.csv')
HURTOWNIA_FILE = os.path.join(FACTS_TEST_DIR, 'hurtownia_export.csv')

def main():
    print("=" * 60)
    print("PORÓWNANIE DANYCH: ŹRÓDŁO vs HURTOWNIA")
    print("=" * 60)
    print(f"Folder z danymi: {FACTS_TEST_DIR}")
    print()
    
    # Wczytanie danych
    try:
        df_zrodlo = pd.read_csv(ZRODLO_FILE, encoding='utf-8')
        print(f"✓ Wczytano dane źródłowe: {len(df_zrodlo)} wierszy")
    except Exception as e:
        print(f"✗ Błąd wczytywania źródła: {e}")
        return
    
    try:
        df_hurtownia = pd.read_csv(HURTOWNIA_FILE, encoding='utf-8')
        print(f"✓ Wczytano dane z hurtowni: {len(df_hurtownia)} wierszy")
    except Exception as e:
        print(f"✗ Błąd wczytywania hurtowni: {e}")
        return
    
    print()
    print("-" * 60)
    print("1. PORÓWNANIE LICZBY REKORDÓW")
    print("-" * 60)
    print(f"Źródło:    {len(df_zrodlo)} rekordów")
    print(f"Hurtownia: {len(df_hurtownia)} rekordów")
    
    if len(df_zrodlo) == len(df_hurtownia):
        print("✓ Liczba rekordów się zgadza")
    else:
        print(f"✗ Różnica: {abs(len(df_zrodlo) - len(df_hurtownia))} rekordów")
    
    print()
    print("-" * 60)
    print("2. PORÓWNANIE KOLUMN")
    print("-" * 60)
    
    # Usuń reservation_id ze źródła (nie ma go w hurtowni)
    if 'reservation_id' in df_zrodlo.columns:
        df_zrodlo = df_zrodlo.drop(columns=['reservation_id'])
    
    # Sprawdź nazwy kolumn
    zrodlo_cols = set(df_zrodlo.columns)
    hurtownia_cols = set(df_hurtownia.columns)
    
    print(f"Kolumny źródło:    {sorted(zrodlo_cols)}")
    print(f"Kolumny hurtownia: {sorted(hurtownia_cols)}")
    
    if zrodlo_cols == hurtownia_cols:
        print("✓ Kolumny się zgadzają")
    else:
        print("✗ Różnice w kolumnach:")
        tylko_zrodlo = zrodlo_cols - hurtownia_cols
        tylko_hurtownia = hurtownia_cols - zrodlo_cols
        if tylko_zrodlo:
            print(f"  Tylko w źródle: {tylko_zrodlo}")
        if tylko_hurtownia:
            print(f"  Tylko w hurtowni: {tylko_hurtownia}")
    
    print()
    print("-" * 60)
    print("3. PORÓWNANIE SUM KWOT")
    print("-" * 60)
    
    # Upewnij się że kwoty są liczbami
    if 'kwota_transakcji' in df_zrodlo.columns:
        df_zrodlo['kwota_transakcji'] = pd.to_numeric(df_zrodlo['kwota_transakcji'], errors='coerce')
        df_hurtownia['kwota_transakcji'] = pd.to_numeric(df_hurtownia['kwota_transakcji'], errors='coerce')
        
        suma_zrodlo = df_zrodlo['kwota_transakcji'].sum()
        suma_hurtownia = df_hurtownia['kwota_transakcji'].sum()
        
        print(f"Suma kwot źródło:    {suma_zrodlo:.2f}")
        print(f"Suma kwot hurtownia: {suma_hurtownia:.2f}")
        
        if abs(suma_zrodlo - suma_hurtownia) < 0.01:
            print("✓ Sumy kwot się zgadzają")
        else:
            print(f"✗ Różnica: {abs(suma_zrodlo - suma_hurtownia):.2f}")
    
    if 'cena_turnusu' in df_zrodlo.columns:
        df_zrodlo['cena_turnusu'] = pd.to_numeric(df_zrodlo['cena_turnusu'], errors='coerce')
        df_hurtownia['cena_turnusu'] = pd.to_numeric(df_hurtownia['cena_turnusu'], errors='coerce')
        
        suma_zrodlo = df_zrodlo['cena_turnusu'].sum()
        suma_hurtownia = df_hurtownia['cena_turnusu'].sum()
        
        print(f"Suma cen turnusów źródło:    {suma_zrodlo:.2f}")
        print(f"Suma cen turnusów hurtownia: {suma_hurtownia:.2f}")
        
        if abs(suma_zrodlo - suma_hurtownia) < 0.01:
            print("✓ Sumy cen turnusów się zgadzają")
        else:
            print(f"✗ Różnica: {abs(suma_zrodlo - suma_hurtownia):.2f}")
    
    print()
    print("-" * 60)
    print("4. PORÓWNANIE SZCZEGÓŁOWE REKORDÓW")
    print("-" * 60)
    
    # Ujednolicenie nazw kolumn
    if 'client_pesel' in df_zrodlo.columns:
        df_zrodlo = df_zrodlo.rename(columns={'client_pesel': 'pesel_klienta'})
    
    # Sortuj oba DataFrame po tych samych kolumnach
    sort_columns = ['nazwa_wycieczki', 'pesel_klienta', 'reservation_date']
    
    df_zrodlo = df_zrodlo.sort_values(by=sort_columns).reset_index(drop=True)
    df_hurtownia = df_hurtownia.sort_values(by=sort_columns).reset_index(drop=True)
    
    # Porównaj rekordy
    if len(df_zrodlo) == len(df_hurtownia) and list(df_zrodlo.columns) == list(df_hurtownia.columns):
        roznice = []
        for idx in range(len(df_zrodlo)):
            for col in df_zrodlo.columns:
                val_zrodlo = df_zrodlo.at[idx, col]
                val_hurtownia = df_hurtownia.at[idx, col]
                
                # Porównanie z tolerancją dla liczb zmiennoprzecinkowych
                if pd.api.types.is_numeric_dtype(df_zrodlo[col]):
                    if pd.isna(val_zrodlo) and pd.isna(val_hurtownia):
                        continue
                    if abs(float(val_zrodlo) - float(val_hurtownia)) > 0.01:
                        roznice.append((idx, col, val_zrodlo, val_hurtownia))
                else:
                    if str(val_zrodlo).strip() != str(val_hurtownia).strip():
                        roznice.append((idx, col, val_zrodlo, val_hurtownia))
        
        if not roznice:
            print("✓ Wszystkie rekordy są identyczne!")
        else:
            print(f"✗ Znaleziono {len(roznice)} różnic:")
            for idx, col, val_z, val_h in roznice[:10]:  # Pokaż max 10 różnic
                print(f"  Wiersz {idx}, kolumna '{col}':")
                print(f"    Źródło:    {val_z}")
                print(f"    Hurtownia: {val_h}")
            if len(roznice) > 10:
                print(f"  ... i {len(roznice) - 10} innych różnic")
    else:
        print("✗ Nie można porównać rekordów - różne liczby wierszy lub kolumn")
    
    print()
    print("-" * 60)
    print("5. ROZKŁAD PO STATUSIE OPŁACENIA")
    print("-" * 60)
    
    if 'status_oplacenia' in df_zrodlo.columns:
        print("Źródło:")
        print(df_zrodlo['status_oplacenia'].value_counts())
        print("\nHurtownia:")
        print(df_hurtownia['status_oplacenia'].value_counts())
        
        if df_zrodlo['status_oplacenia'].value_counts().equals(df_hurtownia['status_oplacenia'].value_counts()):
            print("\n✓ Rozkład statusów się zgadza")
        else:
            print("\n✗ Rozkład statusów się różni")
    
    print()
    print("=" * 60)
    print("KONIEC PORÓWNANIA")
    print("=" * 60)

if __name__ == "__main__":
    main()
