"
This is a Glorp wrapper for a database cursor. It has stream-like behaviour, which is implemented by getting rows from the underlying cursor and constructing the objects as required. All queries go through one of these streams, although in the default case they will get all the results out of it (at which point the cursor will be closed) and then return them in another kind of collection. But it's possible to use one of these as the return type, in which case you can make use of the open cursor to incrementally get results.

Instance Variables:
	builders	<(Collection of: ObjectBuilder)>	The ObjectBuilders used to construct the objects we return out of the rows.
	buildersThatReturnResults	<(SequenceableCollection of: ElementBuilder)>	
	command	<DatabaseCommand>	The command that was executed to give us this cursor.
	cursor	<>	The underlying database cursor. Class varies by dialect. We deal with the lack of polymorphism by indirecting all cursor operations through the accessor.
	databaseAccessor	<DatabaseAccessor>	The accessor that the command was executed against.
	mightHaveDuplicateRows	<Boolean>	May this stream have duplicate rows? This can happen, for example, if we do a join that causes some sub-section of the row to be duplicated. If so, we need to check for this and remove duplicates from the object stream as we go. This forces us to peek ahead.
	peekBuffer	<Object>	The peek buffer (holding an object) that we use when peeking ahead.
	rawPeekBuffer	<>	The peek buffer (holding a row) that we use when peeking ahead. We need to buffer at both levels.
	statement	<GlorpPreparedStatement>	The actual prepared statement that the command ran in order to get our results.


"
Class {
	#name : 'GlorpCursoredStream',
	#superclass : 'Stream',
	#instVars : [
		'command',
		'cursor',
		'mightHaveDuplicateRows',
		'builders',
		'buildersThatReturnResults',
		'databaseAccessor',
		'peekBuffer',
		'rawPeekBuffer',
		'statement'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'instance creation' }
GlorpCursoredStream class >> on: aStream [
	^self basicNew cursor: aStream
]

