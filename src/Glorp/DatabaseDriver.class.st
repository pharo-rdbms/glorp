"
Common superclass for database drivers
"
Class {
	#name : #DatabaseDriver,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'Glorp-Database'
}

{ #category : #executing }
DatabaseDriver >> basicExecuteSQLString: aString [

	^ self subclassResponsibility
]

{ #category : #transactions }
DatabaseDriver >> beginTransaction [

	self subclassResponsibility
]

{ #category : #transactions }
DatabaseDriver >> commitTransaction [

	^ self subclassResponsibility
]

{ #category : #accessing }
DatabaseDriver >> connect: aLogin [

	^ self subclassResponsibility
]

{ #category : #accessing }
DatabaseDriver >> connection [

	^ connection
]

{ #category : #accessing }
DatabaseDriver >> connection: anObject [

	connection := anObject
]

{ #category : #accessing }
DatabaseDriver >> connectionClass [

	^ self subclassResponsibility
]

{ #category : #testing }
DatabaseDriver >> isConnected [

	^ self subclassResponsibility
]

{ #category : #login }
DatabaseDriver >> logout [

	^ self subclassResponsibility
]

{ #category : #transactions }
DatabaseDriver >> rollbackTransaction [

	^ self subclassResponsibility
]
