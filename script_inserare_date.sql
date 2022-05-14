-- inserare date in tabelele masini si detalii_masini
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 01 RNT', 'volkswagen','compact',2019,'benzina','negru','automata',4.9,22);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 02 RNT','renault','compact',2018,'motorina','maro','automata',4,18);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 03 RNT', 'opel','compact',2019,'benzina','maro','manuala',4.7,28);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 04 RNT', 'chevrolet','mini',2019,'benzina','argintiu','manuala',5.2,12);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 05 RNT', 'mercedes','premium',2020,'benzina','galben','automata',4.4,54);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 06 RNT', 'BMW','premium',2018,'motorina','negru','automata',9.2,134);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 07 RNT', 'dacia','economic',2017,'benzina','rosu','manuala',4.5,14);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 08 RNT', 'skoda','economic',2019,'motorina','albastru','automata',4.6,16);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 09 RNT', 'BMW','SUV',2019,'motorina','albastru','automata',8.9,90);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 10 RNT', 'BMW','SUV',2016,'benzina','rosu','manuala',6.8,92);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 11 RNT', 'suzuki','crossover',2018,'benzina','gri','manuala',5.1,30);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 12 RNT', 'volkswagen','crossover',2017,'motorina','burgundy','manuala',5.9,75);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 13 RNT', 'skoda','combi',2019,'benzina','albastru','automata',4.3,38);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 14 RNT', 'volkswagen','combi',2019,'motorina','alb','manuala',5.2,42);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 15 RNT', 'mercedes','bus',2016,'benzina','alb','manuala',8.5,52);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 16 RNT', 'renault','bus',2019,'motorina','alb','automata',9,68);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 17 RNT', 'dacia','economic',2016,'motorina','alb','manuala',6.5,14);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 18 RNT', 'ford','economic',2019,'benzina','alb','automata',5.1,24);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 19 RNT', 'skoda','premium',2016,'motorina','gri','automata',5.2,42);
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 20 RNT', 'mercedes','premium',2019,'benzina','maro','manuala',4.5,100);


--testare tranzactie
EXECUTE  MASINI_DETALII_PACK.ADD_MASINI('IS 21 RNT', 'volkswagen','compact',2009,'benzina','negru','automata',4.9,22);

--inserare date in tabela clienti
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'BV183916','CI','Popescu','Matei','popescumatei@yahoo.com','0786903009',to_date('10.03.2010','DD.MM.YYYY'),to_date('13.09.1973','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MX129056','CI','Pavel','Maria','maria.pavel@gmail.com','0750976725',to_date('01.03.2016','DD.MM.YYYY'),to_date('08.02.1990','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MX456009','CI','Marinescu','Ioana','marinescu_io03@yahoo.com','0786762900',to_date('10.01.2018','DD.MM.YYYY'),to_date('10.09.1995','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'TM889012','CI','Cristea','Alexandru','alex_crst9@gmail.com','0728900156',to_date('17.08.2017','DD.MM.YYYY'),to_date('15.10.1991','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'040000314','Pasaport','Alexandrescu','Cristina','cristinaaalx@gmail.com','0759007689',to_date('19.01.2019','DD.MM.YYYY'),to_date('12.12.1998','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'BV871245','CI','Ionescu','George','george078@gmail.com','0783009851',to_date('20.05.2019','DD.MM.YYYY'),to_date('12.05.1998','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MX651490','CI','Enachi','Anca',null,'0732751200',to_date('12.07.2016','DD.MM.YYYY'),to_date('24.12.1988','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'183916987','Pasaport','Thompson','Sandra','sandra_th@gmail.com','0786502635',to_date('10.03.2014','DD.MM.YYYY'),to_date('10.06.1980','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'861082569','Pasaport','Gomez','Allison','gomez_allison@yahoo.com','0787114907',to_date('12.12.2016','DD.MM.YYYY'),to_date('12.12.1980','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'XC783916','CI','Popa','Andrei','popa1234@yahoo.com','0786903012',to_date('11.10.2015','DD.MM.YYYY'),to_date('13.09.1985','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MX183916','CI','Grecu','Marius','grecu.mar@yahoo.com','0736913009',to_date('10.03.2019','DD.MM.YYYY'),to_date('13.09.1990','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MX183016','CI','Vasiliu','Daniela','dana_vasiliu@gmail.com','0745903349',to_date('03.03.2013','DD.MM.YYYY'),to_date('23.12.1990','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'MZ183916','CI','Morosanu','Dan','dan78_moro@gmail.com','0722345799',to_date('06.06.2016','DD.MM.YYYY'),to_date('24.10.1991','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'8614989028','Pasaport','Anton','Teodora','teo1234@yahoo.com','0755098123',to_date('12.05.2016','DD.MM.YYYY'),to_date('21.08.1991','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'977261182','Pasaport','Georgescu','Marian','georgescu@yahoo.com','0786998109',to_date('14.10.2016','DD.MM.YYYY'),to_date('22.08.1993','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'VS187255','CI','Hanganu','Alice','alicehng@yahoo.com','0786876510',to_date('14.12.2018','DD.MM.YYYY'),to_date('13.09.1997','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'BV123887','CI','Iacob','Sebastian','sebi_iacob@yahoo.com','0755198667',to_date('15.10.2018','DD.MM.YYYY'),to_date('13.09.1996','DD.MM.YYYY'));
EXECUTE CLIENTI_PACK.ADD_CLIENTI(null,'XC986120','CI','Iosub','Luca',null,'0721900817',to_date('10.03.2018','DD.MM.YYYY'),to_date('23.09.1996','DD.MM.YYYY'));

--inserare date in tabela contacte_inchirieri
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('02.02.2022','DD.MM.YYYY'),to_date('17.02.2022','DD.MM.YYYY'),'Pavel','Maria','IS 02 RNT');
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('29.04.2022','DD.MM.YYYY'),to_date('06.05.2022','DD.MM.YYYY'),'Marinescu','Ioana','IS 03 RNT');
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('01.04.2022','DD.MM.YYYY'),to_date('04.04.2022','DD.MM.YYYY'),'Cristea','Alexandru','IS 05 RNT');
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('02.04.2022','DD.MM.YYYY'),to_date('17.04.2022','DD.MM.YYYY'),'Alexandrescu','Cristina','IS 11 RNT');
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('29.04.2022','DD.MM.YYYY'),to_date('17.05.2022','DD.MM.YYYY'),'Morosanu','Dan','IS 08 RNT');
EXECUTE CONTRACTE_PACK.ADD_CONTRACTE(to_date('13.03.2022','DD.MM.YYYY'),to_date('15.03.2022','DD.MM.YYYY'),'Popa','Andrei','IS 06 RNT');

--afisare date utilizand pachetele de vizualizare
EXECUTE  VIZUALIZARE_PACK.AFISARE_INCHIRIERE;
EXECUTE  VIZUALIZARE_PACK.AFISARE_CONTRACTE_DATA(to_date('10.10.2020','DD.MM.YYYY'));
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_DISPONIBILE;
EXECUTE  VIZUALIZARE_PACK.AFISARE_MASINI_INCHIRIATE;
