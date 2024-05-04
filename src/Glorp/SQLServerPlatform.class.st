"
This is a platform for the Microsoft SQL Server database.
"
Class {
	#name : 'SQLServerPlatform',
	#superclass : 'DatabasePlatform',
	#category : 'Glorp-Platforms',
	#package : 'Glorp',
	#tag : 'Platforms'
}

{ #category : 'as yet unclassified' }
SQLServerPlatform class >> reservedWords [

	^#('@@identity' 'add' 'all' 'alter' 'and' 'any' 'as' 'asc' 'authorization' 'avg' 'backup' 'begin' 'between' 'break' 'browse' 'bulk' 'by' 'cascade' 'case' 'check' 'checkpoint' 'close' 'clustered' 'coalesce' 'collate' 'column' 'commit' 'compute' 'constraint' 'contains' 'containstable' 'continue' 'convert' 'count' 'create' 'cross' 'current' 'current_date' 'current_time' 'current_timestamp' 'current_user' 'cursor' 'database' 'databasepassword' 'dateadd' 'datediff' 'datename' 'datepart' 'dbcc' 'deallocate' 'declare' 'default' 'delete' 'deny' 'desc' 'disk' 'distinct' 'distributed' 'double' 'drop' 'dump' 'else' 'encryption' 'end' 'errlvl' 'escape' 'except' 'exec' 'execute' 'exists' 'exit' 'expression' 'fetch' 'file' 'fillfactor' 'for' 'foreign' 'freetext' 'freetexttable' 'from' 'full' 'function' 'goto' 'grant' 'group' 'having' 'holdlock' 'identity' 'identity_insert' 'identitycol' 'if' 'in' 'index' 'inner' 'insert' 'intersect' 'into' 'is' 'join' 'key' 'kill' 'left' 'like' 'lineno' 'load' 'max' 'min' 'national' 'nocheck' 'nonclustered' 'not' 'null' 'nullif' 'of' 'off' 'offsets' 'on' 'open' 'opendatasource' 'openquery' 'openrowset' 'openxml' 'option' 'or' 'order' 'outer' 'over' 'percent' 'plan' 'precision' 'primary' 'print' 'proc' 'procedure' 'public' 'raiserror' 'read' 'readtext' 'reconfigure' 'references' 'replication' 'restore' 'restrict' 'return' 'revoke' 'right' 'rollback' 'rowcount' 'rowguidcol' 'rule' 'save' 'schema' 'select' 'session_user' 'set' 'setuser' 'shutdown' 'some' 'statistics' 'sum' 'system_user' 'table' 'textsize' 'then' 'to' 'top' 'tran' 'transaction' 'trigger' 'truncate' 'tsequal' 'union' 'unique' 'update' 'updatetext' 'use' 'user' 'values' 'varying' 'view' 'waitfor' 'when' 'where' 'while' 'with' 'writetext')
		asSet
]

{ #category : 'constants' }
SQLServerPlatform >> areSequencesExplicitlyCreated [

^false
]

{ #category : 'binding' }
SQLServerPlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	^aCommand batchStatementBindings.
]

{ #category : 'types' }
SQLServerPlatform >> bit [
	^self typeNamed: #bit ifAbsentPut: [GlorpBooleanType new typeString: 'bit'].
]

{ #category : 'types' }
SQLServerPlatform >> blob [

	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'varbinary(max)'; queryType: (self varbinary)].
]

{ #category : 'types' }
SQLServerPlatform >> boolean [
	^self bit.
]

{ #category : 'conversion - boolean' }
SQLServerPlatform >> booleanToBooleanConverter [
	^DelegatingDatabaseConverter
		named: #booleanToBoolean
		hostedBy: self
		fromStToDb: #convertBooleanToInteger:for:
		fromDbToSt: #convertDBBooleanToBoolean:for:.
]

{ #category : 'constants' }
SQLServerPlatform >> capitalWritingOfTableName [
	"^<Boolean>"

	^false
]

{ #category : 'types' }
SQLServerPlatform >> char [
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new].
]

{ #category : 'conversion - strings' }
SQLServerPlatform >> charactersThatNeedEscaping [
	"There seem to be all kind of contradictory bits of information about what sql server does/requires for escaped characters, all of which differ from standard sql. Empirically the only thing that requires escaping appears to be single quote"
	^#($' ).
]

{ #category : 'types' }
SQLServerPlatform >> clob [

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'varchar(max)'].
]

{ #category : 'database - specific' }
SQLServerPlatform >> compoundOperationFor: aSymbol [
	"Return the platform specific version of a compound statement symbol"
	aSymbol == #INTERSECT ifTrue: [^'WHERE EXISTS'].
	aSymbol == #MINUS ifTrue: [^'WHERE NOT EXISTS'].
	^aSymbol.
]

{ #category : 'services columns' }
SQLServerPlatform >> createAlterColumnStatement: aField newType: aType usingExpression: expression [

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll: aType typeString.
	expression ifNotNil: [ sqlStatementStream nextPutAll: ' USING ', expression ].

	^sqlStatementStream contents
]

{ #category : 'services columns' }
SQLServerPlatform >> createAlterColumnStatement: aField setDefault: anObject [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'DEFAULT ';
		space.
	anObject printOn: sqlStatementStream.
	sqlStatementStream
		nextPutAll:  ' WITH VALUES'.
	
	^sqlStatementStream contents
]

{ #category : 'services columns' }
SQLServerPlatform >> createAlterColumnStatementDropDefault: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll:  'DEFAULT NULL'.

	^sqlStatementStream contents
]

{ #category : 'services columns' }
SQLServerPlatform >> createAlterColumnStatementDropNotNull: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll: aField type typeString;
		space;
		nextPutAll:  'NULL'.

	
	^sqlStatementStream contents
]

{ #category : 'services columns' }
SQLServerPlatform >> createAlterColumnStatementSetNotNull: aField [
	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll:  'ALTER TABLE';
		space.
		self printDDLTableNameFor: aField table on: sqlStatementStream.

	sqlStatementStream
		nextPutAll:  ' ALTER COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name);
		space;
		nextPutAll: aField type typeString;
		space;
		nextPutAll:  self sqlTextForNOTNULLAttributeConstraint.

	
	^sqlStatementStream contents
]

{ #category : 'sequences' }
SQLServerPlatform >> databaseSequenceClass [
	"My AccessPlatform subclass has a hardcoded check in StoreDescriptorSystem>>sequenceFor: to ignore this method in favour of calling #justSelectTheMaximumCurrentValueAndAddOneSequenceFor: for AccessPlatform.  Can we retire that?"

	^SQLServerSequence
]

{ #category : 'types' }
SQLServerPlatform >> date [
	"SQL Server does not compare a timestamp that's cast to a date as being equal to a date, which is the behaviour we expect. Its dates are really timestamps internally, so just treat date and timestamp as the same."
	^self timestamp.
]

{ #category : 'conversion - times' }
SQLServerPlatform >> dateConverter [
	"SQL server doesn't have plain dates, and doesn't accept them"
	^DelegatingDatabaseConverter
		named: #date
		hostedBy: self
		fromStToDb: #dateToTimestampConversion:for:
		fromDbToSt: #readDate:for:.	"#printDate:for:"
]

{ #category : 'conversion - times' }
SQLServerPlatform >> dateToTimestampConversion: aDate for: aType [
	aDate isNil ifTrue: [^aDate].
	^aDate asTimestamp.
]

{ #category : 'types' }
SQLServerPlatform >> decimal [
	^self numeric.
]

{ #category : 'types' }
SQLServerPlatform >> double [
	^self float.
]

{ #category : 'conversion - strings' }
SQLServerPlatform >> escapeFor: aCharacter [
	^String with: $' with: aCharacter.
"	^'\', (aCharacter asInteger printStringRadix: 16)."
]

{ #category : 'exdi specific' }
SQLServerPlatform >> exdiTypeForDates [
	^#Timestamp.
]

{ #category : 'types' }
SQLServerPlatform >> float [

	^self typeNamed: #float ifAbsentPut: [GlorpMSSQLFloatType new].
]

{ #category : 'types' }
SQLServerPlatform >> float4 [
	^self float.
]

{ #category : 'types' }
SQLServerPlatform >> float8 [
	^self float.
]

{ #category : 'functions' }
SQLServerPlatform >> initializeFunctions [
	| baseExists dbSpecificExists selectList baseNotExists dbSpecificNotExists |
	super initializeFunctions.
	functions
		at: #, put: (InfixFunction named: '+');
		at: #copyFrom:to: put: (SubstringFunction named: 'SUBSTRING');
		at: #objectId put: (PrefixFunction named: 'OBJECT_ID');
		at: #columnPropertySchema:property: put: ((PrefixFunction named: 'COLUMNPROPERTY') type: self integer);
		at: #convertTo: put: ((PrefixFunction named: 'CONVERT')). "CONVERT(toType, aThing)"

	"Like Oracle, SQL Server doesn't allow functions like EXISTS in a field list,
	but will allow a select there as an argument to a function, such as CASE.
	So print it that way if we're in the select list."

	baseExists := functions at: #exists:.
	dbSpecificExists := DualRoleFunction new.
	dbSpecificExists function: '#exists:'.
	dbSpecificExists whereClauseVersion: baseExists.
	selectList := Case new argumentTypes: (Array with: (self varchar: 1) with: self integer with: self integer).
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 1 asGlorpExpression with: 0 asGlorpExpression].
	dbSpecificExists selectListVersion: selectList.
	dbSpecificExists type: self integer.
	functions at: #exists: put: dbSpecificExists.

	"And similarly NOT EXISTS"
	baseNotExists := functions at: #notExists:.
	dbSpecificNotExists := DualRoleFunction new.
	dbSpecificNotExists function: '#notExists:'.
	dbSpecificNotExists whereClauseVersion: baseNotExists.
	selectList := Case new argumentTypes: (Array with: (self varchar: 1) with: self integer with: self integer).
	selectList argumentModifierBlock: [:function :args | 
		function base: args first.
		Array with: 'x' asGlorpExpression with: 0 asGlorpExpression with: 1 asGlorpExpression].
	dbSpecificNotExists selectListVersion: selectList.
	dbSpecificNotExists type: self integer.
	functions at: #notExists: put: dbSpecificNotExists.
]

{ #category : 'constants' }
SQLServerPlatform >> initializeReservedWords [
	super initializeReservedWords.
	reservedWords add: 'key'.
]

{ #category : 'types' }
SQLServerPlatform >> int [
	^self integer.
]

{ #category : 'types' }
SQLServerPlatform >> int2 [
	^self smallint.
]

{ #category : 'types' }
SQLServerPlatform >> int4 [

	^self integer.
]

{ #category : 'types' }
SQLServerPlatform >> int8 [

	^self numeric.
]

{ #category : 'types' }
SQLServerPlatform >> integer [

	^self typeNamed: #integer ifAbsentPut: [GlorpIntegerType new typeString: 'int'].
]

{ #category : 'testing' }
SQLServerPlatform >> isODBCPlatform [

	^true
]

{ #category : 'testing' }
SQLServerPlatform >> isSQLServerPlatform [

	^true
]

{ #category : 'constants' }
SQLServerPlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)"

	^128
]

{ #category : 'constants' }
SQLServerPlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"

	^128
]

{ #category : 'binding' }
SQLServerPlatform >> maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows [
	"If we are going to group write, how many rows of this collection should we do it for at once"
	^aCollectionOfDatabaseRows size min: 250.
]

{ #category : 'types' }
SQLServerPlatform >> nchar [
	^self typeNamed: #nchar ifAbsentPut: [GlorpCharType new typeString: 'nchar']
]

{ #category : 'types' }
SQLServerPlatform >> nclob [

	^self typeNamed: #nclob ifAbsentPut: [GlorpClobType new typeString: 'nvarchar(max)'].
]

{ #category : 'types' }
SQLServerPlatform >> ntext [
	^self typeNamed: #ntext ifAbsentPut: [GlorpClobType new typeString: 'ntext']
]

{ #category : 'types' }
SQLServerPlatform >> numeric [
	^self typeNamed: #numeric ifAbsentPut: [GlorpNumericType new].
]

{ #category : 'types' }
SQLServerPlatform >> nvarchar [
	^self typeNamed: #nvarchar ifAbsentPut: [GlorpVarCharType new typeString: 'nvarchar'].
]

{ #category : 'conversion - strings' }
SQLServerPlatform >> printBlob: aByteArray on: aStream for: aType [
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	aStream nextPutAll: '0x'.
	aByteArray do: [:each |
		each printOn: aStream paddedWith: $0 to: 2 base: 16].
]

{ #category : 'conversion - boolean' }
SQLServerPlatform >> printBoolean: aBoolean for: aType [
	"If the platform is MS SQL Server, a boolean object in a SELECT needs to be converted to  BIT type, since T, Y, or true make SQLServer complain. "
	
	| string |
	aBoolean isNil ifTrue: [^'NULL'].
	"We may be getting passed something that's already 1 or 0, or something else instead of a boolean. That probably shouldn't be happening, but let's handle it gracefully. We define gracefully to mean 1 is true, and everything else is false"
	string := (aBoolean == 1 or: [aBoolean = true]) 
		ifTrue: ['1'] 
		ifFalse: ['0'].
	^'CONVERT( BIT, ' , string , ' )'.
]

{ #category : 'conversion - times' }
SQLServerPlatform >> printDate: aDate for: aType [
	"Print a date (or timestamp) as yyyy-mm-dd"
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: '{ d '''.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPutAll: ''' }'.
	^stream contents.
]

{ #category : 'database - specific' }
SQLServerPlatform >> printPreLimit: anInteger on: aCommand [
	aCommand
		nextPutAll: ' TOP '.
	anInteger printOn: aCommand.
	aCommand nextPutAll: ' '.
]

{ #category : 'services tables' }
SQLServerPlatform >> printSqlStatementToListTablesInSchema: schemaString on: aStream [
	"Not standardized"

	| schema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	schema := (schemaString isNil or: [schemaString isEmpty])
		ifTrue: ['']
		ifFalse: [schemaString, '.'].
	aStream
		nextPutAll: 'SELECT TABLE_NAME FROM ' ;
		nextPutAll: schema;
		nextPutAll: 'INFORMATION_SCHEMA.TABLES ';
		nextPut: $;
]

{ #category : 'services tables' }
SQLServerPlatform >> printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream [
	"This query will test only for tables that the logged on user has access to..  Glorp supports case-preserving creation of tables in SQLServer (see capitalWritingOfTableName) but this tests case-insensitively, compatibly with its polymorphs in this hierarchy."

	| lowerTableName schema |
	lowerTableName := tableName asLowercase.
	schema := schemaString isNil
		ifTrue: ['']
		ifFalse: [schemaString, '.'].
	aStream
		nextPutAll: 'SELECT count(*) FROM ' ;
		nextPutAll: schema;
		nextPutAll: 'INFORMATION_SCHEMA.TABLES ';
		nextPutAll: 'WHERE lower(TABLE_NAME) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPut: $;
]

{ #category : 'conversion - times' }
SQLServerPlatform >> printTime: aTime for: aType [
	"Print a time (or timestamp) as hh:mm:ss.fff"
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPutAll: '{ t '''.
	self
		printTime: aTime
		isoFormatOn: stream
		milliseconds: self supportsMillisecondsInTimes.
	stream nextPutAll: ''' }'.
	^stream contents.
]

{ #category : 'conversion - times' }
SQLServerPlatform >> printTimestamp: aTimestamp on: stream for: aType [
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPutAll: '{ ts '''.
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ' '.
	self
		printTime: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ''' }'.
]

{ #category : 'database - specific' }
SQLServerPlatform >> queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock [
	"If aQuery has operations that we don't support, rewrite it to do them in terms of lower level operations. In particular, rewrite INTERSECT/EXCEPT operations into EXISTS clauses in a single query. Pass the new query to aBlock."
	| newQuery |
	newQuery := aQuery rewriteIntersect.
	newQuery := newQuery rewriteExcept.
	newQuery == aQuery ifFalse: [aBlock value: newQuery].
]

{ #category : 'types' }
SQLServerPlatform >> real [
	^self float.
]

{ #category : 'conversion - strings' }
SQLServerPlatform >> removeNestedParensFromString: aString [
	"Return a Smalltalk instance of the type indicated by aGlorpType.  SQL-Server wraps aString in parentheses, so uwrap it first.  If aString is nil, ensure we return nil."

	| debracket |
	aString size < 2 ifTrue: [^aString].	"relies on nil size = 0"
	debracket := aString copy.
	[debracket first = $( and: [debracket last = $)]]
		whileTrue: [debracket := debracket copyFrom: 2 to: debracket size - 1].
	^debracket
]

{ #category : 'constants' }
SQLServerPlatform >> requiresTransactionForTableOperations [
	"SQL Server, over ODBC doesn't support DDL transactions reliably, since the current transaction can be rolled back without notice. So we avoid this."
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> reusePreparedStatements [
	^false
]

{ #category : 'types' }
SQLServerPlatform >> sequence [
	^self serial.
]

{ #category : 'types' }
SQLServerPlatform >> serial [

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'int  IDENTITY (1, 1) '].
]

{ #category : 'constants' }
SQLServerPlatform >> sqlTextCurrentServerUTCTimestamp [

	^'SELECT GETUTCDATE()'
]

{ #category : 'constants' }
SQLServerPlatform >> startColumnAddString [
	"The string we use as a prefix when adding a colum.
	Override the superclass default because MS doesn't use COLUMN."
	^' '.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax. Currently hard-coded, but may also vary by database version"
	^true.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsDecimalsOnAllNumerics [
	"Return true if a general 'numeric' type will allow numbers after the decimal place"
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsGroupWritingFor: aCommand [
	^aCommand supportsGroupWriting.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsLimit [
	"Do we support anything analogous to the postgresql LIMIT, returning only the first N rows"
	^true.
]

{ #category : 'constants' }
SQLServerPlatform >> supportsMillisecondsInTimes [
	"I'm guessing here"
	^true.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsMultipleOpenCursors [
	"Can this database support multiple open cursors at once"
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> supportsTableOwners [
	"Return true if this platform supports table owners, i.e. expects table names of the form Bern.TW_* rather than just TW_* in its SQL."
"Access, Firebird and PostGreSQL do not, Oracle does, others I know not."

	^true
]

{ #category : 'types' }
SQLServerPlatform >> text [
	^super text queryType: self varchar.
]

{ #category : 'types' }
SQLServerPlatform >> time [
	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'datetime'].
]

{ #category : 'types' }
SQLServerPlatform >> timeStampTypeString [
	^'datetime'.
]

{ #category : 'types' }
SQLServerPlatform >> timestamp [
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'datetime'].
]

{ #category : 'types' }
SQLServerPlatform >> tinyint [
	^self typeNamed: #tinyInt ifAbsentPut: [GlorpIntegerType new typeString: 'tinyint'].
]

{ #category : 'conversion - strings' }
SQLServerPlatform >> toGlorpType: aGlorpType fromString: aString [
	"Since SQL-Server wraps the string in parentheses, uwrap it first."

	^super
		toGlorpType: aGlorpType
		fromString: (self removeNestedParensFromString: aString)
]

{ #category : 'types' }
SQLServerPlatform >> typeWithDatabaseName: aString characterWidth: aNumber extraInformation: extraValue [
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	extraValue = 'IDENTITY' ifTrue: [^self serial].
	^super typeWithDatabaseName: aString characterWidth: aNumber.
]

{ #category : 'type helpers' }
SQLServerPlatform >> typesWithValues [
	self nvarchar.
	self nchar.
	self ntext.
	^super typesWithValues
]

{ #category : 'testing' }
SQLServerPlatform >> useMicrosoftOuterJoins [
	"Return true if we use the Microsoft x *= y syntax for outer joins"
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> usesArrayBindingRatherThanGroupWriting [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> usesArrayBindingRatherThanGrouping [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^false.
]

{ #category : 'testing' }
SQLServerPlatform >> usesIdentityColumns [
	^true.
]

{ #category : 'testing' }
SQLServerPlatform >> usesInformationSchema [

	^true
]

{ #category : 'testing' }
SQLServerPlatform >> usesLengthNotEndPosInSubstring [
	^true
]

{ #category : 'types' }
SQLServerPlatform >> varbinary [
	^self typeNamed: #varbinary ifAbsentPut: [GlorpVarBinaryType new].
]

{ #category : 'types' }
SQLServerPlatform >> varchar [
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new].
]
