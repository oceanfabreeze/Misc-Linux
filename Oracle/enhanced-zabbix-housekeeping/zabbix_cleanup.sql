/*
Developer = Thomas A. Fabrizio (TF054451)
Version = 1.1
Changelog = Changed variables to more realistic numbers.
This is a sql script to cleanup a zabbix-server or proxy that has become overloaded with data. You can use this in place of the housekeeper or run manually whenever you see fit.
*/
SET @history_interval = 90;
SET @trends_interval = 365;

DELETE FROM alerts WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE alerts ENGINE=INNODB;
DELETE FROM acknowledges WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE acknowledges ENGINE=INNODB;
DELETE FROM events WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE events ENGINE=INNODB;

DELETE FROM history WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE history ENGINE=INNODB;

DELETE FROM history_uint WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE history_uint ENGINE=INNODB;

DELETE FROM history_str WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE history_str ENGINE=INNODB;

DELETE FROM history_text WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE history_text ENGINE=INNODB;

DELETE FROM history_log WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
ALTER TABLE history_log ENGINE=INNODB;

DELETE FROM trends WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@trends_interval * 24 * 60 * 60);
ALTER TABLE trends ENGINE=INNODB;

DELETE FROM trends_uint WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@trends_interval * 24 * 60 * 60);
ALTER TABLE trends_uint ENGINE=INNODB;
