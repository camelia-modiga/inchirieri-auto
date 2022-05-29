
--afisare date utilizand pachetele de vizualizare
EXECUTE  VIZUALIZARE_PACK.AFISARE_INCHIRIERE;
EXECUTE  VIZUALIZARE_PACK.AFISARE_CONTRACTE_DATA(to_date('10.03.2022','DD.MM.YYYY'));
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_DISPONIBILE;
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_INCHIRIATE;

--testarea pachetelor de stergere
EXECUTE DELETE_MASINI('IS 20 RNT');
EXECUTE DELETE_MASINI('IS 31 RNT');
EXECUTE DELETE_CLIENTI('Popescu', 'Matei');
EXECUTE DELETE_CLIENTI('Popescu', 'Ionut');

EXECUTE DELETE_CONTRACTE(5);
EXECUTE DELETE_CONTRACTE(10);

--testare tranzactie
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 21 RNT', 'volkswagen','compact',2009,'benzina','negru','automata',4.9,22);

EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_INCHIRIATE;
-- incercam sa inchiriem o masina care este deja inchiriata
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('01.06.2022','DD.MM.YYYY'),to_date('08.07.2022','DD.MM.YYYY'),'Popa','Andrei','IS 12 RNT');

--incercarea de a modifica data_retur astfel incat sa fie mai mica decat data_inchiriere
EXECUTE CONTRACTE_PACK.UPDATE_DATA_RETUR(4,to_date('24.05.2022','DD.MM.YYYY'));

-- inseram un nou contract in tabela contracte
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('07.06.2022','DD.MM.YYYY'),to_date('10.06.2022','DD.MM.YYYY'),'Marinescu','Ioana','IS 12 RNT');
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_INCHIRIATE;

--incercarea de a modifica data_retur intr-o perioada in care masina este deja inchiriata
EXECUTE CONTRACTE_PACK.UPDATE_DATA_RETUR(4,to_date('08.06.2022','DD.MM.YYYY'));

--incercarea de a modifica data_retur intr-o perioada in care masina este disponibila
EXECUTE CONTRACTE_PACK.UPDATE_DATA_RETUR(4,to_date('03.06.2022','DD.MM.YYYY'));
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_INCHIRIATE;

-- modificarea datei de inchiriere a unei masini care este inchiriata o singura data
EXECUTE CONTRACTE_PACK.UPDATE_DATA_INCHIRIERE(3, to_date('28.04.2022','DD.MM.YYYY'), 'IS 05 RNT')

-- incercarea de a modifica data de inchiriere a masinii inainte de data_retur
EXECUTE CONTRACTE_PACK.UPDATE_DATA_INCHIRIERE(5, to_date('11.06.2022','DD.MM.YYYY'), 'IS 12 RNT');

 --incercarea de a modifica data_inchiriere intr-o perioada in care masina este deja inchiriata
EXECUTE CONTRACTE_PACK.UPDATE_DATA_INCHIRIERE(5, to_date('02.06.2022','DD.MM.YYYY'), 'IS 12 RNT');

