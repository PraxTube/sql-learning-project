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
    ICD varchar PRIMARY KEY check (length(ICD) == 3 and left(ICD, 1) ~ '^[A-Z]' and right(ICD, 2) ~ '^[0-9]{9}$'),
    Zusatzinformation CHAR NOT NULL,
    Beschreibung varchar,
);

create sequence termin_id start 1;
create table Termin (
    ID uinteger primary key default nextval('termin_id') check (ID <= 3_000_000),
    Zeitpunkt datetime not null,
    Zusatzgebühren usmallint not null check (Zusatzgebühren <= 500) default 0,
    ist_Neupatient_in boolean not null,
    Ärzt_in varchar not null,
    foreign key(Ärzt_in) references Ärzt_in(LANR),
    unique (Ärzt_in, Zeitpunkt),
);

CREATE TABLE Gesundheitseinrichtung (
    SteuerID varchar not null check (length(SteuerID) == 11 and starts_with(SteuerID, 'DE') and right(SteuerID, 9) ~ '^[0-9]{9}$'),
    Name varchar not null,
    Bundesland varchar not null check (length(Bundesland) == 5 and starts_with(Bundesland, 'DE-')),
    Adresse varchar not null,
    Umsatz decimal(15, 2) not null,
    Typ varchar not null check (Typ == 'Krankenhaus' or Typ == 'Privatpraxis'),
    primary key (SteuerID, Name),
);

create table Krankenhaus (
    Betten INTEGER,
    Bettenauslastung FLOAT,
    ist_privatisiert BOOLEAN,
    ist_Universitätsklinikum BOOLEAN,
);

create table Privatpraxis (
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
    Patient_in varchar not null,
    SteuerID varchar not null,
    Name varchar not null,
    "OP-Saal" utinyint not null,
    foreign key(Patient_in) references Patient_in(Versichertennummer),
    foreign key(SteuerID, Name, "OP-Saal") references "OP-Saal"(SteuerID, Name, Raumnummer),
    check (datesub('minute', Endzeit, Startzeit) >= 15 and datesub('minute', Endzeit, Startzeit) <= 9 * 60)
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
    unique (Ärzt_in, Zeitpunkt),
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

create table hat (
    Termin uinteger not null,
    Diagnose varchar not null,
    Patient_in varchar not null,
    primary key (Termin, Diagnose),
    foreign key (Termin) references Termin(ID),
    foreign key (Diagnose) references Diagnose(ICD),
    foreign key (Patient_in) references Patient_in(Versichertennummer),
);
