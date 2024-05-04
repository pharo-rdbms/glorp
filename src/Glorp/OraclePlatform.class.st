"
This is a platform for Oracle databases. Currently there's only one, but it might be better for some purposes to separate out by versions, as some older versions don't support all features.
"
Class {
	#name : 'OraclePlatform',
	#superclass : 'DatabasePlatform',
	#category : 'Glorp-Platforms',
	#package : 'Glorp',
	#tag : 'Platforms'
}

{ #category : 'as yet unclassified' }
OraclePlatform class >> reservedWords [
	^#('access' 'account' 'activate' 'add' 'admin' 'advise' 'after' 'all' 'all_rows' 'allocate' 'alter' 'analyze' 'and' 'any' 'archive' 'archivelog' 'array' 'as' 'asc' 'at' 'audit' 'authenticated' 'authorization' 'autoextend' 'automatic' 'backup' 'become' 'before' 'begin' 'between' 'bfile' 'bitmap' 'blob' 'block' 'body' 'by' 'cache' 'cache_instances' 'cancel' 'cascade' 'cast' 'cfile' 'chained' 'change' 'char' 'char_cs' 'character' 'check' 'checkpoint' 'choose' 'chunk' 'clear' 'clob' 'clone' 'close' 'close_cached_open_cursors' 'cluster' 'coalesce' 'column' 'columns' 'comment' 'commit' 'committed' 'compatibility' 'compile' 'complete' 'composite_limit' 'compress' 'compute' 'connect' 'connect_time' 'constraint' 'constraints' 'contents' 'continue' 'controlfile' 'convert' 'cost' 'cpu_per_call' 'cpu_per_session' 'create' 'curren_user' 'current' 'current_schema' 'cursor' 'cycle' 'dangling' 'database' 'datafile' 'datafiles' 'dataobjno' 'date' 'dba' 'dbhigh' 'dblow' 'dbmac' 'deallocate' 'debug' 'dec' 'decimal' 'declare' 'default' 'deferrable' 'deferred' 'degree' 'delete' 'deref' 'desc' 'directory' 'disable' 'disconnect' 'dismount' 'distinct' 'distributed' 'dml' 'double' 'drop' 'dump' 'each' 'else' 'enable' 'end' 'enforce' 'entry' 'escape' 'except' 'exceptions' 'exchange' 'excluding' 'exclusive' 'execute' 'exists' 'expire' 'explain' 'extent' 'extents' 'externally' 'failed_login_attempts' 'false' 'fast' 'file' 'first_rows' 'flagger' 'float' 'flob' 'flush' 'for' 'force' 'foreign' 'freelist' 'freelists' 'from' 'full' 'function' 'global' 'global_name' 'globally' 'grant' 'group' 'groups' 'hash' 'hashkeys' 'having' 'header' 'heap' 'identified' 'idgenerators' 'idle_time' 'if' 'immediate' 'in' 'including' 'increment' 'ind_partition' 'index' 'indexed' 'indexes' 'indicator' 'initial' 'initially' 'initrans' 'insert' 'instance' 'instances' 'instead' 'int' 'integer' 'intermediate' 'intersect' 'into' 'is' 'isolation' 'isolation_level' 'keep' 'key' 'kill' 'label' 'layer' 'less' 'level' 'library' 'like' 'limit' 'link' 'list' 'lob' 'local' 'lock' 'locked' 'log' 'logfile' 'logging' 'logical_reads_per_call' 'logical_reads_per_session' 'long' 'manage' 'master' 'max' 'maxarchlogs' 'maxdatafiles' 'maxextents' 'maxinstances' 'maxlogfiles' 'maxloghistory' 'maxlogmembers' 'maxsize' 'maxtrans' 'maxvalue' 'member' 'min' 'minextents' 'minimum' 'minus' 'minvalue' 'mls_label_format' 'mlslabel' 'mode' 'modify' 'mount' 'move' 'mts_dispatchers' 'multiset' 'national' 'nchar' 'nchar_cs' 'nclob' 'needed' 'nested' 'network' 'new' 'next' 'noarchivelog' 'noaudit' 'nocache' 'nocompress' 'nocycle' 'noforce' 'nologging' 'nomaxvalue' 'nominvalue' 'none' 'noorder' 'nooverride' 'noparallel' 'noreverse' 'normal' 'nosort' 'not' 'nothing' 'nowait' 'null' 'number' 'numeric' 'nvarchar2' 'object' 'objno' 'objno_reuse' 'of' 'off' 'offline' 'oid' 'oidindex' 'old' 'on' 'online' 'only' 'opcode' 'open' 'optimal' 'optimizer_goal' 'option' 'or' 'order' 'organization' 'oslabel' 'overflow' 'own' 'package' 'parallel' 'partition' 'password' 'password_grace_time' 'password_life_time' 'password_lock_time' 'password_reuse_max' 'password_reuse_time' 'password_verify_function' 'pctfree' 'pctincrease' 'pctthreshold' 'pctused' 'pctversion' 'percent' 'permanent' 'plan' 'plsql_debug' 'post_transaction' 'precision' 'preserve' 'primary' 'prior' 'private' 'private_sga' 'privilege' 'privileges' 'procedure' 'profile' 'public' 'purge' 'queue' 'quota' 'range' 'raw' 'rba' 'read' 'readup' 'real' 'rebuild' 'recover' 'recoverable' 'recovery' 'ref' 'references' 'referencing' 'refresh' 'rename' 'replace' 'reset' 'resetlogs' 'resize' 'resource' 'restricted' 'return' 'returning' 'reuse' 'reverse' 'revoke' 'role' 'roles' 'rollback' 'row' 'rowid' 'rownum' 'rows' 'rule' 'sample' 'savepoint' 'sb4' 'scan_instances' 'schema' 'scn' 'scope' 'sd_all' 'sd_inhibit' 'sd_show' 'seg_block' 'seg_file' 'segment' 'select' 'sequence' 'serializable' 'session' 'session_cached_cursors' 'sessions_per_user' 'set' 'share' 'shared' 'shared_pool' 'shrink' 'size' 'skip' 'skip_unusable_indexes' 'smallint' 'snapshot' 'some' 'sort' 'specification' 'split' 'sql_trace' 'standby' 'start' 'statement_id' 'statistics' 'stop' 'storage' 'store' 'structure' 'successful' 'switch' 'synonym' 'sys_op_enforce_not_null$' 'sys_op_ntcimg$' 'sysdate' 'sysdba' 'sysoper' 'system' 'table' 'tables' 'tablespace' 'tablespace_no' 'tabno' 'temporary' 'than' 'the' 'then' 'thread' 'time' 'timestamp' 'to' 'toplevel' 'trace' 'tracing' 'transaction' 'transitional' 'trigger' 'triggers' 'true' 'truncate' 'tx' 'type' 'ub2' 'uba' 'uid' 'unarchived' 'undo' 'union' 'unique' 'unlimited' 'unlock' 'unrecoverable' 'until' 'unusable' 'unused' 'updatable' 'update' 'usage' 'use' 'user' 'using' 'validate' 'validation' 'value' 'values' 'varchar' 'varchar2' 'varying' 'view' 'when' 'whenever' 'where' 'with' 'without' 'work' 'write' 'writedown' 'writeup' 'xid' 'year' 'zone') asSet.
]

{ #category : 'constants' }
OraclePlatform >> areSequencesExplicitlyCreated [
	^true.
]

{ #category : 'binding' }
OraclePlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	^aCommand arrayBindings.
]

{ #category : 'types' }
OraclePlatform >> boolean [
	^self int2.
]

{ #category : 'testing' }
OraclePlatform >> canUseInWhereClause: aValue type: aType [
	"This is mostly for test support purposes. If we know we can't use a particular kind of value in the where clause on some database, don't try."

	(super canUseInWhereClause: aValue type: aType) ifFalse: [^false].
	"On Oracle we effectively can't compare constants against blobs."
	aType = self blob ifFalse: [^true].
	aValue isNil ifTrue: [^true].
	^false.
]

{ #category : 'types' }
OraclePlatform >> char [
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new].
]

{ #category : 'types' }
OraclePlatform >> clob [

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'clob'].
]

{ #category : 'database - specific' }
OraclePlatform >> compoundOperationFor: aSymbol [
	"Return the platform specific version of a compound statement symbol"
	aSymbol == #EXCEPT ifTrue: [^'MINUS'].
	^aSymbol.
]

{ #category : 'services columns' }
OraclePlatform >> createAlterColumnStatement: aField newType: aType usingExpression: expression [

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll: aType typeString, ')'.

	^sqlStatementStream contents
]

{ #category : 'services columns' }
OraclePlatform >> createAlterColumnStatement: aField setDefault: anObject [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'DEFAULT';
		space.
	anObject printOn: sqlStatementStream.
	sqlStatementStream
		nextPutAll:  ')'.
	
	^sqlStatementStream contents
]

{ #category : 'services columns' }
OraclePlatform >> createAlterColumnStatementDropDefault: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'DEFAULT NULL)'.

	^sqlStatementStream contents
]

{ #category : 'services columns' }
OraclePlatform >> createAlterColumnStatementDropNotNull: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'NULL)'.

	
	^sqlStatementStream contents
]

{ #category : 'services columns' }
OraclePlatform >> createAlterColumnStatementSetNotNull: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' MODIFY (';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  self sqlTextForNOTNULLAttributeConstraint;
		nextPutAll: ')'.

	
	^sqlStatementStream contents
]

{ #category : 'sequences' }
OraclePlatform >> databaseSequenceClass [
	^OracleSequence.
]

{ #category : 'types' }
OraclePlatform >> date [
	^self typeNamed: #date ifAbsentPut: [GlorpTimeStampType new typeString: 'date'].
]

{ #category : 'types' }
OraclePlatform >> double [
	^self float8
]

{ #category : 'constants' }
OraclePlatform >> endColumnAddString [
	"The string we use as a suffix when adding a colum"
	^' ) '.
]

{ #category : 'types' }
OraclePlatform >> float [
	^self float4.
]

{ #category : 'types' }
OraclePlatform >> float4 [
	^self typeNamed: #float4 ifAbsentPut: [GlorpFloatType new typeString: 'float'].
]

{ #category : 'types' }
OraclePlatform >> float8 [
	^self typeNamed: #float8 ifAbsentPut: [GlorpDoubleType new typeString: 'double precision'].
]

{ #category : 'functions' }
OraclePlatform >> initializeFunctions [
	| baseExists dbSpecificExists selectList baseNotExists dbSpecificNotExists |
	super initializeFunctions.
	functions at: #regexMatches: put: (PrefixFunction named: 'REGEXP_LIKE').

	"Oracle doesn't allow functions like EXISTS in a field list, but will allow a select there as an argument to a function, such as DECODE. So print it that way if we're in the select list."
	baseExists := functions at: #exists:.
	dbSpecificExists := DualRoleFunction new.
	dbSpecificExists function: '#exists:'.
	dbSpecificExists whereClauseVersion: baseExists.
	selectList := PrefixFunction named: 'DECODE'.
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 1 asGlorpExpression with: 0 asGlorpExpression].
	selectList type: baseExists type.
	dbSpecificExists selectListVersion: selectList.
	dbSpecificExists type: baseExists type.
	functions at: #exists: put: dbSpecificExists.

	"And similarly NOT EXISTS"
	baseNotExists := functions at: #notExists:.
	dbSpecificNotExists := DualRoleFunction new.
	dbSpecificNotExists function: '#notExists:'.
	dbSpecificNotExists whereClauseVersion: baseNotExists.
	selectList := PrefixFunction named: 'DECODE'.
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 0 asGlorpExpression with: 1 asGlorpExpression].
	selectList type: baseNotExists type.
	dbSpecificNotExists selectListVersion: selectList.
	dbSpecificNotExists type: baseExists type.
	functions at: #notExists: put: dbSpecificNotExists.
]

{ #category : 'constants' }
OraclePlatform >> initializeReservedWords [
	super initializeReservedWords.
	reservedWords add: 'number'.
]

{ #category : 'types' }
OraclePlatform >> int [

	^self integer
]

{ #category : 'types' }
OraclePlatform >> int2 [

	^self integer
]

{ #category : 'types' }
OraclePlatform >> int4 [

	^self integer
]

{ #category : 'types' }
OraclePlatform >> int8 [

	^self integer
]

{ #category : 'SQL' }
OraclePlatform >> isOraclePlatform [

	^true
]

{ #category : 'constants' }
OraclePlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)"

	^30
]

{ #category : 'constants' }
OraclePlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"

	^30
]

{ #category : 'testing' }
OraclePlatform >> maximumQueryValueSize [
	"If there's a limit on how big a bound input parameter can be for a query, return it here. By default, no maximum. "
	^4001
]

{ #category : 'testing' }
OraclePlatform >> measuresStringFieldWidthsInBytes [
	"Return true if we measure the width of a string in bytes rather than characters. So, a 255-character field can hold 255 bytes worth of string, not 255 characters. This is important with encodings."

	^true
]

{ #category : 'types' }
OraclePlatform >> number [

	^self typeNamed: #number ifAbsentPut: [GlorpNumericType new typeString: 'number'].
]

{ #category : 'constants' }
OraclePlatform >> primaryKeysAreAutomaticallyUnique [
	"Return false if, in addition to specifying something as a primary key, we must separately specify it as unique"

	^true.
]

{ #category : 'conversion - strings' }
OraclePlatform >> printBlob: aByteArray on: aStream for: aType [
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	aStream nextPutAll: 'HEXTORAW('''.
	aByteArray do: [:each |
		each printOn: aStream paddedWith: $0 to: 2 base: 16].
	aStream nextPutAll: ''')'.
]

{ #category : 'conversion-times' }
OraclePlatform >> printDate: aDate for: aType [
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: 'to_date('''.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'YYYY-MM-DD'.
	stream nextPutAll: ''')'.
	^stream contents.
]

{ #category : 'table creation' }
OraclePlatform >> printNumericFieldOfSize: anInteger on: aStream [

	aStream 
		nextPutAll: 'number('.
	anInteger printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : 'services tables' }
OraclePlatform >> printSqlStatementToListTablesInSchema: schemaString on: aStream [
	"Not standardized"

	| lowerSchema |
	lowerSchema := (schemaString isNil or: [schemaString isEmpty])
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT table_name FROM all_tables '.
	(lowerSchema notNil and: [lowerSchema notEmpty]) ifTrue:
		[aStream 
			nextPutAll: 'WHERE lower(owner) = ';
			nextPut: $';
			nextPutAll: lowerSchema;
			nextPut: $']
]

{ #category : 'services tables' }
OraclePlatform >> printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream [
	" This query will test only for tables that the logged on user has access to... "

	| lowerTableName lowerSchema |
	lowerTableName := tableName asLowercase.
	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT count(*) FROM all_tables ';
		nextPutAll: 'WHERE lower(table_name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPutAll: ' AND lower(owner) = ';
		nextPut: $';
		nextPutAll: lowerSchema;
		nextPut: $'
]

{ #category : 'table creation' }
OraclePlatform >> printStringFieldOfSize: anInteger on: aStream [

	aStream 
		nextPutAll: 'varchar2('.
	anInteger printOn: aStream.
	aStream nextPutAll: ')'.
]

{ #category : 'conversion-times' }
OraclePlatform >> printTime: aTime for: aType [
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: 'to_date('''.
	self
		printTime: aTime
		isoFormatOn: stream.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'HH24:MI:SS'.
	stream nextPutAll: ''')'.
	^stream contents.
]

{ #category : 'conversion-times' }
OraclePlatform >> printTimestamp: aTimestamp on: stream for: aType [
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPutAll: 'to_date('''.
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPut: $ .
	self
		printTime: aTimestamp
		isoFormatOn: stream
		milliseconds: false.
	stream nextPutAll: ''','''.
	stream nextPutAll: 'YYYY-MM-DD HH24:MI:SS'.
	stream nextPutAll: ''')'.
]

{ #category : 'types' }
OraclePlatform >> raw [
	^self typeNamed: #raw ifAbsentPut: [GlorpBlobType new typeString: 'raw'].
]

{ #category : 'constants' }
OraclePlatform >> requiresTransactionForTableOperations [
	"Return true if we need a transaction in order to do table creation, deletion, and so forth. Some databases require it. Others don't like it"
	^false.
]

{ #category : 'types' }
OraclePlatform >> sequence [

	^self serial.
]

{ #category : 'types' }
OraclePlatform >> serial [

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: (self integer typeString)].
]

{ #category : 'constants' }
OraclePlatform >> sqlTextCurrentServerUTCTimestamp [

	^'SELECT SYS_EXTRACT_UTC(CURRENT_TIMESTAMP) FROM DUAL'
]

{ #category : 'constants' }
OraclePlatform >> startColumnAddString [
	"The string we use as a prefix when adding a colum"
	^' ( '.
]

{ #category : 'testing' }
OraclePlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax. Currently hard-coded, but may also vary by database version"
	^false.
]

{ #category : 'testing' }
OraclePlatform >> supportsBinding [
	"Binding works only with VW EXDI so far"
	^false.
]

{ #category : 'testing' }
OraclePlatform >> supportsGroupWritingFor: aCommand [
	^self supportsBinding and: [self useBinding and: [aCommand supportsGroupWriting]].
]

{ #category : 'constants' }
OraclePlatform >> supportsMillisecondsInTimes [
	^false.
]

{ #category : 'testing' }
OraclePlatform >> supportsSettingSequenceIncrement [
	"Return true if this platform can support creating a sequence with an increment other than 1."

	^true.
]

{ #category : 'testing' }
OraclePlatform >> supportsTableOwners [
	^true
]

{ #category : 'types' }
OraclePlatform >> text [
	^self clob.
]

{ #category : 'types' }
OraclePlatform >> time [
	^self timestamp.
]

{ #category : 'types' }
OraclePlatform >> timestamp [
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'date'].
]

{ #category : 'conversion-times' }
OraclePlatform >> timestampConverter [
	^DelegatingDatabaseConverter
		named: #timestamp
		hostedBy: self
		fromStToDb: #asTimestamp:for:
		fromDbToSt: #readTimestamp:for:.
]

{ #category : 'testing' }
OraclePlatform >> useOracleOuterJoins [
	"Return true if we use the old Oracle x = y (+) syntax for outer joins"
	^true.
]

{ #category : 'testing' }
OraclePlatform >> usesArrayBindingRatherThanGroupWriting [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^true.
]

{ #category : 'testing' }
OraclePlatform >> usesLengthNotEndPosInSubstring [
	^true
]

{ #category : 'constants' }
OraclePlatform >> usesNullForEmptyStrings [
	"Return true if this database is likely to use nil as an empty string value"
	^true.
]

{ #category : 'types' }
OraclePlatform >> varchar [
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new typeName: 'varchar2'].
]