{ #category : 'instance creation' }
GlorpCursoredStream class >> on: aStream accessor: aDatabaseAccessor [
	^(self on: aStream)
		databaseAccessor: aDatabaseAccessor
]

{ #category : 'instance creation' }
GlorpCursoredStream class >> on: aStream for: aCommand [
	^(self on: aStream)
		command: aCommand
]

{ #category : 'instance creation' }
GlorpCursoredStream class >> on: aStream for: aCommand accessor: aDatabaseAccessor [
	^(self on: aStream)
		command: aCommand;
		databaseAccessor: aDatabaseAccessor
]

{ #category : 'testing' }
GlorpCursoredStream >> accessor [
	^databaseAccessor
]

{ #category : 'testing' }
GlorpCursoredStream >> atEnd [
	"Release ourselves fairly aggressively when we hit the end"
	| accessor |
	peekBuffer isNil ifFalse: [^false].
	rawPeekBuffer isNil ifFalse: [^false].
	cursor isNil ifTrue: [^true].
	"For test purposes, fabricate an accessor if we don't have one, it's not really needed for a non-db stream"
	accessor := self accessor isNil ifTrue: [DatabaseAccessor new] ifFalse: [self accessor].
	^([accessor isCursorAtEnd: cursor] on: Dialect error do: [:ex | databaseAccessor handleError: ex for: command])
		ifTrue:
			[self release.
			true]
		ifFalse: [	"We have to do this, because VA won't answer true to atEnd until we've read past end"
			self rawPeek isNil].
]

{ #category : 'building objects' }
GlorpCursoredStream >> buildObjectsForRow: aRow [

	self query isNil ifTrue: [ ^ aRow ].
	builders do: [ :each |
		each findInstanceForRow: aRow proxyType: self query proxyType ].
	builders do: [ :each | each buildObjectFrom: aRow ].
	builders do: [ :each |
		each
			sendPostFetchValidateIn: self session
			OnFailureDo: [ each instance: nil ] ].
	builders do: [ :each | each knitResultIn: self ].
	builders do: [ :each |
		self session sendPostFetchEventTo: each instance ].
	^ self buildersThatReturnResults size = 1
		  ifTrue: [
		  self buildersThatReturnResults first returnValueIn: self ]
		  ifFalse: [
			  self buildersThatReturnResults collect: [ :each |
				  each returnValueIn: self ] ]
]

{ #category : 'building objects' }
GlorpCursoredStream >> buildersThatReturnResults [
	buildersThatReturnResults isNil ifTrue: [
		buildersThatReturnResults := OrderedCollection new.
		builders
			do: [:each | 	
				| expression shouldBeRetrieved |
				"For some bizarre reason, includes: fails on ObjectStudio for this"
				expression := each expression.
				shouldBeRetrieved := (self query tracing retrievalExpressions detect: [:foo |
					foo == expression] ifNone: [nil]) notNil.
				(shouldBeRetrieved and: [
					(buildersThatReturnResults anySatisfy: [:eachBuilder | eachBuilder expression == expression]) not])
						ifTrue: [buildersThatReturnResults add: each]].
		buildersThatReturnResults := buildersThatReturnResults asArray].
	^buildersThatReturnResults.
]

{ #category : 'iterating' }
GlorpCursoredStream >> collect: aBlock [ 
	| newStream |
	newStream := WriteStream on: (Array new: 100).
	[self atEnd] whileFalse: [newStream nextPut: (aBlock value: self next)].
	^newStream contents
]

{ #category : 'building objects' }
GlorpCursoredStream >> collectionTypeFor: aCollectionType [
	"Make sure that we can reasonably return aCollectionType. If not, default to something we can"

	aCollectionType class == GlorpDictionaryDescription ifFalse: [^aCollectionType].
	self buildersThatReturnResults size = 1 ifTrue: [^aCollectionType].
	^Array
]

{ #category : 'accessing' }
GlorpCursoredStream >> command [
	^command
]

{ #category : 'accessing' }
GlorpCursoredStream >> command: aDatabaseCommand [
	command := aDatabaseCommand.
	aDatabaseCommand isNil ifTrue: [^self].
	aDatabaseCommand query isNil ifTrue: [^self].
	databaseAccessor := aDatabaseCommand query session accessor.
	builders := self query copyOfBuilders.
	builders do: [:each | each cursor: self]
]

{ #category : 'accessing' }
GlorpCursoredStream >> contents [
	self shouldNotImplement.
]

{ #category : 'accessing' }
GlorpCursoredStream >> cursor [
	^cursor
]

{ #category : 'accessing' }
GlorpCursoredStream >> cursor: aStream [
	cursor := aStream
]

{ #category : 'accessing' }
GlorpCursoredStream >> databaseAccessor: aDatabaseAccessor [
	databaseAccessor := aDatabaseAccessor
]

{ #category : 'iterating' }
GlorpCursoredStream >> detect: aBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	^self detect: aBlock ifNone: [self error: 'not found']
]

{ #category : 'iterating' }
GlorpCursoredStream >> detect: aBlock ifNone: exceptionBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument.
	Answer the first element for which aBlock evaluates to true."

	self do: [:each | (aBlock value: each) ifTrue: [^each]].
	^exceptionBlock value
]

{ #category : 'iterating' }
GlorpCursoredStream >> do: aBlock [ 
	"Evaluate aBlock for each of the elements of the receiver."

	[self atEnd]
		whileFalse: [aBlock value: self next]
]

{ #category : 'building objects' }
GlorpCursoredStream >> elementBuilderFor: anExpression [ 
	^builders detect: [:each | each expression == anExpression] ifNone: [nil]
]

{ #category : 'accessing' }
GlorpCursoredStream >> flush [
	^self
]

{ #category : 'building objects' }
GlorpCursoredStream >> hasCompleteAnswerFor: objects [
	| nextAnswer |
	self atEnd ifTrue: [^true].
	self mightHaveDuplicateRows ifFalse: [^true].
	nextAnswer := self peek.
	^objects ~= nextAnswer
]

{ #category : 'initializing' }
GlorpCursoredStream >> initialize [
]

{ #category : 'testing' }
GlorpCursoredStream >> isReadable [
	^true
]

{ #category : 'testing' }
GlorpCursoredStream >> isWritable [
	^false
]

{ #category : 'accessing' }
GlorpCursoredStream >> mightHaveDuplicateRows [
	mightHaveDuplicateRows isNil ifTrue: [mightHaveDuplicateRows := self query isNil ifTrue: [false] ifFalse: [self query mightHaveDuplicateRows]].
	^mightHaveDuplicateRows.
]

{ #category : 'building objects' }
GlorpCursoredStream >> newCollectionOfSize: aSize for: aCollectionType [
	"Make sure that we can reasonably return aCollectionType. If not, default to something we can"
	| theType |
	theType := self collectionTypeFor: aCollectionType.
	^theType isBehavior ifTrue: [theType new: aSize] ifFalse: [theType copyEmpty: aSize]
]

{ #category : 'accessing' }
GlorpCursoredStream >> next [
	| answer session |
	self atEnd ifTrue: [^nil].
	session := self session.

	[self atEnd ifTrue: [^nil].
	answer := self nextAnswer.
	answer == nil] 
		whileTrue.

	[self hasCompleteAnswerFor: answer] whileFalse: [self nextAnswer].
	session == nil ifFalse: [session privateRegisterAsOld: answer].
	^answer.
]

{ #category : 'accessing' }
GlorpCursoredStream >> next: anInteger [

	^super next: anInteger
]

{ #category : 'building objects' }
GlorpCursoredStream >> nextAnswer [
	| result |
	peekBuffer isNil ifFalse: [
		result := peekBuffer.
		peekBuffer := nil.
		^result].
	^self nextAnswerFromUnderlyingCursor.
]

{ #category : 'building objects' }
GlorpCursoredStream >> nextAnswerFromUnderlyingCursor [
	| objects |
	rawPeekBuffer isNil ifTrue: [rawPeekBuffer := cursor next].
	rawPeekBuffer isNil ifTrue: [^nil].
	objects := self buildObjectsForRow: rawPeekBuffer.
	rawPeekBuffer := nil.
	^objects.
]

{ #category : 'building objects' }
GlorpCursoredStream >> nextObjectFrom: aRow [
	| objects |
	objects := self buildObjectsForRow: aRow.
	self mightHaveDuplicateRows ifFalse: [
		self registerInstances.
		^objects]
]

{ #category : 'accessing' }
GlorpCursoredStream >> nextPut: anObject [
	self shouldNotImplement
]

{ #category : 'building objects' }
GlorpCursoredStream >> objectBuilderFor: anExpression [ 
	"Return the builder for this expression, but only those that directly build compound objects. Most importantly, exclude dictionary builders"
	^builders detect: [:each | 
		each buildsObjects and: [each expression == anExpression]] ifNone: [nil]
]

{ #category : 'accessing' }
GlorpCursoredStream >> peek [
	peekBuffer = nil ifFalse: [^peekBuffer].
	peekBuffer := self nextAnswer.
	^peekBuffer.
]

{ #category : 'accessing' }
GlorpCursoredStream >> privateGetBuilders [
	^builders
]

{ #category : 'accessing' }
GlorpCursoredStream >> query [
	command isNil ifTrue: [^nil].
	^command query.
]

{ #category : 'accessing' }
GlorpCursoredStream >> query: x [
]

{ #category : 'private' }
GlorpCursoredStream >> rawPeek [
	"Peek at the underlying rows, but don't build objects"
	rawPeekBuffer isNil ifFalse: [^rawPeekBuffer].
	rawPeekBuffer := cursor next.
	^rawPeekBuffer.
]

{ #category : 'building objects' }
GlorpCursoredStream >> registerInstances [
	self session isNil ifTrue: [^self].
	builders do: [:each | self session register: each instance].
]

{ #category : 'initializing' }
GlorpCursoredStream >> release [
	super release.
	self releaseCursor.
	cursor := nil.
	rawPeekBuffer := nil.
	peekBuffer := nil.
	statement isNil
		ifFalse:
			[databaseAccessor reusePreparedStatements
				ifTrue: [statement busy: false]
				ifFalse: [statement release].
			statement := nil].
	databaseAccessor := nil.
]

{ #category : 'initializing' }
GlorpCursoredStream >> releaseCursor [
	
	self accessor isNil
		ifFalse:
			[self accessor releaseCursor: cursor in: statement.
			self accessor completedCommand: command].
]

{ #category : 'accessing' }
GlorpCursoredStream >> rowCount [
	^ self cursor rowCount
]

{ #category : 'debugging' }
GlorpCursoredStream >> rows [
	"This will extract all the rows and replace the internal stream with a regular stream on the rows. This is useful for debugging, but in real use rather destroys the purpose of the cursored stream"
	| rows |
	rows := cursor upToEnd.
	self releaseCursor.
	cursor := rows readStream.
	^rows
]

{ #category : 'accessing' }
GlorpCursoredStream >> session [
	^self query isNil ifTrue: [nil] ifFalse: [self query session]
]

{ #category : 'accessing' }
GlorpCursoredStream >> statement [
	^statement
]

{ #category : 'accessing' }
GlorpCursoredStream >> statement: aGlorpPreparedStatement [
	statement := aGlorpPreparedStatement
]

{ #category : 'accessing' }
GlorpCursoredStream >> upToEnd [
	| result |
	result := WriteStream on: (Array new: 100).
	[self atEnd] whileFalse: [
			| nextValue |
			"Stupid VA's cursors don't deal with atEnd or isEmpty nicely, so check for nil"
			nextValue := self next.
			nextValue == nil ifFalse: [	result nextPut: nextValue]].
	^result contents
]
