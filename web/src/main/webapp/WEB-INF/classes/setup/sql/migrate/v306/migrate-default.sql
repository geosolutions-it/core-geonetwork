UPDATE Settings SET value='3.0.6' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';

ALTER TABLE users ADD COLUMN isenabled CHAR(1) DEFAULT 'y';
UPDATE users SET isenabled = 'y' WHERE enabled = true;
UPDATE users SET isenabled = 'n' WHERE enabled = false;
ALTER TABLE users  DROP COLUMN enabled;

ALTER TABLE groups ADD COLUMN enableCategoriesRestriction CHAR(1) DEFAULT 'n';
UPDATE groups SET enableCategoriesRestriction = 'y' WHERE ENABLEALLOWEDCATEGORIES = true;
UPDATE groups SET enableCategoriesRestriction = 'n' WHERE ENABLEALLOWEDCATEGORIES = false;
ALTER TABLE groups DROP COLUMN ENABLEALLOWEDCATEGORIES;
