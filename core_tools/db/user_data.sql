-- user_data.sql, a_pinyin/core_tools/db/
--
-- >  sqlite3 --version
-- 3.23.1 2018-04-10 17:39:29 4bb2294022060e61de7da5c227a69ccd846ba330e31626ebcd59a94efd148b3b
--
-- use this command to create a_pinyin database file user_data.db
-- > cat user_data.sql | sqlite3 user_data.db

BEGIN TRANSACTION;

CREATE TABLE a_pinyin (  -- meta data for a_pinyin core database
  name TEXT PRIMARY KEY UNIQUE NOT NULL,
  value TEXT,
  `desc` TEXT  -- description of this item
);

INSERT INTO a_pinyin(name, value, `desc`) VALUES
  ('a_pinyin version', 'TODO', 'version of the a_pinyin.apk software'),
  ('db_version', '1.0.0', 'version of database format (struct)'),
  ('db_type', 'user_data', 'type of this database (user_data: user input history data (log) for a_pinyin)'),
  ('data_version', '1.0.0', 'version of data in this database'),
  ('url', 'https://coding.net/u/sceext2133/p/a_pinyin', 'where to get source code of this project'),
  ('last_update', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'), 'last update time');


CREATE TABLE a_pinyin_user_symbol (
  text TEXT PRIMARY KEY UNIQUE NOT NULL,
  count INT NOT NULL DEFAULT 0,
  last_used REAL NOT NULL DEFAULT 0  -- last used time, Julian (date) time
) WITHOUT ROWID;

-- index to speed up order by
CREATE INDEX a_pinyin_index_user_symbol_count
ON a_pinyin_user_symbol(count);

CREATE INDEX a_pinyin_index_user_symbol_last_used
ON a_pinyin_user_symbol(last_used);


CREATE TABLE a_pinyin_user_symbol2 (
  text TEXT PRIMARY KEY UNIQUE NOT NULL,
  count INT NOT NULL DEFAULT 0,
  last_used REAL NOT NULL DEFAULT 0,  -- Julian (date) time
  list INT NOT NULL DEFAULT 0  -- support multi-list of symbol2
) WITHOUT ROWID;

CREATE INDEX a_pinyin_index_user_symbol2_count
ON a_pinyin_user_symbol2(count);

CREATE INDEX a_pinyin_index_user_symbol2_last_used
ON a_pinyin_user_symbol2(last_used);

CREATE INDEX a_pinyin_index_user_symbol2_list
ON a_pinyin_user_symbol2(list);


CREATE TABLE a_pinyin_user_dict (  -- user Chinese text input log
  text TEXT NOT NULL,
  pin_yin TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  count INT NOT NULL DEFAULT 0,
  last_used REAL NOT NULL DEFAULT 0,  -- Julian (date) time

  PRIMARY KEY (text, pin_yin)
) WITHOUT ROWID;

CREATE INDEX a_pinyin_index_user_dict_pin_yin
ON a_pinyin_user_dict(pin_yin);

CREATE INDEX a_pinyin_index_user_dict_pinyin
ON a_pinyin_user_dict(pinyin);


CREATE TABLE a_pinyin_user_char_freq (  -- single Chinese char input log
  char TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  count INT NOT NULL DEFAULT 0,
  last_used REAL NOT NULL DEFAULT 0,  -- Julian (date) time

  PRIMARY KEY (char, pinyin)
) WITHOUT ROWID;

CREATE INDEX a_pinyin_index_user_char_freq_pinyin
ON a_pinyin_user_char_freq(pinyin);


COMMIT;


-- ANALYZE;
-- VACUUM;
