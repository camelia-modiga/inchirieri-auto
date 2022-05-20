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
END CLIENTI_PACK;
/

CREATE OR REPLACE PACKAGE BODY CLIENTI_PACK
IS
        PROCEDURE ADD_CLIENTI (p_serie_act_identitate in clienti.serie_act_identitate%TYPE, 
                           p_tip_act in clienti.tip_act%TYPE, 
                           p_nume in clienti.nume%TYPE, 
                           p_prenume in clienti.prenume%TYPE, 
                           p_email in clienti.email%TYPE, 
                           p_nr_telefon in clienti.nr_telefon%TYPE,
                           p_data_obt_permis in clienti.data_obt_permis%TYPE, 
                           p_data_nasterii in clienti.data_nasterii%TYPE) IS 
    BEGIN  
        INSERT INTO CLIENTI VALUES(null, p_serie_act_identitate, p_tip_act, p_nume, p_prenume, p_email, p_nr_telefon, p_data_obt_permis, p_data_nasterii);
    END ADD_CLIENTI;
    
END CLIENTI_PACK;
/


CREATE OR REPLACE FUNCTION GET_ID_MASINA (p_nr_inmatriculare IN masini.nr_inmatriculare%TYPE) 
RETURN NUMBER IS
 v_id masini.id_masina%TYPE;
    BEGIN
   SELECT id_masina INTO v_id FROM masini WHERE nr_inmatriculare = p_nr_inmatriculare;
      RETURN v_id;
END GET_ID_MASINA;
/

CREATE OR REPLACE FUNCTION GET_ID_CLIENT (p_nume IN clienti.nume%TYPE, p_prenume IN clienti.prenume%TYPE)
RETURN NUMBER IS
     v_id clienti.id_client%TYPE;
    BEGIN
        SELECT id_client INTO v_id FROM clienti WHERE nume = p_nume AND prenume = p_prenume;
    RETURN v_id;
END GET_ID_CLIENT;
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

END MASINI_DETALII_PACK;
/

CREATE OR REPLACE PACKAGE BODY MASINI_DETALII_PACK
IS
    PROCEDURE ADD_MASINI(   p_nr_inmatriculare in masini.nr_inmatriculare%TYPE,
                            p_marca in detalii_masini.marca%TYPE,
                            p_clasa in detalii_masini.clasa%TYPE,
                            p_an_fabricatie in detalii_masini.an_fabricatie%TYPE,
                            p_carburant in detalii_masini.carburant%TYPE,
                            p_culoare in detalii_masini.culoare%TYPE, 
                            p_transmisie in detalii_masini.transmisie%TYPE, 
                            p_consum in detalii_masini.consum%TYPE, 
                            p_tarif in detalii_masini.tarif%TYPE) IS 
    BEGIN 

        INSERT INTO MASINI VALUES(null, p_nr_inmatriculare, 0);
        INSERT INTO DETALII_MASINI VALUES(p_marca,p_clasa,p_an_fabricatie,p_carburant,p_culoare,p_transmisie,p_consum,p_tarif,GET_ID_MASINA(p_nr_inmatriculare));
        COMMIT;
    END ADD_MASINI;

END MASINI_DETALII_PACK;
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
                            p_data_retur in contracte_inchirieri.data_retur%TYPE,
                            p_nr_inmatriculare in masini.nr_inmatriculare%TYPE
    );
END CONTRACTE_PACK;
/

CREATE OR REPLACE PACKAGE BODY CONTRACTE_PACK
IS
        PROCEDURE ADD_CONTRACTE (
                             p_data_inchiriere in contracte_inchirieri.data_inchiriere%TYPE,
                             p_data_retur in contracte_inchirieri.data_retur%TYPE,
                             p_nume in clienti.nume%TYPE,
                             p_prenume in clienti.prenume%TYPE,
                             p_nr_inmatriculare in masini.nr_inmatriculare%TYPE) IS 
        v_tarif detalii_masini.tarif%TYPE;
        v_tarif_calculat contracte_inchirieri.tarif%TYPE := 0;
       
        CURSOR c_tarif is 
            SELECT tarif FROM detalii_masini WHERE id_masina=GET_ID_MASINA(p_nr_inmatriculare);
    
    BEGIN  
         OPEN c_tarif;
             LOOP 
                FETCH c_tarif INTO v_tarif;
                EXIT WHEN c_tarif%NOTFOUND;
                v_tarif_calculat := (p_data_retur - p_data_inchiriere) * v_tarif;
                BEGIN 
                    INSERT INTO contracte_inchirieri VALUES (null, p_data_inchiriere, p_data_retur, v_tarif_calculat, GET_ID_CLIENT(p_nume, p_prenume), GET_ID_MASINA(p_nr_inmatriculare)); 
                END;
             END LOOP; 
         CLOSE c_tarif; 
    END ADD_CONTRACTE;
    
    PROCEDURE UPDATE_DATA_RETUR (
                            p_nr_contract contracte_inchirieri.nr_contract%TYPE,
                            p_data_retur in contracte_inchirieri.data_retur%TYPE,
                            p_nr_inmatriculare in masini.nr_inmatriculare%TYPE) IS
    ultima_data_retur contracte_inchirieri.data_retur%TYPE;
    ultima_data_inchiriere contracte_inchirieri.data_inchiriere%TYPE;
    numar_inchirieri NUMBER;
    v_numar_contract contracte_inchirieri.nr_contract%TYPE;
    masina_inchiriata EXCEPTION;
    v_tarif detalii_masini.tarif%TYPE;
    v_tarif_calculat contracte_inchirieri.tarif%TYPE := 0;
       
    CURSOR c_tarif is 
        SELECT tarif FROM detalii_masini WHERE id_masina=GET_ID_MASINA(p_nr_inmatriculare);
        
    BEGIN
        SELECT MAX(data_retur) INTO ultima_data_retur FROM contracte_inchirieri WHERE id_masina = GET_ID_MASINA(p_nr_inmatriculare);
        SELECT MAX(data_inchiriere) INTO ultima_data_inchiriere FROM contracte_inchirieri WHERE id_masina = GET_ID_MASINA(p_nr_inmatriculare);
        SELECT COUNT(*) INTO numar_inchirieri FROM contracte_inchirieri WHERE id_masina = GET_ID_MASINA(p_nr_inmatriculare);
        SELECT nr_contract INTO v_numar_contract FROM contracte_inchirieri WHERE data_retur = ultima_data_retur ORDER BY nr_contract DESC;
        OPEN c_tarif;
            LOOP
                FETCH c_tarif INTO v_tarif;
                EXIT WHEN c_tarif%NOTFOUND;
                v_tarif_calculat := (p_data_retur - ultima_data_inchiriere) * v_tarif;
                BEGIN
                    IF numar_inchirieri = 1 THEN 
                        UPDATE contracte_inchirieri SET data_retur = p_data_retur,tarif = v_tarif_calculat WHERE nr_contract = p_nr_contract;
                    END IF;
                    IF numar_inchirieri > 1 THEN
                        IF p_nr_contract = v_numar_contract THEN
                            UPDATE contracte_inchirieri SET data_retur = p_data_retur,tarif = v_tarif_calculat WHERE nr_contract = p_nr_contract;
                        END IF;
                        IF p_data_retur > ultima_data_retur THEN 
                            UPDATE contracte_inchirieri SET data_retur = p_data_retur,tarif = v_tarif_calculat WHERE nr_contract = p_nr_contract;
                        ELSE 
                            RAISE masina_inchiriata;
                        END IF; 
                    END IF;
                EXCEPTION WHEN masina_inchiriata THEN
                    dbms_output.put_line('Masina este deja inchiriata pana la data ' || ultima_data_retur);
                END;
            END LOOP;
        CLOSE c_tarif;
    END UPDATE_DATA_RETUR;
                        
