--Inspect first 10 rows of parts table
SELECT
    *
FROM
    parts
LIMIT
    10;

--Ensure that that each value inserted is unique and not empty
ALTER TABLE
    parts
ALTER COLUMN
    code
SET
    NOT NULL;

ALTER TABLE
    parts
ADD
    UNIQUE(code);

--Backfill description column in parts table
UPDATE
    parts
SET
    description = 'Edit later'
WHERE
    description IS NULL;

--Test if backfiling worked
ALTER TABLE
    parts
ALTER COLUMN
    description
SET
    NOT NULL;

/*Expected to fail due to not null constraint*/
/*INSERT INTO  parts (id, code, manufacturer_id) VALUES ( 54, 'V100-9', 9);*/
INSERT INTO
    parts (id, description, code, manufacturer_id)
VALUES
    (54, 'OLED screen', 'V100-9', 9);

--Ensurer that price_usd in reorder_options table allows no nulls
ALTER TABLE
    reorder_options
ALTER COLUMN
    price_usd
SET
    NOT NULL;

--Ensurer that qauntity in reorder_options table allows no nulls
ALTER TABLE
    reorder_options
ALTER COLUMN
    quantity
SET
    NOT NULL;

--ensure that price_usd and quantity are both positive in reorder_options table are positive
ALTER TABLE
    reorder_options
ADD
    CHECK (
        price_usd > 0
        AND quantity > 0
    );

--Limit price per unit between 0.02 and 25.00 
ALTER TABLE
    reorder_options
ADD
    CHECK (
        price_usd / quantity > 0.02
        AND price_usd / quantity < 25.00
    );

--Form a relationship between parts and reorder_options that ensures all parts in reorder_options refer to parts tracked in parts.
ALTER TABLE
    parts
ADD
    PRIMARY KEY (id);

ALTER TABLE
    reorder_options
ADD
    FOREIGN KEY (part_id) REFERENCES parts (id);

--ensures that each value in qty is greater than 0
ALTER TABLE
    locations
ADD
    CHECK (qty > 0);

--ensure that locations records only one row for each combination of location and part
ALTER TABLE
    locations
ADD
    UNIQUE (part_id, location);

--ensure that for a part to be stored in locations, it must already be registered in parts
ALTER TABLE
    locations
ADD
    FOREIGN KEY (part_id) REFERENCES parts (id);

--ensure that all parts in parts have a valid manufacturer.
ALTER TABLE
    parts
ADD
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (id);

--Create a new manufacturer (Pip-NNC Industrial) in manufacturers with an id=11
INSERT INTO
    manufacturers (id, name)
VALUES
    (11, 'Pip-NNC Industrial');

--Update the old manufacturers’ parts in 'parts' to reference the new company
UPDATE
    parts
SET
    manufacturer_id = 11
WHERE
    manufacturer_id IN (1, 2);