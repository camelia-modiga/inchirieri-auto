CREATE OR REPLACE TRIGGER clienti_data_nasterii_trg 
    BEFORE INSERT OR UPDATE ON Clienti 
    FOR EACH ROW 
BEGIN
	IF( :new.data_nasterii >= SYSDATE )
    THEN
        RAISE_APPLICATION_ERROR( -20001,
        'Data invalida: ' || TO_CHAR( :new.data_nasterii, 'DD.MM.YYYY ' ) || ' trebuie sa fie mai mica decat data curenta.' );
END IF; 
END;
/

CREATE OR REPLACE TRIGGER "clienti_data_permis_trg " 
    BEFORE INSERT OR UPDATE ON Clienti 
    FOR EACH ROW 
BEGIN
	IF( :new.data_obt_permis >= SYSDATE )
    THEN
        RAISE_APPLICATION_ERROR( -20001,
        'Data invalida: ' || TO_CHAR( :new.data_obt_permis, 'DD.MM.YYYY ' ) || ' trebuie sa fie mai mica decat data curenta.' );
END IF;
END; 
/


CREATE OR REPLACE TRIGGER contracte_data_nastere_trg 
    BEFORE INSERT OR UPDATE ON Contracte_inchirieri 
    FOR EACH ROW 
DECLARE
	aux_date DATE;
BEGIN
	SELECT Clienti.data_nasterii
	INTO aux_date
	FROM Clienti
	WHERE Clienti.id_client=:new.id_client;
	IF( :new.data_inchiriere - aux_date < 21*365)
	THEN
		RAISE_APPLICATION_ERROR(-20001,
			'Data invalida: ' || TO_CHAR(aux_date,'DD.MM.YYYY') ||('Clientul nu are 21 de ani!!'));
	END IF;
	IF( :new.data_inchiriere - aux_date > 70*365)
	THEN
		RAISE_APPLICATION_ERROR(-20001,
			'Data invalida: ' || TO_CHAR(aux_date,'DD.MM.YYYY') ||('Clientul are 70 de ani!!'));
	END IF;
END; 
/

CREATE OR REPLACE TRIGGER contracte_data_permis_trg 
    BEFORE INSERT OR UPDATE ON Contracte_inchirieri 
    FOR EACH ROW 
DECLARE
	aux_date DATE;
BEGIN
	SELECT Clienti.data_obt_permis
	INTO aux_date
	FROM Clienti
	WHERE Clienti.id_client=:new.id_client;
	IF( :new.data_inchiriere - aux_date < 365)
	THEN
		RAISE_APPLICATION_ERROR(-20001,
			'Data invalida: ' || TO_CHAR(aux_date,'DD.MM.YYYY') ||('Clientul nu are permisul de conducere de cel putin un an!!'));
	END IF;
END; 
/

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
                    'Data invalida: ' || TO_CHAR( :new.data_inchiriere, 'DD.MM.YYYY' ) || ' trebuie sa fie mai mare decat data_retur anterioara.' );
        END IF;
    END IF;
END; 
/
