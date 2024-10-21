INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_vigneron', 'VIGNERON', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    ('society_vigneron', 'VIGNERON', 1)
;


INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_vigneron', 'VIGNERON', 1)
;

INSERT INTO `jobs` (name, label) VALUES
    ('vigneron','Vigneron')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary) VALUES
    ('vigneron',0,'recrue','Stagiaire',0,'{}','{}'),
    ('vigneron',1,'novice','Vigneron',0,'{}','{}'),
    ('vigneron',2,'senior','Chef-Equipe',0,'{}','{}'),
    ('vigneron',3,'boss','Patron',0,'{}','{}')
;