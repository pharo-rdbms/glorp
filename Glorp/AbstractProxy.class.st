"
This is an abstract superclass for proxy objects. It inherits from ProtoObject, which is part of the platform specific layer, but implements most of the proxy functionality.

Instance Variables:
	isInstantiated	<Boolean>	Has this proxy been instantiated or not.
	value	<Object>	What we are proxying for.


"
Class {
	#name : #AbstractProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'value',
		'isInstantiated'
	],
	#category : 'Glorp-Queries'
}

{ #category : #'instance creation' }
AbstractProxy class >> new [

	^super new proxyInitialize
]

{ #category : #accessing }
AbstractProxy >> = anObject [
	"In VA we inherit this as identity. Need to override"
	^self getValue = anObject
]

{ #category : #printing }
AbstractProxy >> basicPrintOn: aStream [ 
	aStream nextPut: ${.
	isInstantiated 
		ifTrue: [self getValue basicPrintOn: aStream]
		ifFalse: [aStream nextPutAll: 'uninstantiated proxy'].
	aStream nextPut: $}
]

{ #category : #printing }
AbstractProxy >> basicPrintString [
	| aStream |
	aStream := WriteStream on: String new.
	self basicPrintOn: aStream.
	^aStream contents
]

{ #category : #overrides }
AbstractProxy >> basicSize [
	^self getValue basicSize
]

{ #category : #'dnu handling' }
AbstractProxy >> doesNotUnderstand: aMessage [

	^self getValue perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #'dnu handling' }
AbstractProxy >> doesNotUnderstand: sel args: args [ 
	"This is the variant for ObjectStudio"
	^self getValue perform: sel withArguments: args
]

{ #category : #api }
AbstractProxy >> getValue [

	self subclassesMustImplement
]

{ #category : #notification }
AbstractProxy >> glorpPostFetch: aSession [
]

{ #category : #notification }
AbstractProxy >> glorpPostFetchValidate: aSession [
]

{ #category : #overrides }
AbstractProxy >> hash [
	^self getValue hash
]

{ #category : #overrides }
AbstractProxy >> inspect [
	^self getValue inspect
]

{ #category : #'initialize-release' }
AbstractProxy >> instVarAt: index [ 
	"Primitive. Answer a fixed variable in an object. The numbering of the 
	variables corresponds to the named instance variables. Fail if the index 
	is not an Integer or is not the index of a fixed variable. Essential. See 
	Object documentation whatIsAPrimitive."

	<primitive: 73>
	"Access beyond fixed variables."
	^self basicAt: index - self class instSize		
]

{ #category : #testing }
AbstractProxy >> isGlorpProxy [
	^true
]

{ #category : #overrides }
AbstractProxy >> isImmutable [
	^self getValue isImmutable
]

{ #category : #testing }
AbstractProxy >> isInstantiated [
	isInstantiated isNil ifTrue: [isInstantiated := false].
	^isInstantiated
]

{ #category : #accessing }
AbstractProxy >> isKindOf: aClass [
	self isInstantiated ifTrue: [^value isKindOf: aClass].
	^false
]

{ #category : #testing }
AbstractProxy >> isNumber [

	^false
]

{ #category : #overrides }
AbstractProxy >> isSelfEvaluating [
	^false
]

{ #category : #testing }
AbstractProxy >> isString [

	^false
]

{ #category : #overrides }
AbstractProxy >> longPrintOn: aStream limitedTo: sizeLimit indent: indent [
	"Append to the argument, aStream, the names and values of all of the receiver's instance variables.  Limit is the length limit for each inst var."

	self class allInstVarNames doWithIndex:
		[:title :index |
		indent timesRepeat: [aStream tab].
		aStream nextPutAll: title;
		 nextPut: $:;
		 space;
		 tab;
		 nextPutAll: 
			((self instVarAt: index) printStringLimitedTo: (sizeLimit -3 -title size max: 1));
		 cr]
]

{ #category : #overrides }
AbstractProxy >> longPrintStringLimitedTo: aLimitValue [
	"Answer a String whose characters are a description of the receiver."
	
	| str |
	str := String streamContents: [:aStream | self longPrintOn: aStream limitedTo: aLimitValue indent: 0].
	"Objects without inst vars should return something"
	^ str isEmpty ifTrue: [self printString, String cr] ifFalse: [str]
]

{ #category : #printing }
AbstractProxy >> printOn: aStream [ 
	aStream nextPut: ${.
	isInstantiated 
		ifTrue: [self getValue printOn: aStream]
		ifFalse: [aStream nextPutAll: 'uninstantiated proxy'].
	aStream nextPut: $}
]

{ #category : #printing }
AbstractProxy >> printString [

	| aStream |
	aStream := WriteStream on: (String new: 16).
	self printOn: aStream.
	^aStream contents
]

{ #category : #printing }
AbstractProxy >> printStringLimitedTo: limit [
	"Answer a String whose characters are a description of the receiver.
	If you want to print without a character limit, use fullPrintString."
	| limitedString |
	limitedString := String streamContents: [:s | self printOn: s] limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , '...etc...'
]

{ #category : #'initialize-release' }
AbstractProxy >> proxyInitialize [

	isInstantiated := false
]

{ #category : #overrides }
AbstractProxy >> shouldBePrintedAsLiteral [

	^false
]

{ #category : #overrides }
AbstractProxy >> store [
	"For Object Studio compatibility"
	^self inspectorString.
]

{ #category : #accessing }
AbstractProxy >> uninstantiate [

	value := nil.
	isInstantiated := false
]

{ #category : #accessing }
AbstractProxy >> ~= anObject [ 

	^(self = anObject) not
]
