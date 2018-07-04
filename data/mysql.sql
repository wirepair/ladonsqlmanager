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

CREATE FULLTEXT INDEX ladon_subject_compiled_idx ON ladon_subject (compiled);

CREATE FULLTEXT INDEX ladon_action_compiled_idx ON ladon_action (compiled);

CREATE FULLTEXT INDEX ladon_resource_compiled_idx ON ladon_resource (compiled);

ALTER TABLE ladon_policy ADD COLUMN meta text;