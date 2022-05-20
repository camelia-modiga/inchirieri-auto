--testarea pachetelor de stergere
EXECUTE DELETE_MASINI('IS 20 RNT');
EXECUTE DELETE_MASINI('IS 31 RNT');

EXECUTE DELETE_CLIENTI('Popescu', 'Matei');
EXECUTE DELETE_CLIENTI('Popescu', 'Ionut');


--testare tranzactie
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 21 RNT', 'volkswagen','compact',2009,'benzina','negru','automata',4.9,22);

--testarea pachetelor de insert
--nu se poate incheia un contract daca masina este deja inchiriata
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('15.02.2022','DD.MM.YYYY'),to_date('16.02.2022','DD.MM.YYYY'),'Popa','Andrei','IS 02 RNT');
