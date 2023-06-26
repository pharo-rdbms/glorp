Class {
	#name : #GlorpWorker,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'pendingJobs',
		'finishedJobs',
		'priorityJobs'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #accessing }
GlorpWorker >> finishedJobs [
	^finishedJobs
]

{ #category : #accessing }
GlorpWorker >> finishedJobs: anObject [
	finishedJobs := anObject
]

{ #category : #accessing }
GlorpWorker >> id [
	^id
]

{ #category : #accessing }
GlorpWorker >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GlorpWorker >> initialize [

	super initialize.
	pendingJobs := OrderedCollection new.
	finishedJobs := OrderedCollection new.
	priorityJobs := OrderedCollection new
]

{ #category : #accessing }
GlorpWorker >> name [
	^name
]

{ #category : #accessing }
GlorpWorker >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GlorpWorker >> pendingJobs [
	^pendingJobs
]

{ #category : #accessing }
GlorpWorker >> pendingJobs: anObject [
	pendingJobs := anObject
]

{ #category : #accessing }
GlorpWorker >> priorityJobs [
	^priorityJobs
]

{ #category : #accessing }
GlorpWorker >> priorityJobs: anObject [
	priorityJobs := anObject
]
