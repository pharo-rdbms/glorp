"
This builds raw data items rather than persistent objects with descriptors. Used if we do something like 
  aQuery retrieve: [:each | each address streetName].
giving us back simple data objects.
This makes building them quite simple.
"
Class {
	#name : 'DataElementBuilder',
	#superclass : 'ElementBuilder',
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'building objects' }
DataElementBuilder >> buildObjectFrom: anArray [
	self row: anArray.
	instance := self valueOf: expression
]

{ #category : 'building objects' }
DataElementBuilder >> didValidationFail: validateResult [

	"In other words, don't treat the result of the validation send to the object as a failure if the object was the boolean false, so returning self would normally be interpreted as the failure"
	validateResult == self instance ifTrue: [^false].

	^super didValidationFail: validateResult
]

{ #category : 'selecting fields' }
DataElementBuilder >> fieldsForSelectStatement [
	^Array with: expression
]

{ #category : 'selecting fields' }
DataElementBuilder >> fieldsFromMyPerspective [
	^expression mappedFields
]

{ #category : 'building objects' }
DataElementBuilder >> findInstanceForRow: aRow proxyType: proxyType [

	^self
]
