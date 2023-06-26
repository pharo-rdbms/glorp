Class {
	#name : #GlorpCommandTest,
	#superclass : #TestCase,
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #tests }
GlorpCommandTest >> testFieldsToUpdate [

	| command system row old bookTable session |
	session := GlorpLockingDescriptorSystem sessionForLogin: (Login new database: OraclePlatform new).
	system := session system.
	bookTable := system tableNamed: 'BOOK'.
	row := DatabaseRow newForTable: bookTable.
	old := DatabaseRow newForTable: bookTable.
	old at: (bookTable fieldNamed: 'ID') put: 6.
	old at: (bookTable fieldNamed: 'TITLE') put: 'ABook'.
	old at: (bookTable fieldNamed: 'DESCRIPTION') put: 'Stuff'.
	old at: (bookTable fieldNamed: 'COPIES_IN_STOCK') put: 3.
	old at: (bookTable fieldNamed: 'VERSION') put: 2.

	row at: (bookTable fieldNamed: 'ID') put: 6.
	row at: (bookTable fieldNamed: 'TITLE') put: 'ABook'.
	row at: (bookTable fieldNamed: 'DESCRIPTION') put: 'Stuff'.
	row at: (bookTable fieldNamed: 'COPIES_IN_STOCK') put: 4.
	row at: (bookTable fieldNamed: 'VERSION') put: 2.
	row withAllFieldsIn: old.
	command := UpdateCommand forRows: (Array with: row) useBinding: false session: session.
	self assert: command shouldUpdateOnlyChangedFields.
	self assert: command singleRowBoundFields size equals: 2.
	self assert: command singleRowBindings isEmpty.
	command useBinding: true.
	self deny: command shouldUpdateOnlyChangedFields.
	self assert: command singleRowBoundFields size equals: 5.
	"The lock field is bound at the end"
	self assert: command singleRowBindings size equals: 6
]

{ #category : #tests }
GlorpCommandTest >> testSplittingInserts1 [

	| rows command subCommands |
	rows := Array with: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size equals: 1.
	self assert: subCommands first allRows size equals: 1.
	self assert: subCommands first allRows first == rows first
]

{ #category : #tests }
GlorpCommandTest >> testSplittingInserts1000 [

	| rows command subCommands |
	rows := (Array new: 1000) atAllPut: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size equals: 1.
	self assert: subCommands first allRows size equals: 1000.
	self assert: subCommands first allRows first == rows first
]

{ #category : #tests }
GlorpCommandTest >> testSplittingInserts1001 [
	| rows command subCommands |
	rows := (Array new: 1001) atAllPut: DatabaseRow new.
	rows at: rows size put: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size equals: 2.
	self assert: subCommands first allRows size equals: 1000.
	self assert: subCommands first allRows first == rows first.
	self assert: subCommands last allRows size equals: 1.
	self assert:subCommands last allRows first == rows last.
]

{ #category : #tests }
GlorpCommandTest >> testSplittingInserts1003 [

	| rows command subCommands |
	rows := (Array new: 1003) atAllPut: DatabaseRow new.
	rows at: rows size put: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size equals: 2.
	self assert: subCommands first allRows size = 1000.
	self assert: subCommands first allRows first == rows first.
	self assert: subCommands last allRows size equals: 3.
	self assert:subCommands last allRows last == rows last.
	self assert: subCommands last allRows first == rows first
]

{ #category : #tests }
GlorpCommandTest >> testSplittingInserts2 [

	| rows command subCommands |
	rows := Array with: DatabaseRow new with: DatabaseRow new.
	command := InsertCommand forRows: rows useBinding: false session: nil.
	subCommands := command subCommands.
	self assert: subCommands size equals: 1.
	self assert: subCommands first allRows size equals: 2.
	self assert: subCommands first allRows first == rows first.
	self assert: subCommands first allRows last == rows last.
]
