-- core_data.sql, a_pinyin/core_tools/db/
--
-- >  sqlite3 --version
-- 3.23.1 2018-04-10 17:39:29 4bb2294022060e61de7da5c227a69ccd846ba330e31626ebcd59a94efd148b3b
--
-- use this command to create a_pinyin database file core_data.db
-- > cat core_data.sql | sqlite3 core_data.db

BEGIN TRANSACTION;

CREATE TABLE a_pinyin (  -- meta data for a_pinyin core database
  name TEXT PRIMARY KEY UNIQUE NOT NULL,
  value TEXT,
  `desc` TEXT  -- description of this item
);

INSERT INTO a_pinyin(name, value, `desc`) VALUES
  ('a_pinyin version', 'TODO', 'version of the a_pinyin.apk software'),
  ('db_version', '1.0.0', 'version of database format (struct)'),
  ('db_type', 'core_data', 'type of this database (core_data: static data for a_pinyin core)'),
  ('data_version', 'TODO', 'version of data in this database'),
  ('url', 'https://coding.net/u/sceext2133/p/a_pinyin', 'where to get source code of this project'),
  ('last_update', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'), 'last update time');


CREATE TABLE a_pinyin_core_data (  -- table to store core kryo data
  name TEXT PRIMARY KEY NOT NULL,
  kryo BLOB NOT NULL
);


CREATE TABLE a_pinyin_core_dict (  -- core_dict
  word TEXT PRIMARY KEY UNIQUE NOT NULL,  -- with index already
  count INT NOT NULL DEFAULT 0,
  prefix2 TEXT NOT NULL  -- 2 char prefix for each word
) WITHOUT ROWID;

-- index to search a_pinyin_core_dict.prefix2
CREATE INDEX a_pinyin_index_core_dict
ON a_pinyin_core_dict(prefix2);

CREATE TABLE a_pinyin_core_dict_pinyin (  -- pin_yin to prefix2 table for dict search
  pin_yin TEXT NOT NULL,  -- pin_yin cut seq, with index already
  prefix2 TEXT NOT NULL,

  PRIMARY KEY (pin_yin, prefix2)
) WITHOUT ROWID;


CREATE TABLE a_pinyin_symbol2 (  -- default list data for symbol2
  text TEXT PRIMARY KEY UNIQUE NOT NULL,
  count INT NOT NULL DEFAULT 0
) WITHOUT ROWID;

-- index for order by a_pinyin_symbol2.count
CREATE INDEX a_pinyin_index_symbol2
ON a_pinyin_symbol2(count);


COMMIT;


-- ANALYZE;
-- .selftest --init
-- VACUUM;
