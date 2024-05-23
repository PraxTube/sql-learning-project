alter table Hotel rename Column_5 to Anz_Zimmer;
alter table Hotel drop Adresse;
alter table Hotel add column OrtID uuid;

delete from MitarbeiterIn where PersID = 'em300025';

alter table MitarbeiterIn add Gehalt uinteger;
update MitarbeiterIn set Gehalt = 2000 where Abteilung = 'Sicherheit';
update MitarbeiterIn set Gehalt = 2200 where Abteilung = 'Reinigung';
update MitarbeiterIn set Gehalt = 2600 where Abteilung = 'Rezeption';
update MitarbeiterIn set Gehalt = 3200 where Abteilung = 'Management';

alter table MitarbeiterIn add column Angestellt_am_new date;
update MitarbeiterIn set Angestellt_am_new = strptime(Angestellt_am, '%d-%m-%Y');
alter table MitarbeiterIn drop column Angestellt_am;
alter table MitarbeiterIn rename column Angestellt_am_new to Angestellt_am;

create table Ort (
    OrtID uuid primary key,
    Straße varchar not null,
    Hausnummer varchar not null,
    PLZ varchar not null check (PLZ ~ '^[0-9]{5}$'),
    Stadt varchar not null,
);

insert into Ort values 
    ('60a82896-8e90-4eb3-847d-0f714bd6efe3', 'Albrechtstraße', '5', '10117', 'Berlin'),
    ('21286e4c-b998-4205-aed3-0d513770086f', 'Müllerstraße', '151a', '13353', 'Berlin'),
    ('5d361b72-bc17-4bb9-afed-7d7d05eb3ce6', 'Bjoernsonstraße', '10', '10439', 'Berlin'),
    ('4c2370e6-515b-4ad6-bc29-edf02cd14952', 'Willy-Brandt-Platz', '3', '81829', 'München'),
    ('b7782c2e-a9aa-4a14-bbc2-7aca0b7aff82', 'Albrechtstraße', '13', '80636', 'München');

update Hotel set OrtID = '60a82896-8e90-4eb3-847d-0f714bd6efe3' where HotelID = 1001;
update Hotel set OrtID = '21286e4c-b998-4205-aed3-0d513770086f' where HotelID = 1002;
update Hotel set OrtID = '21286e4c-b998-4205-aed3-0d513770086f' where HotelID = 1003;
update Hotel set OrtID = '5d361b72-bc17-4bb9-afed-7d7d05eb3ce6' where HotelID = 1004;
update Hotel set OrtID = '4c2370e6-515b-4ad6-bc29-edf02cd14952' where HotelID = 1005;
update Hotel set OrtID = 'b7782c2e-a9aa-4a14-bbc2-7aca0b7aff82' where HotelID = 1006;

create table ManagerIn (
    PersID varchar primary key,
    foreign key (PersID) references MitarbeiterIn(PersID),
    Letzte_Fortbildung date,
    Nächste_Fortbildung date not null,
    Bonus decimal(8, 2) not null,
    check (Letzte_Fortbildung is null or Nächste_Fortbildung - Letzte_Fortbildung > 0),
);

insert into ManagerIn values 
    ('em300003', date '2023-10-21', date '2024-06-12', 936.50),
    ('em300004', date '2024-01-13', date '2024-09-02', 0),
    ('em300011', date '2023-11-14', date '2024-06-12', 1500),
    ('em300013', date '2024-01-13', date '2024-09-02', 345.78),
    ('em300016', date '2023-11-14', date '2024-07-27', 0),
    ('em300021', date '2024-01-13', date '2024-07-27', 0);

-- insert into ManagerIn values 
--     ('Seiler, Marena', date '2023-10-21', date '2024-06-12', 936.50),
--     ('Meddings, Otis', date '2024-01-13', date '2024-09-02', 0),
--     ('Van den Dael, Cam', date '2023-11-14', date '2024-06-12', 1500),
--     ('Trazzi, Sofie', date '2024-01-13', date '2024-09-02', 345.78),
--     ('Dermot, Colline', date '2023-11-14', date '2024-07-27', 0),
--     ('Lingner, Bing', date '2024-01-13', date '2024-07-27', 0);
