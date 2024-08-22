--
CREATE TABLE Recipes (
 ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR2(20),
 Ingredients VARCHAR2(20)
);
CREATE TABLE Application_Methods (
 ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR2(20)
);
CREATE TABLE Preparation_Methods (
 ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR2(20)
);
CREATE TABLE Finished_Medicines (
 ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR2(20),
 A_Method_ID NUMBER,
 FOREIGN KEY (A_Method_ID) REFERENCES Application_Methods(ID)
);
CREATE TABLE Unfinished_Medicines (
ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 Name VARCHAR2(20),
 A_Method_ID NUMBER,
 P_Method_ID NUMBER,
 Recipe_ID NUMBER,
 P_Time NUMBER,
 FOREIGN KEY (A_Method_ID) REFERENCES Application_Methods(ID),
 FOREIGN KEY (P_Method_ID) REFERENCES Preparation_Methods(ID),
 FOREIGN KEY (Recipe_ID) REFERENCES Recipes(ID)
);
--ДОДАНО ОБМЕЖЕННЯ ЦІЛІСНОCТІ
ALTER TABLE Recipes
ADD CONSTRAINT unique_name_recipes UNIQUE (Name);
ALTER TABLE Recipes
MODIFY Name NOT NULL;
ALTER TABLE Application_Methods
ADD CONSTRAINT unique_name_application_methods UNIQUE (Name);
ALTER TABLE Application_Methods
MODIFY Name NOT NULL;
ALTER TABLE Preparation_Methods
ADD CONSTRAINT unique_name_preparation_methods UNIQUE (Name);
ALTER TABLE Preparation_Methods
MODIFY Name NOT NULL;

--Скрипти для наповнення 
ALTER TABLE Recipes MODIFY (Name VARCHAR2(50));
ALTER TABLE Recipes MODIFY (Ingredients VARCHAR2(50));
ALTER TABLE Application_Methods MODIFY (Name VARCHAR2(50));
ALTER TABLE Preparation_Methods MODIFY (Name VARCHAR2(50));
ALTER TABLE Finished_Medicines MODIFY (Name VARCHAR2(50));
ALTER TABLE Unfinished_Medicines MODIFY (Name VARCHAR2(50));
INSERT INTO Recipes (Name, Ingredients) VALUES ('Recipe1', 'Ingredient1');
INSERT INTO Recipes (Name, Ingredients) VALUES ('Recipe2', 'Ingredient2');
INSERT INTO Recipes (Name, Ingredients) VALUES ('Recipe3', 'Ingredient3');
UPDATE Recipes SET Ingredients = 'Інгредієнт1' , Name = 'Рецепт1' where ID = 1;
UPDATE Recipes SET Ingredients = 'Інгредієнт2' , Name = 'Рецепт2' where ID = 2;
UPDATE Recipes SET Ingredients = 'Інгредієнт3' , Name = 'Рецепт3' where ID = 3;
INSERT INTO Application_Methods (Name) VALUES ('Зовнішнє заст.');
INSERT INTO Application_Methods (Name) VALUES ('Внутрішнє заст.');
INSERT INTO Application_Methods (Name) VALUES ('Для змішування');
INSERT INTO Preparation_Methods (Name) VALUES ('Змішування');
INSERT INTO Preparation_Methods (Name) VALUES ('Зміш-відст-фільтр');
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Ношпа', 1);
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Мазь Вишневського', 2);
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Аспірин', 2);
7
UPDATE Finished_Medicines SET A_Method_ID = '1' WHERE name ='Аспірин';
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Вазелін', 2);
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Аспаркам', 1);
INSERT INTO Finished_Medicines (Name, A_Method_ID) VALUES ('Детралекс', 1);
INSERT INTO Unfinished_Medicines (Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) 
VALUES ('Мазь за рец1', 2, 1, 1, 15);
INSERT INTO Unfinished_Medicines (Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) 
VALUES ('Розчин за рец2', 3, 2, 2, 10);
INSERT INTO Unfinished_Medicines (Name, A_Method_ID, P_Method_ID, Recipe_ID, P_Time) 
VALUES ('Мікстура за рец1', 1, 2, 3, 30);

--Запит на створення репорту по препаратам які потребують приготування
SELECT
 unfinished_medicines.name AS Medicine_Name,
 recipes.name AS Recipe,
 preparation_methods.name AS Preparation_Method,
 application_methods.name AS Application_Method,
 unfinished_medicines.p_time AS Preparation_Time
FROM 
 unfinished_medicines
JOIN 
 application_methods ON unfinished_medicines.a_method_id = application_methods.id
JOIN 
 preparation_methods ON unfinished_medicines.p_method_id = preparation_methods.id
JOIN 
 recipes ON unfinished_medicines.recipe_id = recipes.id;
-- Запит з використанням псевдонімів таблиць
SELECT
 UM.name AS Medicine_Name,
 R.name AS Recipe_Name,
 PM.name AS Preparation_Method,
 AM.name AS Application_Method,
 UM.p_time AS Preparation_Time
FROM 
 Unfinished_Medicines UM
8
JOIN 
 Application_Methods AM ON UM.a_method_id = AM.id
JOIN 
 Preparation_Methods PM ON UM.p_method_id = PM.id
JOIN 
 Recipes R ON UM.recipe_id = R.id; 
-- Запит на отримання готових препаратів та методу їх застосування
SELECT 
 FM.name AS Medicine_Name,
 AM.name AS Application_Method
FROM 
 finished_medicines FM
JOIN 
 application_methods AM ON FM.a_method_id = AM.id;
