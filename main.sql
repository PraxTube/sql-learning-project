-- CORRECT
CREATE TABLE Ärzt_in (
    LANR varchar PRIMARY KEY check (length(LANR) == 9),
    Fachgebiet varchar NOT NULL,
    Name STRUCT(Titel varchar, Vorname varchar, Nachname varchar) NOT NULL,
    Sprachen varchar[] NOT NULL,
    Geburtsdatum DATE NOT NULL check (Geburtsdatum - date '1956-05-17' > 0),
);

-- CORRECT
CREATE TABLE Patient_in (
    Versichertennummer varchar PRIMARY KEY,
    Name STRUCT(Titel varchar, Vorname varchar, Nachname varchar) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    Beschäftigung varchar,
    Geschlecht CHAR,
);

-- CORRECT
CREATE TABLE Diagnose (
    ICD varchar PRIMARY KEY,
    Zusatzinformation CHAR NOT NULL,
    Beschreibung varchar,
);

create sequence termin_id start 1;
create table Termin (
    ID uinteger primary key default nextval('termin_id'),
    Zeitpunkt datetime not null,
    Zusatzgebühren usmallint not null check (Zusatzgebühren <= 500) default 0,
    ist_Neupatient_in boolean not null,
    Ärzt_in varchar not null,
    Patient_in varchar not null,
    foreign key(Ärzt_in) references Ärzt_in(LANR),
    foreign key(Patient_in) references Patient_in(Versichertennummer),
);

CREATE TABLE Gesundheitseinrichtung (
    SteuerID varchar not null,
    Name varchar not null,
    Bundesland varchar not null,
    Adresse varchar not null,
    Umsatz int not null,
    primary key (SteuerID, Name),

    Betten INTEGER,
    Bettenauslastung FLOAT,
    ist_privatisiert BOOLEAN,
    ist_Universitätsklinikum BOOLEAN,

    Fachrichtung varchar,
    Zahlungsart varchar,
);

-- CORRECT
create table "OP-Saal" (
    Raumnummer utinyint not null check (Raumnummer <= 20),
    SteuerID varchar not null,
    Name varchar not null,
    primary key (SteuerID, Name, Raumnummer),
    foreign key(SteuerID, Name) references Gesundheitseinrichtung(SteuerID, Name),
);

CREATE TABLE OP (
    Nummer INTEGER PRIMARY KEY,
    Dringlichkeit ubigint not null,
    ist_Vollnarkose boolean not null,
    Datum date not null,
    Startzeit time not null,
    Endzeit time not null,
    Patient_in varchar not null,
    SteuerID varchar not null,
    Name varchar not null,
    Raumnummer utinyint not null,
    foreign key(Patient_in) references Patient_in(Versichertennummer),
    foreign key(SteuerID, Name, Raumnummer) references "OP-Saal"(SteuerID, Name, Raumnummer),
);

--
-- RELATIONS
--

create table stellt (
    Zeitpunkt datetime not null,
    Ärzt_in varchar not null,
    Diagnose varchar not null,
    primary key (Ärzt_in, Diagnose),
    foreign key(Ärzt_in) references Ärzt_in(LANR),
    foreign key(Diagnose) references Diagnose(ICD),
);

create table angestellt (
    Einstellungsdatum date not null check (Einstellungsdatum != date ''),
    Gehalt decimal(7, 2) not null check (Gehalt >= 5288.32 and Gehalt <= 11019.20),
    Ärzt_in varchar not null,
    SteuerID varchar not null,
    Name varchar not null,
    foreign key(Ärzt_in) references Ärzt_in(LANR),
    foreign key(SteuerID, Name) references Gesundheitseinrichtung(SteuerID, Name),
);
