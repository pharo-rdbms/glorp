"
This represents the data to be written out to a row. Database rows are normally stored in a rowmap, keyed according to their table and the object that did the primary writes to them. We expect that that's only one object, although embedded values are an exception to that.

Instance Variables:

	table	<DatabaseTable>	The table holding the data
	contents	<IdentityDictionary>	Holds the fields with their values, indirectly through FieldValueWrapper instances.
	shouldBeWritten	<Boolean>	Normally true, but can be set false to suppress writing of a particular row. Used with embedded value mappings, where we create their row, unify it with the parent row, and suppress writing of the original row.
	owner	<Object>	The primary object that wrote into this row, would also be the key into the rowmap.
	forDeletion <Boolean> Is this row to be deleted or written.
	status <Symbol> Used for topological sort to determine write order. We keep a symbol indicating the ""visited"" status of the row while doing the sort. This doesn't separate the sort from the row, using each row directly as a node in the graph. This is less general, but uses less memory than other alternatives.
	parent <DatabaseRow> Also used during sorting. Keep track of our parent node.
	oldVersion <DatabaseRow> The old version of us. Used if we increment a version field to keep track of what its value was before.
	generated <Boolean> True if we have already had field with generated types generated in the preWrite phase. This is needed because we generate all sequences before doing any writes. But if we use an explicit writeRow: operation, then we want to make sure that generated values are generated. And some generated types write over what was there before (e.g. optimistic lock fields). So we need a way of knowing if generation has already been done. Note that this doesn't apply if using post-write sequence generation (i.e. identity columns) because then it's all after the write. This makes certain things not work as well, but that's what you get for using identity columns.
	
"
Class {
	#name : #DatabaseRow,
	#superclass : #Object,
	#instVars : [
		'table',
		'contents',
		'shouldBeWritten',
		'owner',
		'forDeletion',
		'status',
		'oldVersion',
		'generated',
		'parent',
		'operation'
	],
	#classInstVars : [
		'missingFieldIndicator',
		'emptySlot'
	],
	#category : #'Glorp-Database'
}

