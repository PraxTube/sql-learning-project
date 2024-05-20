create sequence termin_id start 1;
CREATE TABLE my_table (
    ID uinteger primary key default nextval('termin_id'),
    column1 TEXT NOT NULL DEFAULT 'default text',
    column2 INTEGER NOT NULL DEFAULT 100,
    column3 TEXT
);

insert into my_table (id, column3) values (0, 'hi mom');
