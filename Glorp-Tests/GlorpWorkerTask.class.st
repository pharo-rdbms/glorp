Class {
	#name : #GlorpWorkerTask,
	#superclass : #Object,
	#instVars : [
		'id',
		'description'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpWorkerTask class >> exampleTaskKeys [
	| keys |
	keys := OrderedCollection new.
	keys add: 'Clean'.
	keys add: 'Yard'.
	keys add: 'Shop'.
	keys add: 'Errands'.
	keys add: 'Relax'.
	^keys
]

{ #category : #'as yet unclassified' }
GlorpWorkerTask class >> exampleTasks [
	| tasks |
	tasks := OrderedCollection new.
	tasks add: (GlorpWorkerTask new id: 1; description: 'Clean house'; yourself).
	tasks add: (GlorpWorkerTask new id: 2; description: 'Trim hedges  and mow lawn'; yourself).
	tasks add: (GlorpWorkerTask new id: 3; description: 'Grocery shopping'; yourself).
	tasks add: (GlorpWorkerTask new id: 4; description: 'Run errands'; yourself).
	tasks add: (GlorpWorkerTask new id: 5; description: 'Take a break'; yourself).
	^tasks
]

{ #category : #'test-comparing' }
GlorpWorkerTask >> <= aTask [ 
	
	^(self > aTask) not
]

{ #category : #comparing }
GlorpWorkerTask >> = aTask [

	self class = aTask class ifFalse:  [ ^false ].
	self id = aTask id ifFalse: [^false].
	self description = aTask description ifFalse: [^false].
	^true
]

{ #category : #comparing }
GlorpWorkerTask >> > aTask [

	^self id > aTask id
]

{ #category : #accessing }
GlorpWorkerTask >> description [

	^description
]

{ #category : #accessing }
GlorpWorkerTask >> description: anObject [

	description := anObject
]

{ #category : #accessing }
GlorpWorkerTask >> id [

	^id
]

{ #category : #accessing }
GlorpWorkerTask >> id: anObject [

	id := anObject
]

{ #category : #printing }
GlorpWorkerTask >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: id printString;
		nextPutAll: ', ';
		nextPutAll: (description ifNil: [description printString]);
		nextPut: $);
		cr
]