END CONTRACTE_PACK;
/


CREATE OR REPLACE PACKAGE VIZUALIZARE_PACK IS
    --afiseaza numele si prenumele impreuna cu masina inchiriata de un anumit client
    PROCEDURE AFISARE_INCHIRIERE;
    --afiseaza toate inchirierile efectuate dupa data respectiva
    PROCEDURE AFISARE_CONTRACTE_DATA(v_data contracte_inchirieri.data_inchiriere%TYPE);
    --afisarea tuturor masinilor care nu sunt inchiriate
    PROCEDURE AFISARE_MASINI_DISPONIBILE;
END VIZUALIZARE_PACK;
/


CREATE OR REPLACE PACKAGE BODY VIZUALIZARE_PACK IS
    PROCEDURE AFISARE_INCHIRIERE
    IS 
        CURSOR c1 IS SELECT DISTINCT nume,prenume,nr_inmatriculare FROM clienti,masini
                    CROSS JOIN contracte_inchirieri WHERE clienti.id_client=contracte_inchirieri.id_client AND masini.id_masina=contracte_inchirieri.id_masina;
    BEGIN
        FOR i IN c1 LOOP
            DBMS_OUTPUT.PUT_LINE('Clientul ' || i.nume || ' ' || i.prenume || ' a inchiriat masina ' || i.nr_inmatriculare );
        END LOOP;
    END AFISARE_INCHIRIERE;
    
    PROCEDURE AFISARE_CONTRACTE_DATA(v_data contracte_inchirieri.data_inchiriere%TYPE)
    IS
        CURSOR c2 IS SELECT masini.nr_inmatriculare,data_inchiriere FROM masini,contracte_inchirieri 
                            WHERE masini.id_masina = contracte_inchirieri.id_masina AND data_inchiriere>v_data;
    BEGIN
        FOR i IN c2 LOOP
            DBMS_OUTPUT.PUT_LINE('Masina ' || i.nr_inmatriculare || ' a fost inchiriata la data ' || i.data_inchiriere);
        END LOOP;
    END AFISARE_CONTRACTE_DATA;
    
    PROCEDURE AFISARE_MASINI_DISPONIBILE
    IS
        CURSOR c3 IS SELECT nr_inmatriculare FROM masini 
                        WHERE id_masina NOT IN (SELECT id_masina FROM contracte_inchirieri WHERE data_retur >= SYSDATE) 
                        ORDER BY id_masina;
    BEGIN
        FOR i IN c3 LOOP
            DBMS_OUTPUT.PUT_LINE('Masina ' || i.nr_inmatriculare || ' nu este inchiriata');
        END LOOP;
    END AFISARE_MASINI_DISPONIBILE;    
END VIZUALIZARE_PACK;
/


CREATE OR REPLACE PROCEDURE DELETE_MASINI (p_nr_inmatriculare in masini.nr_inmatriculare%TYPE)  AS 
BEGIN
    DELETE FROM MASINI WHERE nr_inmatriculare=p_nr_inmatriculare;
    IF SQL%NOTFOUND THEN
          dbms_output.put_line('Nu exista masina cu numarul de inmatriculare ' || p_nr_inmatriculare);
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE DELETE_CLIENTI (p_nume in clienti.nume%TYPE, p_prenume in clienti.prenume%TYPE)  AS 
BEGIN
    DELETE FROM CLIENTI WHERE nume = p_nume AND prenume = p_prenume;
    IF SQL%NOTFOUND THEN
          dbms_output.put_line('Nu exista clientul cu numele ' || p_nume || ' ' || p_prenume);
    END IF;
END;
/