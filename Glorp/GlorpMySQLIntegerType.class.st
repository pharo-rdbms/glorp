Class {
	#name : #GlorpMySQLIntegerType,
	#superclass : #GlorpAbstractIntegerType,
	#instVars : [
		'length',
		'zerofill',
		'unsigned'
	],
	#category : #'Glorp-Types'
}

{ #category : #accessing }
GlorpMySQLIntegerType >> hasParameters [
	^true
]

{ #category : #initialize }
GlorpMySQLIntegerType >> initialize [ 
	super initialize.
	typeString := 'int'
]

{ #category : #accessing }
GlorpMySQLIntegerType >> length [
	^ length
]

{ #category : #accessing }
GlorpMySQLIntegerType >> length: anObject [
	length := anObject
]

{ #category : #accessing }
GlorpMySQLIntegerType >> unsigned [
	^ unsigned
]

{ #category : #accessing }
GlorpMySQLIntegerType >> unsigned: anObject [
	unsigned := anObject
]

{ #category : #accessing }
GlorpMySQLIntegerType >> zerofill [
	^ zerofill
]

{ #category : #accessing }
GlorpMySQLIntegerType >> zerofill: anObject [
	zerofill := anObject
]
