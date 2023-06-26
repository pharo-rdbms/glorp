Class {
	#name : #GlorpTaskedWorker,
	#superclass : #GlorpWorkingStiff,
	#instVars : [
		'tasks'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #examples }
GlorpTaskedWorker class >> example1 [
	<sampleInstance>

	| workers tasks keys names |
	tasks := GlorpWorkerTask exampleTasks.
	keys := GlorpWorkerTask exampleTaskKeys.
	names := #('Jim' 'Tom' 'Lori' 'George' 'Jenny').
	workers := OrderedCollection new.
	1 to: 5 do: [:i|
		workers add: ((GlorpTaskedWorker new)
				id: i;
				name: (names at: i);
				addTask: (tasks at: i) key: (keys at: i);
				yourself)].
	^workers
]

{ #category : #comparing }
GlorpTaskedWorker >> = aWorker [
	super = aWorker ifFalse: [^false].
	(tasks keys asSortedCollection = aWorker tasks keys asSortedCollection) ifFalse: [^false].
	(tasks asSortedCollection = aWorker tasks asSortedCollection) ifFalse: [^false].
	^true
]

{ #category : #actions }
GlorpTaskedWorker >> addTask: aTask key: aString [
	tasks at: aString put: aTask
]

{ #category : #initialization }
GlorpTaskedWorker >> initialize [

	super initialize.
	tasks := Dictionary new
]

{ #category : #accessing }
GlorpTaskedWorker >> isSimilarToWorker: aWorker [
	"Compare values, ignoring #ids, which are assigned by the database."

	| myKeys otherKeys myTask otherTask |
	myKeys := self tasks keys asSortedCollection.
	otherKeys := aWorker tasks keys asSortedCollection.
	myKeys = otherKeys ifFalse: [^false].
	myKeys do: [:aKey|
		myTask := self tasks at: aKey.
		otherTask := aWorker tasks at: aKey.
		myTask description = otherTask description ifFalse: [^false]].
	^true
]

{ #category : #printing }
GlorpTaskedWorker >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: id printString;
		nextPutAll: ', ';
		nextPutAll: (name ifNil: [name printString]);
		nextPut: $);
		cr
]

{ #category : #actions }
GlorpTaskedWorker >> removeTaskAtKey: aString [
	tasks removeKey: aString ifAbsent: [self error: 'Task not found.']
]

{ #category : #accessing }
GlorpTaskedWorker >> tasks [

	^tasks
]

{ #category : #accessing }
GlorpTaskedWorker >> tasks: anObject [

	tasks := anObject
]
