"
This is an abstract superclass for classes that provide a compatibility layer for different databases. They encapsulate different SQL syntaxes, binding mechanism, types that are available, and general limits.

Subclasses must implement the following messages:
	accessing
		vwEXDIConnectionClass
	binding
		bindingsForGroupWritingFor:
	constants
		areSequencesExplicitlyCreated
		supportsMillisecondsInTimes
	sequences
		databaseSequenceClass
	testing
		usesArrayBindingRatherThanGrouping
	types
		int4
		sequence
		serial
		timestamp
		varbinary
		varchar

Instance Variables:
	characterEncoding	<ByteSymbol>	What character encoding should we use for the database connection.
	converters	<Dictionary from: Symbol to: DatabaseConverter>	The available type converters. So, for example, if there is a boolean to integer conversion, we expect it in this dictionary associated with the symbol #booleanToInteger. If that symbol isn't there, we will look up the converter by performing #booleanToIntegerConverter and caching the result.
	functions	<FunctionExpression>	Which functions are available for this database. There is a set of common functions created by FunctionExpression, plus we can define our own additions or overrides that are specific to this database.
	reservedWords	<Collection of: String>	Which names are reserved words in this database. Any that we use as table or column names will need to be quoted.
	types	<Dictionary from: Symbol to: GlorpDatabaseType>	A cache of available types, mapped by name to the type instance.
	useBinding	<Boolean>	By default, should we use binding for this database.


"
Class {
	#name : #DatabasePlatform,
	#superclass : #Object,
	#instVars : [
		'types',
		'converters',
		'useBinding',
		'reservedWords',
		'functions',
		'characterEncoding'
	],
	#classVars : [
		'UseBindingIfSupported'
	],
	#classInstVars : [
		'converterRepository'
	],
	#category : #'Glorp-Platforms'
}

