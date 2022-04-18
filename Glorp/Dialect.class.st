"
This is an encapsulation layer for dialect differences between Smalltalk. It has a variety of class messages that do different things depending which dialect we are running on.
"
Class {
	#name : #Dialect,
	#superclass : #Object,
	#classInstVars : [
		'dialectName',
		'timestampClass',
		'lookedUpNames',
		'isNamespaceAware',
		'lastSystemTime',
		'lastServerTime'
	],
	#category : #'Glorp-Exceptions'
}

{ #category : #dates }
Dialect class >> addSeconds: seconds to: aTime [

	^ aTime addSeconds: seconds
]

{ #category : #'general portability' }
Dialect class >> argumentCountFor: aBlock [

	^aBlock argumentCount
]

{ #category : #numbers }
Dialect class >> coerceToDoublePrecisionFloat: aNumber [

	^aNumber asFloat
]

{ #category : #files }
Dialect class >> contentsOfFileNamed: aString [
	"Given a text file name, read its contents"

	| stream contents |
	stream := (Dialect smalltalkAt: #MultiByteFileStream) oldFileNamed: aString.
	[ contents := stream contents ]
		ensure: [ stream close ].
	^ contents
]

{ #category : #strings }
Dialect class >> convert: aString toByteArrayWithEncoding: encodingName [
	^ aString convertToEncoding: encodingName
]

{ #category : #strings }
Dialect class >> convert: aByteArray toStringWithEncoding: encodingName [
	^ aByteArray asString convertToEncoding: encodingName
]

{ #category : #dates }
Dialect class >> dateAndTimeClass [

	^ self smalltalkAt: #DateAndTime
]

{ #category : #private }
Dialect class >> determineDialect [
	^ dialectName := #Pharo
]

{ #category : #'*Glorp' }
Dialect class >> dialectName [

	dialectName isNil ifTrue: [self determineDialect.].
	^ dialectName
]

{ #category : #'*Glorp' }
Dialect class >> dialectVersion [
	"Glorp does not need to consult dialect versions at the moment.  This method is currently made available purely as a precaution, in case Glorp experimenters should wish to add a dialect-version-requiring feature."

	^self dialectName, SystemVersion current imageVersionString
]

{ #category : #numbers }
Dialect class >> doesPrecisionOf: aNumber equal: aPrecision [
	^aNumber class == self fixedPointClass and: [aNumber scale = aPrecision]
]

{ #category : #numbers }
Dialect class >> doublePrecisionFloatClass [

	^ Float
]

{ #category : #'*Glorp' }
Dialect class >> error [

	^Error
]

{ #category : #'general portability' }
Dialect class >> fitHashIntoSmallInteger: aNumber [
	^aNumber
]

{ #category : #'class lookup' }
Dialect class >> fixedPointClass [
	^ScaledDecimal 
]

{ #category : #'general portability' }
Dialect class >> garbageCollect [

	 ^ Smalltalk garbageCollect
]

{ #category : #'forward references' }
Dialect class >> glorpConstantExpressionClass [
	^ConstantExpression
]

{ #category : #'general portability' }
Dialect class >> identitySetClass [
	^IdentitySet 
]

{ #category : #reflection }
Dialect class >> instVarNameFor: aName [

	^ aName asString
]

{ #category : #'general portability' }
Dialect class >> isBlock: anObject [
	
	^anObject isBlock
]

{ #category : #numbers }
Dialect class >> isFloatingPoint: aNumber [
	^aNumber class == self doublePrecisionFloatClass or: [aNumber class == Float]
]

{ #category : #identifying }
Dialect class >> isHeadless [

	^ Smalltalk isHeadless
]

{ #category : #'general portability' }
Dialect class >> isNamespaceAware [
	isNamespaceAware isNil
		ifTrue: [ isNamespaceAware := false ].
	^ isNamespaceAware
]

{ #category : #identifying }
Dialect class >> isPharo [

	^ self dialectName = #Pharo
]

{ #category : #numbers }
Dialect class >> isScaleOf: aNumber lessThanOrEqualTo: aScale [
	^aNumber class == self fixedPointClass and: [aNumber scale <= aScale].
]

{ #category : #'class lookup' }
Dialect class >> lookedUpNames [
	lookedUpNames isNil ifTrue: [lookedUpNames := IdentityDictionary new].
	^lookedUpNames.
]

{ #category : #'class lookup' }
Dialect class >> lookupClassNamed: aString inContextOf: aClass [
	"Look up the class by name, but use the namespace of the class. Mostly useful if we're trying to guess from unqualified names in dialects with namespaces."
	^self lookupClassNamed: aString inContextOf: aClass ifAbsent: [nil]
]

{ #category : #'class lookup' }
Dialect class >> lookupClassNamed: aString inContextOf: aClass ifAbsent: aBlock [
	"Look up the class by name, but use the namespace of the class. Mostly useful if we're trying to guess from unqualified names in dialects with namespaces."
	
	^self smalltalkAt: aString ifAbsent: aBlock
]

{ #category : #collections }
Dialect class >> needsCollectionMementoFor: aCollection [
	^true
]

{ #category : #dates }
Dialect class >> newDateWithYears: years months: months days: days [

	^Date newDay: days month: months year: years
]

{ #category : #'general portability' }
Dialect class >> newIdentitySet [
	^self identitySetClass new
]

{ #category : #dates }
Dialect class >> newTimeWithHours: hours minutes: minutes seconds: seconds milliseconds: milliseconds [

	^ Time fromSeconds: hours * 60 * 60 + (minutes * 60) + (milliseconds / 10000)
]

{ #category : #dates }
Dialect class >> newTimestampFromDate: aDate time: aTime [

	^self timestampClass date: aDate time: aTime
]

{ #category : #dates }
Dialect class >> newTimestampWithYears: years
	months: months
	days: days
	hours: hours
	minutes: minutes
	seconds: seconds
	milliseconds: millis
	offset: offset [

	^self timestampClass 
			year: years
			month: months
			day: days
			hour: hours
			minute: minutes
			second: seconds
			nanoSecond: millis * 1000000
			offset: (Duration seconds: offset)

]

{ #category : #'general portability' }
Dialect class >> quitTheImage [
	"Quit the entire image"

	^(self smalltalkAt: #SmalltalkImage) current snapshot: false andQuit: true
]

{ #category : #dates }
Dialect class >> readFixedPointFrom: aString [

	^ Number readFrom: (ReadStream on: aString , 's')
]

{ #category : #private }
Dialect class >> reset [
	"self reset"
	lookedUpNames := nil.
	timestampClass := nil.
	dialectName := nil
]

{ #category : #reflection }
Dialect class >> selectorsFor: aClass do: aBlock [

	^aClass methodDict keysDo: aBlock
]

{ #category : #numbers }
Dialect class >> singlePrecisionFloatClass [
	^ Float
]

{ #category : #numbers }
Dialect class >> smallDoublePrecisionFloatClass [

	^self doublePrecisionFloatClass
]

{ #category : #'class lookup' }
Dialect class >> smalltalkAssociationAt: aName [

	^ self smalltalkAssociationAt: aName ifAbsent: [self error: 'element not found']
]

{ #category : #'class lookup' }
Dialect class >> smalltalkAssociationAt: aName ifAbsent: aBlock [

	^ Smalltalk associationAt: aName asSymbol ifAbsent: aBlock
]

{ #category : #'class lookup' }
Dialect class >> smalltalkAt: aName [

	^ self smalltalkAt: aName ifAbsent: [self error: 'element not found']
]

{ #category : #'class lookup' }
Dialect class >> smalltalkAt: aName ifAbsent: aBlock [
	"We may look these names up a lot, so cache them in a small, local dictionary"
	| cached value symbol |
	symbol := aName asSymbol.
	cached := self lookedUpNames at: symbol ifAbsent: [nil].
	cached isNil ifFalse: [
		(cached isBehavior and: [cached isObsolete]) ifFalse: [^cached]].
	value := Smalltalk at: symbol ifAbsent: aBlock.
	self lookedUpNames
		at: symbol
		put: value.
	^value
]

{ #category : #dates }
Dialect class >> supportsMillisecondsInTimeStamps [

	^true
]

{ #category : #dates }
Dialect class >> supportsMillisecondsInTimes [

	^true
]

{ #category : #dates }
Dialect class >> timeOffsetFromGMT [

	^ 0
]

{ #category : #dates }
Dialect class >> timestampClass [

	timestampClass == nil ifFalse: [^ timestampClass].
	^ timestampClass := self smalltalkAt: #DateAndTime
]

{ #category : #dates }
Dialect class >> timestampNow [

	^ self timestampClass current
	
]

{ #category : #dates }
Dialect class >> timestampNowUTC [

	^self timestampClass now asUTC
]

{ #category : #'general portability' }
Dialect class >> tokensBasedOn: aString in: stringToTokenize [

	^ stringToTokenize findTokens: aString
]

{ #category : #'general portability' }
Dialect class >> totalSeconds [

	^ Time totalSeconds
]

{ #category : #'class lookup' }
Dialect class >> unbindableClassNames [

	^ #()
]

{ #category : #'general portability' }
Dialect class >> weakValueDictionaryClass [

	^self smalltalkAt: #WeakValueDictionary
]
