INSERT INTO `society` (name, label, registration_number) VALUES
    ('ambulance', 'EMS', 'REG_NUMBER_AMBULANCE')
;

INSERT INTO `society_account` (society_id, balance, iban) VALUES
    (LAST_INSERT_ID(), 0, 'IBAN_AMBULANCE')
;

INSERT INTO `jobs` (name, label) VALUES
    ('ambulance', 'EMS')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    ('ambulance', 0, 'second', 'Co-Patron', 0, '{}', '{}'),
    ('ambulance', 1, 'boss', 'Patron', 0, '{}', '{}')
;

INSERT INTO `society_employee` (identifier, grade, society_id) VALUES
    ('IDENTIFIER_OF_BOSS', 1, (SELECT id FROM society WHERE name = 'ambulance'))
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_ambulance', 'EMS', 1)
;