{ #category : #'*Glorp' }
DatabaseRow class >> emptySlot [
	emptySlot == nil ifTrue: [emptySlot := Object new].
	^emptySlot.
]

{ #category : #'*Glorp' }
DatabaseRow class >> missingFieldIndicator [
	missingFieldIndicator == nil ifTrue: [missingFieldIndicator := Object new].
	^missingFieldIndicator.
]

{ #category : #'*Glorp' }
DatabaseRow class >> new [

	^super new initialize.
]

{ #category : #'*Glorp' }
DatabaseRow class >> newForTable: aTable [

	^self new table: aTable.
]

{ #category : #'*Glorp' }
DatabaseRow class >> newForTable: aTable withOwner: anObject [

	^self new table: aTable; owner: anObject.
]

{ #category : #comparing }
DatabaseRow >> = aRow [

	self class == aRow class ifFalse: [ ^ false ].
	^ self equals: aRow
]

{ #category : #accessing }
DatabaseRow >> at: aField [

	^ self at: aField ifAbsent: [ self error: 'missing field' ]
]

{ #category : #private }
DatabaseRow >> at: aField forcePut: aValue [
	"Write the value. If there's a previous value, overwrite it. Use with extreme caution."

	| wrapper |
	aValue isGlorpExpression ifTrue: [self error: 'cannot store expressions in rows'].
	aField table == self table ifFalse: [self error: 'Invalid table'].
	wrapper := self contentsAt: aField ifAbsentPut: [FieldValueWrapper new].
	wrapper privateSetContents: aValue.
	^ wrapper
]

{ #category : #accessing }
DatabaseRow >> at: aField ifAbsent: absentBlock [

	^ (self wrapperAt: aField ifAbsent: [^absentBlock value]) contents
]

{ #category : #accessing }
DatabaseRow >> at: aField ifAbsentPut: absentBlock [

	| old |
	old := contents at: aField position.
	old == self class emptySlot
		ifTrue: absentBlock
		ifFalse: [^old contents]
]

{ #category : #accessing }
DatabaseRow >> at: aField put: aValue [

	"For generated fields, we expect the real value to be provided later by the database, so don't write a nil value"

	| wrapper |
"	aValue isGlorpExpression ifTrue: [self error: 'cannot store expressions in rows']."
	aField table == self table ifFalse: [self error: 'Invalid table'].
	wrapper := self contentsAt: aField ifAbsentPut: [FieldValueWrapper new].
	(aValue isNil and: [aField isGenerated]) ifFalse: [wrapper contents: aValue].
	wrapper isNowContainedBy: self and: aField.
	^wrapper
]

{ #category : #accessing }
DatabaseRow >> atFieldNamed: aString [

	| field |
	field := table fieldNamed: aString.
	^ self at: field
]

{ #category : #accessing }
DatabaseRow >> atFieldNamed: aString ifAbsent: aBlock [

	| field |
	field := table fieldNamed: aString ifAbsent: aBlock.
	^ self at: field ifAbsent: aBlock
]

{ #category : #accessing }
DatabaseRow >> atFieldNamed: aString put: anObject [

	| field |
	field := table fieldNamed: aString.
	^ self at: field put: anObject
]

{ #category : #accessing }
DatabaseRow >> contentsAt: aField ifAbsentPut: absentBlock [

	| old newValue |
	old := contents at: aField position.
	^ old == self class emptySlot
		  ifTrue: [
			  newValue := absentBlock value.
			  contents at: aField position put: newValue.
			  newValue ]
		  ifFalse: [ old ]
]

{ #category : #accessing }
DatabaseRow >> doesNotUnderstand: aMessage [

	^ self
		  atFieldNamed: aMessage selector asString
		  ifAbsent: [ super doesNotUnderstand: aMessage ]
]

{ #category : #printing }
DatabaseRow >> equalityStringForField: aDatabaseField [

	| stream |
	stream := WriteStream on: (String new: 50).
	self printEqualityStringForField: aDatabaseField on: stream.
	^ stream contents
]

{ #category : #testing }
DatabaseRow >> equals: aRow [

	self forDeletion = aRow forDeletion ifFalse: [ ^ false ].
	self fieldsAndValuesDo:
			[:eachField :eachWrapper |
			| otherValue |
			otherValue := aRow at: eachField ifAbsent: [ self class missingFieldIndicator ].
			eachWrapper = otherValue ifFalse: [ ^false ]].
	^true
]

{ #category : #querying }
DatabaseRow >> expectsToGetValueFor: aField [
	"Are we constrained to a field which is presumably going to get a value, which for the moment must mean it's a serial type. This is primarily required for identity column databases, because in other cases we will pre-allocate sequence numbers, and this should never come up"
	| wrapper innerWrappers testBlock containing |
	wrapper := self wrapperAt: aField ifAbsent: [^false].
	innerWrappers := wrapper allInnerWrappers.
	testBlock := [:eachField | (eachField ~~ aField and: [eachField type isSerial]) ifTrue: [^true]].
	(Array with: wrapper), innerWrappers do: [:eachWrapper |
		containing := eachWrapper containedBy.
		containing glorpIsCollection
			ifTrue: [containing keysDo: testBlock]
			ifFalse: [testBlock value: containing key]].
	^false
]

{ #category : #enumerating }
DatabaseRow >> fieldValuesDo: aBlock [

	contents do: [ :each |
		each == self class emptySlot ifFalse: [ aBlock value: each ] ]
]

{ #category : #accessing }
DatabaseRow >> fields [

	^ self table fields select: [ :each | self includesField: each ]
]

{ #category : #initialization }
DatabaseRow >> fieldsAndValidValuesDo: aBlock [
	"If iterating over fields and values, we include wrappers with no value assigned yet. This might or might not be what we want. This one just iterates over ones with actual values"
	self isEmpty ifTrue: [^self].
	table fields do: [:each |  | value |
		value := self at: each ifAbsent: [self class missingFieldIndicator].
		value == self class missingFieldIndicator ifFalse: [
			aBlock value: each value: value]]
]

{ #category : #initialization }
DatabaseRow >> fieldsAndValuesDo: aBlock [

	table isNil ifTrue: [ ^ self ].
	table fields do: [ :each |
		aBlock
			value: each
			value:
			(self at: each ifAbsent: [ self class missingFieldIndicator ]) ]
]

{ #category : #enumerating }
DatabaseRow >> fieldsDo: aBlock [

	1 to: contents size do: [ :i |
		| value |
		value := contents at: i.
		value == self class emptySlot ifFalse: [
			aBlock value: (self table fields at: i) ] ]
]

{ #category : #printing }
DatabaseRow >> fieldsNeedingUpdate [
	"Return a list of the fields that are different from the previous version (if we know what that was)"

	| result |
	oldVersion isNil ifTrue: [ ^ self nonPrimaryKeyFields ].
	result := OrderedCollection new: contents size.
	self fieldsDo: [ :each |
		each isPrimaryKey ifFalse: [
			(oldVersion at: each ifAbsent: [ self class missingFieldIndicator ])
			= (self at: each) ifFalse: [ result add: each ] ] ].
	^ result
]

{ #category : #accessing }
DatabaseRow >> forDeletion [

	^ forDeletion
]

{ #category : #accessing }
DatabaseRow >> forDeletion: aBoolean [

	forDeletion := aBoolean
]

{ #category : #printing }
DatabaseRow >> hasOldVersion [

	^ oldVersion notNil
]

{ #category : #querying }
DatabaseRow >> hasValueFor: aField [

	^ (self wrapperAt: aField ifAbsent: [ ^ false ]) hasValue
]

{ #category : #testing }
DatabaseRow >> hash [

	| basic |
	basic := self table hash.
	self fieldsAndValuesDo: [ :eachField :eachValue |
		basic := basic bitXor: eachField hash.
		basic := basic bitXor: eachValue hash ].
	^ basic
]

{ #category : #accessing }
DatabaseRow >> includesField: aField [

	^ (contents at: aField position) ~~ self class emptySlot
]

{ #category : #initialization }
DatabaseRow >> initialize [

	shouldBeWritten := true.
	forDeletion := false.
	generated := false
]

{ #category : #testing }
DatabaseRow >> isEmpty [

	| empty |
	contents isNil ifTrue: [ ^ true ].
	empty := self class emptySlot.
	contents do: [ :each | each == empty ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #enumerating }
DatabaseRow >> keysAndValuesDo: aBlock [

	1 to: contents size do: [ :i |
		| value |
		value := contents at: i.
		value == self class emptySlot ifFalse: [
			aBlock value: (self table fields at: i) value: value contents ] ]
]

{ #category : #accessing }
DatabaseRow >> lockKeyFields [

	^ table lockKeyFields
]

{ #category : #sequencing }
DatabaseRow >> needsValueFromSequence: aSequence [

	self table fields do: [ :each |
		((self shouldGenerateValueFor: each) and: [
			 each type sequence == aSequence ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
DatabaseRow >> nonGeneratedFields [
	"Return a list of our fields that are not generated"

	| result |
	result := OrderedCollection new: contents size.
	self table fields do: [ :field |
		field isGenerated not ifTrue: [ result add: field ] ].
	^ result
]

{ #category : #accessing }
DatabaseRow >> nonGeneratedFieldsWithValues [
	"Return a list of our fields that a) are not generated or b) have values. That is, exclude values we expect the database to generate"

	| result |
	result := OrderedCollection new: contents size.
	self fieldsAndValidValuesDo: [ :field :value |
		(value notNil or: [ field isGenerated not ]) ifTrue: [
			result add: field ] ].
	^ result
]

{ #category : #accessing }
DatabaseRow >> nonPrimaryKeyFields [

	| result |
	result := OrderedCollection new: contents size.
	self fieldsDo: [ :field |
		field isPrimaryKey ifFalse: [ result add: field ] ].
	^ result
]

{ #category : #accessing }
DatabaseRow >> numberOfFields [

	^ contents inject: 0 into: [ :sum :each |
		  sum + (each == self class emptySlot
			   ifTrue: [ 0 ]
			   ifFalse: [ 1 ]) ]
]

{ #category : #accessing }
DatabaseRow >> oldVersionAt: aField ifAbsent: aBlock [

	oldVersion isNil ifTrue: [ ^ aBlock value ].
	^ oldVersion at: aField ifAbsent: aBlock
]

{ #category : #accessing }
DatabaseRow >> owner [

	^ owner
]

{ #category : #accessing }
DatabaseRow >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
DatabaseRow >> parent [

	^ parent
]

{ #category : #accessing }
DatabaseRow >> parent: aDatabaseRow [

	parent := aDatabaseRow
]

{ #category : #sequencing }
DatabaseRow >> postWriteAssignSequencesUsing: anAccessor [

	self table fields do: [:each |
		(self hasValueFor: each) ifFalse: [
			each type postWriteAssignSequenceValueFor: each in: self using: anAccessor]]
]

{ #category : #sequencing }
DatabaseRow >> preWriteAssignSequencesUsing: aSession [
	"Skip if we've already been generated"

	generated ifTrue: [^self].
	self table fields do:
			[:each |
			(self shouldGenerateValueFor: each in: aSession)
				ifTrue:
					[each type
						preWriteAssignSequenceValueFor: each
						in: self
						using: (aSession isNil ifTrue: [nil] ifFalse: [aSession accessor])]].
	generated := true
]

{ #category : #accessing }
DatabaseRow >> primaryKey [

	self table primaryKeyFields isEmpty ifTrue: [^nil].
	^self table hasCompositePrimaryKey
		ifTrue: [
			self table primaryKeyFields
				collect: [:each | 	self at: each]]
		ifFalse: [self at: self table primaryKeyFields first ifAbsent: [nil]]
]

{ #category : #printing }
DatabaseRow >> printEqualityStringForField: aDatabaseField on: aCommand [
	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."

	aCommand nextPutAll:
		(aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	self printValueOfField: aDatabaseField on: aCommand
]

{ #category : #printing }
DatabaseRow >> printEqualityTemplateForField: aDatabaseField on: aCommand [

	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."
	| bind |
	aCommand nextPutAll: (aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	bind := aCommand canBind: (self at: aDatabaseField ifAbsent: [nil]) to: aDatabaseField type.
	bind
		ifTrue: [aCommand nextPutAll: '?']
		ifFalse: [self printValueOfField: aDatabaseField on: aCommand]
]

{ #category : #printing }
DatabaseRow >> printEqualityTemplateForField: aDatabaseField on: aCommand withBinding: aBoolean [

	"Get around PostgreSQL bug.  Qualified names cannot appear in SET expression."
	aCommand nextPutAll: (aDatabaseField platform nameForColumn: aDatabaseField name).
	aCommand nextPutAll: ' = '.
	aBoolean
		ifTrue: [aCommand nextPutAll: '?']
		ifFalse: [self printValueOfField: aDatabaseField on: aCommand]
]

{ #category : #printing }
DatabaseRow >> printFieldNamesOn: aWriteStream [

	GlorpHelper 
		do: [:each | aWriteStream nextPutAll: each name]
		for: self table fields
		separatedBy: [aWriteStream nextPutAll: ',']
]

{ #category : #printing }
DatabaseRow >> printLockEqualityForField: aDatabaseField on: aStream [

	| expression |
	expression := ((BaseExpression new getTable: aDatabaseField table)
		               getField: aDatabaseField)
		              get: #=
		              withArguments:
		              (Array with: (oldVersion at: aDatabaseField)).
	expression printSQLOn: aStream withParameters: #(  )
]

{ #category : #printing }
DatabaseRow >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '(' , ((table isNil or: [table name isNil]) ifTrue: [''] ifFalse: [table name]),  ')'.
	aStream cr.
	self fieldsAndValuesDo: [:eachField :eachWrapper |
		aStream nextPutAll: '    '.
		eachField printOn: aStream.
		aStream nextPutAll: '->'.
		eachWrapper printOn: aStream.
		aStream cr.]
]

{ #category : #printing }
DatabaseRow >> printPrimaryKeyStringOn: aStream [
	"If there is no primary key (i.e. this is a link table) use all the values that we have"

	| fields |
	fields := table primaryKeyFields isEmpty
		ifTrue: [self fields]
		ifFalse: [table primaryKeyFields].
	GlorpHelper
		do:  [:eachField |
			self printEqualityStringForField: eachField on: aStream]
		for: fields
		separatedBy: [aStream nextPutAll: ' AND ']
]

{ #category : #printing }
DatabaseRow >> printPrimaryKeyTemplateOn: aStream [
	"If there is no primary key (i.e. this is a link table) use all the values that we have"
	| fields |
	fields := table primaryKeyFields isEmpty
		ifTrue: [self fields]
		ifFalse: [table primaryKeyFields].
	GlorpHelper
		do:  [:eachField |
			self printEqualityTemplateForField: eachField on: aStream]
		for: fields
		separatedBy: [aStream nextPutAll: ' AND ']
]

{ #category : #printing }
DatabaseRow >> printValueOfField: aDatabaseField on: aWriteStream [

	aDatabaseField type print: (self at: aDatabaseField ifAbsent: [nil]) on: aWriteStream
]

{ #category : #relationships }
DatabaseRow >> relatedRowsIn: aRowMap [

	| relatedRows |
	relatedRows := OrderedCollection new.
	self table foreignKeyConstraints
		do:
			[:eachConstraint | relatedRows addAll: (eachConstraint rowsRelatedTo: self)].
	^relatedRows.
]

{ #category : #querying }
DatabaseRow >> shouldBeWritten [

	table isNil ifTrue: [ ^ shouldBeWritten ].
	^ shouldBeWritten and: [ table shouldBeWritten ]
]

{ #category : #configuring }
DatabaseRow >> shouldBeWritten: aBoolean [

	shouldBeWritten := aBoolean
]

{ #category : #sequencing }
DatabaseRow >> shouldGenerateValueFor: aField [

	^ self shouldGenerateValueFor: aField in: nil
]

{ #category : #sequencing }
DatabaseRow >> shouldGenerateValueFor: aField in: aSession [
	| isInsert |
	aField isGenerated ifFalse: [^false].
	aField type generatesOverExistingValues ifTrue: [^true].
	"For those that don't write over existing values, only update them if this is an insert. Otherwise we can't tell the difference between an empty column and one which we're just not updating in this unit of work. This requires the session, but the session may be nil - if so, default to true, because that usage is just for reserving sequence numbers, and it's better to err on the side of too many."
	isInsert := aSession isNil ifTrue: [true] ifFalse: [aSession shouldInsert: self].
	^isInsert and: [(self hasValueFor: aField) not].
]

{ #category : #accessing }
DatabaseRow >> status [

	^ status
]

{ #category : #accessing }
DatabaseRow >> status: aSymbol [

	status := aSymbol
]

{ #category : #accessing }
DatabaseRow >> table [
	"Private - Answer the value of the receiver's ''table'' instance variable."

	^ table
]

{ #category : #configuring }
DatabaseRow >> table: aDatabaseTable [

	table := aDatabaseTable.
	contents := Array new: aDatabaseTable fields size.
	contents atAllPut: self class emptySlot
]

{ #category : #api }
DatabaseRow >> unifyField: eachSourceField withField: eachTargetField inRow: targetRow [
	| sourceWrapper targetWrapper |
	sourceWrapper := self wrapperAt: eachSourceField ifAbsent: [nil].
	targetWrapper := targetRow wrapperAt: eachTargetField ifAbsent: [nil].
	sourceWrapper isNil
		ifTrue:
			[targetWrapper isNil
				ifTrue:
					[targetWrapper := FieldValueWrapper new.
					targetRow wrapperAt: eachTargetField put: targetWrapper].
			^self wrapperAt: eachSourceField put: targetWrapper].
	targetWrapper isNil ifTrue: [^targetRow wrapperAt: eachTargetField put: sourceWrapper].
	sourceWrapper unifyWith: targetWrapper.
]

{ #category : #accessing }
DatabaseRow >> values [

	| result |
	result := OrderedCollection new.
	self keysAndValuesDo: [ :key :value | result add: value ].
	^ result
]

{ #category : #configuring }
DatabaseRow >> withAllFieldsIn: aRow [
	"aRow represents our original state. Make sure that we have all the fields in aRow, using nil values for any that are missing. This is needed if, e.g. we have been removed from a 1-many relationship, so we don't get a value generated for our foreign key, but we should still write it as a nil. We have to distinguish this from the case of a value that simply hasn't changed."

	aRow isEmpty ifTrue: [^self].
	oldVersion := aRow.
	self numberOfFields = table fields size ifTrue: [^self].
	aRow fieldsAndValidValuesDo:
			[:eachField :eachValue |
			(self includesField: eachField) ifFalse: [self at: eachField put: nil]].
	^ self
]

{ #category : #accessing }
DatabaseRow >> wrapperAt: aField [

	^ self wrapperAt: aField ifAbsent: [ self error: 'Field not found' ]
]

{ #category : #accessing }
DatabaseRow >> wrapperAt: aField ifAbsent: aBlock [

	| thing |
	contents isNil ifTrue: [^aBlock value].
	thing := contents at: aField position.
	^thing == self class emptySlot ifTrue: aBlock ifFalse: [thing]
]

{ #category : #accessing }
DatabaseRow >> wrapperAt: aField put: aWrapper [

	| old |
	old := contents at: aField position.
	old == aWrapper ifTrue: [ ^ self ].
	contents at: aField position put: aWrapper.
	aWrapper isNowContainedBy: self and: aField
]
