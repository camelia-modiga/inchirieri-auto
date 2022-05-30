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
)
LOGGING;

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

CREATE TABLE masini (
    id_masina        NUMBER(4) NOT NULL,
    nr_inmatriculare VARCHAR2(9) NOT NULL,
    status           NUMBER(1) NOT NULL
)
LOGGING;

ALTER TABLE masini
    ADD CONSTRAINT masini_nr_inmatriculare_ck CHECK ( length(nr_inmatriculare) = 9
                                                      AND REGEXP_LIKE ( nr_inmatriculare,
                                                                        '[A-Z_ ]{1,2}+[0-9_ ]{2,3}+[A-Z]{3}*$' ) );

ALTER TABLE masini
    ADD CONSTRAINT masini_status_ck CHECK ( status IN ( 0, 1 ) );

ALTER TABLE masini ADD CONSTRAINT masini_pk PRIMARY KEY ( id_masina );

ALTER TABLE masini ADD CONSTRAINT masini_nr_inmatriculare_uk UNIQUE ( nr_inmatriculare );

CREATE TABLE contracte_inchirieri (
    nr_contract     NUMBER(4) NOT NULL,
    data_inchiriere DATE NOT NULL,
    data_retur      DATE NOT NULL,
    tarif           NUMBER(4) NOT NULL,
    id_client       NUMBER(4) NOT NULL,
    id_masina       NUMBER(4) NOT NULL
)
LOGGING;

ALTER TABLE contracte_inchirieri ADD CONSTRAINT contracte_data_retur_ck CHECK ( data_retur > data_inchiriere );

ALTER TABLE contracte_inchirieri ADD CONSTRAINT contracte_inchirieri_pk PRIMARY KEY ( nr_contract,
                                                                                      id_masina );

CREATE TABLE detalii_masini (
    marca         VARCHAR2(20) NOT NULL,
    clasa         VARCHAR2(20) NOT NULL,
    an_fabricatie NUMBER(4) NOT NULL,
    carburant     VARCHAR2(10) NOT NULL,
    culoare       VARCHAR2(10) NOT NULL,
    transmisie    VARCHAR2(15) NOT NULL,
    consum        NUMBER(3, 1) NOT NULL,
    tarif         NUMBER(3) NOT NULL,
    id_masina     NUMBER(4) NOT NULL
)
LOGGING;

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

ALTER TABLE detalii_masini ADD CONSTRAINT detalii_masini_pk PRIMARY KEY ( id_masina );

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT clienti_contracte_fk FOREIGN KEY ( id_client )
        REFERENCES clienti ( id_client )
    NOT DEFERRABLE;

ALTER TABLE contracte_inchirieri
    ADD CONSTRAINT masini_contracte_inchirieri_fk FOREIGN KEY ( id_masina )
        REFERENCES masini ( id_masina )
    NOT DEFERRABLE;

ALTER TABLE detalii_masini
    ADD CONSTRAINT masini_detalii_masini FOREIGN KEY ( id_masina )
        REFERENCES masini ( id_masina )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER contracte_data_inchiriere_trg 
    BEFORE INSERT ON Contracte_inchirieri 
    FOR EACH ROW 
DECLARE
    ultima_data_retur DATE;
    v_nr_de_inchirieri NUMBER(4);
BEGIN  
    SELECT COUNT(*) INTO v_nr_de_inchirieri FROM Contracte_inchirieri WHERE id_masina = :new.id_masina;
    IF v_nr_de_inchirieri > 0 
    THEN
        SELECT MAX(data_retur) INTO ultima_data_retur FROM Contracte_inchirieri WHERE id_masina = :new.id_masina;
        IF (:new.data_inchiriere < ultima_data_retur)
        THEN
           RAISE_APPLICATION_ERROR( -20001,
                    'Data invalida: ' || TO_CHAR( :new.data_inchiriere, 'DD.MM.YYYY' ) || '. Masina este inchiriata pana la data ' || TO_CHAR(ultima_data_retur,'DD.MM.YYYY'));
        END IF;
    END IF;
