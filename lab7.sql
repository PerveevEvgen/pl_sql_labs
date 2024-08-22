CREATE OR REPLACE PROCEDURE MaskSensitiveData2 AS
BEGIN
    UPDATE Personss
    SET FirstName = 'Ххххххх',
        MiddleName = NULL,
        LastName = 'Ххххххх',
        EmailAddress = 'xxxxxxxx@xxxx.yyy',
        PhoneNumber = '+380888888888';
END MaskSensitiveData2;

CREATE TABLE Personss (
    ID INT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL
);
INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (1, 'Іван', 'Петрович', 'Петров', 'ivan@example.com', '+380971234567');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (2, 'Марія', 'Олексіївна', 'Сидоренко', 'maria@example.com', '+380971234568');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (3, 'Олександр', 'Ігорович', 'Ковальчук', 'oleksandr@example.com', '+380971234569');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (4, 'Тетяна', 'Сергіївна', 'Павленко', 'tetiana@example.com', '+380971234570');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (5, 'Андрій', 'Олександрович', 'Мельник', 'andriy@example.com', '+380971234571');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (6, 'Ольга', 'Віталіївна', 'Іваненко', 'olga@example.com', '+380971234572');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (7, 'Володимир', 'Миколайович', 'Бондаренко', 'volodymyr@example.com', '+380971234573');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (9, 'Ігор', 'Васильович', 'Григоренко', 'igor@example.com', '+380971234575');

INSERT INTO Personss (ID, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber)
VALUES (10, 'Оксана', 'Анатоліївна', 'Кузьмінська', 'oksana@example.com', '+380971234576');

CALL masksensitivedata2();

CREATE OR REPLACE TYPE MedicineReport AS OBJECT (
    MedicineName VARCHAR2(20),
    ApplicationMethod VARCHAR2(20),
    PreparationMethod VARCHAR2(20),
    RecipeName VARCHAR2(20),
    RecipeIngredients VARCHAR2(20),
    PreparationTime NUMBER
);

ALTER TYPE MedicineReport MODIFY ATTRIBUTE (MedicineName VARCHAR2(100)) CASCADE;
ALTER TYPE MedicineReport MODIFY ATTRIBUTE (ApplicationMethod VARCHAR2(100)) CASCADE;
ALTER TYPE MedicineReport MODIFY ATTRIBUTE (PreparationMethod VARCHAR2(100)) CASCADE;
ALTER TYPE MedicineReport MODIFY ATTRIBUTE (RecipeName VARCHAR2(100)) CASCADE;
ALTER TYPE MedicineReport MODIFY ATTRIBUTE (RecipeIngredients VARCHAR2(100)) CASCADE;


CREATE OR REPLACE TYPE MedicineReportTable AS TABLE OF MedicineReport;

CREATE OR REPLACE FUNCTION GenerateReport RETURN MedicineReportTable IS
    rep_table MedicineReportTable := MedicineReportTable();
BEGIN
    FOR rec IN (SELECT 
                    fm.Name AS MedicineName,
                    am.Name AS ApplicationMethod,
                    pm.Name AS PreparationMethod,
                    r.Name AS RecipeName,
                    r.Ingredients AS RecipeIngredients,
                    um.P_Time AS PreparationTime
                FROM 
                    Finished_Medicines fm
                JOIN 
                    Application_Methods am ON fm.A_Method_ID = am.ID
                LEFT JOIN 
                    Unfinished_Medicines um ON fm.ID = um.ID
                LEFT JOIN 
                    Preparation_Methods pm ON um.P_Method_ID = pm.ID
                LEFT JOIN 
                    Recipes r ON um.Recipe_ID = r.ID)
    LOOP
        rep_table.EXTEND;
        rep_table(rep_table.LAST) := MedicineReport(rec.MedicineName, rec.ApplicationMethod, rec.PreparationMethod, rec.RecipeName, rec.RecipeIngredients, rec.PreparationTime);
    END LOOP;
    
    RETURN rep_table;
END;


SELECT * FROM TABLE(GenerateReport());