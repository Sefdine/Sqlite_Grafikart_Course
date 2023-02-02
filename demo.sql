-- SQLite

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title VARCHAR(150) NOT NULL,
    slug VARCHAR(150) NOT NULL,
    date DATETIME,
    duration INTEGER DEFAULT 0 NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS categories_recipes(
    recipe_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(recipe_id, category_id),
    UNIQUE(recipe_id, category_id)
);

CREATE TABLE IF NOT EXISTS ingredients(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name VARCHAR(150),
    usage_count INTEGER DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS ingredients_recipes(
    recipe_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity INTEGER,
    unit VARCHAR(20),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(recipe_id, ingredient_id),
    UNIQUE(recipe_id, ingredient_id)
);

CREATE TABLE IF NOT EXISTS animals (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    parent_id INTEGER,
    FOREIGN KEY (parent_id) REFERENCES animals(id) ON DELETE CASCADE 
);

INSERT INTO animals
VALUES (1, 'Mammifère', NULL),
       (2, 'Chien', 1),
       (3, 'Chat', 1),
       (4, 'Singe', 1),
       (5, 'Gorille', 4),
       (6, 'Chimpanzé', 4),
       (7, 'Shiba', 2),
       (8, 'Corgi', 2),
       (9, 'Labrador', 2),
       (10, 'Poisson', NULL),
       (11, 'Requin', 10),
       (12, 'Requin blanc', 11),
       (13, 'Grand requin blanc', 12),
       (14, 'Petit requin blanc', 12),
       (15, 'Requin marteau', 11),
       (16, 'Requin tigre', 11),
       (17, 'Poisson rouge', 10),
       (18, 'Poisson chat', 10);

SELECT * FROM animals;

WITH RECURSIVE parent (id, name, parent_id) AS (
    SELECT id, name, parent_id FROM animals WHERE id = 16
    UNION ALL 
    SELECT a.id, a.name, a.parent_id 
    FROM animals a, parent p 
    WHERE a.id = p.parent_id
)

SELECT * FROM parent;

SELECT * FROM (
    SELECT 
        c.title AS categories, 
        r.title AS recettes, 
        i.name AS ingredients,
        ROW_NUMBER() OVER (PARTITION BY cr.category_id, ir.recipe_id) AS row_number
    FROM categories c
        LEFT JOIN categories_recipes cr ON cr.category_id = c.id
        LEFT JOIN recipes r ON cr.recipe_id = r.id
        LEFT JOIN ingredients_recipes ir ON ir.recipe_id = r.id
        LEFT JOIN ingredients i ON ir.ingredient_id = i.id
) AS t
WHERE t.row_number < 4;


