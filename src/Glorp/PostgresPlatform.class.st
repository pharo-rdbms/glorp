"
This is a an abstract superclass for the protocol 2 and protocol 3 APIs of the open-source PostgreSQL database.

This supports binding but has it off by default.  To change this generally, implement (class-side) useBindingByDefault to return true for it or a subclass.  To change it (for all platforms) in a given image, set
	Glorp.DatabasePlatform.UseBindingIfSupported := true
In either case check already-assigned values of any existing platform instances after changing.

"
Class {
	#name : #PostgresPlatform,
	#superclass : #DatabasePlatform,
	#instVars : [
		'charactersThatNeedEscaping'
	],
	#category : #'Glorp-Platforms'
}

{ #category : #'as yet unclassified' }
PostgresPlatform class >> reservedWords [
	^#('all' 'analyse' 'analyze' 'and' 'any' 'array' 'as' 'asc' 'asymmetric' 'both' 'case' 'cast' 'check' 'collate' 'column' 'constraint' 'create' 'current_catalog' 'current_date' 'current_role' 'current_time' 'current_timestamp' 'current_user' 'default' 'deferrable' 'desc' 'distinct' 'do' 'else' 'end' 'except' 'false' 'fetch' 'for' 'foreign' 'from' 'grant' 'group' 'having' 'in' 'initially' 'intersect' 'into' 'leading' 'limit' 'localtime' 'localtimestamp' 'not' 'null' 'offset' 'on' 'only' 'or' 'order' 'placing' 'primary' 'references' 'returning' 'select' 'session_user' 'some' 'symmetric' 'table' 'then' 'to' 'trailing' 'true' 'union' 'unique' 'user' 'using' 'variadic' 'when' 'where' 'window' 'with')
		asSet
]

{ #category : #'as yet unclassified' }
PostgresPlatform class >> useBindingByDefault [
	^false
]

{ #category : #constants }
PostgresPlatform >> areSequencesExplicitlyCreated [
	^true.
]

{ #category : #types }
PostgresPlatform >> array [ 
	^self typeNamed: #ARRAY ifAbsentPut: [GlorpPGArrayType new typeString: 'ARRAY'].
]

{ #category : #types }
PostgresPlatform >> bigint [
	^self typeNamed: #bigint ifAbsentPut: [GlorpIntegerType new typeString: 'bigint'].
]

{ #category : #binding }
PostgresPlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	^aCommand batchStatementBindings.
]

{ #category : #types }
PostgresPlatform >> blob [

	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'bytea'].
]

{ #category : #types }
PostgresPlatform >> boolean [
	^self typeNamed: #boolean ifAbsentPut: [GlorpBooleanType new typeString: 'boolean'].
]

{ #category : #'conversion-strings' }
PostgresPlatform >> byteArrayToSQLStringConverter [

	^DelegatingDatabaseConverter
		named: #byteArrayToSQLString
		hostedBy: self
		fromStToDb: #convertByteArrayToSQLString:for:
		fromDbToSt: #convertSQLStringToByteArray:for:.
]

{ #category : #types }
PostgresPlatform >> bytea [
	^self typeNamed: #bytea ifAbsentPut: [GlorpBinaryType new typeString: 'bytea'].
]

{ #category : #types }
PostgresPlatform >> char [
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new typeName: 'character'].
]

{ #category : #types }
PostgresPlatform >> character [
	^self char.
]

{ #category : #types }
PostgresPlatform >> character: width [
	^self char: width.
]

{ #category : #types }
PostgresPlatform >> characterVarying [
	^self varchar
]

{ #category : #types }
PostgresPlatform >> characterVarying: length [
	^self varchar: length
]

{ #category : #constants }
PostgresPlatform >> charactersThatNeedEscaping [
	^charactersThatNeedEscaping ifNil: [#($')]
]

{ #category : #constants }
PostgresPlatform >> charactersThatNeedEscaping: aCollectionOfChars [
	"Call this if you know the database servers setting for standard-conforming_strings and so can save the postLoginInitializeFrom: call."

	charactersThatNeedEscaping := aCollectionOfChars
]

{ #category : #types }
PostgresPlatform >> clob [

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'text'].
]

{ #category : #'conversion-strings' }
PostgresPlatform >> convertJSONObjectToSQLString: anObject for: aType [
	^anObject ifNotNil: [ NeoJSONWriter toString: anObject ]
]

{ #category : #'conversion-strings' }
PostgresPlatform >> convertSQLStringToByteArray: aString for: aType [

	| aStream str | 
	aString isNil ifTrue: [^nil].
	aStream := (ByteArray new: aString size // 4) writeStream.
	str := aString readStream.
	[str atEnd] whileFalse: [ |nextChar|
		nextChar := str next.
		aStream nextPut: (nextChar = $\
								ifTrue: [str peek = $\
											ifTrue: [str next asInteger]
											ifFalse: [Number readFrom: (str next: 3) base: 8]]
								ifFalse: [nextChar asInteger])
	].
	aStream close.
	^aStream contents
]

{ #category : #'conversion-strings' }
PostgresPlatform >> convertSQLStringToJSONObject: anObject for: aType [
	^anObject isString 
		ifTrue: [ NeoJSONReader fromString: anObject ] 
		ifFalse: [ anObject ]
]

{ #category : #sequences }
PostgresPlatform >> databaseSequenceClass [
	^PGSequence.
]

{ #category : #types }
PostgresPlatform >> date [
	^self typeNamed: #date ifAbsentPut: [GlorpDateType new typeString: 'date'].
]

{ #category : #types }
PostgresPlatform >> decimal [
	^self typeNamed: #decimal ifAbsentPut: [GlorpDecimalType new].
]

{ #category : #types }
PostgresPlatform >> double [
	^self float8
]

{ #category : #types }
PostgresPlatform >> doublePrecision [
	^self double
]

{ #category : #'conversion-strings' }
PostgresPlatform >> encodeAsBase64String: aByteArray [
	"Pure inline of Base64FastCoder's method."

	| output thirdTripletIndex firstQuartetIndex firstOfThree secondOfThree thirdOfThree remainder |
	output := ByteString new: (aByteArray size / 3) ceiling * 4.
	thirdTripletIndex := 3.
	firstQuartetIndex := 1.	"Process all complete triplets."
	[thirdTripletIndex > aByteArray size] whileFalse: 
			[firstOfThree := aByteArray at: thirdTripletIndex - 2.
			secondOfThree := aByteArray at: thirdTripletIndex - 1.
			thirdOfThree := aByteArray at: thirdTripletIndex.
			output at: firstQuartetIndex
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((firstOfThree bitAnd: 2r11111100) bitShift: -2) + 1).
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((firstOfThree bitAnd: 2r00000011) bitShift: 4)
								bitOr: ((secondOfThree bitAnd: 2r11110000) bitShift: -4)) + 1).
			output at: firstQuartetIndex + 2
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((secondOfThree bitAnd: 2r00001111) bitShift: 2)
								bitOr: ((thirdOfThree bitAnd: 2r11000000) bitShift: -6)) + 1).
			output at: firstQuartetIndex + 3
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (thirdOfThree bitAnd: 2r00111111) + 1).
			thirdTripletIndex := thirdTripletIndex + 3.
			firstQuartetIndex := firstQuartetIndex + 4].	"Process any final incomplete triplet."
	remainder := thirdTripletIndex - aByteArray size.
	remainder = 3 ifTrue: [^output].
	firstOfThree := aByteArray at: thirdTripletIndex - 2.
	output at: firstQuartetIndex
		put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
				at: ((firstOfThree bitAnd: 2r11111100) bitShift: -2) + 1).
	output at: firstQuartetIndex + 3 put: $=.
	remainder = 1
		ifFalse: 
			["the byte array is missing two values of another triplet"
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((firstOfThree bitAnd: 2r00000011) bitShift: 4) + 1).
			output at: firstQuartetIndex + 2 put: $=]
		ifTrue: 
			["the byte array is only missing one value of another triplet"
			secondOfThree := aByteArray at: thirdTripletIndex - 1.
			output at: firstQuartetIndex + 1
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: (((firstOfThree bitAnd: 2r00000011) bitShift: 4)
								bitOr: ((secondOfThree bitAnd: 2r11110000) bitShift: -4)) + 1).
			output at: firstQuartetIndex + 2
				put: ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
						at: ((secondOfThree bitAnd: 2r00001111) bitShift: 2) + 1)].
	^output
]

{ #category : #types }
PostgresPlatform >> float [
	^self float4.
]

{ #category : #types }
PostgresPlatform >> float4 [
	^self typeNamed: #float4 ifAbsentPut: [GlorpFloatType new].
]

{ #category : #types }
PostgresPlatform >> float8 [
	^self typeNamed: #float8 ifAbsentPut: [GlorpDoubleType new].
]

{ #category : #functions }
PostgresPlatform >> initializeFunctions [
	"Postgres supports standard regex and also the ANSI SQL 'SIMILAR TO' form of regex, in which the % and _ of SQL's LIKE predicate replace the corresponding * and ? of regex."

	super initializeFunctions.
	functions at: #similarTo: put: (InfixFunction named: 'SIMILAR TO').
	functions at: #regexMatches: put: (InfixFunction named: '~').
]

{ #category : #constants }
PostgresPlatform >> initializeReservedWords [
	super initializeReservedWords.
]

{ #category : #types }
PostgresPlatform >> int [
	^self int4
]

{ #category : #types }
PostgresPlatform >> int2 [
	^self typeNamed: #int2 ifAbsentPut: [GlorpIntegerType new typeString: 'int2'].
]

{ #category : #types }
PostgresPlatform >> int4 [
	^self typeNamed: #int4 ifAbsentPut: [GlorpIntegerType new typeString: 'int4'].
]

{ #category : #types }
PostgresPlatform >> int8 [
	^self typeNamed: #int8 ifAbsentPut: [GlorpIntegerType new typeString: 'int8'].
]

{ #category : #SQL }
PostgresPlatform >> isPostgreSQLPlatform [
	^true.
]

{ #category : #types }
PostgresPlatform >> json [
	^self typeNamed: #json ifAbsentPut: [GlorpJSONType new]
]

{ #category : #'conversion-strings' }
PostgresPlatform >> jsonToStringConverter [

	^DelegatingDatabaseConverter
		named: #jsonToString
		hostedBy: self
		fromStToDb: #convertJSONObjectToSQLString:for:
		fromDbToSt: #convertSQLStringToJSONObject:for:.
]

{ #category : #types }
PostgresPlatform >> jsonb [
	^self typeNamed: #jsonb ifAbsentPut: [GlorpJSONType new]
]

{ #category : #constants }
PostgresPlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)"

	^31
]

{ #category : #constants }
PostgresPlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"

	^31
]

{ #category : #testing }
PostgresPlatform >> measuresStringFieldWidthsInBytes [
	"Return true if we measure the width of a string in bytes rather than characters. So, a 255-character field can hold 255 bytes worth of string, not 255 characters. This is important with encodings"
	^true.
]

{ #category : #types }
PostgresPlatform >> numeric [
	^self typeNamed: #numeric ifAbsentPut: [GlorpNumericType new].
]

{ #category : #'conversion-strings' }
PostgresPlatform >> postLoginInitializeFromAccessor: aDatabaseAccessor [
	"If we cannot get the standard_conforming_strings state, assume the database is too old to understand it."

	| standardConformingStrings |
	charactersThatNeedEscaping isNil ifFalse: [^self].
	standardConformingStrings :=
		[aDatabaseAccessor executeSQLString: 'SHOW standard_conforming_strings']
			on: Dialect error
			do: [:ex |
				(ex description indexOfSubCollection: 'standard_conforming_strings' startingAt: 1) = 0
					ifFalse: [#(('off'))]
					ifTrue: [ex pass]].
	standardConformingStrings = #(('on'))
		ifTrue: [charactersThatNeedEscaping := #($')]
		ifFalse: [charactersThatNeedEscaping := #($' $\)].
]

{ #category : #'conversion-strings' }
PostgresPlatform >> printBlob: aByteArray on: aStream for: aType [
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	Dialect isSqueak ifTrue: [^self squeakPrintBlob: aByteArray on: aStream for: aType].
	aStream nextPutAll: (self encodeAsBase64String: aByteArray) printString
]

{ #category : #'conversion-times' }
PostgresPlatform >> printDate: aDate for: aType [
	"Print a date (or timestamp) as yyyy-mm-dd"
	| stream |
	aDate isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $'.
	self
		printDate: aDate
		isoFormatOn: stream.
	stream nextPut: $'.
	^stream contents.
]

{ #category : #'database-specific' }
PostgresPlatform >> printOffset: anInteger on: aCommand [
	aCommand
		nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.
]

{ #category : #'database-specific' }
PostgresPlatform >> printPostLimit: anInteger on: aCommand [
	aCommand
		nextPutAll: ' LIMIT '.
	anInteger printOn: aCommand.
]

{ #category : #'services tables' }
PostgresPlatform >> printSqlStatementToListColumnsInTable: aDatabaseTable inSchema: schemaString on: aStream [
	" Format:
	       name           |       type        | length | nullable |     default_value     | pk 
-------------------------+-------------------+--------+----------+-----------------------+----
 id                      | character varying |    255 |        0 | ''::character varying |  1 
	"
	aStream 
		nextPutAll: ('SELECT column_name as name, data_type as type, character_maximum_length as length, (is_nullable=''YES'')::int as nullable, column_default as default_value, (SELECT count(*) FROM pg_attribute a LEFT OUTER JOIN  pg_index i  ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = ''{1}''::regclass AND i.indisprimary AND a.attname=column_name) as pk  FROM information_schema.columns where table_name=''{1}''' format: {aDatabaseTable. schemaString })
]

{ #category : #'conversion-times' }
PostgresPlatform >> printTime: aTime for: aType [
	"Print a time (or timestamp) as hh:mm:ss.fff"
	| stream |
	aTime isNil ifTrue: [^'NULL'].
	stream := WriteStream on: String new.
	stream nextPut: $'.
	self
		printTime: aTime
		isoFormatOn: stream.
	stream nextPut: $'.
	^stream contents.
]

{ #category : #'conversion-times' }
PostgresPlatform >> printTimestamp: aTimestamp on: stream for: aType [
	aTimestamp isNil ifTrue: [stream nextPutAll: 'NULL'. ^self].
	stream nextPut: $'.
	self
		printDate: aTimestamp
		isoFormatOn: stream.
	stream nextPutAll: ' '.
	self
		printTime: aTimestamp
		isoFormatOn: stream.
	stream nextPut: $'.
]

{ #category : #types }
PostgresPlatform >> real [
	^self float4
]

{ #category : #testing }
PostgresPlatform >> requiresCastsForNullsInUnions [
	"If we have explicit nulls in a query which is unioned, do we need to cast them to the appropriate type in order to keep the database happy."
	^true.
]

{ #category : #constants }
PostgresPlatform >> requiresTransactionForTableOperations [
	"Return true if we need a transaction in order to do table creation, deletion, and so forth. Some databases require it. Others don't like it"
	^false.
]

{ #category : #types }
PostgresPlatform >> sequence [

	^self serial
]

{ #category : #types }
PostgresPlatform >> serial [
	"For postgresql, we use sequences, and explicitly get the values ourselves, so just tell the database that they're integers."
	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'integer'].
]

{ #category : #types }
PostgresPlatform >> smallint [
	^self int2
]

{ #category : #constants }
PostgresPlatform >> sqlTextCurrentServerUTCTimestamp [

	^'SELECT CURRENT_TIMESTAMP AT TIME ZONE ''UTC'' '
]

{ #category : #testing }
PostgresPlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax."
	^true.
]

{ #category : #testing }
PostgresPlatform >> supportsCaseInsensitiveLike [
	^true.
]

{ #category : #testing }
PostgresPlatform >> supportsGroupWritingFor: aCommand [
	^aCommand supportsGroupWriting
]

{ #category : #testing }
PostgresPlatform >> supportsLimit [
	"Do we support anything analogous to the postgresql LIMIT, returning only the first N rows"
	^true.
]

{ #category : #constants }
PostgresPlatform >> supportsMillisecondsInTimes [
	"I think this depends on settings, but it's easier right now to just turn it off"
	^false.
]

{ #category : #testing }
PostgresPlatform >> supportsOffset [
	"Do we support anything analogous to the postgresql OFFSET, skipping the first N rows"
	^true.
]

{ #category : #'services tables' }
PostgresPlatform >> tableNameFor: aStringRepresentingATableName [
	"Return the table name, as modified to be used in a database statement."
	
	^(aStringRepresentingATableName
		detect: [:each | each isUppercase]
		ifNone: [nil]) isNil
	ifTrue: [aStringRepresentingATableName]
	ifFalse: ['"' , aStringRepresentingATableName , '"'].
]

{ #category : #types }
PostgresPlatform >> time [
	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'time'].
]

{ #category : #types }
PostgresPlatform >> timeStampTypeString [
	^'timestamp'.
]

{ #category : #types }
PostgresPlatform >> timestamp [
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp without time zone'].
]

{ #category : #types }
PostgresPlatform >> timestampWithTimeZone [
	^self timestamptz
]

{ #category : #types }
PostgresPlatform >> timestampWithoutTimeZone [
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp without time zone'].
]

{ #category : #types }
PostgresPlatform >> timestamptz [
	^self typeNamed: #timestamptz ifAbsentPut: [GlorpPGTimestampWithTimeZoneType new]
]

{ #category : #types }
PostgresPlatform >> timetz [
	^self typeNamed: #timetz ifAbsentPut: [GlorpPGTimeWithTimeZoneType new].
]

{ #category : #'type helpers' }
PostgresPlatform >> typesWithValues [
	super typesWithValues.
	self boolean.
	self bigint.
	self date.
	self decimal.
	self double.
	self float.
	self float4.
	self float8.
	self int2.
	self int.
	self integer.
	self numeric.
	self real.
	self sequence.
	self serial.
	self timetz.
	self timestamptz.
	^self types.
]

{ #category : #testing }
PostgresPlatform >> usesArrayBindingRatherThanGroupWriting [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^false.
]

{ #category : #testing }
PostgresPlatform >> usesInformationSchema [

	^true
]

{ #category : #testing }
PostgresPlatform >> usesLengthNotEndPosInSubstring [
	^true
]

{ #category : #types }
PostgresPlatform >> uuid [
	^self typeNamed: #uuid ifAbsentPut: [GlorpUUIDType new].
]

{ #category : #types }
PostgresPlatform >> varchar [
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new typeName: 'character varying'].
]
