types
serial
	"In SQLLite, the column declared as INTEGER PRIMARY KEY will default to ROWID, unless the inserted value is not null. But in Sqlite3 a declaration like: INTEGER PRIMARY KEY AUTOINCREMENT will cause ROWID to be fetched from the sqlite_sequence table, which provides always increasing values."

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'INTEGER PRIMARY KEY AUTOINCREMENT'].