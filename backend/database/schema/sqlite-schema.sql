CREATE TABLE IF NOT EXISTS "migrations"(
  "id" integer primary key autoincrement not null,
  "migration" varchar not null,
  "batch" integer not null
);
CREATE TABLE IF NOT EXISTS "goals"(
  "id" integer primary key autoincrement not null,
  "name" varchar not null,
  "targetPercentage" integer not null,
  "created_at" datetime,
  "updated_at" datetime
);
CREATE TABLE IF NOT EXISTS "percentages"(
  "id" integer primary key autoincrement not null,
  "percentage" integer not null,
  "created_at" datetime,
  "updated_at" datetime
);

INSERT INTO migrations VALUES(1,'2025_01_09_114300_create_goals_table',1);
INSERT INTO migrations VALUES(2,'2025_01_09_114516_create_percentage_table',1);