END; 
/

CREATE OR REPLACE TRIGGER delete_clienti_trg 
    BEFORE DELETE ON Clienti 
    FOR EACH ROW 
DECLARE
v_nr_clienti NUMBER(20);
BEGIN 
    SELECT COUNT(*) INTO v_nr_clienti FROM contracte_inchirieri WHERE id_client=:old.id_client;
    IF v_nr_clienti>0
    THEN
        RAISE_APPLICATION_ERROR(-20200, 'Clientul nu poate fi sters pentru ca are o masina inchiriata.');
    END IF;
    EXCEPTION 
    		WHEN NO_DATA_FOUND THEN 
    			DBMS_OUTPUT.PUT_LINE('No data found');
END; 
/

CREATE OR REPLACE TRIGGER delete_masini_trg 
    BEFORE DELETE ON Masini 
    FOR EACH ROW 
DECLARE
v_nr_masini NUMBER(20);
BEGIN 
    SELECT COUNT(*) INTO v_nr_masini FROM contracte_inchirieri WHERE id_masina=:old.id_masina;
    IF v_nr_masini>0
    THEN
       RAISE_APPLICATION_ERROR(-20200, 'Masina nu poate fi stearsa pentru ca este inchiriata.');
    END IF;
    EXCEPTION 
    		WHEN NO_DATA_FOUND THEN 
    			DBMS_OUTPUT.PUT_LINE('No data found');
END; 
/


CREATE SEQUENCE clienti_id_client_seq 
START WITH 1 
    MAXVALUE 9999 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER client_id_client_trg 
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

CREATE SEQUENCE masini_id_masina_seq 
START WITH 1 
    MAXVALUE 9999 
    NOCACHE 
    ORDER ;

CREATE OR REPLACE TRIGGER masini_id_masina_trg 
BEFORE INSERT ON Masini 
FOR EACH ROW 
WHEN (NEW.id_masina IS NULL) 
BEGIN
:new.id_masina := masini_id_masina_seq.nextval;

end;
/

CREATE OR REPLACE FUNCTION get_id_client (
    p_nume    IN clienti.nume%TYPE,
    p_prenume IN clienti.prenume%TYPE
) RETURN NUMBER IS
    v_id clienti.id_client%TYPE;
BEGIN
    SELECT
        id_client
    INTO v_id
    FROM
        clienti
    WHERE
            nume = p_nume
        AND prenume = p_prenume;

    RETURN v_id;
END get_id_client;
/

CREATE OR REPLACE FUNCTION get_id_masina (
    p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE
) RETURN NUMBER IS
    v_id masini.id_masina%TYPE;
BEGIN
    SELECT
        id_masina
    INTO v_id
    FROM
        masini
    WHERE
        nr_inmatriculare = p_nr_inmatriculare;

    RETURN v_id;
END get_id_masina;
/

CREATE OR REPLACE FUNCTION get_id_masina_contracte (
    p_nr_contract IN contracte_inchirieri.nr_contract%TYPE
) RETURN NUMBER IS
    v_id masini.id_masina%TYPE;
BEGIN
    SELECT
        id_masina
    INTO v_id
    FROM
        contracte_inchirieri
    WHERE
        nr_contract = p_nr_contract;

    RETURN v_id;
END get_id_masina_contracte;
/

