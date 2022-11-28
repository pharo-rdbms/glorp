Class {
	#name : #GlorpRowDifferencingTest,
	#superclass : #GlorpDatabaseBasedTest,
	#instVars : [
		'session',
		'currentObject',
		'currentObjectRowMap',
		'correspondenceMap',
		'differenceMap',
		'mementoObject',
		'mementoObjectRowMap'
	],
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpRowDifferencingTest >> addRowsFor: object to: rowMap [ 
	| descriptor |
	descriptor := system descriptorFor: object class.
	descriptor createRowsFor: object in: rowMap.
]

{ #category : #tests }
GlorpRowDifferencingTest >> computeDifference [
	currentObjectRowMap := self generateRowMapFor: currentObject.
	correspondenceMap := self correspond: currentObject to: mementoObject.
	mementoObjectRowMap := self generateMementoRowMapFor: mementoObject withCorrespondenceMap: correspondenceMap.
	differenceMap := currentObjectRowMap differenceFrom: mementoObjectRowMap.
]

{ #category : #support }
GlorpRowDifferencingTest >> correspond: person1 to: person2 [ 
	| correspondanceMap |
	correspondanceMap := IdentityDictionary new.
	correspondanceMap at: person1 put: person2.
	person1 address notNil ifTrue: 
		[correspondanceMap at: person1 address put: person2 address.
		"Now fix it up so this actually looks like a real memento"
		person2 address: person1 address].
	^correspondanceMap
]

{ #category : #support }
GlorpRowDifferencingTest >> generateMementoRowMapFor: person withCorrespondenceMap: aDictionary [
	| rowMap |
	rowMap := RowMapForMementos withCorrespondenceMap: aDictionary.
	self addRowsFor: person to: rowMap.
	(person address notNil and: [(aDictionary at: person address ifAbsent: [nil]) notNil]) ifTrue: [self addRowsFor: (aDictionary at: person address) to: rowMap].
	^rowMap
]

{ #category : #support }
GlorpRowDifferencingTest >> generateRowMapFor: person [ 
	| rowMap |
	rowMap := RowMap new.
	self addRowsFor: person to: rowMap.
	person address notNil ifTrue: [self addRowsFor: person address to: rowMap].
	^rowMap
]

{ #category : #support }
GlorpRowDifferencingTest >> setUp [
	super setUp.
	session := GlorpSessionResource current newSession.
	system := session system.
	session beginUnitOfWork.
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromAnotherObject [
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example2.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromSameObjectWithAddedComponent [
"	Commenting these out because I think the setup is just wrong.
currentObject := Person example1.
	mementoObject := Person example1WithNoAddress.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1"
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromSameObjectWithChangedAttribute [
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1WithDifferentName.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromSameObjectWithChangedComponent [
	"Commenting these out because I think the setup is just wrong"
	"currentObject := Person example1.
	mementoObject := Person example1WithDifferentAddress.

	currentObjectRowMap := self generateRowMapFor: currentObject."

	"Before changes occur, all original objects are registered with the unit of work.  
		To mimic that, the original person's address needs to be added to current (after changes) "
"	self addRowsFor: mementoObject address to: currentObjectRowMap.
	correspondenceMap := self correspond: currentObject to: mementoObject.
	correspondenceMap at: mementoObject address put: mementoObject address.
	correspondenceMap removeKey: currentObject address.
	mementoObjectRowMap := self generateMementoRowMapFor: mementoObject withCorrespondenceMap: correspondenceMap.
	differenceMap := currentObjectRowMap differenceFrom: mementoObjectRowMap.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1"
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromSameObjectWithChangedComponentAttribute [
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1WithChangedAddress.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1
]

{ #category : #tests }
GlorpRowDifferencingTest >> testDifferenceFromSameObjectWithDeletedComponent [
	"Commenting these out because I think the setup is just wrong"
"	currentObject := Person example1WithNoAddress.
	mementoObject := Person example1.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1"
]

{ #category : #tests }
GlorpRowDifferencingTest >> testEquality [
	| addressRow1 addressRow2 |
	addressRow1 := session system exampleAddressRow.
	addressRow2 := session system exampleAddressRowWithDifferentStreet.
	self assert: (addressRow1 equals: addressRow1).
	self assert: (addressRow1 equals: addressRow2) not.
]

{ #category : #tests }
GlorpRowDifferencingTest >> testNoDifference2 [
	| |
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 0.
]
