-- word_count.sql, a_pinyin/core_tools/jvm/cli/word_count/src/main/sql/
--
-- > sqlite3 --version
-- 3.23.1 2018-04-10 17:39:29 4bb2294022060e61de7da5c227a69ccd846ba330e31626ebcd59a94efd148b3b
--
-- use this command to create the database file for word_count
-- > cat word_count.sql | sqlite3 word_count.db

BEGIN TRANSACTION;


CREATE TABLE a_pinyin_data_word_count (
  word TEXT PRIMARY KEY NOT NULL,
  count INT NOT NULL DEFAULT 0
) WITHOUT ROWID;


-- FIXME not create index to improve INSERT performance
CREATE UNIQUE INDEX a_pinyin_index_data_word_count_1
ON a_pinyin_data_word_count(word);

CREATE INDEX a_pinyin_index_data_word_count_2
ON a_pinyin_data_word_count(count);


COMMIT;

-- ANALYZE;
-- .selftest --init
-- VACUUM;
