EXECUTE DELETE_MASINI('IS 20 RNT');
EXECUTE DELETE_MASINI('IS 31 RNT');

EXECUTE DELETE_CLIENTI('Popescu', 'Matei');
EXECUTE DELETE_CLIENTI('Popescu', 'Ionut');


--testare tranzactie
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 21 RNT', 'volkswagen','compact',2009,'benzina','negru','automata',4.9,22);