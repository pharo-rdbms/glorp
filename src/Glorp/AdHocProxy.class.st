"
This represents a proxy that gets its value in a user-defined way, by evaluating a block.

Instance Variables:
	readBlock	<BlockClosure>	The zero-argument block we evaluate to get the proxied object.


"
Class {
	#name : 'AdHocProxy',
	#superclass : 'AbstractProxy',
	#instVars : [
		'readBlock'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : '*Glorp' }
AdHocProxy class >> readBlock: aZeroArgumentBlock [

	^self new glorpReadBlock: aZeroArgumentBlock
]

{ #category : 'accessing' }
AdHocProxy >> class [

	^AdHocProxy
]

{ #category : 'api' }
AdHocProxy >> getValue [

	self isInstantiated ifTrue: [^value].
	[value := readBlock value] ensure: [isInstantiated := true].
	^value
]

{ #category : 'api' }
AdHocProxy >> glorpReadBlock: aZeroArgumentBlock [
	readBlock := aZeroArgumentBlock
]

{ #category : 'printing' }
AdHocProxy >> printOn: aStream [ 
	aStream nextPut: ${.
	isInstantiated 
		ifTrue: [self getValue printOn: aStream]
		ifFalse: [aStream nextPutAll: 'uninstantiated AdHocProxy'].
	aStream nextPut: $}
]

{ #category : 'initialization' }
AdHocProxy >> proxyInitialize [

	super proxyInitialize.
	readBlock := [nil]
]
