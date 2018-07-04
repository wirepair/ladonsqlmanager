-- +goose Up
-- SQL in this section is executed when the migration is applied.

CREATE TABLE IF NOT EXISTS ladon_subject (
    id          varchar(64) NOT NULL PRIMARY KEY,
    has_regex   bool NOT NULL,
    compiled    varchar(511) NOT NULL UNIQUE,
    template    varchar(511) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ladon_action (
    id          varchar(64) NOT NULL PRIMARY KEY,
    has_regex   bool NOT NULL,
    compiled    varchar(511) NOT NULL UNIQUE,
    template    varchar(511) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ladon_resource (
    id          varchar(64) NOT NULL PRIMARY KEY,
    has_regex   bool NOT NULL,
    compiled    varchar(511) NOT NULL UNIQUE,
    template    varchar(511) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ladon_policy_subject_rel (
    policy   varchar(255) NOT NULL,
    subject  varchar(64) NOT NULL,
    PRIMARY KEY (policy, subject),
    FOREIGN KEY (policy) REFERENCES ladon_policy(id) ON DELETE CASCADE,
    FOREIGN KEY (subject) REFERENCES ladon_subject(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ladon_policy_action_rel (
    policy  varchar(255) NOT NULL,
    action  varchar(64) NOT NULL,
    PRIMARY KEY (policy, action),
    FOREIGN KEY (policy) REFERENCES ladon_policy(id) ON DELETE CASCADE,
    FOREIGN KEY (action) REFERENCES ladon_action(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ladon_policy_resource_rel (
    policy    varchar(255) NOT NULL,
    resource  varchar(64) NOT NULL,
    PRIMARY KEY (policy, resource),
    FOREIGN KEY (policy) REFERENCES ladon_policy(id) ON DELETE CASCADE,
    FOREIGN KEY (resource) REFERENCES ladon_resource(id) ON DELETE CASCADE
);

CREATE INDEX ladon_subject_compiled_idx ON ladon_subject (compiled text_pattern_ops);

CREATE INDEX ladon_permission_compiled_idx ON ladon_action (compiled text_pattern_ops);

CREATE INDEX ladon_resource_compiled_idx ON ladon_resource (compiled text_pattern_ops);

ALTER TABLE ladon_policy ADD COLUMN meta json;


-- +goose Down
-- SQL in this section is executed when the migration is rolled back.
ALTER TABLE ladon_policy DROP COLUMN IF EXISTS meta;
DROP INDEX ladon_resource_compiled_idx;
DROP INDEX ladon_permission_compiled_idx;
DROP INDEX ladon_subject_compiled_idx;
DROP TABLE ladon_policy_resource_rel;
DROP TABLE ladon_policy_action_rel;
DROP TABLE ladon_policy_subject_rel;
DROP TABLE ladon_resource;
DROP TABLE ladon_action;
DROP TABLE ladon_subject;