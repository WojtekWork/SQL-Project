USE financial8_22;

-- HISTORIA UDZIELANYCH KREDYTÓW
SELECT YEAR(date) AS Rok
,      QUARTER(date) AS Kwartał
,      MONTH(date) AS Miesiąc
,      SUM(amount) AS Suma
,      AVG(amount) AS Średnia
,      COUNT(loan_id) AS Ilość
FROM loan
GROUP BY YEAR(date)
,        QUARTER(date)
,        MONTH(date)
WITH ROLLUP
ORDER BY YEAR(date)
,        QUARTER(date)
,        MONTH(date);

-- STATUS POŻYCZKI
SELECT status AS Status
,      COUNT(status) AS Ilość
FROM loan
GROUP BY status
ORDER BY status;

-- ANALIZA KONT
WITH cte AS
(
    SELECT account_id AS Account_id
    ,      COUNT(loan_id) AS Ilość
    ,      SUM(amount) AS Suma
    ,      AVG(amount) AS Średnia
    FROM loan
    WHERE status IN ('A', 'C')
    GROUP BY account_id
)
SELECT *
,      ROW_NUMBER() OVER (ORDER BY Ilość DESC) AS Ranking_Ilość
,      ROW_NUMBER() OVER (ORDER BY Suma DESC) AS Ranking_Suma
,      ROW_NUMBER() OVER (ORDER BY Średnia) AS Ranking_Średnia
FROM cte;

-- SPŁACONE POŻYCZKI
SELECT gender AS Płeć
,      COUNT(loan_id) AS Ilość
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN disp d ON a.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE status IN ('A', 'C') AND type = 'OWNER'
GROUP BY gender;

-- ANALIZA KLIENTA CZ 1
SELECT gender AS Płeć
,      AVG(YEAR(NOW()) - YEAR(birth_date)) AS Średni_Wiek
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN disp d ON a.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE type = 'OWNER'
GROUP BY gender;

-- ANALIZA KLIENTA CZ 2
CREATE TEMPORARY TABLE tmp AS
SELECT c.district_id AS District_id
,      COUNT(DISTINCT c.client_id) AS Ilość_klientów
,      COUNT(loan_id) AS Ilość_pożyczek
,      SUM(amount) AS Suma_pożyczek
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN disp d on a.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE status IN ('A', 'C') AND type = 'OWNER'
GROUP BY district_id;
SELECT District_id, Ilość_klientów
FROM tmp
ORDER BY Ilość_klientów DESC
LIMIT 1;
SELECT District_id, Ilość_pożyczek
FROM tmp
ORDER BY Ilość_pożyczek DESC
LIMIT 1;
SELECT District_id, Suma_pożyczek
FROM tmp
ORDER BY Suma_pożyczek DESC
LIMIT 1;

-- ANALIZA KLIENTA CZ 3
WITH cte AS
(
    SELECT district_id AS District_id
    ,      SUM(amount) AS Suma_pożyczek
    FROM loan l
    JOIN account a ON l.account_id = a.account_id
    JOIN disp d on a.account_id = d.account_id
    WHERE status IN ('A', 'C') AND type = 'OWNER'
    GROUP BY district_id
)
SELECT *,
       ROUND(Suma_pożyczek / SUM(Suma_pożyczek) OVER(), 2) AS Udział_procentowy
FROM cte;

-- SELEKCJA CZ 1
SELECT c.client_id AS Klient_id
,      YEAR(c.birth_date) AS Rok_urodzenia
,      SUM(amount - payments) AS Saldo
,      COUNT(loan_id) AS Ilość_pożyczek
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN disp d ON a.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE YEAR(c.birth_date) > 1990
AND type = 'OWNER'
GROUP BY c.client_id
,        c.birth_date
HAVING COUNT(loan_id) > 5
AND SUM(amount - payments) > 1000;

-- SELEKCJA CZ 2
SELECT c.client_id AS Klient_id
,      YEAR(c.birth_date) AS Rok_urodzenia
,      SUM(amount - payments) AS Saldo
,      COUNT(loan_id) AS Ilość_pożyczek
FROM loan l
JOIN account a ON l.account_id = a.account_id
JOIN disp d ON a.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE type = 'OWNER'
-- AND YEAR(c.birth_date) > 1990
GROUP BY c.client_id
,        c.birth_date
HAVING SUM(amount - payments) > 1000;
-- AND COUNT(loan_id) > 5;

-- WYGASAJĄCE KARTY
DELIMITER $$
CREATE PROCEDURE add_cards_at_expiration(IN p_date DATE)
BEGIN
    DROP TABLE IF EXISTS cards_at_expiration;
    CREATE TABLE cards_at_expiration
    (
        id_klienta INT,
        id_karty INT,
        data_wygaśnięcia DATE,
        adres_klienta VARCHAR(50)
    );
    INSERT INTO cards_at_expiration
    WITH cte AS
    (
        SELECT c2.client_id AS id_klienta
        ,      card_id AS id_karty
        ,      ADDDATE(issued, INTERVAL 3 YEAR) AS data_wygaśnięcia
        ,      A3 AS adres_klienta
        FROM card c1
        JOIN disp d1 on c1.disp_id = d1.disp_id
        JOIN client c2 on d1.client_id = c2.client_id
        JOIN district d2 on c2.district_id = d2.district_id
    )
    SELECT *
    FROM cte
    WHERE p_date BETWEEN ADDDATE(data_wygaśnięcia, INTERVAL -7 DAY) AND data_wygaśnięcia;
    SELECT *
    FROM cards_at_expiration;
END; $$
CALL add_cards_at_expiration('2001-01-01');