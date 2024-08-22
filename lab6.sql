CREATE TABLE Recipes (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(20),
  	Ingredients VARCHAR2(20)
);

CREATE TABLE Application_Methods (
    ID  NUMBER PRIMARY KEY,
    Name VARCHAR2(20)
);
CREATE TABLE Preparation_Methods (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(20)
);

CREATE TABLE Finished_Medicines (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(20),
    A_Method_ID NUMBER,
    FOREIGN KEY (A_Method_ID) REFERENCES Application_Methods(ID)
);

CREATE TABLE Unfinished_Medicines (
	ID NUMBER PRIMARY KEY,
    Name VARCHAR2(20),
    A_Method_ID NUMBER,
    P_Method_ID NUMBER,
  	Recipe_ID NUMBER,
  	P_Time NUMBER,
    FOREIGN KEY (A_Method_ID) REFERENCES Application_Methods(ID),
    FOREIGN KEY (P_Method_ID) REFERENCES Preparation_Methods(ID),
    FOREIGN KEY (Recipe_ID) REFERENCES Recipes(ID)
);

CREATE TABLE Deletion_Logs (
    Log_ID NUMBER PRIMARY KEY,
    Table_Name VARCHAR2(30),
    Record_ID NUMBER,
    Deleted_By VARCHAR2(30),
    Deletion_Date TIMESTAMP,
    Details VARCHAR2(4000)
);

ALTER TABLE Recipes MODIFY (Name VARCHAR2(100));
ALTER TABLE Recipes MODIFY (Ingredients VARCHAR2(100));
ALTER TABLE Application_Methods MODIFY (Name VARCHAR2(100));
ALTER TABLE Preparation_Methods MODIFY (Name VARCHAR2(100));
ALTER TABLE Finished_Medicines MODIFY (Name VARCHAR2(100));
ALTER TABLE Unfinished_Medicines MODIFY (Name VARCHAR2(100));


ALTER TABLE Recipes ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP;

ALTER TABLE Application_Methods ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP;

ALTER TABLE Preparation_Methods ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP;

ALTER TABLE Finished_Medicines ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP;

ALTER TABLE Unfinished_Medicines ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP;


--Sequences
CREATE SEQUENCE Deletion_Logs_Seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE Recipes_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE Application_Methods_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE Preparation_Methods_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE Finished_Medicines_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE Unfinished_Medicines_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER recipes_auto_generate
BEFORE INSERT ON Recipes
FOR EACH ROW
BEGIN
    SELECT Recipes_seq.nextval
    INTO :NEW.ID
    FROM dual;
END;
-- auto generate triggers 
CREATE OR REPLACE TRIGGER deletion_logs_auto_generate
BEFORE INSERT ON Deletion_Logs
FOR EACH ROW
BEGIN
    SELECT Deletion_Logs_Seq.nextval
    INTO :NEW.Log_ID
    FROM dual;
END;



CREATE OR REPLACE TRIGGER application_methods_auto_generate
BEFORE INSERT ON Application_Methods
FOR EACH ROW
BEGIN
    SELECT Application_Methods_seq.nextval
    INTO :NEW.ID
    FROM dual;
END;

CREATE OR REPLACE TRIGGER preparation_methodsauto_generate
BEFORE INSERT ON Preparation_Methods
FOR EACH ROW
BEGIN
    SELECT Preparation_Methods_seq.nextval
    INTO :NEW.ID
    FROM dual;
END;

CREATE OR REPLACE TRIGGER finished_medicines_generate
BEFORE INSERT ON Finished_Medicines
FOR EACH ROW
BEGIN
    SELECT Finished_Medicines_seq.nextval
    INTO :NEW.ID
    FROM dual;
END;

CREATE OR REPLACE TRIGGER unfinished_medicinesauto_generate
BEFORE INSERT ON Unfinished_Medicines
FOR EACH ROW
BEGIN
    SELECT Unfinished_Medicines_seq.nextval
    INTO :NEW.ID
    FROM dual;
END;
--row deletion triggers
CREATE OR REPLACE TRIGGER recipes_deletion_log
AFTER DELETE ON Recipes
FOR EACH ROW
BEGIN
    INSERT INTO Deletion_Logs ( Table_Name, Record_ID, Deleted_By, Deletion_Date, Details)
    VALUES ('Recipes', :OLD.ID, USER, SYSTIMESTAMP, 'Name: ' || :OLD.Name || ', Ingredients: ' || :OLD.Ingredients);
END;



CREATE OR REPLACE TRIGGER application_methods_deletion_log
AFTER DELETE ON Application_Methods
FOR EACH ROW
BEGIN
    INSERT INTO Deletion_Logs ( Table_Name, Record_ID, Deleted_By, Deletion_Date, Details)
    VALUES ( 'Application_Methods', :OLD.ID, USER, SYSTIMESTAMP, 'Name: ' || :OLD.Name);
END;

CREATE OR REPLACE TRIGGER preparation_methods_deletion_log
AFTER DELETE ON Preparation_Methods
FOR EACH ROW
BEGIN
    INSERT INTO Deletion_Logs (Table_Name, Record_ID, Deleted_By, Deletion_Date, Details)
    VALUES ('Preparation_Methods', :OLD.ID, USER, SYSTIMESTAMP, 'Name: ' || :OLD.Name);
END;

