"
This is a version generator that takes an arbitrary block and runs it.

Instance Variables:
	block	<BlockClosure>	The block we evaluate to get the next version.
	numberOfArguments	<Integer>	Generated automatically. How many arguments does block take. If zero, we invoke it without our arguments. If not, we give it the arguments to use.


"
Class {
	#name : #AdHocVersionGenerator,
	#superclass : #VersionGenerator,
	#instVars : [
		'block',
		'numberOfArguments'
	],
	#category : #'Glorp-Database'
}

{ #category : #constructor }
AdHocVersionGenerator class >> block: aBlock [
	^self new block: aBlock.
]

{ #category : #accessing }
AdHocVersionGenerator >> block [

	^ block
]

{ #category : #accessing }
AdHocVersionGenerator >> block: aBlock [

	block := aBlock.
	numberOfArguments := Dialect argumentCountFor: block
]

{ #category : #sequencing }
AdHocVersionGenerator >> nextValueFor: aField in: aRow [
	"Get the next value by evaluating the block. If it doesn't care about the field or row, don't pass them as arguments. If it does, then give it both."

	numberOfArguments = 0
		ifTrue: [ ^ block value ]
		ifFalse: [ ^ block value: aField value: aRow ]
]
