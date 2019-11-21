Class {
	#name : #GlorpOffice,
	#superclass : #Object,
	#instVars : [
		'id',
		'employees',
		'street',
		'employeeOfMonth'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
GlorpOffice >> addEmployee: anEmployee [
	self employees add: anEmployee.
]

{ #category : #accessing }
GlorpOffice >> employeeOfMonth [
	^employeeOfMonth
]

{ #category : #accessing }
GlorpOffice >> employeeOfMonth: anObject [
	employeeOfMonth := anObject
]

{ #category : #accessing }
GlorpOffice >> employees [
	employees isNil ifTrue: [ employees := OrderedCollection new ].
	^employees
]

{ #category : #accessing }
GlorpOffice >> employees: anObject [
	employees := anObject
]

{ #category : #accessing }
GlorpOffice >> id [
	^id
]

{ #category : #accessing }
GlorpOffice >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GlorpOffice >> street [
	^street
]

{ #category : #accessing }
GlorpOffice >> street: aString [
	street := aString
]
