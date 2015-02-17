-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('fre','Français', 'y', 'n');

UPDATE CategoriesDes             SET langid='fre' WHERE langid='fr';
UPDATE IsoLanguagesDes           SET langid='fre' WHERE langid='fr';
UPDATE RegionsDes                SET langid='fre' WHERE langid='fr';
UPDATE GroupsDes                 SET langid='fre' WHERE langid='fr';
UPDATE OperationsDes             SET langid='fre' WHERE langid='fr';
UPDATE StatusValuesDes           SET langid='fre' WHERE langid='fr';
UPDATE CswServerCapabilitiesInfo SET langid='fre' WHERE langid='fr';
DELETE FROM Languages WHERE id='fr';

-- Take care to table ID (related to other loc files)
DELETE FROM CategoriesDes WHERE langid='fre' AND iddes IN (11, 12, 13);
INSERT INTO CategoriesDes VALUES (11,'fre','Serveurs Z3950');
INSERT INTO CategoriesDes VALUES (12,'fre','Annuaires');
INSERT INTO CategoriesDes VALUES (13,'fre','Echantillons physiques');

DELETE FROM StatusValuesDes WHERE langid='fre' AND iddes IN (0, 1, 2, 3, 4, 5);
INSERT INTO StatusValuesDes VALUES (0,'fre','Inconnu');
INSERT INTO StatusValuesDes VALUES (1,'fre','Brouillon');
INSERT INTO StatusValuesDes VALUES (2,'fre','Validé');
INSERT INTO StatusValuesDes VALUES (3,'fre','Retiré');
INSERT INTO StatusValuesDes VALUES (4,'fre','A valider');
INSERT INTO StatusValuesDes VALUES (5,'fre','Rejeté');

