CREATE TABLE clienti (
    id_client            NUMBER(4) NOT NULL,
    serie_act_identitate VARCHAR2(20) NOT NULL,
    tip_act              VARCHAR2(15) NOT NULL,
    nume                 VARCHAR2(20) NOT NULL,
    prenume              VARCHAR2(20) NOT NULL,
    email                VARCHAR2(40),
    nr_telefon           CHAR(10) NOT NULL,
    data_obt_permis      DATE NOT NULL,
    data_nasterii        DATE NOT NULL
);

ALTER TABLE clienti
    ADD CONSTRAINT clienti_serie_act_ck CHECK ( REGEXP_LIKE ( serie_act_identitate,
                                                              '^[A-Z0-9 ]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_ti_act_ck CHECK ( tip_act IN ( 'Altele', 'CI', 'Pasaport' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_nume_ck CHECK ( length(nume) >= 2
                                           AND REGEXP_LIKE ( nume,
                                                             '^[a-zA-Z ]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_prenume_ck CHECK ( length(prenume) >= 2
                                              AND REGEXP_LIKE ( prenume,
                                                                '^[a-zA-Z ]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_email_ck CHECK ( REGEXP_LIKE ( email,
                                                          '[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}' ) );

ALTER TABLE clienti
    ADD CONSTRAINT clienti_nr_telefon_ck CHECK ( length(nr_telefon) = 10
                                                 AND REGEXP_LIKE ( nr_telefon,
                                                                   '^[0][:7:3:2][0-9 ]*$' ) );

ALTER TABLE clienti
    ADD CONSTRAINT data_permis_ck CHECK ( data_obt_permis >= add_months(data_nasterii, 12 * 18) );

ALTER TABLE clienti ADD CONSTRAINT clienti_pk PRIMARY KEY ( id_client );

ALTER TABLE clienti ADD CONSTRAINT clienti_nr_telefon_uk UNIQUE ( nr_telefon );

ALTER TABLE clienti ADD CONSTRAINT clienti_serie_act_uk UNIQUE ( serie_act_identitate );

ALTER TABLE clienti ADD CONSTRAINT clienti_email_uk UNIQUE ( email );

CREATE TABLE contracte_inchirieri (
    nr_contract       NUMBER(4) NOT NULL,
    data_inchiriere   DATE NOT NULL,
    data_retur        DATE NOT NULL,
    tarif             NUMBER(4) NOT NULL,
    clienti_id_client NUMBER(4) NOT NULL,
    masini_id_masina  NUMBER(4) NOT NULL
);

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT contracte_data_inchiriere_ck CHECK ( to_char(data_inchiriere, 'YYYY-MM-DD') >= '2020-10-01' );

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT contracte_data_retur_ck CHECK ( data_retur > data_inchiriere
                                                   AND data_retur < add_months(data_inchiriere, 1) );

ALTER TABLE contracte_inchirieri ADD CONSTRAINT contracte_inchirieri_tarif_ck CHECK ( tarif > 10 );

ALTER TABLE contracte_inchirieri ADD CONSTRAINT contracte_inchirieri_pk PRIMARY KEY ( nr_contract,
                                                                                      masini_id_masina );

CREATE TABLE detalii_masini (
    marca            VARCHAR2(20) NOT NULL,
    clasa            VARCHAR2(20) NOT NULL,
    an_fabricatie    NUMBER(4) NOT NULL,
    carburant        VARCHAR2(10) NOT NULL,
    culoare          VARCHAR2(10) NOT NULL,
    transmisie       VARCHAR2(15) NOT NULL,
    consum           NUMBER(3, 1) NOT NULL,
    tarif            NUMBER(3) NOT NULL,
    masini_id_masina NUMBER(4) NOT NULL
);

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_marca_ck CHECK ( length(marca) >= 2
                                                   AND REGEXP_LIKE ( marca,
                                                                     '^[a-zA-Z ]*$' ) );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_clasa_ck CHECK ( length(clasa) >= 2
                                                   AND REGEXP_LIKE ( clasa,
                                                                     '^[a-zA-Z ]*$' ) );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_an_fabricatie_ck CHECK ( an_fabricatie BETWEEN 2010 AND 2020 );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_carburant_ck CHECK ( carburant IN ( 'benzina', 'motorina' ) );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_culoare_ck CHECK ( length(culoare) >= 2
                                                     AND REGEXP_LIKE ( culoare,
                                                                       '^[a-zA-Z ]*$' ) );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_transmisie_ck CHECK ( transmisie IN ( 'automata', 'manuala' ) );

ALTER TABLE detalii_masini
    ADD CONSTRAINT detalii_masini_consum_ck CHECK ( consum BETWEEN 3 AND 15 );

ALTER TABLE detalii_masini ADD CONSTRAINT detalii_masini_tarif_ck CHECK ( tarif > 10 );

ALTER TABLE detalii_masini ADD CONSTRAINT detalii_masini_pk PRIMARY KEY ( masini_id_masina );

CREATE TABLE masini (
    id_masina        NUMBER(4) NOT NULL,
    nr_inmatriculare VARCHAR2(9) NOT NULL
);

ALTER TABLE masini
    ADD CONSTRAINT masini_nr_inmatriculare_ck CHECK ( length(nr_inmatriculare) = 9
                                                      AND REGEXP_LIKE ( nr_inmatriculare,
                                                                        '[A-Z_ ]{1,2}+[0-9_ ]{2,3}+[A-Z]{3}*$' ) );

ALTER TABLE masini ADD CONSTRAINT masini_pk PRIMARY KEY ( id_masina );

ALTER TABLE masini ADD CONSTRAINT masini_nr_inmatriculare_uk UNIQUE ( nr_inmatriculare );

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT clienti_contracte_fk FOREIGN KEY ( clienti_id_client )
        REFERENCES clienti ( id_client );

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT masini_contracte_inchirieri_fk FOREIGN KEY ( masini_id_masina )
        REFERENCES masini ( id_masina );

ALTER TABLE detalii_masini
    ADD CONSTRAINT masini_detalii_masini FOREIGN KEY ( masini_id_masina )
        REFERENCES masini ( id_masina );

CREATE SEQUENCE clienti_id_client_seq 
START WITH 1 
    MAXVALUE 9999 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER clienti_id_client_trg 
BEFORE INSERT ON Clienti 
FOR EACH ROW 
WHEN (NEW.id_client IS NULL) 
BEGIN
:new.id_client := clienti_id_client_seq.nextval;

end;
/

CREATE SEQUENCE contracte_nr_contract_seq 
START WITH 1 
    MAXVALUE 9999 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER contracte_nr_contract_trg 
BEFORE INSERT ON Contracte_inchirieri 
FOR EACH ROW 
WHEN (NEW.nr_contract IS NULL) 
BEGIN
:new.nr_contract := contracte_nr_contract_seq.nextval;

end;
/

CREATE SEQUENCE masini.id_masina_seq 
START WITH 1 
    MAXVALUE 9999 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER masini.id_masina_trg 
BEFORE INSERT ON Masini 
FOR EACH ROW 
WHEN (NEW.id_masina IS NULL) 
BEGIN
:new.id_masina := masini.id_masina_seq.nextval;

end;
/