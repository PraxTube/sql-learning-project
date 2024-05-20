CREATE TABLE Ärzt_in (
    LANR int PRIMARY KEY,
    Fachgebiet varchar NOT NULL,
    Name STRUCT(Titel varchar, Vorname varchar, Nachname varchar) NOT NULL,
    Sprachen varchar[] NOT NULL,
    Geburtsdatum DATE NOT NULL,
);

CREATE TABLE Patient_in (
    Versichertennummer varchar PRIMARY KEY,
    Name STRUCT(Titel varchar, Vorname varchar, Nachname varchar) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    Beschäftigung varchar,
    Geschlecht CHAR,
);

CREATE TABLE Diagnose (
    ICD varchar PRIMARY KEY,
    Zusatzinformation CHAR NOT NULL,
    Beschreibung varchar,
);

create table Termin (
    ID uinteger primary key,
    Zeitpunkt datetime not null,
    Zusatzgebühren uinteger not null,
    ist_Neupatient_in boolean not null,
    Ärzt_in int,
    foreign key(Ärzt_in) references Ärzt_in(LANR),
);

create table OP_Saal (
    Raumnummer utinyint,
);

CREATE TABLE OP (
    Nummer INTEGER PRIMARY KEY,
    Dringlichkeit ubigint not null,
    ist_Vollnarkose boolean not null,
    Datum date not null,
    Startzeit time not null,
    Endzeit time not null,
    Patient_in varchar,
    foreign key(Patient_in) references Patient_in(Versichertennummer),
    OP_Saal utinyint,
    foreign key(OP_Saal) references OP_Saal(Raumnummer),
);

CREATE TABLE Krankenhaus (
    Betten INTEGER NOT NULL,
    Bettenauslastung FLOAT NOT NULL,
    ist_privatisiert BOOLEAN NOT NULL,
    ist_Universitätsklinikum BOOLEAN NOT NULL,
);

CREATE TABLE Privatpraxis (
    Fachrichtung varchar NOT NULL,
    Zahlungsart varchar NOT NULL,
);

CREATE TABLE Gesundheitseinrichtung (
    SteuerID varchar not null,
    Name varchar not null,
    Bundesland varchar not null,
    Adresse varchar not null,
    Umsatz int not null,
    primary key (SteuerID, Name),
);

create table angestellt (
    Einstellungsdatum date not null,
    Gehalt decimal(7, 2) not null,
    Ärzt_in int,
    SteuerID varchar,
    Name varchar,
    foreign key(Ärzt_in) references Ärzt_in(LANR),
    foreign key(SteuerID, Name) references Gesundheitseinrichtung(SteuerID, Name),
);
