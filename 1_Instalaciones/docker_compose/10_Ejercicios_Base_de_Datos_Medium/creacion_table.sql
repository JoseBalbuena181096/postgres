-- -------------------------------------------------------------
-- TablePlus 5.3.8(500)
--
-- https://tableplus.com/
--
-- Database: medium-02
-- Generation Time: 2023-07-18 09:54:26.9910
-- -------------------------------------------------------------


DROP TABLE IF EXISTS "public"."claps";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS clap_id_seq;

-- Table Definition
CREATE TABLE "public"."claps" (
    "clap_id" int4 NOT NULL DEFAULT nextval('clap_id_seq'::regclass),
    "post_id" int4,
    "user_id" int4,
    "counter" int4 DEFAULT 0,
    "created_at" timestamp,
    PRIMARY KEY ("clap_id")
);

DROP TABLE IF EXISTS "public"."comments";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Table Definition
CREATE TABLE "public"."comments" (
    "comment_id" int4 NOT NULL,
    "post_id" int4,
    "user_id" int4,
    "content" text,
    "created_at" timestamp,
    "visible" bool,
    "comment_parent_id" int4,
    PRIMARY KEY ("comment_id")
);

DROP TABLE IF EXISTS "public"."posts";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS post_id_seq;

-- Table Definition
CREATE TABLE "public"."posts" (
    "post_id" int4 NOT NULL DEFAULT nextval('post_id_seq'::regclass),
    "title" varchar(200) DEFAULT ''::character varying,
    "body" text DEFAULT ''::text,
    "og_image" varchar,
    "slug" varchar NOT NULL,
    "published" bool,
    "created_by" int4,
    "created_at" timestamp NOT NULL,
    PRIMARY KEY ("post_id")
);

DROP TABLE IF EXISTS "public"."user_list_entry";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_list_entry_seq;

-- Table Definition
CREATE TABLE "public"."user_list_entry" (
    "user_list_entry" int4 NOT NULL DEFAULT nextval('user_list_entry_seq'::regclass),
    "user_list_id" int4 NOT NULL,
    "post_id" int4 NOT NULL,
    PRIMARY KEY ("user_list_entry")
);

DROP TABLE IF EXISTS "public"."user_lists";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_list_id_seq;

-- Table Definition
CREATE TABLE "public"."user_lists" (
    "user_list_id" int4 NOT NULL DEFAULT nextval('user_list_id_seq'::regclass),
    "user_id" int4,
    "title" varchar(100) NOT NULL,
    PRIMARY KEY ("user_list_id")
);

DROP TABLE IF EXISTS "public"."users";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_id_seq;

-- Table Definition
CREATE TABLE "public"."users" (
    "user_id" int4 NOT NULL DEFAULT nextval('user_id_seq'::regclass),
    "username" varchar NOT NULL,
    "email" varchar NOT NULL,
    "password" varchar NOT NULL,
    "name" varchar NOT NULL,
    "role" varchar NOT NULL,
    "gender" varchar(10) NOT NULL,
    "avatar" varchar,
    "created_at" timestamp DEFAULT '2023-07-14 18:37:35.045163'::timestamp without time zone,
    PRIMARY KEY ("user_id")
);

ALTER TABLE "public"."claps" ADD FOREIGN KEY ("post_id") REFERENCES "public"."posts"("post_id");
ALTER TABLE "public"."claps" ADD FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id");
ALTER TABLE "public"."comments" ADD FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id");
ALTER TABLE "public"."comments" ADD FOREIGN KEY ("post_id") REFERENCES "public"."posts"("post_id");
ALTER TABLE "public"."posts" ADD FOREIGN KEY ("created_by") REFERENCES "public"."users"("user_id");
ALTER TABLE "public"."user_list_entry" ADD FOREIGN KEY ("user_list_id") REFERENCES "public"."user_lists"("user_list_id");
ALTER TABLE "public"."user_list_entry" ADD FOREIGN KEY ("post_id") REFERENCES "public"."posts"("post_id");
ALTER TABLE "public"."user_lists" ADD FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id");