CREATE OR REPLACE PROCEDURE DELETE_CLIENTI (p_nume in clienti.nume%TYPE, p_prenume in clienti.prenume%TYPE)  AS 
BEGIN
    DELETE FROM CLIENTI WHERE nume = p_nume AND prenume = p_prenume;
    IF SQL%NOTFOUND THEN
          dbms_output.put_line('Nu exista clientul cu numele ' || p_nume || ' ' || p_prenume);
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE DELETE_CONTRACTE (p_nr_contract in contracte_inchirieri.nr_contract%TYPE)  AS 
BEGIN
    DELETE FROM contracte_inchirieri WHERE nr_contract = p_nr_contract;
    IF SQL%NOTFOUND THEN
          dbms_output.put_line('Nu exista contractul cu numarul ' || p_nr_contract);
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE DELETE_MASINI (p_nr_inmatriculare in masini.nr_inmatriculare%TYPE)  AS 
    INTEGRITY_CONSTRAINT_VIOLATED EXCEPTION;
    PRAGMA EXCEPTION_INIT(INTEGRITY_CONSTRAINT_VIOLATED, -02292);
BEGIN
    DELETE FROM MASINI WHERE nr_inmatriculare=p_nr_inmatriculare;
    IF SQL%NOTFOUND THEN
          dbms_output.put_line('Nu exista masina cu numarul de inmatriculare ' || p_nr_inmatriculare);
    END IF;
    EXCEPTION
        WHEN INTEGRITY_CONSTRAINT_VIOLATED THEN
              DBMS_OUTPUT.PUT_LINE('DELETE failed due to integrity constraint violation');
        WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('Something else went wrong - ' || SQLCODE || ' : ' || SQLERRM);
END;
/

CREATE OR REPLACE PACKAGE CLIENTI_PACK
IS
    PROCEDURE ADD_CLIENTI (p_serie_act_identitate in clienti.serie_act_identitate%TYPE, 
                           p_tip_act in clienti.tip_act%TYPE, 
                           p_nume in clienti.nume%TYPE, 
                           p_prenume in clienti.prenume%TYPE, 
                           p_email in clienti.email%TYPE, 
                           p_nr_telefon in clienti.nr_telefon%TYPE,
                           p_data_obt_permis in clienti.data_obt_permis%TYPE, 
                           p_data_nasterii in clienti.data_nasterii%TYPE);
                           
   PROCEDURE UPDATE_CLIENTI_TELEFON (p_nr_telefon in clienti.nr_telefon%TYPE,
                                      p_id_client in clienti.id_client%TYPE);
    
    PROCEDURE UPDATE_CLIENTI_EMAIL (p_email in clienti.email%TYPE,
                                    p_id_client in clienti.id_client%TYPE);
END CLIENTI_PACK;
/

CREATE OR REPLACE PACKAGE BODY clienti_pack IS

    PROCEDURE add_clienti (
        p_serie_act_identitate IN clienti.serie_act_identitate%TYPE,
        p_tip_act              IN clienti.tip_act%TYPE,
        p_nume                 IN clienti.nume%TYPE,
        p_prenume              IN clienti.prenume%TYPE,
        p_email                IN clienti.email%TYPE,
        p_nr_telefon           IN clienti.nr_telefon%TYPE,
        p_data_obt_permis      IN clienti.data_obt_permis%TYPE,
        p_data_nasterii        IN clienti.data_nasterii%TYPE
    ) IS

        check_constraint_violated EXCEPTION;
        PRAGMA exception_init ( check_constraint_violated, -2290 );
        unique_constraint_violated EXCEPTION;
        PRAGMA exception_init ( unique_constraint_violated, -00001 );
    BEGIN
        INSERT INTO clienti VALUES (
            NULL,
            p_serie_act_identitate,
            p_tip_act,
            p_nume,
            p_prenume,
            p_email,
            p_nr_telefon,
            p_data_obt_permis,
            p_data_nasterii
        );

    EXCEPTION
        WHEN check_constraint_violated THEN
            dbms_output.put_line('INSERT failed due to check constraint violation');
        WHEN unique_constraint_violated THEN
            dbms_output.put_line('INSERT failed due to unique constraint violation');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END add_clienti;

    PROCEDURE update_clienti_telefon (
        p_nr_telefon IN clienti.nr_telefon%TYPE,
        p_id_client  IN clienti.id_client%TYPE
    ) IS

        check_constraint_violated EXCEPTION;
        PRAGMA exception_init ( check_constraint_violated, -2290 );
        unique_constraint_violated EXCEPTION;
        PRAGMA exception_init ( unique_constraint_violated, -00001 );
    BEGIN
        UPDATE clienti
        SET
            nr_telefon = p_nr_telefon
        WHERE
            id_client = p_id_client;

        IF SQL%rowcount = 0 THEN
            dbms_output.put_line('Clientul '
                                 || p_id_client
                                 || ' nu exista');
        END IF;

    EXCEPTION
        WHEN unique_constraint_violated THEN
            dbms_output.put_line('Numarul de telefon al clientului trebuie sa fie unic');
        WHEN check_constraint_violated THEN
            dbms_output.put_line('Formatul pentru numarul de telefon nu este respectat');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END update_clienti_telefon;

    PROCEDURE update_clienti_email (
        p_email     IN clienti.email%TYPE,
        p_id_client IN clienti.id_client%TYPE
    ) IS

        unique_constraint_violated EXCEPTION;
        PRAGMA exception_init ( unique_constraint_violated, -00001 );
        check_constraint_violated EXCEPTION;
        PRAGMA exception_init ( check_constraint_violated, -2290 );
    BEGIN
        UPDATE clienti
        SET
            email = p_email
        WHERE
            id_client = p_id_client;

        IF SQL%rowcount = 0 THEN
            dbms_output.put_line('Clientul '
                                 || p_id_client
                                 || ' nu exista');
        END IF;

    EXCEPTION
        WHEN unique_constraint_violated THEN
            dbms_output.put_line('Emailul clientului trebuie sa fie unic');
        WHEN check_constraint_violated THEN
            dbms_output.put_line('Formatul pentru email nu este respectat');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END update_clienti_email;

