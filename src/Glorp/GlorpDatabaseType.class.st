"
This is an abstract superclass for objects representing types in the database. Each one will correspond to a particular simple type that we can store and retrieve from the database. e.g. int, varchar, and so on. For types that are variable sizes, different instances may represent, e.g. varchar(5) vs. varchar(20). While the classes may be reused across different databases, a database platform is expected to be able to return the types that it knows about as instances of these clasess. So you can send #varchar to OraclePlatform and get back one of these.

Subclasses must implement the following messages:
	exdi specific
		exdiType

Instance Variables
	platform	<DatabasePlatform>	The platform that owns us.
	typeString	<String>	Our name in the database.
	selector <Symbol> The name of the message we can send to the platform to get ourselves or an equivalent type back again.


"
Class {
	#name : #GlorpDatabaseType,
	#superclass : #Object,
	#instVars : [
		'platform',
		'selector',
		'typeString'
	],
	#category : #'Glorp-Types'
}

{ #category : #'as yet unclassified' }
GlorpDatabaseType class >> instance [

	^super new
]

{ #category : #testing }
GlorpDatabaseType class >> isAbstract [

	^ self == GlorpDatabaseType
]

{ #category : #'as yet unclassified' }
GlorpDatabaseType class >> new [
	^super new initialize.
]

{ #category : #'as yet unclassified' }
GlorpDatabaseType class >> padToThreeDigits: anInteger [

	| string |
	string := anInteger truncated printString.
	string size = 3 ifTrue: [^string].
	string size = 2 ifTrue: [^'0', string].
	string size = 1 ifTrue: [^'00', string].
	^string
]

{ #category : #'as yet unclassified' }
GlorpDatabaseType class >> padToTwoDigits: anInteger [

	| string |
	string := anInteger truncated printString.
	^string size = 1 ifTrue: ['0', string] ifFalse: [string].
]

{ #category : #comparing }
GlorpDatabaseType >> = aType [
	^self basicEquals: aType.
]

{ #category : #comparing }
GlorpDatabaseType >> basicEquals: aType [
	self class == aType class ifFalse: [^false].
	self platform == aType platform ifFalse: [^false].
	self typeString = aType typeString ifFalse: [^false].
	^true.
]

{ #category : #converting }
GlorpDatabaseType >> converterForStType: aClass [

	^self platform nullConverter.
]

{ #category : #testing }
GlorpDatabaseType >> generatesOverExistingValues [
	"Do we generate our value even if there's alread one present in the field"

	^false.
]

{ #category : #SQL }
GlorpDatabaseType >> glorpPrintSQLOn: aCommand [
	aCommand nextPutAll: self typeString.
]

{ #category : #SQL }
GlorpDatabaseType >> glorpPrintSelectSQLOn: aCommand [
	self printSelectSQLOn: aCommand withParameters: #().
]

{ #category : #testing }
GlorpDatabaseType >> hasParameters [
	"Return true if this has modifiable parameters. That is, when we return one of these, should we return a copy rather than trying to save space be re-using instances"
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> hasSequence [
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> hasWidth [
	"Return true if this type has a width attribute - basically meaning it's a string or LOB type. Note that this is different from the isVariableWidth test, which tells us if a field has fixed vs. varying width. So a CHAR field hasWidth=>true, but isVariableWidth=>false, while a VARCHAR field hasWidth=>true isVariableWidth=>false, and a NUMBER has both false."
	^false.
]

{ #category : #comparing }
GlorpDatabaseType >> hash [
	^self platform hash bitXor: self typeString hash
]

{ #category : #converting }
GlorpDatabaseType >> impliedSmalltalkType [
	"Return the Smalltalk type which most commonly corresponds to our database type. By default, Object if we don't have any more specific information."
	^Object.
]

{ #category : #initialize }
GlorpDatabaseType >> initialize [
]

{ #category : #initialize }
GlorpDatabaseType >> initializeForField: aDatabaseField in: aDescriptorSystem [
]

{ #category : #testing }
GlorpDatabaseType >> isGenerated [

	^false
]

{ #category : #testing }
GlorpDatabaseType >> isIdentityColumn [
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> isIntegerType [
	"Return true if the type of values this stores are strings"
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> isSerial [
	"answer if this is a database-generated primary key column"

	^false
]

{ #category : #testing }
GlorpDatabaseType >> isStringType [
	"Return true if the type of values this stores are strings"
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> isVariable [
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> isVariableWidth [
	"Return true if this type allows varying length data within a particular instance. e.g., this is true for a varchar, but false for a fixed size character field"
	^false.
]

{ #category : #SQL }
GlorpDatabaseType >> platform [

	^platform
]

{ #category : #SQL }
GlorpDatabaseType >> platform: aDatabasePlatform [

	platform := aDatabasePlatform.
]

{ #category : #SQL }
GlorpDatabaseType >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow [
]

{ #category : #SQL }
GlorpDatabaseType >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: aSession [
]

{ #category : #SQL }
GlorpDatabaseType >> preWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [
	aDatabaseField defaultValue isNil ifTrue: [^self].
	(aDatabaseRow hasValueFor: aDatabaseField) ifTrue: [^self].
	"Default values will not write if this field is constrained to a primary key generator"
	(aDatabaseRow expectsToGetValueFor: aDatabaseField) ifTrue: [^self].
	aDatabaseRow at: aDatabaseField put: (aDatabaseField defaultValue).
]

{ #category : #accessing }
GlorpDatabaseType >> precision: anInteger [

	^self error: ((self class name asString), ' is not a variable precision type.')
]

{ #category : #SQL }
GlorpDatabaseType >> print: aValue on: aStream [
	aValue glorpPrintSQLOn: aStream.
]

{ #category : #SQL }
GlorpDatabaseType >> printCollection: aCollection on: aStream [
	aCollection glorpPrintSQLOn: aStream for: self.
]

{ #category : #SQL }
GlorpDatabaseType >> printNullCastOn: aStream [
	"Some platforms, eg., DB2, need to cast NULL for collections, as in
	SELECT ... WHERE ... IN (CAST(NULL AS type))."
	
	| expr |
	expr := FunctionExpression
		for: #cast:
		withArguments: (Array with: (ConstantExpression for: self))
		basedOn: (ConstantExpression for: nil).
	expr printSelectSQLOn: aStream withParameters: #()
]

{ #category : #SQL }
GlorpDatabaseType >> printSelectSQLOn: aCommand withParameters: aDictionary [
	aCommand nextPutAll: self typeString.
]

{ #category : #accessing }
GlorpDatabaseType >> queryType [
	"If we can't pass this type in as an argument to a query (e.g. a blob) then return a type we can use instead"
	^self.
]

{ #category : #testing }
GlorpDatabaseType >> requiresCast [
	^false.
]

{ #category : #testing }
GlorpDatabaseType >> requiresConvertToVarbinary [
	"This is a hack for testing against SQL Server"
	^false.
]

{ #category : #accessing }
GlorpDatabaseType >> scale: anInteger [

	^self error: ((self class name asString), ' is not a variable scale type.')
]

{ #category : #accessing }
GlorpDatabaseType >> selector [
	^selector
]

{ #category : #accessing }
GlorpDatabaseType >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #accessing }
GlorpDatabaseType >> sequence [
	^nil
]

{ #category : #accessing }
GlorpDatabaseType >> size: anInteger [

	^self error: ((self class name asString), ' is not a variable sized type.')
]

{ #category : #SQL }
GlorpDatabaseType >> typeName [
	"An alias that can be used to print the non-parameterized name"
	^typeString.
]

{ #category : #SQL }
GlorpDatabaseType >> typeString [

	^typeString.
]

{ #category : #accessing }
GlorpDatabaseType >> typeString: aString [

	typeString := aString
]

{ #category : #accessing }
GlorpDatabaseType >> underlyingType [
	^self.
]