{ #category : #'as yet unclassified' }
DatabasePlatform class >> allReservedWords [

	| words |
	words := IdentityDictionary new.
	self allSubclasses do: [:each | words at: each put: each reservedWords].
	^words
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> createLoginFromConnectionDictionary: aDict [ 
	self subclassResponsibility
]

{ #category : #eoglorp }
DatabasePlatform class >> loginWithConnectionDictionary: aDict [ 
	| platformClass |
	platformClass := self allSubclasses
				detect: [:cls | cls understandsConnectionDictionary: aDict].
	^ platformClass isNil
		ifFalse: [platformClass createLoginFromConnectionDictionary: aDict] ifTrue: [nil]
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> reservedWords [
	
	^Set new.
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> understandsConnectionDictionary: aDict [

	^false
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> useBindingByDefault [
	^true
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> useBindingIfSupported [
	"If I am nil (the default), each platform that supportsBinding lazily initializes to its defaultUseBinding value.  If I have a value, I force lazy initialization of each platform that supportsBinding to my value.  Normally, a value is set only for specific testing purposes."

	UseBindingIfSupported isNil ifTrue: [^self useBindingByDefault].
	^UseBindingIfSupported
]

{ #category : #'as yet unclassified' }
DatabasePlatform class >> useBindingIfSupported: aBooleanOrNil [
	"If I am nil (the default), each platform that supportsBinding lazily initializes to its defaultUseBinding value.  If I have a value, I force lazy initialization of each platform that supportsBinding to my value.  Normally, a value is set only for specific testing purposes."

	UseBindingIfSupported := aBooleanOrNil.
]

{ #category : #constants }
DatabasePlatform >> areSequencesExplicitlyCreated [

	self subclassResponsibility.
]

{ #category : #'conversion - times' }
DatabasePlatform >> asTimestamp: anObject for: aType [
	anObject isNil ifTrue: [^nil].
	^anObject class = Time
		ifTrue: [Dialect newTimestampFromDate: Date today time: anObject]
		ifFalse: [anObject asDateAndTime].
]

{ #category : #constants }
DatabasePlatform >> autoTrimsStringsLongerThanColumnSize [
	"Answer true if the platform trims an string longer that the column size without triggering any error.
	E.g. the string 'abcde' is trimmed to 'abcd' during if the column is a CHAR(4)."

	^false
]

{ #category : #constants }
DatabasePlatform >> batchWriteStatementTerminatorString [
	"^<String> This statement return the string to be used to devide several statement during batch write ..."

	^';'
]

{ #category : #binding }
DatabasePlatform >> bindingsForGroupWritingFor: aCommand [
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	self subclassResponsibility.
]

{ #category : #types }
DatabasePlatform >> blob [
	^self typeNamed: #blob ifAbsentPut: [GlorpBlobType new].
]

{ #category : #types }
DatabasePlatform >> boolean [
	"By default, we represent booleans as small integers."
	^self smallint.
]

{ #category : #types }
DatabasePlatform >> booleanFalse [
^ 0.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> booleanToBooleanConverter [
	^DelegatingDatabaseConverter
		named: #booleanToBoolean
		hostedBy: self
		fromStToDb: #convertBooleanToDBBoolean:for:
		fromDbToSt: #convertDBBooleanToBoolean:for:.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> booleanToIntegerConverter [
	^DelegatingDatabaseConverter
		named: #booleanToInteger
		hostedBy: self
		fromStToDb: #convertBooleanToInteger:for:
		fromDbToSt: #convertIntegerToBoolean:for:.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> booleanToStringTFConverter [
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToTF:for:
		fromDbToSt: #convertTFToBoolean:for:.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> booleanToStringYNConverter [
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToYN:for:
		fromDbToSt: #convertYNToBoolean:for:.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> booleanToStringYesNoConverter [
	^DelegatingDatabaseConverter
		named: #booleanToString
		hostedBy: self
		fromStToDb: #convertBooleanToYesNo:for:
		fromDbToSt: #convertYesNoToBoolean:for:.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> byteArrayToString: aByteArray for: aType [
	^aByteArray isNil ifTrue: [nil] ifFalse: [Dialect convert: aByteArray toStringWithEncoding: self characterEncoding].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> byteArrayToStringConverter [
	^DelegatingDatabaseConverter
		named: #byteArrayToString
		hostedBy: self
		fromStToDb: #convertStringToByteArray:for:
		fromDbToSt: #convertByteArrayToString:for:.
]

{ #category : #'conversion - times' }
DatabasePlatform >> byteaConverter [
	^DelegatingDatabaseConverter
		named: #bytea
		hostedBy: self
		fromStToDb: #toByteaSQLString:for:
		fromDbToSt: #nullConverter:for: "P3 converts on the way in"
]

{ #category : #testing }
DatabasePlatform >> canBind: aValue to: aType [
	(Dialect unbindableClassNames includes: aValue class name) ifTrue: [^false].
	^true.
]

{ #category : #testing }
DatabasePlatform >> canUseInWhereClause: aValue type: aType [
	(Dialect isFloatingPoint: aValue) ifTrue: [^false].
	^true.
]

{ #category : #constants }
DatabasePlatform >> capitalWritingOfColumnName [
	"^<Boolean> This method returns true, if the dbms wants to have column 
	names written in capital letters"

	^false
]

{ #category : #constants }
DatabasePlatform >> capitalWritingOfCreatorName [
	"^<Boolean> This method returns true, if the dbms wants to have column 
	names written in capital letters"

	^true
]

{ #category : #constants }
DatabasePlatform >> capitalWritingOfDatabaseName [
	"^<Boolean>"

	^true
]

{ #category : #constants }
DatabasePlatform >> capitalWritingOfSQLCommands [
	"^<Boolean>"

	^true
]

{ #category : #constants }
DatabasePlatform >> capitalWritingOfTableName [
	"^<Boolean>"

	^true
]

{ #category : #types }
DatabasePlatform >> char [
	^self typeNamed: #char ifAbsentPut: [GlorpCharType new].
]

{ #category : #types }
DatabasePlatform >> char: anInteger [
	^self char width: anInteger asInteger.
]

{ #category : #types }
DatabasePlatform >> character [
	^self char
]

{ #category : #accessing }
DatabasePlatform >> characterEncoding [
	"We hope that this will be set appropriately for the connection, but make sure the default is fairly harmless, and will in most cases complain rather than write characters incorrectly"
	characterEncoding isNil ifTrue: [characterEncoding := #ascii].
	^characterEncoding
]

{ #category : #accessing }
DatabasePlatform >> characterEncoding: anEncodingName [
	characterEncoding := anEncodingName.
]

{ #category : #constants }
DatabasePlatform >> charactersThatNeedEscaping [
	^#($' )
]

{ #category : #types }
DatabasePlatform >> clob [
	^self typeNamed: #blob ifAbsentPut: [GlorpClobType new].
]

{ #category : #constants }
DatabasePlatform >> columnNameSeparatorString [
	"^<String> This statement return the string to be used to devide several columns ..."

	^','
]

{ #category : #'database - specific' }
DatabasePlatform >> compoundOperationFor: aSymbol [
	"Return the platform specific version of a compound statement symbol"
	^aSymbol.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertBooleanToDBBoolean: aBoolean for: aType [
	(self usesNullForFalse and: [aBoolean isNil]) ifTrue: [^false].
	^aBoolean.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertBooleanToInteger: aBoolean for: aType [
	aBoolean isNil ifTrue: [^nil].
	^aBoolean ifTrue: [1] ifFalse: [0].
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertBooleanToTF: aBoolean for: aType [
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['T'] ifFalse: ['F'].
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertBooleanToYN: aBoolean for: aType [
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['Y'] ifFalse: ['N'].
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertBooleanToYesNo: aBoolean for: aType [
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['YES'] ifFalse: ['NO'].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> convertByteArrayToSQLString: aByteArray for: aType [
	"This is a slightly misleading name. Really what we want is conversion to a Blob-type of field. So if it's a bytearray, we can just let the driver take care of that conversion, but if we're given a string, we should convert it."

	^aByteArray isString
		ifTrue:
			[Dialect
				convert: aByteArray
				toByteArrayWithEncoding: self characterEncoding]
		ifFalse: [aByteArray].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> convertByteArrayToString: aByteArray for: aType [
	
	^aByteArray ifNotNil: [ aByteArray asString ]
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertDBBooleanToBoolean: aBoolean for: aType [
	^aBoolean.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertIntegerToBoolean: anInteger for: aType [
	anInteger isNil ifTrue: [^anInteger].
	anInteger = 1 ifTrue: [^true].
	anInteger = 0 ifTrue: [^false].
	self error: 'invalid boolean conversion'.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> convertStringToByteArray: aString for: aType [
	^aString ifNotNil:  [aString asByteArray]
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertTFToBoolean: aString for: aType [
	aString isNil ifTrue: [^aString].
	aString = 'T' ifTrue: [^true].
	aString = 'F' ifTrue: [^false].
	self error: 'invalid boolean conversion'.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> convertToDecimal: aNumber for: type [

 	aNumber isNil ifTrue: [^nil].
	^ScaledDecimal newFromNumber: aNumber scale: type scale.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> convertToDouble: aNumber for: type [ 

	aNumber isNil ifTrue: [^nil].
	^Dialect coerceToDoublePrecisionFloat: aNumber
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> convertToFloat: aNumber for: aType [ 
	aNumber isNil ifTrue: [^nil].
	^aNumber asFloat.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> convertToInteger: aNumber for: aType [ 
	^aNumber isNil ifTrue: [aNumber] ifFalse: [aNumber asNumber asInteger].
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> convertToNumber: aNumber for: aType [
	"Convert to an arbitrary numeric type. Make sure our precision matches. *Hate* floating point"

	| exponent result |
	aNumber isNil ifTrue: [^nil].
	aType scale isNil ifTrue: [^aNumber].
	(Dialect doesScaleOf: aNumber equal: aType scale) ifTrue: [^aNumber].
	exponent := Dialect
		coerceToDoublePrecisionFloat: (10 raisedToInteger: aType scale).
	result := (aNumber * exponent) rounded / exponent.
	^aNumber isInteger ifTrue: [result rounded] ifFalse: [result].
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertYNToBoolean: aString for: aType [
	aString isNil ifTrue: [^aString].
	aString = 'Y' ifTrue: [^true].
	aString = 'N' ifTrue: [^false].
	self error: 'invalid boolean conversion'.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> convertYesNoToBoolean: aString for: aType [
	aString isNil ifTrue: [^aString].
	aString asUppercase = 'YES' ifTrue: [^true].
	aString asUppercase = 'NO' ifTrue: [^false].
	self error: 'invalid boolean conversion'.
]

{ #category : #'type converters' }
DatabasePlatform >> converterNamed: aSymbol [

	^self converters at: aSymbol ifAbsentPut: [
		| converter |
		converter := self perform: (aSymbol, 'Converter') asSymbol.
		converter name: aSymbol]
]

{ #category : #'type converters' }
DatabasePlatform >> converters [
	converters isNil ifTrue: [converters := IdentityDictionary new].
	^converters.
]

{ #category : #'services columns' }
DatabasePlatform >> createAddColumnStatementFor: aField [
	| stream |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table on: stream.
	stream
		space;
		nextPutAll: ' ADD ';
		nextPutAll: self startColumnAddString.
	self  printColumn: aField on: stream.
	stream nextPutAll: self  endColumnAddString.
		
	^stream contents
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatement: aField newType: aType [

	^self createAlterColumnStatement: aField newType: aType usingExpression: nil
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatement: aField newType: aType usingExpression: expression [

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
		nextPutAll:  ' TYPE ';
		nextPutAll: aType typeString.
	expression ifNotNil: [ sqlStatementStream nextPutAll: ' USING ', expression ].

	^sqlStatementStream contents
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatement: aField setDefault: anObject [
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
		nextPutAll:  'SET DEFAULT';
		space.
	anObject printOn: sqlStatementStream.
	
	^sqlStatementStream contents
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatementDropDefault: aField [
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
		nextPutAll:  'DROP DEFAULT '.

	^sqlStatementStream contents
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatementDropNotNull: aField [
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
		nextPutAll:  'DROP';
		space;
		nextPutAll:  self sqlTextForNOTNULLAttributeConstraint.

	
	^sqlStatementStream contents
]

{ #category : #'services columns' }
DatabasePlatform >> createAlterColumnStatementSetNotNull: aField [
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
		nextPutAll:  'SET';
		space;
		nextPutAll:  self sqlTextForNOTNULLAttributeConstraint.

	
	^sqlStatementStream contents
]

{ #category : #'services constraints' }
DatabasePlatform >> createConstraintAddStatement:  aConstraint [
	| sqlStatementStream |
	self supportsAlterTableForConstraints ifFalse: [^''].
	aConstraint shouldCreateInDatabase ifFalse: [^''].
	self supportsConstraints
			ifTrue: [sqlStatementStream := WriteStream on: String new.
					sqlStatementStream
						nextPutAll:  'ALTER TABLE';
						space.
					self printDDLTableNameFor: aConstraint table on: sqlStatementStream.
					(aConstraint creationStringFor: self)
						do: [ :each | sqlStatementStream nextPutAll: ' ADD ', each.]
						separatedBy: [sqlStatementStream nextPut: $,].
					^sqlStatementStream contents].
	^String new
]

{ #category : #'services constraints' }
DatabasePlatform >> createConstraintDropStatement: aConstraint [
	| aStream |
	self supportsAlterTableForConstraints ifFalse: [^''].
	aConstraint shouldCreateInDatabase ifFalse: [^''].
	aStream := WriteStream on: (String new: 50).
	aStream nextPutAll: 'ALTER TABLE '.
	self printDDLTableNameFor: aConstraint table on: aStream.
	aStream nextPutAll: ' DROP '.
	self writeConstraintToDrop: aConstraint onStream: aStream.
	^aStream contents.
]

{ #category : #'services columns' }
DatabasePlatform >> createDropColumnStatementFor: aField [
	| stream |
	stream := WriteStream on: String new.
	stream 
		nextPutAll: 'ALTER TABLE';
		space.
	self printDDLTableNameFor: aField table  on: stream.
	stream
		space;
		nextPutAll: 'DROP COLUMN';
		space;
		nextPutAll: (self nameForColumn: aField name).
		
	^stream contents
]

{ #category : #'services tables' }
DatabasePlatform >> createDropTableStatementFor: aTableNameString [
	"^<String> This method returns a string which can be used to drop a database table ..."

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: 'DROP TABLE';
		space;
		nextPutAll: aTableNameString.

	^sqlStatementStream contents
]

{ #category : #'services constraints' }
DatabasePlatform >> createForeignKeyConstraintAddStatement: aForeignKeyConstraint [
	"Callback from the ForeignKeyConstraint. Returns collection of statements "
	| ws |
	aForeignKeyConstraint shouldCreateInDatabase ifFalse: [^#('')].
	ws := WriteStream on: (String new: 50).
	ws
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aForeignKeyConstraint name;
		nextPutAll: ' FOREIGN KEY ('.
	GlorpHelper print: [:each | each name] on: ws for: aForeignKeyConstraint sourceFields separatedBy: ','.
	ws 	nextPutAll: ') REFERENCES ';
		nextPutAll: aForeignKeyConstraint targetTable qualifiedName;
		nextPutAll: ' ('.
	GlorpHelper print: [:each | each name] on: ws for: aForeignKeyConstraint targetFields separatedBy: ','.
	ws nextPutAll: ')'.
	aForeignKeyConstraint suffixExpression isNil
		ifFalse:
			[ws
				space;
				nextPutAll: aForeignKeyConstraint suffixExpression].

	^OrderedCollection with: ws contents.
]

{ #category : #'services constraints' }
DatabasePlatform >> createPrimaryKeyConstraintAddStatement: aPrimaryKeyConstraint [
	"Callback from the PrimaryKeyConstraint. Returns collection of statements "
	| aStream statements |
	aPrimaryKeyConstraint shouldCreateInDatabase ifFalse: [^''].
	statements := OrderedCollection new.
	aStream := WriteStream on: String new.
	aStream nextPutAll: 'CONSTRAINT '.
	aStream nextPutAll: aPrimaryKeyConstraint name.
	aStream nextPutAll: ' PRIMARY KEY  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: aPrimaryKeyConstraint primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).
	statements add: aStream contents.
	self primaryKeysAreAutomaticallyUnique ifTrue: [^statements].

	aStream reset.
	aStream nextPutAll: ' CONSTRAINT '.
	aStream nextPutAll: (self usesPrimaryKeyUniqueConstraintNames 
							ifTrue: [aPrimaryKeyConstraint table name, '_UNIQ'] 
							ifFalse: ['']).
	aStream nextPutAll: ' UNIQUE  ('.
	GlorpHelper 
		print: [:each | each name]
		on: aStream
		for: aPrimaryKeyConstraint  primaryKeyFields
		separatedBy: ','.
	aStream nextPut: $).
	statements add: aStream contents.

	^statements
]

{ #category : #obsolete }
DatabasePlatform >> createTableFKContraintsStatementStringsFor: aGLORPDatabaseTable [

	^aGLORPDatabaseTable foreignKeyConstraintsForCreation
		collect: [:each |	self createConstraintAddStatement: each ]
]

{ #category : #'services tables' }
DatabasePlatform >> createTableIndexStatementStringFor: aGLORPDatabaseTable index: aGlorpDatabaseIndex [

	| sqlStatementStream |
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream nextPutAll: 'CREATE INDEX '.
	sqlStatementStream nextPutAll: aGlorpDatabaseIndex name.
	sqlStatementStream nextPutAll: ' ON '.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.
	aGlorpDatabaseIndex printStatementOn: sqlStatementStream platform: self.
	^sqlStatementStream contents
]

{ #category : #'services tables' }
DatabasePlatform >> createTableIndexStatementStringsFor: aGLORPDatabaseTable [
	^aGLORPDatabaseTable indexes
		collect:
			[:idx | 
			| sqlStatementStream |
			sqlStatementStream := WriteStream on: String new.
			sqlStatementStream nextPutAll: 'CREATE INDEX '.
			sqlStatementStream nextPutAll: idx name.
			sqlStatementStream nextPutAll: ' ON '.
			self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.
			idx printStatementOn: sqlStatementStream.
			sqlStatementStream contents].
]

{ #category : #'services tables' }
DatabasePlatform >> createTableStatementStringFor: aGLORPDatabaseTable [ 
	"^<String> This method returns a string which can be used to create a database table ..."

	| sqlStatementStream tmpString |
	tmpString := 'create table'.
	sqlStatementStream := WriteStream on: String new.
	sqlStatementStream
		nextPutAll: (self capitalWritingOfSQLCommands 
			ifTrue: [tmpString asUppercase]
			ifFalse: [tmpString]);
		space.
	self printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream.

	"Now print the columns specification for each field in the table ..."
	self 
		printColumnsSpecificationFor: aGLORPDatabaseTable
		on: sqlStatementStream.
	self supportsConstraints ifTrue:
		[aGLORPDatabaseTable hasPrimaryKeyConstraints ifTrue: 
			[sqlStatementStream nextPutAll: ', '.
			(aGLORPDatabaseTable primaryKeyConstraints creationStringFor: self)
				do: [ :each | sqlStatementStream nextPutAll: each.]
				separatedBy: [sqlStatementStream nextPut: $,]].

		aGLORPDatabaseTable hasUniqueConstraints ifTrue:
			[sqlStatementStream nextPutAll: ', '.
			aGLORPDatabaseTable uniqueConstraints do:
				[:each | sqlStatementStream nextPutAll: (each creationString)]
				separatedBy: [sqlStatementStream nextPut: $,]]].

	sqlStatementStream
		nextPut: $).
	^sqlStatementStream contents
]

{ #category : #'services constraints' }
DatabasePlatform >> createUniqueConstraintAddStatement: aUniqueConstraint [
	"Callback from the UniqueConstraint. Returns collection of statements "
	
	| stream |
	aUniqueConstraint shouldCreateInDatabase ifFalse: [^#('')].
	stream := WriteStream on: (String new: 50).
	stream
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aUniqueConstraint name;
		nextPutAll: ' UNIQUE ('.
	GlorpHelper 
		print: [:each | each name] 
		on: stream 
		for: aUniqueConstraint fields 
		separatedBy: ','.
	stream nextPutAll: ')'.
	^OrderedCollection with: stream contents
]

{ #category : #sequences }
DatabasePlatform >> databaseIdentitySequenceClass [
	"This method applies only to classes that have both types--database sequences and identity columns.
	Currently, only DB2 has both types. The sequence is prefered, and the identity type has minimal support."

	self databaseSequenceClass
]

{ #category : #sequences }
DatabasePlatform >> databaseSequenceClass [
	self subclassResponsibility.
]

{ #category : #types }
DatabasePlatform >> date [
	"Return the type we use to represent dates. By default, we use the same type as for timestamps."
	^self timestamp.
]

{ #category : #'conversion - times' }
DatabasePlatform >> dateConverter [
	^DelegatingDatabaseConverter
		named: #date
		hostedBy: self
		fromStToDb: #toDate:for:
		fromDbToSt: #readDate:for:.	"#printDate:for:"
]

{ #category : #types }
DatabasePlatform >> datetime [
	^self timestamp
]

{ #category : #'services tables' }
DatabasePlatform >> ddlTableNameFor: aTableOrString [
	"
	Either a databaseTable or a string can be passed in the argument.
	"

	^ aTableOrString isString
		ifTrue: [ self capitalWritingOfTableName 
			ifTrue: [ aTableOrString asUppercase ] 
			ifFalse:[ aTableOrString ] ]
		ifFalse: [ self ddlTableNameFor: aTableOrString qualifiedName ]
]

{ #category : #constants }
DatabasePlatform >> defaultOptimalINClauseLimit [
	"Databases have limits on the number if values allowed in an IN clause. 
	However, if you research their user forums, you'll find that there is quite a difference between the
	vendor's hard upper limit and the discovered opmimal limit. 
	Sometimes the 'real' limit is further degraded because of the total size in characters of the final SQL statement.
	This value represents a common realistic default.
	Subclasses may override this for better values for their platform."

	^500
]

{ #category : #accessing }
DatabasePlatform >> defaultPort [
	"self subclassResponsibility.
	for this instance i'll return 5432, but all platforms must be return you own port"
	^ '5432'.
]

{ #category : #constants }
DatabasePlatform >> deleteViewWithTableSyntax [

	^false
]

{ #category : #types }
DatabasePlatform >> double [
	^self subclassResponsibility.
]

{ #category : #constants }
DatabasePlatform >> endColumnAddString [
	"The string we use as a suffix when adding a colum"
	^''.
]

{ #category : #'services columns' }
DatabasePlatform >> endColumnQuote [
	"Return the character used to stop quoting the name of a column so that we can avoid conflicts with reserved names. ANSI says to use double quotes, so that's the default."
	^'"'.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> escapeFor: aCharacter [
	aCharacter = $' ifTrue: [^''''''].
	^String with: $\ with: aCharacter.
]

{ #category : #functions }
DatabasePlatform >> functions [
	functions isNil ifTrue: [self initializeFunctions].
	^functions.
]

{ #category : #types }
DatabasePlatform >> generatorFor: aType withBlock: aBlock [
	"Don't cache this, because we want to return different instances depending on aType"
	^VersionType underlyingType: aType generator: (AdHocVersionGenerator block: aBlock).
]

{ #category : #constants }
DatabasePlatform >> hasSubtransaction [
	"^<Boolean> This method returns true, if the used dbms is able to execute multiple sql-statements
	transferred via a command line transmitted from client to server - otherwise I return false"

	^true
]

{ #category : #types }
DatabasePlatform >> inMemorySequence [
	^self typeNamed: #inMemorySequence ifAbsentPut: [
		GlorpInMemorySequenceDatabaseType representedBy: self int4].
]

{ #category : #functions }
DatabasePlatform >> initializeFunctions [
	"Subclasses should override to add database-specific functions"

	functions := FunctionExpression createBasicFunctionsFor: self.
]

{ #category : #constants }
DatabasePlatform >> initializeReservedWords [
	reservedWords := Set new.
]

{ #category : #constants }
DatabasePlatform >> initializeTypes [
	types := nil.
]

{ #category : #types }
DatabasePlatform >> int [
	^self integer.
]

{ #category : #types }
DatabasePlatform >> int2 [

	^self subclassResponsibility
]

{ #category : #types }
DatabasePlatform >> int4 [

	^self subclassResponsibility
]

{ #category : #types }
DatabasePlatform >> int8 [

	^self subclassResponsibility
]

{ #category : #types }
DatabasePlatform >> integer [
	^self typeNamed: #integer ifAbsentPut: [GlorpIntegerType new].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> integerToString: anInteger for: aType [
	anInteger isNil ifTrue: [^nil].
	^self padString: anInteger printString for: aType.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> integerToStringConverter [
	^DelegatingDatabaseConverter
		named: #integerToString
		hostedBy: self
		fromStToDb: #integerToString:for:
		fromDbToSt: #stringToInteger:for:.
]

{ #category : #testing }
DatabasePlatform >> isAccessPlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isDB2Platform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isMySQLPlatform [
	^false.
]

{ #category : #testing }
DatabasePlatform >> isNBSQLite3Platform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isODBCPlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isOcelotPlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isOraclePlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isPostgreSQLPlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isSQLServerPlatform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isSQLite3Platform [

	^false
]

{ #category : #testing }
DatabasePlatform >> isUDBCSQLite3Platform [
	^false
]

{ #category : #constants }
DatabasePlatform >> maxSQLBufferLength [
	"^<Integer> I return the maximum length of a sql command stream"

	^8192
]

{ #category : #constants }
DatabasePlatform >> maximumLengthOfColumnName [
	"^<Integer> I return the maximum length of a column name.  (I am not sent at present;  I am here so that if I and #maximumLengthOfTableName (which is sent) should ever differ on some database platform, I can be used in revised truncation logic.)"

	^18
]

{ #category : #constants }
DatabasePlatform >> maximumLengthOfTableName [
	"^<Integer> I return the max. length of a table name"

	^18
]

{ #category : #testing }
DatabasePlatform >> maximumQueryValueSize [
	"If there's a limit on how big a bound input parameter can be for a query, return it here. By default, no maximum. "
	^536870911 "VisualWorks SmallInteger maxVal. Lacking infinity, this will do as a default."
]

{ #category : #binding }
DatabasePlatform >> maximumSizeToGroupWriteFor: aCollectionOfDatabaseRows [
	"If we are going to group write, how many rows of this collection should we do it for at once"
	^aCollectionOfDatabaseRows size.
]

{ #category : #testing }
DatabasePlatform >> measuresStringFieldWidthsInBytes [
	"Return true if we measure the width of a string in bytes rather than characters. So, a 255-character field can hold 255 bytes worth of string, not 255 characters. This is important with encodings"
	^false.
]

{ #category : #'services columns' }
DatabasePlatform >> nameForColumn: aColumnString [
	| upper |
	upper := self capitalWritingOfColumnName ifTrue: [aColumnString asUppercase] ifFalse: [aColumnString].
	(self reservedWords includes: aColumnString asLowercase) ifFalse: [^upper].
	^self startColumnQuote, upper, self endColumnQuote.
]

{ #category : #constants }
DatabasePlatform >> nameForPrimaryKeyConstraintsWhenDropping [
	"Return the name we use to describe a constraint when dropping them. This is required because MySQL wants you to use 'DROP PRIMARY KEY' rather than the ANSI 'DROP CONSTRAINT'."
	^'CONSTRAINT'.
]

{ #category : #sequences }
DatabasePlatform >> newDatabaseIdentitySequenceNamed: aString [
	"Return an identity sequence, with the given name. This method is useful for platforms
	which provide regular sequence objects as well as identity column objects. Glorp uses
	sequences when they are available, but pre-existing DB2 tables may contain identity
	columns, so we need to be able to recognize them."

	^self databaseIdentitySequenceClass named: aString
]

{ #category : #sequences }
DatabasePlatform >> newDatabaseSequenceNamed: aString [
	"Return a sequence of the type we use, with the given name"
	^self databaseSequenceClass named: aString.
]

{ #category : #'conversion - null' }
DatabasePlatform >> nullConversion: anObject for: aType [
	^anObject.
]

{ #category : #'conversion - null' }
DatabasePlatform >> nullConverter [
	^NullConverter new
		name: #null.
]

{ #category : #types }
DatabasePlatform >> number [

	^self typeNamed: #number ifAbsentPut: [GlorpNumericType new].
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> numberToDecimalConverter [

	^DelegatingDatabaseConverter
		named: #numberToDecimal
		hostedBy: self
		fromStToDb: #convertToDecimal:for:
		fromDbToSt: #convertToDecimal:for:.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> numberToDoubleConverter [
	^DelegatingDatabaseConverter
		named: #numberToDouble
		hostedBy: self
		fromStToDb: #convertToDouble:for:
		fromDbToSt: #convertToDouble:for:.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> numberToFloatConverter [
	^DelegatingDatabaseConverter
		named: #numberToFloat
		hostedBy: self
		fromStToDb: #convertToFloat:for:
		fromDbToSt: #convertToFloat:for:.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> numberToIntegerConverter [
	^DelegatingDatabaseConverter
		named: #numberToInteger
		hostedBy: self
		fromStToDb: #convertToInteger:for:
		fromDbToSt: #convertToInteger:for:.
]

{ #category : #'conversion - numbers' }
DatabasePlatform >> numberToNumberConverter [
	^DelegatingDatabaseConverter
		named: #numberToNumber
		hostedBy: self
		fromStToDb: #convertToNumber:for:
		fromDbToSt: #convertToNumber:for:.
]

{ #category : #types }
DatabasePlatform >> numeric [
	^self number.
]

{ #category : #types }
DatabasePlatform >> nvarchar [
	^self subclassResponsibility.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> padString: aString for: aType [
	"Between 0.3.140.1 and 7.10 inclusive, Glorp trimmed strings that were too long for fixed-length fields.  This is no longer done, so such strings (sometimes too long only because the database platform measuresStringFieldWidthsInBytes and the string has multi-byte characters) will normally cause database errors (intentionally:  overlong strings should not be submitted to such fields)."

	| padding |
	aString isNil ifTrue: [^nil].
	aString isString ifFalse: [self error: 'Invalid data type'].
	(self usesNullForEmptyStrings and: [aString isEmpty]) ifTrue: [^nil].
	(aType isVariableWidth or: [aString size >= aType width]) ifTrue: [^aString].
	padding := String new: aType width - aString size.
	padding atAllPut: self paddingCharacter.
	^aString , padding
]

{ #category : #'conversion - strings' }
DatabasePlatform >> padTrimmedString: aString for: aType [
	| padding trimmed |
	aString isNil ifTrue: [^nil].
	aString isString ifFalse: [self error: 'Invalid data type'].
	(self usesNullForEmptyStrings and: [aString isEmpty]) ifTrue: [^nil].
	trimmed := self trimString: aString for: aType.
				
	(aType isVariableWidth or: [trimmed size = aType width]) ifTrue: [^trimmed].
	padding := String new: aType width - aString size.
	padding atAllPut: self paddingCharacter.
	^aString , padding
]

{ #category : #'conversion - strings' }
DatabasePlatform >> paddingCharacter [
	^1 asCharacter.
]

{ #category : #constants }
DatabasePlatform >> parenthesizeAllButFirstCommandInCompoundQuery [
	"Access wants parenthesies around all but the first SELECT in a UNION query."
	^false
]

{ #category : #constants }
DatabasePlatform >> parenthesizeCommandsInCompoundQuery [
	^true
]

{ #category : #login }
DatabasePlatform >> postLoginInitializeFromAccessor: aDatabaseAccessor [
	"Database servers and clients have configuration parameters.  We may need to read or set them."
]

{ #category : #constants }
DatabasePlatform >> postfixTableNameBeforeDeleting [

	^false
]

{ #category : #'general services' }
DatabasePlatform >> predefinedKeywords [
	"
		^<OrderdCollection of: String> This method returns a list of preserved keyword, which should
		not be used in database-, table or column names or any othe names in the platform system
	"

	^OrderedCollection new
]

{ #category : #constants }
DatabasePlatform >> prefixQualifierBeforeCreatingAndDeleting [

	^true
]

{ #category : #constants }
DatabasePlatform >> prefixQualifierSeparatorString [
	"^<String> This statement return the string to be used to separate the qualifier and the table/column name"

	^'.'
]

{ #category : #constants }
DatabasePlatform >> prefixTableNameBeforeDeleting [

	^false
]

{ #category : #constants }
DatabasePlatform >> primaryKeysAreAutomaticallyUnique [
	"Return false if, in addition to specifying something as a primary key, we must separately specify it as unique"

	^false.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> printBlob: aByteArray on: aStream for: aType [
	aByteArray isNil ifTrue: [^aStream nextPutAll: 'NULL'].
	aStream nextPutAll: 'X'''.
	aByteArray do: [:each |
		each printOn: aStream paddedWith: $0 to: 2 base: 16].
	aStream nextPut: $'.
]

{ #category : #'conversion - boolean' }
DatabasePlatform >> printBoolean: aBoolean for: aType [
	"If the platform is MS SQL Server, a boolean object in a SELECT needs to be converted to  BIT type, since T, Y, or true make SQLServer complain. "
	| stream |
	stream := WriteStream on: String new.
	aBoolean glorpPrintSQLOn: stream.
	^stream contents.
]

{ #category : #'services columns' }
DatabasePlatform >> printColumn: eachGlorpDatabaseField on: sqlStatementStream [
	"Print the column specification for the CREATE TABLE statement.
	Don't show a default value for serial columns, since their semanitics are different."

	sqlStatementStream
		nextPutAll: (self nameForColumn: eachGlorpDatabaseField name);
		space;
		nextPutAll: eachGlorpDatabaseField typeString;
		space;
		nextPutAll: 
				(eachGlorpDatabaseField type isSerial
					ifTrue: ['']
					ifFalse: [self sqlTextForDEFAULT: eachGlorpDatabaseField defaultValue]);
		space;
		nextPutAll:
				(eachGlorpDatabaseField isNullable
						ifTrue: [self sqlTextForNULLAttributeConstraint]
						ifFalse: [self sqlTextForNOTNULLAttributeConstraint]);
		space;
		nextPutAll:
				(eachGlorpDatabaseField isUnique
						ifTrue: [self sqlTextForUNIQUEAttributeConstraint]
						ifFalse: [self sqlTextForNOTUNIQUEAttributeConstraint]).
]

{ #category : #'services columns' }
DatabasePlatform >> printColumnsSpecificationFor: aGlorpDatabaseTable on: sqlStatementStream [
	aGlorpDatabaseTable fields isEmpty not
		ifTrue:
			[| sepFlag |
			sqlStatementStream
				space;
				nextPut: $(.
			sepFlag := false.
			aGlorpDatabaseTable fields
				do:
					[:eachGlorpDatabaseField | 
					sepFlag
						ifTrue:
							[sqlStatementStream nextPutAll: self columnNameSeparatorString].
					self printColumn: eachGlorpDatabaseField on: sqlStatementStream.
					sepFlag := true]].
]

{ #category : #'services tables' }
DatabasePlatform >> printDDLTableNameFor: aGLORPDatabaseTable on: sqlStatementStream [
	"This method just writes the name of a table to a stream, in a way appropriate for DDL statements."
	
	sqlStatementStream nextPutAll:
		(self capitalWritingOfTableName
			ifTrue: [aGLORPDatabaseTable qualifiedName asUppercase]
			ifFalse: [aGLORPDatabaseTable qualifiedName]).
]

{ #category : #'conversion - times' }
DatabasePlatform >> printDate: aTimestamp isoFormatOn: stream [
	"Print the date as yyyy-mm-dd"
	| monthNumber dayOfMonth |
	aTimestamp isNil ifTrue: [^'NULL'].
	aTimestamp year printOn: stream.
	stream nextPut: $-.
	monthNumber := aTimestamp monthIndex.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: monthNumber).
	stream nextPut: $-.
	dayOfMonth := aTimestamp dayOfMonth.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: dayOfMonth).
]

{ #category : #'conversion - strings' }
DatabasePlatform >> printEscapedString: aString on: aCommand [
	"In this method, aCommand only needs its polymorphic stream protocol, but the parameter is sure to be a command, not a stream, if this method is called."

	| charsToEscape |
	charsToEscape := self charactersThatNeedEscaping.
	1 to: aString size do:
		[:i || char | char := aString at: i.
		(charsToEscape includes: char)
			ifTrue: [aCommand nextPutAll: (self escapeFor: char)]
			ifFalse: [aCommand nextPut: char]].
]

{ #category : #'database - specific' }
DatabasePlatform >> printOffset: anInteger on: aCommand [
	"By default, do nothing"
]

{ #category : #'database - specific' }
DatabasePlatform >> printOffset: anInteger on: aCommand withLimit: aBoolean [
	self printOffset: anInteger  on: aCommand. 
]

{ #category : #'database - specific' }
DatabasePlatform >> printPostLimit: anInteger on: aCommand [
	"By default, do nothing"
]

{ #category : #'database - specific' }
DatabasePlatform >> printPreLimit: anInteger on: aCommand [
	"By default, do nothing"
]

{ #category : #obsolete }
DatabasePlatform >> printPrimaryKeyConstraintsOn: sqlStatementStream for: aTable [ 
	"This method print the constraint specification on sqlStatementStream"

	aTable primaryKeyFields isEmpty ifTrue: [^self].
	(self createPrimaryKeyConstraintAddStatement: aTable primaryKeyConstraints)
		do: [ :each | sqlStatementStream nextPutAll: each].
]

{ #category : #'services columns' }
DatabasePlatform >> printSqlStatementToCopyDataFromColumn: fromColumn to: toColumn on: aStream [
	"
	Example:
	UPDATE test_bank_acct
	SET close_balance = balance
	WHERE close_balance IS NULL OR close_balance <> balance
	"
	| toColumnName fromColumnName |
	toColumnName := self nameForColumn: toColumn name.
	fromColumnName := self nameForColumn: fromColumn name.
	aStream
		nextPutAll: 'UPDATE ';
		nextPutAll: (self ddlTableNameFor: fromColumn table);
		nextPutAll: ' SET ';
		nextPutAll: toColumnName;
		nextPutAll: ' = ';
		nextPutAll: fromColumnName;
		nextPutAll: ' WHERE ';
		nextPutAll: toColumnName;
		nextPutAll: ' IS NULL OR ';
		nextPutAll: toColumnName;
		nextPutAll: ' <> ';
		nextPutAll: fromColumnName
]

{ #category : #'services columns' }
DatabasePlatform >> printSqlStatementToCopyDataFromTable: fromTable to: toTable on: aStream [

	aStream
		nextPutAll: 'INSERT INTO ';
		nextPutAll: (self ddlTableNameFor: toTable);
		nextPutAll: ' ( '.

	GlorpHelper 
		print: [:each | self nameForColumn: each name]
		on: aStream
		for: fromTable fields
		separatedBy: ','.


	aStream
		nextPutAll: ' ) ';
		nextPutAll: ' SELECT '.

	GlorpHelper 
		print: [:each | self nameForColumn: each name]
		on: aStream
		for: fromTable fields
		separatedBy: ','.

	aStream
		nextPutAll: ' FROM ';
		nextPutAll: (self ddlTableNameFor: fromTable)
]

{ #category : #'services tables' }
DatabasePlatform >> printSqlStatementToListColumnsInTable: aDatabaseTable inSchema: schemaString on: aStream [
	" The default SQL statement is
	"
	self subclassResponsibility 
]

{ #category : #'services tables' }
DatabasePlatform >> printSqlStatementToListTablesInSchema: schemaString on: aStream [
	" Not standardized, although SQL Server, MySQL and PostgreSQL use the INFORMATION_SCHEMA "

	| lowerSchema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT table_name FROM information_schema.tables ';
		nextPutAll: 'WHERE table_type = ';
		nextPut: $';
		nextPutAll: 'BASE TABLE';
		nextPut: $'.
	(lowerSchema notNil and: [lowerSchema notEmpty])
		ifTrue: [
			aStream
				nextPutAll: ' AND lower(table_schema) = ';
				nextPut: $';
				nextPutAll: lowerSchema;
				nextPut: $'.].
	aStream nextPut: $;
]

{ #category : #'services columns' }
DatabasePlatform >> printSqlStatementToPopulateColumn: aDatabaseField with: aValue on: aStream [

	| converter dbValue |

	converter := aDatabaseField converterForStType: aValue class.
	dbValue := converter
		convert: aValue
		toDatabaseRepresentationAs: aDatabaseField type.

	aStream
		nextPutAll: 'UPDATE ';
		nextPutAll: (self ddlTableNameFor: aDatabaseField table);
		nextPutAll: ' SET ';
		nextPutAll: (self nameForColumn: aDatabaseField name);
		nextPutAll: ' = ';
		nextPutAll: dbValue printString;
		nextPutAll: ' WHERE (';
		nextPutAll: ( self nameForColumn: aDatabaseField name);
		nextPutAll: ' IS NULL OR ';
		nextPutAll: (self nameForColumn: aDatabaseField name);
		nextPutAll: ' <> ';
		nextPutAll: dbValue printString;
		nextPutAll: ')'
]

{ #category : #'services columns' }
DatabasePlatform >> printSqlStatementToRenameColumn: oldColumn to: newColumnName on: aStream [

	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (self ddlTableNameFor: oldColumn table);
		nextPutAll: ' RENAME ';
		nextPutAll:  (self nameForColumn:  oldColumn name);
		nextPutAll: ' TO ';
		nextPutAll:  (self nameForColumn: newColumnName).
]

{ #category : #'services tables' }
DatabasePlatform >> printSqlStatementToRenameTable: aDatabaseTable to: newTableName on: aStream [
	" Tje default SQL statement is
	ALTER TABLE <oldTableName> RENAME TO <newTableName>.
	Different platforms may use another form. Override in subclasses if necessary.
	"

	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (self ddlTableNameFor: aDatabaseTable);
		nextPutAll: ' RENAME TO ';
		nextPutAll: newTableName
]

{ #category : #'services tables' }
DatabasePlatform >> printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: aStream [
	" Not standardized, although SQL Server, MySQL and PostgreSQL use the INFORMATION_SCHEMA "

	| lowerTableName lowerSchema |
	self usesInformationSchema
		ifFalse: [^self subclassResponsibility].

	lowerTableName := tableName asLowercase.
	lowerSchema := schemaString isNil
		ifTrue: [schemaString]
		ifFalse: [schemaString asLowercase].
	aStream
		nextPutAll: 'SELECT count(*) FROM information_schema.tables ';
		nextPutAll: 'WHERE lower(table_name) = ';
		nextPut: $';
		nextPutAll: lowerTableName;
		nextPut: $'.
	(lowerSchema notNil and: [lowerSchema notEmpty])
		ifTrue: [
			aStream
				nextPutAll: ' AND lower(table_schema) = ';
				nextPut: $';
				nextPutAll: lowerSchema;
				nextPut: $'.].
	aStream
		nextPutAll: ' AND table_type = ';
		nextPut: $';
		nextPutAll: 'BASE TABLE';
		nextPut: $';
		nextPut: $;
]

{ #category : #'conversion - times' }
DatabasePlatform >> printTime: aTime isoFormatOn: aStream [ 

	self
		printTime: aTime
		isoFormatOn: aStream
		milliseconds: self supportsMillisecondsInTimes.
	^self
]

{ #category : #'conversion - times' }
DatabasePlatform >> printTime: aTimestamp isoFormatOn: stream milliseconds: aBoolean [
	"Print the time as hh:mm:ss.mmm"
	| ms |
	aTimestamp isNil ifTrue: [^nil].
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp hours).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp minutes).
	stream nextPut: $:.
	stream nextPutAll: (GlorpDatabaseType padToTwoDigits: aTimestamp seconds).
	aBoolean ifFalse: [^self].
	Dialect supportsMillisecondsInTimes ifFalse: [ ^self ].
	ms := aTimestamp milliseconds.
	ms = 0 ifTrue: [^self].
	stream nextPut: $..
	stream nextPutAll: (GlorpDatabaseType padToThreeDigits: ms).
]

{ #category : #'conversion - times' }
DatabasePlatform >> printTimestamp: aTimestamp on: aStream for: aType [
	aTimestamp isNil ifTrue: [aTimestamp glorpPrintSQLOn: aStream. ^self].

	aStream nextPut: $'; nextPutAll: aTimestamp printString; nextPut: $'.
]

{ #category : #'database - specific' }
DatabasePlatform >> queryWithUnsupportedOperationsEliminatedFrom: aQuery do: aBlock [
	"If aQuery has operations that we don't support, rewrite it to do them in terms of lower level operations. In particular, rewrite INTERSECT/EXCEPT operations into EXISTS clauses in a single query. Pass the new query to aBlock."
	^self.
]

{ #category : #types }
DatabasePlatform >> raw [
	^self blob.
]

{ #category : #'conversion - times' }
DatabasePlatform >> readDate: anObject for: aType [
	"format '2003-03-13"
	anObject isNil ifTrue: [^nil].
	anObject class == Date ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readDateFromStream: (ReadStream on: anObject) for: aType].
	^anObject asDate.
]

{ #category : #'conversion - times' }
DatabasePlatform >> readDateFromStream: aStream for: aType [
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Translate into GMT if we've got a timezone."
	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil

"
	|  years months days |
	years := (aStream upTo: $-) asNumber.
	months := (aStream upTo: $-) asNumber.
	days := (aStream upTo: $ ) asNumber.
	^Dialect newDateWithYears: years months: months days: days.
]

{ #category : #'conversion - times' }
DatabasePlatform >> readTime: anObject for: aType [
	"format 15:29:28.337-05  (timezone optional)"
	anObject isNil ifTrue: [^nil].
	anObject class == Time ifTrue: [^anObject].
	anObject isString ifTrue: [
		^self readTimeFromStream: (ReadStream on: anObject) for: aType].
	^anObject asTime.
]

{ #category : #'conversion - times' }
DatabasePlatform >> readTimeFromStream: aStream for: aType [
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Ignore timezones right now"
	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil

"
	| hours minutes seconds milliseconds timeZoneOffset millisecondAccumulator |
	hours := (aStream upTo: $:) asNumber.
	minutes := (aStream upTo: $:) asNumber.
	seconds := (aStream next: 2) asNumber.
	(aStream peek = $.) 
		ifTrue: [
			aStream next.
			millisecondAccumulator := WriteStream on: String new.
			[aStream atEnd not and: [aStream peek isDigit]] whileTrue: [
				millisecondAccumulator nextPut: aStream next].
			milliseconds := millisecondAccumulator contents asNumber]
		ifFalse: [milliseconds := 0].
	timeZoneOffset := aStream upToEnd.
	timeZoneOffset := Number readFrom: timeZoneOffset ifFail: [ 0 ].
	^Dialect newTimeWithHours: hours minutes: minutes seconds: seconds milliseconds: milliseconds.
	"^Dialect addSeconds: (timeZoneOffset * -1* 60 * 60) to: aTime."
]

{ #category : #'conversion - times' }
DatabasePlatform >> readTimestamp: anObject for: aType [
	"Seems like we get to do this ourselves, in a lowest common denominator kind of way. Translate into GMT if we've got a timezone."

	"assumes ISO format.
	self readTimestamp: '2003-03-03 15:29:28.337-05' for: nil.
	self readTimestamp: '2003-03-03 19:29:28.337-05' for: nil"

	anObject isNil ifTrue: [^nil].
	anObject class == Dialect timestampClass ifTrue: [^anObject].
	anObject isString
		ifTrue:
			[| stream |
			stream := ReadStream on: anObject.
			^self readTimestampFromStream: stream for: aType].
	^anObject asDateAndTime.
]

{ #category : #'conversion - times' }
DatabasePlatform >> readTimestampFromStream: aStream for: aType [

	| years months days hours minutes seconds millisecondAccumulator milliseconds timeZoneOffset |
	years := (aStream upTo: $-) asNumber.
	months := (aStream upTo: $-) asNumber.
	days := (aStream upTo: $ ) asNumber.
	hours := (aStream upTo: $:) asNumber.
	minutes := (aStream upTo: $:) asNumber.
	seconds := (aStream next: 2) asNumber.
	(aStream peek = $.) 
		ifTrue: [
			aStream next.
			millisecondAccumulator := WriteStream on: String new.
			[aStream atEnd not and: [aStream peek isDigit]] whileTrue: [
				millisecondAccumulator nextPut: aStream next].
			milliseconds := millisecondAccumulator contents asNumber]
		ifFalse: [milliseconds := 0].
	timeZoneOffset := Number readFrom: aStream upToEnd ifFail: [ 0 ].
	timeZoneOffset := timeZoneOffset * 60 * 60.
	^Dialect 
		newTimestampWithYears: years
		months: months
		days: days
		hours: hours
		minutes: minutes
		seconds: seconds
		milliseconds: milliseconds
		offset:timeZoneOffset.
]

{ #category : #testing }
DatabasePlatform >> requiresCastsForNullsInUnions [
	"If we have explicit nulls in a query which is unioned, do we need to cast them to the appropriate type in order to keep the database happy."
	^false.
]

{ #category : #constants }
DatabasePlatform >> requiresEscapeFor: aCharacter [
	^self charactersThatNeedEscaping includes: aCharacter.
]

{ #category : #constants }
DatabasePlatform >> requiresTransactionForTableOperations [
	"Return true if we need a transaction in order to do table creation, deletion, and so forth. Some databases require it. Others don't like it"
	^true.
]

{ #category : #constants }
DatabasePlatform >> reservedWords [
	reservedWords isNil ifTrue: [self initializeReservedWords].
	^reservedWords.
]

{ #category : #testing }
DatabasePlatform >> reusePreparedStatements [
	"The ordinary choice is to initialize the accessor to reuse statements whenever binding is being used."

	^true
]

{ #category : #types }
DatabasePlatform >> sequence [

	^self subclassResponsibility
]

{ #category : #types }
DatabasePlatform >> serial [
	self subclassResponsibility.
]

{ #category : #types }
DatabasePlatform >> serial: aNumber [
	^self serial increment: aNumber asNumber
]

{ #category : #types }
DatabasePlatform >> smallint [

	^self typeNamed: #smallint ifAbsentPut: [GlorpSmallIntType new].
]

{ #category : #'services columns' }
DatabasePlatform >> sqlStatementToCopyDataFromColumn: fromDatabaseField to: toDatabaseField [

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToCopyDataFromColumn: fromDatabaseField
		to: toDatabaseField
		on: stream.

	^ stream contents
]

{ #category : #'services columns' }
DatabasePlatform >> sqlStatementToCopyDataFromTable: fromDatabaseTable to: toDatabaseTable [

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToCopyDataFromTable: fromDatabaseTable
		to: toDatabaseTable
		on: stream.

	^ stream contents
]

{ #category : #'services tables' }
DatabasePlatform >> sqlStatementToListColumnsForTable: aTableName inSchema: schemaString [

	| stream |
	stream := WriteStream on: String new.
	self printSqlStatementToListColumnsInTable: aTableName inSchema: schemaString on: stream.
	^stream contents
]

{ #category : #'services tables' }
DatabasePlatform >> sqlStatementToListTablesInSchema: schemaString [

	| stream |
	stream := WriteStream on: String new.
	self printSqlStatementToListTablesInSchema: schemaString on: stream.
	^stream contents
]

{ #category : #'services columns' }
DatabasePlatform >> sqlStatementToPopulateColumn: aDatabaseField with: aValue [

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToPopulateColumn: aDatabaseField
		with: aValue
		on: stream.

	^ stream contents
]

{ #category : #'services columns' }
DatabasePlatform >> sqlStatementToRenameColumn: oldColumn to: newColumnName [

	| stream |

	stream := WriteStream on: String new.

	self
		printSqlStatementToRenameColumn: oldColumn
		to: newColumnName
		on: stream.

	^ stream contents
]

{ #category : #'services tables' }
DatabasePlatform >> sqlStatementToRenameTable: aDatabaseTable to: newTableName [

	| stream |

	stream := WriteStream on: String new.

	self printSqlStatementToRenameTable: aDatabaseTable to: newTableName on: stream.

	^ stream contents
]

{ #category : #'services tables' }
DatabasePlatform >> sqlStatementToTestExistenceOfTable: tableName inSchema: schemaString [

	| stream |
	stream := WriteStream on: String new.
	self printSqlStatementToTestExistenceOfTable: tableName inSchema: schemaString on: stream.
	^stream contents
]

{ #category : #constants }
DatabasePlatform >> sqlTextCurrentServerUTCTimestamp [

	self subclassResponsibility
]

{ #category : #constants }
DatabasePlatform >> sqlTextForBeginTransaction [
	"comment"

	^'BEGIN'
]

{ #category : #constants }
DatabasePlatform >> sqlTextForDEFAULT: defaultValue [
	"^<String>. Answer the column DEFAULT clause as a string with the given value.
	This is used in CREATE TABLE statements as part of each column specification."
	
	| strm |
	^defaultValue
		ifNotNil:
			[strm := String new writeStream.
			strm nextPutAll: 'DEFAULT '.
			defaultValue glorpPrintSQLOn: strm.
			strm contents]
		ifNil: ['']
]

{ #category : #constants }
DatabasePlatform >> sqlTextForNOTNULLAttributeConstraint [
	"^<String>"

	^'NOT NULL'
]

{ #category : #constants }
DatabasePlatform >> sqlTextForNOTNULLWithDefaultAttributeConstraint [
	"^<String>"

	^'NOT NULL WITH DEFAULT'
]

{ #category : #constants }
DatabasePlatform >> sqlTextForNOTUNIQUEAttributeConstraint [
	^''.
]

{ #category : #constants }
DatabasePlatform >> sqlTextForNULLAttributeConstraint [
	"^<String>"

	^'NULL'
]

{ #category : #constants }
DatabasePlatform >> sqlTextForUNIQUEAttributeConstraint [
	^'UNIQUE'.
]

{ #category : #constants }
DatabasePlatform >> sqlWildcardForMultipleCharacters [
	"^<String> This method returns the used wildcard string for multiple characters"
	
	^'%'
]

{ #category : #constants }
DatabasePlatform >> sqlWildcardForSingleCharacter [
	"^<String> This method returns the used wildcard string for single characters"
	
	^'_'
]

{ #category : #constants }
DatabasePlatform >> startColumnAddString [
	"The string we use as a prefix when adding a colum"
	^' COLUMN '.
]

{ #category : #'services columns' }
DatabasePlatform >> startColumnQuote [
	"Return the character used to start quoting the name of a column so that we can avoid conflicts with reserved names. ANSI says to use double quotes, so that's the default."
	^'"'.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> stringToByteArray: aString for: aType [

	| string |
	string := self unpadString: aString for: aType.
	^ string ifNil: [ nil ] ifNotNil: [
		  Dialect
			  convert: string
			  toByteArrayWithEncoding: self characterEncoding ]
]

{ #category : #'conversion - strings' }
DatabasePlatform >> stringToInteger: aString for: aType [
	| string |
	string := self unpadString: aString for: aType.
	^string isNil ifTrue: [nil] ifFalse: [string asNumber truncated].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> stringToStringConverter [
	^DelegatingDatabaseConverter
		named: #stringToString
		hostedBy: self
		fromStToDb: #padString:for:
		fromDbToSt: #unpadString:for:.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> stringToSymbol: aString for: aType [
	| string |
	string := self unpadString: aString for: aType.
	^string isNil ifTrue: [nil] ifFalse: [string asSymbol].
]

{ #category : #'conversion - strings' }
DatabasePlatform >> stringToTrimmedStringConverter [
	"Between 0.3.140.1 and 7.10 inclusive, Glorp routinely trimmed strings that were too long for fixed-length fields in the stringToString converter.  It no longer does this, but if a particular Mapping wants trimming (e.g. StoreProperty has a searchString summary field for its comment's text blob, so the longest initial length of text that can be written to the search field is always OK), then assign this converter to the Mapping in the descriptor."

	^DelegatingDatabaseConverter
		named: #stringToTrimmedString
		hostedBy: self
		fromStToDb: #padTrimmedString:for:
		fromDbToSt: #unpadString:for:
]

{ #category : #testing }
DatabasePlatform >> supportsANSIJoins [
	"Do we support the JOIN <tableName> USING <criteria> syntax. Currently hard-coded, but may also vary by database version"
	^false.
]

{ #category : #testing }
DatabasePlatform >> supportsAliasInCompoundQuery [
	"Return true if, when we have a subselect, we can (and/or must) alias the result with a table name. Access doesn't like the table name"
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsAlterTableForConstraints [

	^true
]

{ #category : #testing }
DatabasePlatform >> supportsArithmeticOperatorsOnDates [
	"Answer whether arithmetic operators such as + or - can be used on DATE like columns.
	Some platforms require the use of specific functions."
	
	^true
]

{ #category : #constants }
DatabasePlatform >> supportsAuthentication [
	^true
]

{ #category : #testing }
DatabasePlatform >> supportsBinding [
	"Return true if this platform supports binding parameters rather than printing them as strings into the SQL statement"
	^false.
]

{ #category : #testing }
DatabasePlatform >> supportsCaseInsensitiveLike [
	^false.
]

{ #category : #constants }
DatabasePlatform >> supportsConstraints [
	"Return true if we support integrity constraints. That is, foreign key, primary key or unique constraints."
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsCorrelatedSubqueriesInOrderBy [
	"Return true if this platform supports correlated subqueries in the ORDER BY clause."

	^true
]

{ #category : #testing }
DatabasePlatform >> supportsDecimalsOnAllNumerics [
	"Return true if a general 'numeric' type will allow numbers after the decimal place"
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsGroupWritingFor: aCommand [
	"Return true if this platform can do array binding or an equivalent for this command"
	^false.
]

{ #category : #testing }
DatabasePlatform >> supportsInformationSchema [
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsIntersect [
	"Do we support the INTERSECT or MINUS operations."
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsLimit [
	"Do we support anything analogous to the postgresql LIMIT, returning only the first N rows"
	^false.
]

{ #category : #constants }
DatabasePlatform >> supportsMillisecondsInTimes [
	self subclassResponsibility.
]

{ #category : #testing }
DatabasePlatform >> supportsMultipleOpenCursors [
	"Can this database support multiple open cursors at once"
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsOffset [
	"Do we support anything analogous to the postgresql OFFSET, skipping the first N rows"
	^false.
]

{ #category : #testing }
DatabasePlatform >> supportsRowCount [
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsSchemas [
	"Return true if this platform supports schemas. Access and SQLite 3 do not."

	^true
]

{ #category : #testing }
DatabasePlatform >> supportsSettingSequenceIncrement [
	"Return true if this platform can support creating a sequence with an increment other than 1."

	^false
]

{ #category : #testing }
DatabasePlatform >> supportsSingleQueryHorizontalInheritance [
	"Can this database support a single query for horizontal inheritance."
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsStringQueryOnBlobs [
	^true.
]

{ #category : #testing }
DatabasePlatform >> supportsTableOwners [
	"Return true if this platform supports table owners, i.e. expects table names of the form Bern.TW_* rather than just TW_* in its SQL."
"Access, Firebird and PostGreSQL do not, Oracle does, others I know not."

	^false
]

{ #category : #constants }
DatabasePlatform >> supportsVariableSizedNumerics [
	"Return true if this platform can support numbers with a varying size and number of decimal places. Access, notably, doesn't seem to be able to"
	^true.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> symbolToString: aSymbol for: aType [
	aSymbol isNil ifTrue: [^nil].
	^self padString: aSymbol asString for: aType.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> symbolToStringConverter [
	^DelegatingDatabaseConverter
		named: #symbolToString
		hostedBy: self
		fromStToDb: #symbolToString:for:
		fromDbToSt: #stringToSymbol:for:.
]

{ #category : #'services tables' }
DatabasePlatform >> tableNameFor: aStringRepresentingATableName [
	"Return the table name, as modified to be used in a database statement."
	^aStringRepresentingATableName.
]

{ #category : #types }
DatabasePlatform >> text [
	^self clob.
]

{ #category : #types }
DatabasePlatform >> time [
	self subclassResponsibility.
]

{ #category : #'conversion - times' }
DatabasePlatform >> timeConverter [
	^DelegatingDatabaseConverter
		named: #time
		hostedBy: self
		fromStToDb: #toTime:for:
		fromDbToSt: #readTime:for:.	"#printTime:for:"
]

{ #category : #types }
DatabasePlatform >> timestamp [
	self subclassResponsibility.
]

{ #category : #'conversion - times' }
DatabasePlatform >> timestampConverter [
	^DelegatingDatabaseConverter
		named: #timestamp
		hostedBy: self
		fromStToDb: #toTimestamp:for:
		fromDbToSt: #readTimestamp:for:.	"#printTimestamp:for:"
]

{ #category : #'conversion - times' }
DatabasePlatform >> timestampToDateConverter [
	^DelegatingDatabaseConverter
		named: #timestampToDate
		hostedBy: self
		fromStToDb: #toTimestamp:for:
		fromDbToSt: #readDate:for:.
]

{ #category : #'type converters' }
DatabasePlatform >> tinyint [
	^self number
]

{ #category : #'conversion - times' }
DatabasePlatform >> toByteaSQLString: aByteArray for: aType [
	^String streamContents: [ :s | 
		s nextPut: $\. 
		aByteArray printHexOn: s ]
]

{ #category : #'conversion - times' }
DatabasePlatform >> toDate: anObject for: aType [
	"SQL supports adding an integer to a date, meaning incrementing the date by that number of days, so we pass integer values here as well as dates."

	anObject isNil ifTrue: [^nil].
	anObject class = Date ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDate
]

{ #category : #'conversion - strings' }
DatabasePlatform >> toGlorpType: aGlorpType fromString: aString [
	"Return a Smalltalk instance of the type indicated by aGlorpType."
	
	| aClass |
	^aString
		ifNotNil:
			[aClass := aGlorpType impliedSmalltalkType.
			aClass readFrom: aString readStream]
]

{ #category : #'conversion - times' }
DatabasePlatform >> toTime: anObject for: aType [
	anObject isNil ifTrue: [^nil].
	anObject class = Time ifTrue: [^anObject].
	^anObject asTime.
]

{ #category : #'conversion - times' }
DatabasePlatform >> toTimestamp: anObject for: aType [
	"SQL supports adding an integer to a date, meaning incrementing the date by that number of days.  Oracle and SQLServer use Timestamp and Date as synonyms, so we pass integer values here as well as in #toDate:for:."

	anObject isNil ifTrue: [^nil].
	anObject class = Dialect timestampClass ifTrue: [^anObject].
	anObject isInteger ifTrue: [^anObject].
	^anObject asDateAndTime
]

{ #category : #'conversion - strings' }
DatabasePlatform >> trimString: aString for: aType [ 
	| trimmedString length excess |
	aType width isNil ifTrue: [^aString].
	self measuresStringFieldWidthsInBytes ifFalse: [
		^aString size > aType width ifTrue: [aString copyFrom: 1 to: aType width] ifFalse: [aString]].
	"If our characters are less than half the number of bytes it can hold, assume it will fit and don't try to do this"
	(aString size < (aType width // 2)) ifTrue: [^aString].
	"If we're doing defaults that don't map characters to multi-bytes, don't do this"
	(#(ascii default) includes: self characterEncoding) ifTrue: [
		^aString size > aType width ifTrue: [aString copyFrom: 1 to: aType width] ifFalse: [aString]].
	trimmedString := aString.
	[length := (Dialect convert: trimmedString toByteArrayWithEncoding: self characterEncoding) size.
	excess := length - aType width.
	excess > 0 
		"Try to be careful and trim as little as possible, while still keeping the number of steps reasonable for large excesses"
		ifTrue: [trimmedString := trimmedString copyFrom: 1 to: trimmedString size - ((excess // 2) max: 1)]
		ifFalse: [^trimmedString].
	true] whileTrue.
]

{ #category : #types }
DatabasePlatform >> typeNamed: aSymbol ifAbsentPut: aBlock [

	| type |
	type := self types at: aSymbol ifAbsentPut: [
		| newType |
		newType := aBlock value.
		newType platform: self.
		newType selector: aSymbol].
	type hasParameters ifTrue: [type := type copy].
	^type.
]

{ #category : #types }
DatabasePlatform >> typeWithDatabaseName: aString characterWidth: aNumber [
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	| baseType matchingTypes simpleTypes |
	matchingTypes := self typesWithValues values asArray select: [:each | each typeName asLowercase = aString asLowercase].
	matchingTypes isEmpty ifTrue: [
		Transcript cr; show: 'Cannot find type ', aString, ' using integer instead.'. matchingTypes := Array with: self integer].
	"We may get generated and non-generated both matching, e.g. inMemorySequence and int. Prefer the non-generated."
	simpleTypes := matchingTypes reject: [:each | each isGenerated].
	baseType := simpleTypes isEmpty ifTrue: [matchingTypes first] ifFalse: [simpleTypes first].
	^baseType hasWidth ifTrue: [baseType copy width: aNumber] ifFalse: [baseType].
]

{ #category : #types }
DatabasePlatform >> typeWithDatabaseName: aString characterWidth: aNumber extraInformation: anythingElse [
	"Return our type which matches the database name for the type. Assumes all variable width fields are strings right now."
	^self typeWithDatabaseName: aString characterWidth: aNumber.
]

{ #category : #types }
DatabasePlatform >> typeWithQueriedDatabaseDescription: row inflector: inflector [
	| type name dbType parameters isNullable defaultValue isPrimaryKey scale |
	name := row at: 1.
	dbType := row at: 2.
	parameters := row at: 3.
	isNullable := (row at: 4) = 1.
	defaultValue := row at: 5.
	isPrimaryKey := (row at: 6) = 1.
	scale := (row at: 9) ifNotNil: [(row at: 9) asInteger].
	type := (parameters 
				ifNil: [ | sel |
					sel := inflector accessor: dbType.
					(self respondsTo: sel) 
						ifTrue: [ self perform: sel asSymbol ]
						ifFalse: [ self perform: sel asLowercase asSymbol ]]
				ifNotNil: [ self
						perform: (inflector mutator: dbType)
						with: parameters ]).
			
			(name = 'created_at' and: [ dbType asLowercase beginsWith: 'timestamp' ]) 
				ifTrue: [ 
						type := 
							(self versionFieldFor: type) generatesOverExistingValues: false.
					].
				
			(name = 'updated_at' and: [ dbType asLowercase beginsWith: 'timestamp' ]) 
				ifTrue: [ 
						type := (self versionFieldFor: type) 
							generatesOverExistingValues: true.
					].
			
			(name = 'id' and: [isPrimaryKey and: [type isStringType]]) 
				ifTrue: [ 
					type := (self generatorFor: type 
						withBlock: [UUIDGenerator next asString]) 
					generatesOverExistingValues: false ].
				
			(name = 'id' and: [isPrimaryKey and: [type typeString = #uuid]]) 
				ifTrue: [ 
					type := (self generatorFor: type 
						withBlock: [UUIDGenerator next]) 
					generatesOverExistingValues: false ].
		(scale notNil and: [ scale asInteger notNil and: [scale asInteger > 0]]) ifTrue: [ type scale: scale  ].
	^type
]

{ #category : #types }
DatabasePlatform >> types [
	types == nil ifTrue: [types := IdentityDictionary new].
	^types.
]

{ #category : #'type helpers' }
DatabasePlatform >> typesWithValues [
	"Return our types list, but makes sure it has at least basic types in it"
	self varchar.
	self int4.
	self integer.
	self int.
	self number.
	self timestamp.
	self char.
	self blob.
	self clob.
	self raw.
	self serial.
	self text.
	^self types.
]

{ #category : #'conversion - strings' }
DatabasePlatform >> unpadString: aString for: aType [
	aString isNil ifTrue: [^nil].
	^aType isVariableWidth 
		ifTrue: [aString]
		ifFalse: [(ReadStream on: aString) upTo: self paddingCharacter]
]

{ #category : #testing }
DatabasePlatform >> useBinding [
	"Return true if we should use binding"

	self supportsBinding ifFalse: [^false].
	useBinding isNil ifTrue: [useBinding := self class useBindingIfSupported].
	^useBinding
]

{ #category : #testing }
DatabasePlatform >> useBinding: aBoolean [
	useBinding := aBoolean.
]

{ #category : #testing }
DatabasePlatform >> useMicrosoftOuterJoins [
	"Return true if we use the Microsoft x *= y syntax for outer joins"
	^false.
]

{ #category : #testing }
DatabasePlatform >> useOracleOuterJoins [
	"Return true if we use the old Oracle x = y (+) syntax for outer joins"
	^false.
]

{ #category : #testing }
DatabasePlatform >> usesArrayBindingRatherThanGroupWriting [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^self subclassResponsibility.
]

{ #category : #testing }
DatabasePlatform >> usesArrayBindingRatherThanGrouping [
	"Return true if we use array binding for grouped writes rather than printing the sql multiple times. Only applies if we support grouped writes"
	^self subclassResponsibility.
]

{ #category : #testing }
DatabasePlatform >> usesIdentityColumns [
	^false.
]

{ #category : #testing }
DatabasePlatform >> usesInformationSchema [

	^false
]

{ #category : #testing }
DatabasePlatform >> usesLengthNotEndPosInSubstring [
	"Glorp provides arguments start position and end position to SUBSTR by default but in some databases this function wants arguments (start) position and length."

	^false
]

{ #category : #constants }
DatabasePlatform >> usesNullForEmptyStrings [
	"Return true if this database is likely to use nil as an empty string value"
	^false.
]

{ #category : #constants }
DatabasePlatform >> usesNullForFalse [
	"Return true if this database is likely to use nil as an empty string value"
	^false.
]

{ #category : #testing }
DatabasePlatform >> usesPrimaryKeyUniqueConstraintNames [
	"When dropping/creating primary key constraints, do they have distinguished names."
	^true.
]

{ #category : #'services tables' }
DatabasePlatform >> validateTableName: tableNameString [
	" <Boolean> I return true, if the choosen tableNameString is valid for the platform"

 	^( tableNameString size <= self maximumLengthOfTableName ) 
			and: [ (self predefinedKeywords includes: tableNameString asLowercase) not ]
]

{ #category : #types }
DatabasePlatform >> varChar [
	^self varchar.
]

{ #category : #types }
DatabasePlatform >> varChar: anInt [

	^self varchar width: anInt asInteger.
]

{ #category : #types }
DatabasePlatform >> varbinary [
	^self subclassResponsibility.
]

{ #category : #types }
DatabasePlatform >> varbinary: anInteger [
	^self varbinary width: anInteger.
]

{ #category : #types }
DatabasePlatform >> varchar [
	^self subclassResponsibility.
]

{ #category : #types }
DatabasePlatform >> varchar: anInt [

	^self varchar width: anInt.
]

{ #category : #types }
DatabasePlatform >> versionFieldFor: aType [
	"Don't cache this, because we want to return different instances depending on aType"
	^(VersionType underlyingType: aType) generatesOverExistingValues: true; platform: self.
]

{ #category : #accessing }
DatabasePlatform >> vwConnectionClass [
	^self isODBCPlatform 
			ifTrue: [self vwODBCConnectionClass]
			ifFalse: [self vwEXDIConnectionClass]
]

{ #category : #accessing }
DatabasePlatform >> vwODBCConnectionClass [
	"Prefer Threaded over not if nothing is loaded, but use whatever is loaded if there is anything"

	'ODBCThreadedConnection' asQualifiedReference ifDefinedDo:
		[:class | ^class].
	'ODBCConnection' asQualifiedReference ifDefinedDo:
		[:class | ^class].		
	^'ODBCThreadedConnection' asQualifiedReference valueIfUndefinedLoadFrom: 'ODBCThapiEXDI'
]

{ #category : #'services constraints' }
DatabasePlatform >> writeConstraintToDrop: aConstraint onStream: aStream [
	aStream
		nextPutAll: 'CONSTRAINT ';
		nextPutAll: aConstraint name.
]