END clienti_pack;
/

CREATE OR REPLACE PACKAGE CONTRACTE_PACK
IS
    PROCEDURE ADD_CONTRACTE (
                             p_data_inchiriere in contracte_inchirieri.data_inchiriere%TYPE,
                             p_data_retur in contracte_inchirieri.data_retur%TYPE,
                             p_nume in clienti.nume%TYPE,
                             p_prenume in clienti.prenume%TYPE,
                             p_nr_inmatriculare in masini.nr_inmatriculare%TYPE
                           );
    PROCEDURE UPDATE_DATA_RETUR (
                            p_nr_contract contracte_inchirieri.nr_contract%TYPE,
                            p_data_retur in contracte_inchirieri.data_retur%TYPE
                        );
    PROCEDURE UPDATE_DATA_INCHIRIERE (
                            p_nr_contract contracte_inchirieri.nr_contract%TYPE,
                            p_data_inchiriere in contracte_inchirieri.data_inchiriere%TYPE,
                            p_nr_inmatriculare in masini.nr_inmatriculare%TYPE
                        );
END CONTRACTE_PACK;
/

CREATE OR REPLACE PACKAGE BODY contracte_pack IS

    PROCEDURE add_contracte (
        p_data_inchiriere  IN contracte_inchirieri.data_inchiriere%TYPE,
        p_data_retur       IN contracte_inchirieri.data_retur%TYPE,
        p_nume             IN clienti.nume%TYPE,
        p_prenume          IN clienti.prenume%TYPE,
        p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE
    ) IS

        v_tarif          detalii_masini.tarif%TYPE;
        v_tarif_calculat contracte_inchirieri.tarif%TYPE := 0;
        data_invalida EXCEPTION;
        data_egala EXCEPTION;
        CURSOR c_tarif IS
        SELECT
            tarif
        FROM
            detalii_masini
        WHERE
            id_masina = get_id_masina(p_nr_inmatriculare);

    BEGIN
        OPEN c_tarif;
        LOOP
            FETCH c_tarif INTO v_tarif;
            EXIT WHEN c_tarif%notfound;
            v_tarif_calculat := ( p_data_retur - p_data_inchiriere ) * v_tarif;
            BEGIN
                IF p_data_retur < p_data_inchiriere THEN
                    RAISE data_invalida;
                ELSIF p_data_retur = p_data_inchiriere THEN
                    RAISE data_egala;
                ELSE
                    INSERT INTO contracte_inchirieri VALUES (
                        NULL,
                        p_data_inchiriere,
                        p_data_retur,
                        v_tarif_calculat,
                        get_id_client(p_nume, p_prenume),
                        get_id_masina(p_nr_inmatriculare)
                    );

                    IF p_data_retur > sysdate THEN
                        UPDATE masini
                        SET
                            status = 1
                        WHERE
                            id_masina = (
                                SELECT
                                    id_masina
                                FROM
                                    masini
                                WHERE
                                    nr_inmatriculare = p_nr_inmatriculare
                            );

                        IF SQL%rowcount = 0 THEN
                            dbms_output.put_line('Masina cu numarul de inmatriculare '
                                                 || p_nr_inmatriculare
                                                 || ' nu exista');
                        END IF;

                    END IF;

                END IF;
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('SELECT did not return any row');
                WHEN data_invalida THEN
                    dbms_output.put_line('data_retur trebuie sa fie mai mare decat data_inchiriere');
                WHEN data_egala THEN
                    dbms_output.put_line('Masina poate fi inchiriata minim o zi');
                WHEN OTHERS THEN
                    dbms_output.put_line('Something else went wrong - '
                                         || sqlcode
                                         || ' : '
                                         || sqlerrm);
            END;

        END LOOP;

        CLOSE c_tarif;
    END add_contracte;

    PROCEDURE update_data_retur (
        p_nr_contract contracte_inchirieri.nr_contract%TYPE,
        p_data_retur  IN contracte_inchirieri.data_retur%TYPE
    ) IS

        ultima_data_retur      contracte_inchirieri.data_retur%TYPE;
        numar_inchirieri       NUMBER;
        v_numar_contract       contracte_inchirieri.nr_contract%TYPE;
        masina_inchiriata EXCEPTION;
        v_tarif                detalii_masini.tarif%TYPE;
        v_tarif_calculat       contracte_inchirieri.tarif%TYPE := 0;
        data_invalida EXCEPTION;
        v_data_inchiriere      contracte_inchirieri.data_inchiriere%TYPE;
        ultima_data_inchiriere contracte_inchirieri.data_inchiriere%TYPE;
        CURSOR c_tarif IS
        SELECT
            tarif
        FROM
            detalii_masini
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

    BEGIN
        SELECT
            MAX(data_inchiriere)
        INTO ultima_data_inchiriere
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            MAX(data_retur)
        INTO ultima_data_retur
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            COUNT(*)
        INTO numar_inchirieri
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            nr_contract
        INTO v_numar_contract
        FROM
            contracte_inchirieri
        WHERE
            data_retur = ultima_data_retur
        ORDER BY
            nr_contract DESC;

        SELECT
            data_inchiriere
        INTO v_data_inchiriere
        FROM
            contracte_inchirieri
        WHERE
                id_masina = get_id_masina_contracte(p_nr_contract)
            AND nr_contract = p_nr_contract;

        OPEN c_tarif;
        LOOP
            FETCH c_tarif INTO v_tarif;
            EXIT WHEN c_tarif%notfound;
            BEGIN
                IF p_data_retur < v_data_inchiriere THEN
                    RAISE data_invalida;
                ELSE
                    v_tarif_calculat := ( p_data_retur - v_data_inchiriere ) * v_tarif;
                    IF numar_inchirieri = 1 THEN
                        UPDATE contracte_inchirieri
                        SET
                            data_retur = p_data_retur,
                            tarif = v_tarif_calculat
                        WHERE
                            nr_contract = p_nr_contract;

                    END IF;

                    IF numar_inchirieri > 1 THEN
                        IF p_nr_contract = v_numar_contract THEN
                            UPDATE contracte_inchirieri
                            SET
                                data_retur = p_data_retur,
                                tarif = v_tarif_calculat
                            WHERE
                                nr_contract = p_nr_contract;

                        END IF;

                        IF p_data_retur < ultima_data_inchiriere THEN
                            UPDATE contracte_inchirieri
                            SET
                                data_retur = p_data_retur,
                                tarif = v_tarif_calculat
                            WHERE
                                nr_contract = p_nr_contract;

                        ELSE
                            RAISE masina_inchiriata;
                        END IF;

                    END IF;

                END IF;
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('SELECT did not return any row');
                WHEN masina_inchiriata THEN
                    dbms_output.put_line('Masina este deja inchiriata pana la data ' || ultima_data_retur);
                WHEN data_invalida THEN
                    dbms_output.put_line('data_retur trebuie sa fie mai mare decat data_inchiriere');
                WHEN OTHERS THEN
                    dbms_output.put_line('Something else went wrong - '
                                         || sqlcode
                                         || ' : '
                                         || sqlerrm);
            END;

        END LOOP;

        CLOSE c_tarif;
    END update_data_retur;

    PROCEDURE update_data_inchiriere (
        p_nr_contract      contracte_inchirieri.nr_contract%TYPE,
        p_data_inchiriere  IN contracte_inchirieri.data_inchiriere%TYPE,
        p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE
    ) IS

        ultima_data_retur      contracte_inchirieri.data_retur%TYPE;
        ultima_data_inchiriere contracte_inchirieri.data_inchiriere%TYPE;
        numar_inchirieri       NUMBER;
        v_numar_contract       contracte_inchirieri.nr_contract%TYPE;
        masina_inchiriata EXCEPTION;
        v_tarif                detalii_masini.tarif%TYPE;
        v_tarif_calculat       contracte_inchirieri.tarif%TYPE := 0;
        data_invalida EXCEPTION;
        data_comparare         contracte_inchirieri.data_retur%TYPE;
        v_data_retur           contracte_inchirieri.data_retur%TYPE;
        CURSOR c_tarif IS
        SELECT
            tarif
        FROM
            detalii_masini
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

    BEGIN
        SELECT
            MAX(data_retur)
        INTO ultima_data_retur
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            MAX(data_inchiriere)
        INTO ultima_data_inchiriere
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            COUNT(*)
        INTO numar_inchirieri
        FROM
            contracte_inchirieri
        WHERE
            id_masina = get_id_masina_contracte(p_nr_contract);

        SELECT
            nr_contract
        INTO v_numar_contract
        FROM
            contracte_inchirieri
        WHERE
            data_retur = ultima_data_retur
        ORDER BY
            nr_contract DESC;

        SELECT
            MAX(data_retur)
        INTO data_comparare
        FROM
            contracte_inchirieri
        WHERE
            data_retur IN (
                SELECT
                    data_retur
                FROM
                    contracte_inchirieri
                MINUS
                SELECT
                    MAX(data_retur)
                FROM
                    contracte_inchirieri
                WHERE
                    id_masina = get_id_masina(p_nr_inmatriculare)
            );

        SELECT
            data_retur
        INTO v_data_retur
        FROM
            contracte_inchirieri
        WHERE
                id_masina = get_id_masina_contracte(p_nr_contract)
            AND nr_contract = v_numar_contract;

        OPEN c_tarif;
        LOOP
            FETCH c_tarif INTO v_tarif;
            EXIT WHEN c_tarif%notfound;
            BEGIN
                IF v_data_retur < p_data_inchiriere THEN
                    RAISE data_invalida;
                ELSE
                    v_tarif_calculat := ( v_data_retur - p_data_inchiriere ) * v_tarif;
                    IF numar_inchirieri = 1 THEN
                        UPDATE contracte_inchirieri
                        SET
                            data_inchiriere = p_data_inchiriere,
                            tarif = v_tarif_calculat
                        WHERE
                            nr_contract = p_nr_contract;

                    END IF;

                    IF numar_inchirieri > 1 THEN
                        IF p_data_inchiriere < data_comparare THEN
                            RAISE masina_inchiriata;
                        ELSE
                            UPDATE contracte_inchirieri
                            SET
                                data_inchiriere = p_data_inchiriere,
                                tarif = v_tarif_calculat
                            WHERE
                                nr_contract = p_nr_contract;

                        END IF;
                    END IF;

                END IF;
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('SELECT did not return any row');
                WHEN masina_inchiriata THEN
                    dbms_output.put_line('Masina este deja inchiriata incepand cu ' || ultima_data_inchiriere);
                WHEN data_invalida THEN
                    dbms_output.put_line('data_retur trebuie sa fie mai mare decat data_inchiriere');
                WHEN OTHERS THEN
                    dbms_output.put_line('Something else went wrong - '
                                         || sqlcode
                                         || ' : '
                                         || sqlerrm);
            END;

        END LOOP;

        CLOSE c_tarif;
    END update_data_inchiriere;

