# SQL-Project
SQLProject

Struktura bazy

Schemat
schema

Opis tabel
Card
Tabela zawierająca dane dotyczące karty kredytowej.

Kolumny:

card_id - id karty,
disp_id - id dysponenta karty,
type - typ karty (klasyczna, złota itp.),
issued - data wydania karty.
Disp
Tabela zawiera informacje o osobach przypisanych do danej karty. Jej nazwa pochodzi od skróconej nazwy disponent (dysponent), czyli osoby, która również może korzystać z karty.

Kolumny:

disp_id - id dysponenta karty,
client_id - id klienta,
account_id - id konta, do którego jest przypisana karta,
type - typ zarządzania kartą (właściciel lub dysponent).
Client
Tabela zawiera podstawowe charakterystyki klienta.

Kolumny:

client_id - id klienta,
gender - płeć,
birth_date - data urodzenia,
district_id - id dzielnicy zamieszkania.
District
Tabela zawiera dane demograficzne dzielnicy.

Kolumny:

district_id - id dzielnicy,
A2 - nazwa dzielnicy,
A3 - region,
A4 - liczba mieszkańców,
A5 - liczba gmin z mieszkańcami poniżej 499,
A6 - liczba gmin z mieszkańcami pomiędzy 500-1999,
A7 - liczba gmin z mieszkańcami pomiędzy 2000-9999,
A8 - liczba gmin z mieszkańcami powyżej> 10000,
A9 - liczba miast,
A10 - stosunek liczby mieszkańców miast do wsi,
A11 - średnie wynagrodzenie,
A12 - współczynnik bezrobocia w 1995,
A13 - współczynnik bezrobocia w 1996,
A14 - liczba przedsiębiorców na 1000 mieszkańców,
A15 - liczba przestępstw popełnionych w 1995,
A16 - liczba przestępstw popełnionych w 1996.
Account
Tabela zawiera informacje o kontach.

Kolumny:

account_id - id konta,
district_id - id dzielnicy oddziału, gdzie konto zostało założone,
frequency - częstotliwość wystawiania wyciągów,
date - data założenia konta.
Trans
Tabela zawiera informacje o transakcjach.

Kolumny:

trans_id - id transakcji,
account_id - id konta, na którym zapisana jest transakcja,
date - data transakcji,
type - czy transakcja debetowa/kredytowa,
operation - typ transakcji,
amount - kwota transakcji,
balance - stan konta po transakcji,
k_symbol - charakterystyka transakcji,
bank - bank partnera transakcji,
account - konto partnera transakcji.
Order
Tabela zawiera charakterystykę polecenia zapłaty.

Kolumn:

order_id - identyfikator,
account_id - id konta,
bank_to - id banku odbiorcy,
account_to - id konta odbiorcy,
amount - kwota przelewu,
k_symbol - charakterystyka płatności.
Loan
Tabela zawiera informacje o statusie pożyczki.

Kolumny:

loan_id - id pożyczki,
account_id - id konta wnioskującego o pożyczkę,
date - data udzielenia pożyczki,
amount - kwota pożyczki,
duration - czas trwania pożyczki,
payments - miesięczna kwota płatności,
status - status spłaty pożyczki.

The project is carried out as part of the specialized Data Lab course from CodersLab

