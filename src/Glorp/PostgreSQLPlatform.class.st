"
This is a platform for the socket protocol 2 API of the PostgreSQL database.
"
Class {
	#name : 'PostgreSQLPlatform',
	#superclass : 'PostgresPlatform',
	#category : 'Glorp-Platforms',
	#package : 'Glorp',
	#tag : 'Platforms'
}

{ #category : 'testing' }
PostgreSQLPlatform class >> useBindingByDefault [
	^false
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> NeoJSONReaderSQLStringToJSONObject: aString for: aType [
	aString isNil
		ifTrue: [ ^ nil ].
	^ NeoJSONReader  fromString: aString
]

{ #category : 'constants' }
PostgreSQLPlatform >> areSequencesExplicitlyCreated [
	^true.
]

{ #category : 'types' }
PostgreSQLPlatform >> bigint [
	^self typeNamed: #bigint ifAbsentPut: [GlorpIntegerType new typeString: 'bigint'].
]

{ #category : 'binding' }
PostgreSQLPlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	^aCommand batchStatementBindings.
]

{ #category : 'types' }
PostgreSQLPlatform >> blob [

	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new typeString: 'bytea'].
]

{ #category : 'types' }
PostgreSQLPlatform >> boolean [
	^self typeNamed: #boolean ifAbsentPut: [GlorpBooleanType new typeString: 'boolean'].
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> byteArrayToSQLStringConverter [

	^DelegatingDatabaseConverter
		named: #byteArrayToSQLString
		hostedBy: self
		fromStToDb: #convertByteArrayToSQLString:for:
		fromDbToSt: #convertSQLStringToByteArray:for:.
]

{ #category : 'testing' }
PostgreSQLPlatform >> canBind: aValue to: aType [
	"In 7.10, the Postgres protocol 2.0 EXDI can accept Timestamp and Number formats for binding.  Date and time formats have not yet been handled."

	aType = self date ifTrue: [^false].
	aType = self time ifTrue: [^false].
	aType = self timetz ifTrue: [^false].
	^super canBind: aValue to: aType
]

{ #category : 'types' }
PostgreSQLPlatform >> char [
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new typeName: 'character'].
]

{ #category : 'constants' }
PostgreSQLPlatform >> charactersThatNeedEscaping [
	^#($')
]

{ #category : 'types' }
PostgreSQLPlatform >> clob [

	^self typeNamed: #clob ifAbsentPut: [GlorpClobType new typeString: 'text'].
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> convertByteArrayToSQLString: aByteArray for: aType [

	^aByteArray ifNotNil: [:array | array asString]
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> convertEscapeSQLStringToByteArray: aString [
	^ ByteArray
		new: aString size // 4
		streamContents: [ :out | | in nextChar |
			in := aString readStream.
			[ in atEnd ] whileFalse: [ 
				nextChar := in next.
				out
					nextPut:
						(nextChar = $\
							ifTrue: [ 
								in peek = $\
									ifTrue: [ in next asInteger ]
									ifFalse: [ Number readFrom: (in next: 3) base: 8 ] ]
							ifFalse: [ nextChar asInteger ]) ] ]
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> convertHexSQLStringToByteArray: aString [
	^ ByteArray
		new: aString size // 2 - 1
		streamContents: [ :out | | in |
			(in := aString readStream) skip: 2.
			[ in atEnd ] whileFalse: [ out nextPut: (Number readFrom: (in next: 2) base: 16) ] ]
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> convertSQLStringToByteArray: aString for: aType [
	aString isNil
		ifTrue: [ ^ nil ].
	^ (aString beginsWith: '\x')
		ifTrue: [ self convertHexSQLStringToByteArray: aString ]
		ifFalse: [ self convertEscapeSQLStringToByteArray: aString ]
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> convertSQLStringToString: aString for: aType [
	aString isNil
		ifTrue: [ ^ nil ].
	^ (self convertSQLStringToByteArray: aString for: aType) asString
]

{ #category : 'sequences' }
PostgreSQLPlatform >> databaseSequenceClass [
	^PGSequence.
]

{ #category : 'types' }
PostgreSQLPlatform >> date [
	^self typeNamed: #date ifAbsentPut: [GlorpDateType new typeString: 'date'].
]

{ #category : 'types' }
PostgreSQLPlatform >> dateAndTime [
	^self typeNamed: #dateAndTime ifAbsentPut: [GlorpDateAndTimeType new typeString: 'timestamp without time zone'].
]

{ #category : 'as yet unclassified' }
PostgreSQLPlatform >> dateAndTimeConverter [

	^PluggableDatabaseConverter new
		dbToStConverter: [:dateAndTime | dateAndTime];
		stToDbConverter: [:dateAndTime | dateAndTime ifNotNil: [:c | dateAndTime printString ]];
		yourself
]

{ #category : 'types' }
PostgreSQLPlatform >> decimal [
	^self numeric.
]

{ #category : 'types' }
PostgreSQLPlatform >> double [
	^self float8
]

{ #category : 'types' }
PostgreSQLPlatform >> float [
	^self float4.
]

{ #category : 'types' }
PostgreSQLPlatform >> float4 [
	^self typeNamed: #float4 ifAbsentPut: [GlorpFloatType new].
]

{ #category : 'types' }
PostgreSQLPlatform >> float8 [
	^self typeNamed: #float8 ifAbsentPut: [GlorpDoubleType new].
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> hexPrintBlob: aByteArray on: aStream for: aType [

	aStream nextPutAll: 'E'''.
	aStream nextPutAll: '\\x'.
	aStream nextPutAll: aByteArray hex.
	aStream nextPutAll: '''::bytea'.
]

{ #category : 'types' }
PostgreSQLPlatform >> inet [
	^self text
]

{ #category : 'functions' }
PostgreSQLPlatform >> initializeFunctions [
	super initializeFunctions.
	functions at: #copyFrom:to: put: (SubstringFunction named: 'substring').
]

{ #category : 'types' }
PostgreSQLPlatform >> int [
	^self int4
]

{ #category : 'types' }
PostgreSQLPlatform >> int2 [
	^self typeNamed: #int2 ifAbsentPut: [GlorpIntegerType new typeString: 'int2'].
]

{ #category : 'types' }
PostgreSQLPlatform >> int4 [
	^self typeNamed: #int4 ifAbsentPut: [GlorpIntegerType new typeString: 'int4'].
]

{ #category : 'types' }
PostgreSQLPlatform >> int8 [
	^self typeNamed: #int8 ifAbsentPut: [GlorpIntegerType new typeString: 'int8'].
]

{ #category : 'sql' }
PostgreSQLPlatform >> isPostgreSQLPlatform [
	^true.
]

{ #category : 'constants' }
PostgreSQLPlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)"

	^31
]

{ #category : 'constants' }
PostgreSQLPlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"

	^31
]

{ #category : 'testing' }
PostgreSQLPlatform >> measuresStringFieldWidthsInBytes [
	"Return true if we measure the width of a string in bytes rather than characters. So, a 255-character field can hold 255 bytes worth of string, not 255 characters. This is important with encodings"
	^true.
]

{ #category : 'types' }
PostgreSQLPlatform >> numeric [
	^self typeNamed: #numeric ifAbsentPut: [GlorpNumericType new].
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> printBlob: aByteArray on: aStream for: aType [

	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	self hexPrintBlob: aByteArray on: aStream for: aType


]

{ #category : 'conversion - times' }
PostgreSQLPlatform >> printDate: aDate for: aType [
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

{ #category : 'database - specific' }
PostgreSQLPlatform >> printOffset: anInteger on: aCommand [
	aCommand
		nextPutAll: ' OFFSET '.
	anInteger printOn: aCommand.
]

{ #category : 'database - specific' }
PostgreSQLPlatform >> printPostLimit: anInteger on: aCommand [
	aCommand
		nextPutAll: ' LIMIT '.
	anInteger printOn: aCommand.
]

{ #category : 'conversion - times' }
PostgreSQLPlatform >> printTime: aTime for: aType [
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

{ #category : 'conversion - times' }
PostgreSQLPlatform >> printTimestamp: aTimestamp on: stream for: aType [
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

{ #category : 'types' }
PostgreSQLPlatform >> real [
	^self float4
]

{ #category : 'testing' }
PostgreSQLPlatform >> requiresCastsForNullsInUnions [
	"If we have explicit nulls in a query which is unioned, do we need to cast them to the appropriate type in order to keep the database happy."
	^true.
]

{ #category : 'constants' }
PostgreSQLPlatform >> requiresTransactionForTableOperations [
	"Return true if we need a transaction in order to do table creation, deletion, and so forth. Some databases require it. Others don't like it"
	^false.
]

{ #category : 'types' }
PostgreSQLPlatform >> sequence [

	^self serial
]

{ #category : 'types' }
PostgreSQLPlatform >> serial [
	"For postgresql, we use sequences, and explicitly get the values ourselves, so just tell the database that they're integers."
	^self typeNamed: #serial ifAbsentPut: [GlorpSerialType new typeString: 'integer'].
]

{ #category : 'types' }
PostgreSQLPlatform >> smallint [
	^self int2
]

{ #category : 'constants' }
PostgreSQLPlatform >> sqlTextCurrentServerUTCTimestamp [

	^'SELECT CURRENT_TIMESTAMP AT TIME ZONE ''UTC'' '
]

{ #category : 'conversion - strings' }
PostgreSQLPlatform >> stringToSQLStringConverter [

	^DelegatingDatabaseConverter
		named: #stringToSQLString
		hostedBy: self
		fromStToDb: #convertByteArrayToSQLString:for:
		fromDbToSt: #convertSQLStringToString:for:.
]

{ #category : 'testing' }
PostgreSQLPlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax."
	^true.
]

{ #category : 'testing' }
PostgreSQLPlatform >> supportsCaseInsensitiveLike [
	^true.
]

{ #category : 'testing' }
PostgreSQLPlatform >> supportsGroupWritingFor: aCommand [
	^aCommand supportsGroupWriting.
]

{ #category : 'testing' }
PostgreSQLPlatform >> supportsLimit [
	"Do we support anything analogous to the postgresql LIMIT, returning only the first N rows"
	^true.
]

{ #category : 'constants' }
PostgreSQLPlatform >> supportsMillisecondsInTimes [
	"I think this depends on settings, but it's easier right now to just turn it off"
	^false.
]

{ #category : 'testing' }
PostgreSQLPlatform >> supportsOffset [
	"Do we support anything analogous to the postgresql OFFSET, skipping the first N rows"
	^true.
]

{ #category : 'services tables' }
PostgreSQLPlatform >> tableNameFor: aStringRepresentingATableName [
	"Return the table name, as modified to be used in a database statement."
	
	^(aStringRepresentingATableName
		detect: [:each | each isUppercase]
		ifNone: [nil]) isNil
	ifTrue: [aStringRepresentingATableName]
	ifFalse: ['"' , aStringRepresentingATableName , '"'].
]

{ #category : 'types' }
PostgreSQLPlatform >> time [
	^self typeNamed: #time ifAbsentPut: [GlorpTimeType new typeString: 'time'].
]

{ #category : 'types' }
PostgreSQLPlatform >> timeStampTypeString [
	^'timestamp'.
]

{ #category : 'types' }
PostgreSQLPlatform >> timestamp [
	^self typeNamed: #timestamp ifAbsentPut: [GlorpTimeStampType new typeString: 'timestamp without time zone'].
]

{ #category : 'types' }
PostgreSQLPlatform >> timetz [
	^self typeNamed: #timetz ifAbsentPut: [GlorpPGTimeWithTimeZoneType new].
]

{ #category : 'type helpers' }
PostgreSQLPlatform >> typesWithValues [
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
	^self types.
]

{ #category : 'testing' }
PostgreSQLPlatform >> usesArrayBindingRatherThanGrouping [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^false.
]

{ #category : 'types' }
PostgreSQLPlatform >> varchar [
	^self typeNamed: #varchar ifAbsentPut: [GlorpVarCharType new typeName: 'character varying'].
]