END contracte_pack;
/

CREATE OR REPLACE PACKAGE MASINI_DETALII_PACK
IS
    PROCEDURE ADD_MASINI(   p_nr_inmatriculare in masini.nr_inmatriculare%TYPE,
                            p_marca in detalii_masini.marca%TYPE,
                            p_clasa in detalii_masini.clasa%TYPE,
                            p_an_fabricatie in detalii_masini.an_fabricatie%TYPE,
                            p_carburant in detalii_masini.carburant%TYPE,
                            p_culoare in detalii_masini.culoare%TYPE, 
                            p_transmisie in detalii_masini.transmisie%TYPE, 
                            p_consum in detalii_masini.consum%TYPE, 
                            p_tarif in detalii_masini.tarif%TYPE);
    PROCEDURE UPDATE_MASINI_TARIF ( p_nr_inmatriculare in masini.nr_inmatriculare%TYPE,
                                    p_tarif in detalii_masini.tarif%TYPE);

END MASINI_DETALII_PACK;
/

CREATE OR REPLACE PACKAGE BODY masini_detalii_pack IS

    PROCEDURE add_masini (
        p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE,
        p_marca            IN detalii_masini.marca%TYPE,
        p_clasa            IN detalii_masini.clasa%TYPE,
        p_an_fabricatie    IN detalii_masini.an_fabricatie%TYPE,
        p_carburant        IN detalii_masini.carburant%TYPE,
        p_culoare          IN detalii_masini.culoare%TYPE,
        p_transmisie       IN detalii_masini.transmisie%TYPE,
        p_consum           IN detalii_masini.consum%TYPE,
        p_tarif            IN detalii_masini.tarif%TYPE
    ) IS

        check_constraint_violated EXCEPTION;
        PRAGMA exception_init ( check_constraint_violated, -2290 );
        unique_constraint_violated EXCEPTION;
        PRAGMA exception_init ( unique_constraint_violated, -00001 );
    BEGIN
        INSERT INTO masini VALUES (
            NULL,
            p_nr_inmatriculare,
            0
        );

        INSERT INTO detalii_masini VALUES (
            p_marca,
            p_clasa,
            p_an_fabricatie,
            p_carburant,
            p_culoare,
            p_transmisie,
            p_consum,
            p_tarif,
            get_id_masina(p_nr_inmatriculare)
        );

        COMMIT;
    EXCEPTION
        WHEN check_constraint_violated THEN
            dbms_output.put_line('INSERT failed due to check constraint violation');
        WHEN unique_constraint_violated THEN
            dbms_output.put_line('INSERT failed due to unique constraint violation');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END add_masini;

    PROCEDURE update_masini_tarif (
        p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE,
        p_tarif            IN detalii_masini.tarif%TYPE
    ) IS
    BEGIN
        UPDATE detalii_masini
        SET
            tarif = p_tarif
        WHERE
            id_masina = get_id_masina(p_nr_inmatriculare);

        IF SQL%rowcount = 0 THEN
            dbms_output.put_line('Masina cu numarul de inmatriculare '
                                 || p_nr_inmatriculare
                                 || ' nu exista');
        END IF;

    END update_masini_tarif;

