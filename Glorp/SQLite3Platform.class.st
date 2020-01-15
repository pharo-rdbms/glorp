"
I support Glorp's use of the SQLite database;  see http://www.sqlite.org.  Some notes on the implementation:

SQLite provides no specific support for time-related data other than column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
I therefore map Date, Time and Timestamp to and from strings via #to... and (inherited) #read... methods whose formats agree with these functions.  (I also return false to #supportsMillisecondsInTimes, again in agreement with the above functions which do not include millliseconds.)

My #maximumLengthOfTableName value is limited purely for convenience;  it can probably be much larger.

In VW, this version uses the non-threaded SQLite3Connection EXDI class.  Make my #vwEXDIConnectionClass return SQLite3ThreadedConnection to make Glorp use the threaded interface and, if using this with Store, also change its string reference in #asGlorpDatabase, #databaseFor:.  Alternatively, create an SQLlite3ThreadedPlatform subclass of me and add an extra line, instead of changing a line, to the Store methods.  (Note that in order to be thread-safe, your SQLite installation must be compiled with the SQLITE_THREADSAFE preprocessor macro set to 1.  In SQLite3, both the Windows and Linux precompiled binaries in the distribution are compiled this way.  If you are unsure if the SQLite library you are linking against is compiled to be threadsafe you can call the sqlite3_threadsafe()  interface to find out.)

SQLite parses FOREIGN KEY constraints but does not enforce them.

SQLite's approach to data typing is unusual for SQL.  Its data values are:
	NULL
	INTEGER. The value is a signed integer, stored in 1, 2, 3, 4, 6, or 8 bytes depending on the magnitude of the value.
	REAL. The value is a floating point value, stored as an 8-byte IEEE floating point number.
	TEXT. The value is a text string, stored using the database encoding (UTF-8, UTF-16BE or UTF-16-LE).
	BLOB. The value is a blob of data, stored exactly as it was input
but its typing is dynamic, so any column can in principle store any value, and its column affinities are
	TEXT - can store NULL, TEXT or BLOB
	NUMERIC - can store all five; text values that converts to reals or integers without loss of information are so stored
	INTEGER - as NUMERIC plus reals that convert to integer without loss of information are so stored
	REAL - as NUMERIC but integer values are coerced to reals
	NONE - no coercion is performed.
My int* and float*/double type methods that define Glorp types for SQLite conform to the expressibility of the above data values.


"
Class {
	#name : #SQLite3Platform,
	#superclass : #DatabasePlatform,
	#category : #'Glorp-Platforms'
}