CREATE OR REPLACE TRIGGER finished_medicines_deletion_log
AFTER DELETE ON Finished_Medicines
FOR EACH ROW
BEGIN
    INSERT INTO Deletion_Logs (Table_Name, Record_ID, Deleted_By, Deletion_Date, Details)
    VALUES ('Finished_Medicines', :OLD.ID, USER, SYSTIMESTAMP, 'Name: ' || :OLD.Name || ', A_Method_ID: ' || :OLD.A_Method_ID);
END;

CREATE OR REPLACE TRIGGER unfinished_medicines_deletion_log
AFTER DELETE ON Unfinished_Medicines
FOR EACH ROW
BEGIN
    INSERT INTO Deletion_Logs (Table_Name, Record_ID, Deleted_By, Deletion_Date, Details)
    VALUES ('Unfinished_Medicines', :OLD.ID, USER, SYSTIMESTAMP, 'Name: ' || :OLD.Name || ', A_Method_ID: ' || :OLD.A_Method_ID || ', P_Method_ID: ' || :OLD.P_Method_ID || ', Recipe_ID: ' || :OLD.Recipe_ID || ', P_Time: ' || :OLD.P_Time);
END;
--update triggers
CREATE OR REPLACE TRIGGER recipes_update_trigger
BEFORE UPDATE ON Recipes
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;

CREATE OR REPLACE TRIGGER application_methods_update_trigger
BEFORE UPDATE ON Application_Methods
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;

CREATE OR REPLACE TRIGGER preparation_methods_update_trigger
BEFORE UPDATE ON Preparation_Methods
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;

CREATE OR REPLACE TRIGGER finished_medicines_update_trigger
BEFORE UPDATE ON Finished_Medicines
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;

CREATE OR REPLACE TRIGGER unfinished_medicines_update_trigger
BEFORE UPDATE ON Unfinished_Medicines
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;

INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'Herbal Tea', 'Herbs, Water');
INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'Cough Syrup', 'Honey, Lemon, Ginger');
INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'Pain Balm', 'Menthol, Camphor, Eucalyptus Oil');
INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'Herbal Capsule', 'Herbal Extract, Gelatin');
INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'Energy Drink', 'Ginseng, Vitamin B12, Water');
select * from Recipes;

INSERT INTO Application_Methods ( Name) VALUES ( 'Oral');
INSERT INTO Application_Methods ( Name) VALUES ( 'Topical');
INSERT INTO Application_Methods ( Name) VALUES ( 'Inhalation');
INSERT INTO Application_Methods ( Name) VALUES ( 'Injection');
INSERT INTO Application_Methods ( Name) VALUES ( 'Sublingual');
select * from Application_Methods;

INSERT INTO Preparation_Methods ( Name) VALUES ( 'Boiling');
INSERT INTO Preparation_Methods ( Name) VALUES ( 'Mixing');
INSERT INTO Preparation_Methods ( Name) VALUES ( 'Grinding');
INSERT INTO Preparation_Methods ( Name) VALUES ( 'Extraction');
INSERT INTO Preparation_Methods ( Name) VALUES ( 'Fermentation');
select * from Preparation_Methods;

INSERT INTO Finished_Medicines ( Name, A_Method_ID) VALUES ( 'Herbal Tea Bag', 1);
INSERT INTO Finished_Medicines ( Name, A_Method_ID) VALUES ( 'Cough Syrup Bottle', 1);
INSERT INTO Finished_Medicines ( Name, A_Method_ID) VALUES ( 'Pain Balm Tube', 2);
INSERT INTO Finished_Medicines ( Name, A_Method_ID) VALUES ( 'Herbal Capsule Box', 1);
INSERT INTO Finished_Medicines ( Name, A_Method_ID) VALUES ( 'Energy Drink Can', 1);
select * from Finished_Medicines;

INSERT INTO Unfinished_Medicines ( Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) VALUES ( 'Herbal Tea Mixture', 1, 1, 1, 30);
INSERT INTO Unfinished_Medicines ( Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) VALUES ( 'Cough Syrup Mixture', 1, 2, 2, 15);
INSERT INTO Unfinished_Medicines ( Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) VALUES ( 'Pain Balm Base', 2, 3, 3, 45);
INSERT INTO Unfinished_Medicines ( Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) VALUES ( 'Herbal Extract', 1, 4, 4, 60);
INSERT INTO Unfinished_Medicines ( Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) VALUES ( 'Energy Drink Concentrate', 1, 5, 5, 20);
select * from Unfinished_Medicines;

DELETE FROM Recipes
WHERE ID = 2;
DELETE FROM Application_Methods
WHERE ID = 3;

DELETE FROM Finished_Medicines
WHERE ID = 4;

DELETE FROM Preparation_Methods
WHERE ID = 5;

DELETE FROM Unfinished_Medicines
WHERE ID = 2;
select * from Deletion_Logs;

--combined trigger
CREATE OR REPLACE TRIGGER combined_trigger
BEFORE INSERT OR UPDATE OR DELETE ON Recipes
FOR EACH ROW
DECLARE
    operation VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        operation := 'INSERT';
    ELSIF UPDATING THEN
        operation := 'UPDATE';
    ELSIF DELETING THEN
        operation := 'DELETE';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Triggered ' || operation || ' operation on Recipes table');
END;

INSERT INTO Recipes ( Name, Ingredients) VALUES ( 'SomeName2', 'SomeIngredients2');

