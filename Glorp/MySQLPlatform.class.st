"
This is a definition for MySQL databases. It's not done yet, just here as a placeholder.
"
Class {
	#name : #MySQLPlatform,
	#superclass : #DatabasePlatform,
	#instVars : [
		'engine'
	],
	#category : #'Glorp-Platforms'
}

{ #category : #'as yet unclassified' }
MySQLPlatform class >> createLoginFromConnectionDictionary: aDict [
	" *** This method was defined by Glorp.DatabasePlatform class as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #'as yet unclassified' }
MySQLPlatform class >> reservedWords [
	^#('accessible' 'add' 'all' 'alter' 'analyze' 'and' 'as' 'asc' 'asensitive' 'before' 'between' 'bigint' 'binary' 'blob' 'both' 'by' 'call' 'cascade' 'case' 'change' 'char' 'character' 'check' 'collate' 'column' 'condition' 'constraint' 'continue' 'convert' 'create' 'cross' 'current_date' 'current_time' 'current_timestamp' 'current_user' 'cursor' 'database' 'databases' 'day_hour' 'day_microsecond' 'day_minute' 'day_second' 'dec' 'decimal' 'declare' 'default' 'delayed' 'delete' 'desc' 'describe' 'deterministic' 'distinct' 'distinctrow' 'div' 'double' 'drop' 'dual' 'each' 'else' 'elseif' 'enclosed' 'escaped' 'exists' 'exit' 'explain' 'false' 'fetch' 'float' 'float4' 'float8' 'for' 'force' 'foreign' 'from' 'fulltext' 'grant' 'group' 'having' 'high_priority' 'hour_microsecond' 'hour_minute' 'hour_second' 'if' 'ignore' 'in' 'index' 'infile' 'inner' 'inout' 'insensitive' 'insert' 'int' 'int1' 'int2' 'int3' 'int4' 'int8' 'integer' 'interval' 'into' 'is' 'iterate' 'join' 'key' 'keys' 'kill' 'leading' 'leave' 'left' 'like' 'limit' 'linear' 'lines' 'load' 'localtime' 'localtimestamp' 'lock' 'long' 'longblob' 'longtext' 'loop' 'low_priority' 'master_ssl_verify_server_cert' 'match' 'mediumblob' 'mediumint' 'mediumtext' 'middleint' 'minute_microsecond' 'minute_second' 'mod' 'modifies' 'natural' 'no_write_to_binlog' 'not' 'null' 'numeric' 'on' 'optimize' 'option' 'optionally' 'or' 'order' 'out' 'outer' 'outfile' 'precision' 'primary' 'procedure' 'purge' 'range' 'read' 'read_write' 'reads' 'real' 'references' 'regexp' 'release' 'rename' 'repeat' 'replace' 'require' 'restrict' 'return' 'revoke' 'right' 'rlike' 'schema' 'schemas' 'second_microsecond' 'select' 'sensitive' 'separator' 'set' 'show' 'smallint' 'spatial' 'specific' 'sql' 'sql_big_result' 'sql_calc_found_rows' 'sql_small_result' 'sqlexception' 'sqlstate' 'sqlwarning' 'ssl' 'starting' 'straight_join' 'table' 'terminated' 'then' 'tinyblob' 'tinyint' 'tinytext' 'to' 'trailing' 'trigger' 'true' 'undo' 'union' 'unique' 'unlock' 'unsigned' 'update' 'usage' 'use' 'using' 'utc_date' 'utc_time' 'utc_timestamp' 'values' 'varbinary' 'varchar' 'varcharacter' 'varying' 'when' 'where' 'while' 'with' 'write' 'xor' 'year_month' 'zerofill') asSet.
]

{ #category : #constants }
MySQLPlatform >> areSequencesExplicitlyCreated [
	^false.
]

{ #category : #constants }
MySQLPlatform >> autoTrimsStringsLongerThanColumnSize [
	"Answer true if the platform trims an string longer that the column size without triggering any error.
	E.g. the string 'abcde' is trimmed to 'abcd' during if the column is a CHAR(4)."

	^true
]

{ #category : #constants }
MySQLPlatform >> beArchive [
	engine := 'ARCHIVE'.
]

{ #category : #constants }
MySQLPlatform >> beBDB [
	engine := 'BDB'.
]

{ #category : #constants }
MySQLPlatform >> beBlackHole [
	engine := 'BLACKHOLE'.
]

{ #category : #constants }
MySQLPlatform >> beCSV [
	engine := 'CSV'.
]

{ #category : #constants }
MySQLPlatform >> beExample [
	engine := 'EXAMPLE'.
]

{ #category : #constants }
MySQLPlatform >> beFederated [
	engine := 'FEDERATED'.
]

{ #category : #constants }
MySQLPlatform >> beInnoDB [
	engine := 'InnoDB'.
]

{ #category : #constants }
MySQLPlatform >> beMemory [
	engine := 'MEMORY'.
]

{ #category : #constants }
MySQLPlatform >> beMyISAM [
	engine := 'MyISAM'.
]

{ #category : #binding }
MySQLPlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	^aCommand batchStatementBindings.
]

{ #category : #types }
MySQLPlatform >> blob [
	"Return the MySQL type for long blob."
	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'LONGBLOB'].
]

{ #category : #types }
MySQLPlatform >> boolean [
	^self typeNamed: #boolean ifAbsentPut: [GlorpMySQLBooleanType new typeString: 'boolean'].
]

{ #category : #testing }
MySQLPlatform >> canUseInWhereClause: aValue type: aType [
	"This is mostly for test support purposes. If we know we can't use a particular kind of value in the where clause on some database, don't try."

	(super canUseInWhereClause: aValue type: aType) ifFalse: [^false].
	"On MySQL we don't seem to be able to compare constants against blobs."
	aType = self blob ifTrue: [^false].
	^true.
]

{ #category : #constants }
MySQLPlatform >> capitalWritingOfTableName [
	"^<Boolean>"

	^false
]

{ #category : #constants }
MySQLPlatform >> charactersThatNeedEscaping [
	^#($' $\)
]

{ #category : #types }
MySQLPlatform >> clob [
	"Return the MySQL type for long text."
	^self typeNamed: #clob ifAbsentPut: [GlorpMySQLClobType new typeString: 'LONGTEXT'].
]

{ #category : #constants }
MySQLPlatform >> createTableStatementStringFor: aGLORPDatabaseTable [
	^(super createTableStatementStringFor: aGLORPDatabaseTable), ' ENGINE=', self engine.
]

{ #category : #sequences }
MySQLPlatform >> databaseSequenceClass [
	^MySQLSequence.
]

{ #category : #types }
MySQLPlatform >> date [
	"Return the type we use to represent dates."
	^self typeNamed: #date ifAbsentPut: [GlorpDateType new].
]

{ #category : #types }
MySQLPlatform >> decimal [
	^self double
]

{ #category : #constants }
MySQLPlatform >> defaultOptimalINClauseLimit [
	"MySQL users report that anything over 100 degrades performance significantly"

	^100
]

{ #category : #types }
MySQLPlatform >> double [
	^self typeNamed: #double ifAbsentPut: [GlorpDoubleType new typeString: 'double' ].
]

{ #category : #'services tables' }
MySQLPlatform >> endColumnQuote [
	"Return the character used to start quoting the name of a column so that we can avoid conflicts with reserved names. The default MySQL quoting is to use backquotes rather than the ANSI style."
	^'`'.
]

{ #category : #constants }
MySQLPlatform >> engine [
	engine ifNil: [ self beInnoDB ].
	^engine
]

{ #category : #types }
MySQLPlatform >> float [
	^self typeNamed: #float ifAbsentPut: [GlorpFloatType new typeString: 'float' ].
]

{ #category : #types }
MySQLPlatform >> float4 [
	^self float.
]

{ #category : #types }
MySQLPlatform >> float8 [
	^self double.
]

{ #category : #functions }
MySQLPlatform >> initializeFunctions [
	super initializeFunctions.
	functions at: #regexMatches: put: (InfixFunction named: 'REGEXP').
	functions at: #, put: (PrefixFunction named: 'CONCAT').
]

{ #category : #constants }
MySQLPlatform >> initializeReservedWords [
	super initializeReservedWords.
	reservedWords 
		add: 'key'.
]

{ #category : #types }
MySQLPlatform >> int2 [
	^self smallint
]

{ #category : #types }
MySQLPlatform >> int4 [
	^self typeNamed: #int4 ifAbsentPut: [GlorpIntegerType new typeString: 'int'].
]

{ #category : #types }
MySQLPlatform >> int8 [
	^self typeNamed: #int8 ifAbsentPut: [GlorpIntegerType new typeString: 'bigint'].
]

{ #category : #types }
MySQLPlatform >> integer [

	^self typeNamed: #integer ifAbsentPut: [GlorpIntegerType new typeString: 'int'].
]

{ #category : #testing }
MySQLPlatform >> isMySQLPlatform [
	^true.
]

{ #category : #constants }
MySQLPlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)
	Don't know the answer for this platform;  make something large up."

	^64
]

{ #category : #constants }
MySQLPlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"
	"Don't know, make something large up."
	^64
]

{ #category : #constants }
MySQLPlatform >> nameForPrimaryKeyConstraintsWhenDropping [
	"Return the name we use to describe a constraint when dropping them. This is required because MySQL wants you to use 'DROP PRIMARY KEY' rather than the ANSI 'DROP CONSTRAINT'."
	^'PRIMARY KEY'.
]

{ #category : #types }
MySQLPlatform >> number [

	^self typeNamed: #number ifAbsentPut: [GlorpNumericType new typeString: 'decimal'].
]

{ #category : #'conversion-times' }
MySQLPlatform >> printDate: aDate for: aType [
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $".
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPut: $".
	^stream contents.
]

{ #category : #'database-specific' }
MySQLPlatform >> printOffset: anInteger on: aCommand [
	"MySQL cannot have an offset without a limit.  A very large number, like 256T, is equivalent to an infinite limit. We only print it here if there is no limit, but there is an offset."

	aCommand query hasLimit ifFalse:
		[self printPostLimit: SmallInteger maxVal on: aCommand].
	aCommand nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.
]

{ #category : #'database-specific' }
MySQLPlatform >> printPostLimit: anInteger on: aCommand [
    aCommand
        nextPutAll: ' LIMIT '.
    anInteger printOn: aCommand.
]

{ #category : #'services tables' }
MySQLPlatform >> printSqlStatementToListColumnsInTable: aDatabaseTable inSchema: schemaString on: aStream [
	" Query to fetch column definitions in mysql in the format ActiveRecordDescriptorSystem wants"
	^(String streamContents: [ :s | s
		nextPutAll: 'select col.column_name as name, '; 
		nextPutAll: 'col.data_type as type, '; 
		nextPutAll: 'case when col.numeric_precision is not null ';
      nextPutAll:     'then col.numeric_precision ';
      nextPutAll:     'else col.character_maximum_length end as length, ';
		nextPutAll: 'if(col.is_nullable = ''YES'',1,0) as nullable, ';
		nextPutAll: 'col.column_default as default_value, ';
		nextPutAll: 'if(col.column_key = ''PRI'' or col.column_key = ''MUL'',1,0) as pk ';
		nextPutAll: 'from information_schema.tables as tab ';
		nextPutAll: 'inner join information_schema.columns as col ';
		nextPutAll:     'on col.table_schema = tab.table_schema ';
		nextPutAll:     'and col.table_name = tab.table_name ';
		nextPutAll: 'where tab.table_type = ''BASE TABLE'' ';
		nextPutAll:     'and tab.table_schema not in (''information_schema'',''mysql'',''performance_schema'',''sys'') ';
		nextPutAll:     'and tab.table_schema = ''{2}'' and col.table_name = ''{1}'' ';
		nextPutAll: 'order by tab.table_name, col.ordinal_position ']) format: { aDatabaseTable . schemaString }
		
]

{ #category : #'conversion-times' }
MySQLPlatform >> printTime: aTime for: aType [
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $".
	self
		printTime: aTime
		isoFormatOn: stream
		milliseconds: false.
	stream nextPut: $".
	^stream contents.
]

{ #category : #'conversion-times' }
MySQLPlatform >> printTimestamp: aTimestamp on: stream for: aType [
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPut: $".
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ' '.
	self
		printTime: aTimestamp
		isoFormatOn: stream
		milliseconds: false.
	stream nextPut: $".
]

{ #category : #'database-specific' }
MySQLPlatform >> queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock [
	"If aQuery has operations that we don't support, rewrite it to do them in terms of lower level operations. In particular, rewrite INTERSECT/EXCEPT operations into EXISTS clauses in a single query. Pass the new query to aBlock."
	| newQuery |
	newQuery := aQuery rewriteIntersect.
	newQuery := newQuery rewriteExcept.
	newQuery == aQuery ifFalse: [aBlock value: newQuery].
]

{ #category : #types }
MySQLPlatform >> sequence [
	^self serial.
]

{ #category : #types }
MySQLPlatform >> serial [

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'int AUTO_INCREMENT'].
]

{ #category : #types }
MySQLPlatform >> smallint [

	^self typeNamed: #smallint ifAbsentPut: [GlorpSmallIntType new typeString: 'SMALLINT'].
]

{ #category : #'services tables' }
MySQLPlatform >> startColumnQuote [
	"Return the character used to start quoting the name of a column so that we can avoid conflicts with reserved names. The default MySQL quoting is to use backquotes rather than the ANSI style."
	^'`'.
]

{ #category : #'conversion-strings' }
MySQLPlatform >> stringToByteArrayOneWayConverter [
	"This is a special converter for MySQL that is a null conversion on the way out, but converts the byte arrays that we get back from blobs into strings."
	^DelegatingDatabaseConverter
		named: #stringToByteArrayOneWay
		hostedBy: self
		fromStToDb: #nullConversion:for:
		fromDbToSt: #byteArrayToString:for:.
]

{ #category : #testing }
MySQLPlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax. Currently hard-coded, but may also vary by database version"
	^true.
]

{ #category : #testing }
MySQLPlatform >> supportsArithmeticOperatorsOnDates [
	"Answer whether arithmetic operators such as + or - can be used on DATE like columns.
	Some platforms require the use of specific functions."
	
	^false
]

{ #category : #testing }
MySQLPlatform >> supportsBinding [
	^ true
]

{ #category : #testing }
MySQLPlatform >> supportsDecimalsOnAllNumerics [
	"Return true if a general 'numeric' type will allow numbers after the decimal place"
	^false.
]

{ #category : #testing }
MySQLPlatform >> supportsIntersect [
	"Do we support operations like UNION ALL And INTERSECT."
	^false.
]

{ #category : #testing }
MySQLPlatform >> supportsLimit [
	"Do we support LIMIT ... (or something analogous to it), returning only the first N rows."

	^true
]

{ #category : #constants }
MySQLPlatform >> supportsMillisecondsInTimes [
	^false.
]

{ #category : #testing }
MySQLPlatform >> supportsOffset [
	"Do we support OFFSET ... (or something analogous to it), skipping the first N rows."

	^true
]

{ #category : #types }
MySQLPlatform >> time [
	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'time'].
]

{ #category : #types }
MySQLPlatform >> timestamp [
	"Although MySQL has a type called 'timestamp', 'datetime' is more suitable."
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'DATETIME'].
]

{ #category : #types }
MySQLPlatform >> typeWithDatabaseName: aString characterWidth: aNumber extraInformation: extraValue [
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	extraValue = 'auto_increment' ifTrue: [^self serial].
	^super typeWithDatabaseName: aString characterWidth: aNumber.
]

{ #category : #testing }
MySQLPlatform >> usesArrayBindingRatherThanGroupWriting [
	^false.
]

{ #category : #testing }
MySQLPlatform >> usesArrayBindingRatherThanGrouping [
	^false.
]

{ #category : #testing }
MySQLPlatform >> usesIdentityColumns [
	^true.
]

{ #category : #testing }
MySQLPlatform >> usesInformationSchema [

	^true
]

{ #category : #testing }
MySQLPlatform >> usesLengthNotEndPosInSubstring [
	^true
]

{ #category : #testing }
MySQLPlatform >> usesPrimaryKeyUniqueConstraintNames [
	"When dropping/creating primary key constraints, do they have distinguished names."
	^false.
]

{ #category : #types }
MySQLPlatform >> varchar [
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new].
]

{ #category : #'services constraints' }
MySQLPlatform >> writeConstraintToDrop: aConstraint onStream: aStream [
	"Return the term we use to describe a constraint when dropping them.  This is required because MySQL wants you to use
		'DROP PRIMARY KEY' for primary key constraints (and then says don't name the constraint name in the drop statement!)
		'DROP FOREIGN KEY'  for foreign key constraints
		'DROP KEY' for unique constraints (it also supports DROP INDEX for this)
	rather than the ANSI 'DROP CONSTRAINT'."

	aConstraint isForeignKeyConstraint ifTrue: [aStream nextPutAll: 'FOREIGN KEY'].
	aConstraint isPrimaryKeyConstraint ifTrue: [aStream nextPutAll: 'PRIMARY KEY'].
	aConstraint isUniqueConstraint ifTrue: [aStream nextPutAll: 'KEY'].
	aConstraint isPrimaryKeyConstraint ifFalse:
		[aStream
			nextPut: $ ;
			nextPutAll: aConstraint name].
]