{ #category : #'as yet unclassified' }
SQLite3Platform class >> reservedWords [

	^#('abort' 'action' 'add' 'after' 'all' 'alter' 'analyze' 'and' 'as' 'asc' 'attach' 'autoincrement' 'before' 'begin' 'between' 'by' 'cascade' 'case' 'cast' 'check' 'collate' 'column' 'commit' 'conflict' 'constraint' 'create' 'cross' 'current_date' 'current_time' 'current_timestamp' 'database' 'default' 'deferrable' 'deferred' 'delete' 'desc' 'detach' 'distinct' 'drop' 'each' 'else' 'end' 'escape' 'except' 'exclusive' 'exists' 'explain' 'fail' 'for' 'foreign' 'from' 'full' 'glob' 'group' 'having' 'if' 'ignore' 'immediate' 'in' 'index' 'indexed' 'initially' 'inner' 'insert' 'instead' 'intersect' 'into' 'is' 'isnull' 'join' 'key' 'left' 'like' 'limit' 'match' 'natural' 'no' 'not' 'notnull' 'null' 'of' 'offset' 'on' 'or' 'order' 'outer' 'plan' 'pragma' 'primary' 'query' 'raise' 'references' 'regexp' 'reindex' 'release' 'rename' 'replace' 'restrict' 'right' 'rollback' 'row' 'savepoint' 'select' 'set' 'table' 'temp' 'temporary' 'then' 'to' 'transaction' 'trigger' 'union' 'unique' 'update' 'using' 'vacuum' 'values' 'view' 'virtual' 'when' 'where')
		asSet
]

{ #category : #constants }
SQLite3Platform >> areSequencesExplicitlyCreated [
	^false
]

{ #category : #binding }
SQLite3Platform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."

	^aCommand batchStatementBindings
]

{ #category : #types }
SQLite3Platform >> clob [

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'text'].
]

{ #category : #'conversion-boolean' }
SQLite3Platform >> convertIntegerToBoolean: anInteger for: aType [
	"This method accomodates an error in earlier SQLite 3 dlls. For the table_info() PRAGMA, 99 means True."

	anInteger isNil ifTrue: [^anInteger].
	anInteger >= 1 ifTrue: [^true].
	anInteger = 0 ifTrue: [^false].
	self error: 'invalid boolean conversion'
]

{ #category : #'services tables' }
SQLite3Platform >> createTableStatementStringFor: aGLORPDatabaseTable [ 
	"^<String> This method returns a string which can be used to create a database table ..."

	| sqlStatementStream tmpString fkeys |
	tmpString := 'create table'.
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: (self capitalWritingOfSQLCommands 
					ifTrue: [tmpString asUppercase]
					ifFalse: [tmpString]);
		space.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.

	"Now print the columns specification for each field in the table ..."
	self printColumnsSpecificationFor: aGLORPDatabaseTable
		on: sqlStatementStream.
	"Print the primary key constraint, unless using serial pkeys, since it would be a redundant declaration."
	(aGLORPDatabaseTable hasPrimaryKeyConstraints and: [aGLORPDatabaseTable primaryKeyFields first type isSerial not])
			ifTrue: [sqlStatementStream nextPutAll: ', '.
					(aGLORPDatabaseTable primaryKeyConstraints creationStringFor: self)
						do: [ :each | sqlStatementStream nextPutAll: each.]
						separatedBy: [sqlStatementStream nextPut: $,]].

	fkeys := aGLORPDatabaseTable foreignKeyConstraintsForCreation.
	fkeys notEmpty
			ifTrue: [sqlStatementStream nextPutAll: ', '.
					(fkeys collect: [:each| self createForeignKeyConstraintAddStatement: each])
						do: [ :each | sqlStatementStream nextPutAll: each first]
						separatedBy: [sqlStatementStream nextPut: $,]].

	sqlStatementStream
		nextPut: $).
	^sqlStatementStream contents
]

{ #category : #sequences }
SQLite3Platform >> databaseSequenceClass [
	^SQLite3Sequence
]

{ #category : #types }
SQLite3Platform >> date [
	"SQLite does not support any time-related types;  use text as the type and convert in readDate.../toDate..."

	^self typeNamed: #date ifAbsentPut: [GlorpDateType new typeString: 'date']
]

{ #category : #types }
SQLite3Platform >> decimal [

	^self decimal: nil scale: 4
]

{ #category : #types }
SQLite3Platform >> decimal: precision scale: scale [

	^self typeNamed: #numeric ifAbsentPut:
			[GlorpDecimalType new
				selector: #decimal;
				precision: precision;
				scale: scale;
				yourself].
]

{ #category : #types }
SQLite3Platform >> defaultPort [
	^ ''.
]

{ #category : #types }
SQLite3Platform >> double [
	^self typeNamed: #double ifAbsentPut: [GlorpDoubleType new typeString: 'double' ].
]

{ #category : #types }
SQLite3Platform >> float4 [
	"The only kind of REAL that SQLite supports is an 8-byte IEEE floating point number, so we just map float4 to float8."

	^self double
]

{ #category : #types }
SQLite3Platform >> float8 [
	"The only kind of REAL that SQLite supports is an 8-byte IEEE floating point number."

	^self double
]

{ #category : #functions }
SQLite3Platform >> initializeFunctions [
	"The REGEXP operator is a special syntax for the regexp() user function in SQLite. No regexp() user function is defined by default and so use of the REGEXP operator will normally result in an error message. If a application-defined SQL function named 'regexp' is added at run-time, that function will be called in order to implement the REGEXP operator.  (See sqlite.org/lang_expr.html#regexp for details.)"

	super initializeFunctions.
	functions at: #regexMatches: put: (InfixFunction named: 'REGEXP').
]

{ #category : #constants }
SQLite3Platform >> initializeReservedWords [
	super initializeReservedWords.
]

{ #category : #types }
SQLite3Platform >> int2 [
	^self smallint.
]

{ #category : #types }
SQLite3Platform >> int4 [
	^self typeNamed: #int4 ifAbsentPut: [GlorpIntegerType new typeString: 'int'].
]

{ #category : #types }
SQLite3Platform >> int8 [
	^self int4.
]

{ #category : #testing }
SQLite3Platform >> isSQLite3Platform [
	^true
]

{ #category : #constants }
SQLite3Platform >> maximumLengthOfTableName [
	"It is the boast of SQLite that their limits are only for stability purposes:  if it fits in 32 bits then they will handle it.  Since the maximum length of an SQL statement is limited to SQLITE_MAX_LENGTH (defaults to 1000000, cannot be higher than 1073741824), table names had better be shorter and in normal use should be much shorter.  I chose the number below at random;  change it if it causes you any inconvenience."

	^128
]

{ #category : #types }
SQLite3Platform >> numeric [

	^self typeNamed: #numeric ifAbsentPut: [GlorpNumericType new].
]

{ #category : #types }
SQLite3Platform >> nvarchar [
	^self text
]

{ #category : #constants }
SQLite3Platform >> parenthesizeCommandsInCompoundQuery [
	^false
]

{ #category : #'conversion-times' }
SQLite3Platform >> printDate: aDateString for: aType [
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form '1959-09-30'."

	aDateString isNil ifTrue: [^'NULL'].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aDateString class = Date ifTrue: [self error: 'SQLite does not support date types;  this should have been a String'].
	^aDateString printString
]

{ #category : #'database-specific' }
SQLite3Platform >> printOffset: anInteger on: aCommand [
	"SQLite cannot have an offset without a limit.  A negative limit is treated as an infinite limit.  We cannot set it as an actual limit value;  that would hit limitMakesSense optimisation and abort the trip to the database.  So we add it here."

	aCommand query hasLimit ifFalse:
		[self printPostLimit: -1 on: aCommand].
	aCommand nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.
]

{ #category : #'database-specific' }
SQLite3Platform >> printPostLimit: anInteger on: aCommand [
	aCommand
		nextPutAll: ' LIMIT '.
	anInteger printOn: aCommand.
]

{ #category : #'services tables' }
SQLite3Platform >> printSqlStatementToListColumnsInTable: aDatabaseTable inSchema: schemaString on: aStream [

	" Format:
	       name           |       type        | length | nullable |     default_value     | pk 
-------------------------+-------------------+--------+----------+-----------------------+----
 id                      | character varying |    255 |        0 | ''::character varying |  1 
	"

	aStream nextPutAll: ('SELECT 
  p.name as name,
  rtrim(p.type,''(1234567890)'') AS type,
nullif(trim(substr(p.type,instr(p.type,''('')),''()''),p.type) as length,
  p.[notnull] AS nullable,
  p.dflt_value AS col_default_val,
  p.pk AS pk
FROM sqlite_master m
LEFT OUTER JOIN pragma_table_info((m.name)) p
  ON m.name <> p.name
WHERE m.type = ''table'' AND m.name=''{1}''' format:{aDatabaseTable. schemaString})
]

{ #category : #'services tables' }
SQLite3Platform >> printSqlStatementToListTablesInSchema: schemaString on: aStream [
	"SQLite3 uses a readonly system table "

	aStream
		nextPutAll: 'SELECT name as table_name FROM sqlite_master ';
		nextPutAll: 'WHERE type = ';
		nextPut: $';
		nextPutAll: 'table';
		nextPut: $';
		nextPut: $;
]

{ #category : #'services tables' }
SQLite3Platform >> printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream [
	"SQLite3 uses a readonly system table and doesn't support schemas, as far as I know"

	| lowerTableName |
	lowerTableName := tableName asLowercase.
	aStream
		nextPutAll: 'SELECT count(*) FROM sqlite_master ';
		nextPutAll: 'WHERE lower(name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $';
		nextPutAll: ' AND type = ';
		nextPut: $';
		nextPutAll: 'table';
		nextPut: $';
		nextPut: $;
]

{ #category : #'conversion-times' }
SQLite3Platform >> printTime: aTimeString for: aType [
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form 10:20:23."

	aTimeString isNil ifTrue: [^'NULL'].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aTimeString class = Time ifTrue: [self error: 'SQLite does not support time types;  this should have been a String'].
	^aTimeString printString
]

{ #category : #'conversion-times' }
SQLite3Platform >> printTimestamp: aTimestampString on: stream for: aType [
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form '1959-03-27 10:20:23'."

	aTimestampString isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aTimestampString class = Dialect timestampClass ifTrue: [self error: 'SQLite does not support timestamp types;  this should have been a String'].
	stream nextPut: $'.
	stream nextPutAll: aTimestampString.
	stream nextPut: $'.
]

{ #category : #'database-specific' }
SQLite3Platform >> queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock [
	"SQLite3 does not allow LIMIT{OFFSET} in subqueries.  As far as is known at time of writing (2011jun07), Glorp will only generate such queries in the case of a readOneOf: on a superclass which is mapped by horizontal inheritance to its subclasses' tables:  if shouldUseSingleQuery is true, it will present a series of UNION ALLed subselects on each subclass table where only one is expected to match.

To handle this case, we make the assumption that whenever all the subqueries' limits and offsets match those of the compound query, they are an artefact of the compound query's values being copied to the subqueries and really apply to the compound.  We therefore nil them for all but the last subselect.  This trick causes SQLite to interpret the resulting single LIMIT{OFFSET} at the end of the SQL string as applying to the whole UNIONed compound statement.

In the general case, there is no algorithmic way to convert subselect limits and offsets into a single limit and offset on the whole statement, and so we cannot handle the statement.  We assume no such statements will occur.  If they do, we let them go on to their inevitable failure, so it will be visible."

	| subQueries |
	subQueries := aQuery queries.
	(subQueries allSatisfy: [:each | each limit = aQuery limit and: [each offset = aQuery offset]])
"		ifFalse: [	just carry on and let it fail - don't hide the problem	]"
		ifTrue:
			[1 to: subQueries size - 1 do:
				[:index | (subQueries at: index) limit: nil; offset: nil]].
]

{ #category : #testing }
SQLite3Platform >> requiresTransactionForTableOperations [
	^false
]

{ #category : #types }
SQLite3Platform >> sequence [
	^self serial
]

{ #category : #types }
SQLite3Platform >> serial [
	"In SQLLite, the column declared as INTEGER PRIMARY KEY will default to ROWID, unless the inserted value is not null. But in Sqlite3 a declaration like: INTEGER PRIMARY KEY AUTOINCREMENT will cause ROWID to be fetched from the sqlite_sequence table, which provides always increasing values."

	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'INTEGER PRIMARY KEY AUTOINCREMENT'].
]

{ #category : #testing }
SQLite3Platform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax."
	^true.
]

{ #category : #testing }
SQLite3Platform >> supportsAlterTableForConstraints [

	^false
]

{ #category : #constants }
SQLite3Platform >> supportsAuthentication [
	"SQLite does not support authentication:  anyone can login with any username and password.  The only security is that provided by the OS for the file being used as the database."

	^false
]

{ #category : #testing }
SQLite3Platform >> supportsBinding [
	"Return true if this platform supports binding parameters rather than printing them as strings into the SQL statement"
	^false.
]

{ #category : #constants }
SQLite3Platform >> supportsConstraints [
	"Return false, because this platform does not support constraint add or drop statements.
	However, foreign key constraints can be created as part of the create table statement.
	Also, a foreign key constraint can be created in the statement that adds that column to
	the table. (Eg., ALTER TABLE ADD COLUMN ...)."

	^false
]

{ #category : #testing }
SQLite3Platform >> supportsLimit [
	"Do we support LIMIT ... (or something analogous to it), returning only the first N rows."

	^true
]

{ #category : #constants }
SQLite3Platform >> supportsMillisecondsInTimes [
	"The only time-type-related functions in SQLite are CURRENT_TIME format HH:MM:SS and CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS, neither of which support milliseconds.  As against that, since we map to and from strings, we can easily include milliseconds in these strings.  For now, I go with the SQLite function choice and say no, but I have verified that tests work fine when I set this to true."

	^false
]

{ #category : #testing }
SQLite3Platform >> supportsOffset [
	"Do we support OFFSET ... (or something analogous to it), skipping the first N rows"

	^true
]

{ #category : #testing }
SQLite3Platform >> supportsSchemas [
	^false
]

{ #category : #testing }
SQLite3Platform >> supportsStringQueryOnBlobs [
	"This is something of a guess but I see no evidence that SQLite does and the relevant test certainly fails."

	^false
]

{ #category : #constants }
SQLite3Platform >> supportsVariableSizedNumerics [
	"SQLite supports a single 8-byte IEEE floating point type:  e.g. give it 321.12s and it will return 321.12d.  Perhaps clever Glorp converters could arrange for Glorp to know which fields are really FixedPoint numbers, as we do for Date, Time and Timestamp (which SQLite also does not support) but I'll leave that until there's demand for it (ee also #canBind:to:)."

	^false
]

{ #category : #types }
SQLite3Platform >> text [
	^self typeNamed: #nvarchar ifAbsentPut: [GlorpTextType new typeString: 'text']
]

{ #category : #types }
SQLite3Platform >> time [
	"SQLite does not support any time-related types;  use text as the type and convert in readTime.../toTime..."

	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'time']
]

{ #category : #types }
SQLite3Platform >> timestamp [
	"SQLite does not support any time-related types;  use text as the type and convert in readTimestamp.../toTimestamp..."

	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp']
]

{ #category : #'conversion-times' }
SQLite3Platform >> toDate: anObject for: aType [
	"SQLite does not handle timestamps;  all such must be treated as strings and the to... and read... formats must agree.  SQLite does use column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
so our string conversions must agree with these formats."

	| stream |
	anObject isNil ifTrue: [^nil].
	stream := String new writeStream.
	self
		printDate: (super toDate: anObject for: aType)
		isoFormatOn: stream.
	^stream contents
]

{ #category : #'conversion-times' }
SQLite3Platform >> toTime: anObject for: aType [
	"SQLite does not handle timestamps;  all such must be treated as strings and the to... and read... formats must agree.  SQLite does use column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
so our string conversions must agree with these formats."

	| stream |
	anObject isNil ifTrue: [^nil].
	stream := String new writeStream.
	self
		printTime: (super toTime: anObject for: aType)
		isoFormatOn: stream.
	^stream contents
]

{ #category : #'conversion-times' }
SQLite3Platform >> toTimestamp: anObject for: aType [
	"SQLite does not handle timestamps;  all such must be treated as strings and the to... and read... formats must agree.  SQLite does use column-default-value UTC functions:
	CURRENT_DATE format YYYY-MM-DD
	CURRENT_TIME format HH:MM:SS
	CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS
so our string conversions must agree with these formats."

	| stream timestampObject |
	anObject isNil ifTrue: [^nil].
	stream := String new writeStream.
	timestampObject := super toTimestamp: anObject for: aType.
	self
		printDate: timestampObject
		isoFormatOn: stream.
	stream space.
	self
		printTime: timestampObject
		isoFormatOn: stream.
	^stream contents
]

{ #category : #types }
SQLite3Platform >> typeWithDatabaseName: aString characterWidth: aNumber [
	"Since this is SQLite, let the type names be more flexible."

	| aTypeName total block |
	block := [:sum :name | sum + (aString asLowercase findString: name startingAt: 1)].
	aTypeName := aString.
	total := #('char' 'clob' 'text') inject: 0 into: block.
	total > 0
		ifTrue: [aTypeName := 'text']
		ifFalse: 
			[total := #('num' 'double' 'float') inject: 0 into: block.
			total > 0
				ifTrue: [aTypeName := 'numeric']
				ifFalse: 
					[total := #('int') inject: 0 into: block.
					total > 0
						ifTrue: [aTypeName := 'integer']
						ifFalse: 
							[total := #('blob') inject: 0 into: block.
							total > 0 ifTrue: [aTypeName := 'blob']]]].
	aString isEmpty ifTrue: [aTypeName := 'blob'].
	^super typeWithDatabaseName: aTypeName characterWidth: aNumber
]

{ #category : #testing }
SQLite3Platform >> usesArrayBindingRatherThanGroupWriting [
	^false.
]

{ #category : #testing }
SQLite3Platform >> usesArrayBindingRatherThanGrouping [
	^false.
]

{ #category : #testing }
SQLite3Platform >> usesIdentityColumns [
	^true.
]

{ #category : #constants }
SQLite3Platform >> usesNullForEmptyStrings [
	^ true
]

{ #category : #types }
SQLite3Platform >> varbinary [
	" *** This method was defined by Glorp.DatabasePlatform as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #types }
SQLite3Platform >> varchar [
	^self text.
]
