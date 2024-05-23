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
    Versichertennummer varchar PRIMARY KEY check(length(Versichertennummer) == 10 and left(Versichertennummer, 1) ~ '^[A-Z]' and right(Versichertennummer, 9) ~ '^[0-9]{9}$'),
    Name STRUCT(Titel varchar, Vorname varchar, Nachname varchar) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    Beschäftigung varchar,
    Geschlecht CHAR,
);

-- CORRECT
CREATE TABLE Diagnose (
    ICD varchar PRIMARY KEY check (length(ICD) == 3 and left(ICD, 1) ~ '^[A-Z]' and right(ICD, 2) ~ '^[0-9]{9}$'),
    Zusatzinformation CHAR NOT NULL,
    Beschreibung varchar,
);

-- CORRECT
create sequence termin_id start 1;
create table Termin (
    ID uinteger primary key default nextval('termin_id') check (ID <= 3_000_000),
    Zeitpunkt datetime not null,
    Zusatzgebühren decimal(5, 2) not null check (Zusatzgebühren <= 500.00) default 0.00,
    ist_Neupatient_in boolean not null,
    LANR varchar not null,
    foreign key(LANR) references Ärzt_in(LANR),
    unique (LANR, Zeitpunkt),
);

CREATE TABLE Gesundheitseinrichtung (
    SteuerID varchar not null check (length(SteuerID) == 11 and starts_with(SteuerID, 'DE') and right(SteuerID, 9) ~ '^[0-9]{9}$'),
    Name varchar not null,
    Bundesland varchar not null check (length(Bundesland) == 5 and starts_with(Bundesland, 'DE-')),
    Adresse varchar not null,
    Umsatz decimal(15, 2) not null,
    Typ varchar not null check (Typ == 'Krankenhaus' or Typ == 'Privatpraxis'),
    primary key (SteuerID, Name),
    Betten INTEGER,
    Bettenauslastung FLOAT,
    ist_privatisiert BOOLEAN,
    ist_Universitätsklinikum BOOLEAN,
    Fachrichtung varchar,
    Zahlungsart varchar check (Zahlungsart == 'Versichert' or Zahlungsart == 'Selbstzahler'),
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
    Nummer uuid primary key,
    Dringlichkeit varchar not null check (Dringlichkeit == 'Notoperation' or Dringlichkeit == 'dringliche Operation' or Dringlichkeit == 'frühelektive Operation' or Dringlichkeit == 'elektive Operation'),
    ist_Vollnarkose boolean not null,
    Datum date not null,
    Startzeit time not null,
    Endzeit time not null,
    Versichertennummer varchar not null,
    SteuerID varchar not null,
    Name varchar not null,
    Raumnummer utinyint not null,
    foreign key(Versichertennummer) references Patient_in(Versichertennummer),
    foreign key(SteuerID, Name, Raumnummer) references "OP-Saal"(SteuerID, Name, Raumnummer),
    check (datesub('minute', Endzeit, Startzeit) >= 15 and datesub('minute', Endzeit, Startzeit) <= 9 * 60)
);

--
-- RELATIONS
--

-- CORRECT
create table stellt (
    LANR varchar not null,
    ICD varchar not null,
    Zeitpunkt datetime not null,
    primary key (LANR, ICD),
    foreign key(LANR) references Ärzt_in(LANR),
    foreign key(ICD) references Diagnose(ICD),
    unique (LANR, Zeitpunkt),
);

-- CORRECT
create table angestellt (
    LANR varchar not null,
    SteuerID varchar not null,
    Name varchar not null,
    Einstellungsdatum date not null check (
        strftime(Einstellungsdatum, '%m-%d') != '01-01'
        and strftime(Einstellungsdatum, '%m-%d') != '03-08'
        and strftime(Einstellungsdatum, '%m-%d') != '05-01'
        and strftime(Einstellungsdatum, '%m-%d') != '10-03'
        and strftime(Einstellungsdatum, '%m-%d') != '12-25'
        and strftime(Einstellungsdatum, '%m-%d') != '12-26'
    ),
    Gehalt decimal(7, 2) not null check (Gehalt >= 5288.32 and Gehalt <= 11019.20),
    primary key (LANR, SteuerID, Name),
    foreign key(LANR) references Ärzt_in(LANR),
    foreign key(SteuerID, Name) references Gesundheitseinrichtung(SteuerID, Name),
);

-- CORRECT
create table hat (
    ID uinteger not null,
    ICD varchar not null,
    Versichertennummer varchar not null,
    primary key (ID, ICD),
    foreign key (ID) references Termin(ID),
    foreign key (ICD) references Diagnose(ICD),
    foreign key (Versichertennummer) references Patient_in(Versichertennummer),
);