END masini_detalii_pack;
/


CREATE OR REPLACE PACKAGE VIZUALIZARE_PACK IS
    --afiseaza numele si prenumele impreuna cu masina inchiriata de un anumit client
    PROCEDURE AFISARE_INCHIRIERE;
    --afiseaza toate inchirierile efectuate dupa data respectiva
    PROCEDURE AFISARE_CONTRACTE_DATA(v_data contracte_inchirieri.data_inchiriere%TYPE);
    --afisarea tuturor masinilor care nu sunt inchiriate
    PROCEDURE AFISARE_MASINI_DISPONIBILE;
    --afisarea masinilor inchiriate la data curenta
    PROCEDURE AFISARE_MASINI_INCHIRIATE;
END VIZUALIZARE_PACK;
/

CREATE OR REPLACE PACKAGE BODY vizualizare_pack IS

    PROCEDURE afisare_inchiriere IS

        CURSOR c1 IS
        SELECT DISTINCT
            nume,
            prenume,
            nr_inmatriculare
        FROM
            clienti, masini
            CROSS JOIN contracte_inchirieri
        WHERE
                clienti.id_client = contracte_inchirieri.id_client
            AND masini.id_masina = contracte_inchirieri.id_masina;

    BEGIN
        FOR i IN c1 LOOP
            dbms_output.put_line('Clientul '
                                 || i.nume
                                 || ' '
                                 || i.prenume
                                 || ' a inchiriat masina '
                                 || i.nr_inmatriculare);
        END LOOP;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('SELECT did not return any row');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END afisare_inchiriere;

    PROCEDURE afisare_contracte_data (
        v_data contracte_inchirieri.data_inchiriere%TYPE
    ) IS

        CURSOR c2 IS
        SELECT
            masini.nr_inmatriculare,
            data_inchiriere
        FROM
            masini,
            contracte_inchirieri
        WHERE
                masini.id_masina = contracte_inchirieri.id_masina
            AND data_inchiriere > v_data;

    BEGIN
        FOR i IN c2 LOOP
            dbms_output.put_line('Masina '
                                 || i.nr_inmatriculare
                                 || ' a fost inchiriata la data '
                                 || i.data_inchiriere);
        END LOOP;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('SELECT did not return any row');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END afisare_contracte_data;

    PROCEDURE afisare_masini_disponibile IS

        CURSOR c3 IS
        SELECT
            nr_inmatriculare
        FROM
            masini
        WHERE
            id_masina NOT IN (
                SELECT
                    id_masina
                FROM
                    contracte_inchirieri
                WHERE
                    data_retur >= sysdate
            )
        ORDER BY
            id_masina;

    BEGIN
        FOR i IN c3 LOOP
            dbms_output.put_line('Masina '
                                 || i.nr_inmatriculare
                                 || ' nu este inchiriata');
        END LOOP;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('SELECT did not return any row');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END afisare_masini_disponibile;

    PROCEDURE afisare_masini_inchiriate IS
        CURSOR c4 IS
        SELECT
            *
        FROM
            contracte_inchirieri
        WHERE
            data_retur > sysdate;

    BEGIN
        FOR i IN c4 LOOP
            dbms_output.put_line('Masina '
                                 || i.id_masina
                                 || ' este inchiriata de la '
                                 || i.data_inchiriere
                                 || ' pana la '
                                 || i.data_retur
                                 || ' de clientul '
                                 || i.id_client
                                 || ' care are de platit '
                                 || i.tarif);
        END LOOP;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('SELECT did not return any row');
        WHEN OTHERS THEN
            dbms_output.put_line('Something else went wrong - '
                                 || sqlcode
                                 || ' : '
                                 || sqlerrm);
    END afisare_masini_inchiriate;

END vizualizare_pack;
/
