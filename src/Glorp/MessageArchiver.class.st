"
This is what we use to construct GlorpExpression trees out of blocks. An instance of MessageArchiver is passed into the block. It has a doesNotUnderstand: handler, and in response to almost any message, will just return a new MessageArchiver which knows it is descended from this one. The result (assuming no inlined messages or other tricky stuff happened) is a tree of MessageArchivers recording all the sent messages. We can then traverse that and construct the appropriate expression tree.

Instance Variables:
	myArguments	<(Collection of: (Object | ProtoObject))>	The arguments to the message that caused me to be constructed.
	myReceiver	<MessageArchiver | nil>	The object that received the message that caused me to be constructed. For the initial MessageArchiver that's passed in, this will be nil. Otherwise it is a MessageArchiver.
	mySelector	<Symbol>	The selector of the message that caused me to be constructed.
	query	<AbstractReadQuery>	The query for which I am constructing the expression. This is here so that we can construct the final expression tree directly onto its BaseExpression.


"
Class {
	#name : 'MessageArchiver',
	#superclass : 'ProtoObject',
	#instVars : [
		'mySelector',
		'myArguments',
		'myReceiver',
		'query'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'as yet unclassified' }
MessageArchiver class >> inspectorClass [

	^EyeProtoInspector 
]

{ #category : 'instance creation' }
MessageArchiver class >> receiver: aMessageCollector selector: aSymbol arguments: aCollection [

	^self new
		receiver: aMessageCollector
		selector: aSymbol
		arguments: aCollection
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> = anObject [
	"Needed because VA's abtObservableWrapper implements =. Should be portable."
	^MessageArchiver 
		receiver: self
		selector: #= 
		arguments: (Array with: anObject)
]

{ #category : 'expression creation' }
MessageArchiver >> asGlorpExpression [
	^self asGlorpExpressionOn: BaseExpression new
]

{ #category : 'expression creation' }
MessageArchiver >> asGlorpExpressionOn: aBaseExpression [ 
	| arguments |
	myReceiver == nil ifTrue: [^query isNil ifTrue: [aBaseExpression] ifFalse: [query baseExpression]].
	arguments := myArguments collect: [:each | each asGlorpExpressionOn: aBaseExpression].
	^self sendMessageTo: (myReceiver asGlorpExpressionOn: aBaseExpression) withArguments: arguments
]

{ #category : 'expression creation' }
MessageArchiver >> asGlorpExpressionOn: aBaseExpression basedOn: aMessageArchiver withUltimateBase: ultimateBaseExpression [
	"We know we are built from aMessageArchiver, but parts of us may refer to an outer scope. Those parts should be built on ultimateBaseExpression rather than aBaseExpression. e.g. consider 
 [:each | each amount amount = ((Query readManyOf: GlorpBankTransaction
			where: [:eachTrans | eachTrans owner = each owner]) 
				retrieve: [:eachTrans | eachTrans amount amount max])]."

	| arguments |
	self == aMessageArchiver ifTrue: [^aBaseExpression].
	myReceiver == nil ifTrue: [^query isNil ifTrue: [ultimateBaseExpression] ifFalse: [query baseExpression]].
	arguments := myArguments
		collect:
			[:each | 
			each
				asGlorpExpressionOn: aBaseExpression
				basedOn: aMessageArchiver
				withUltimateBase: ultimateBaseExpression].
	^self 
		sendMessageTo: (myReceiver
			asGlorpExpressionOn: aBaseExpression
			basedOn: aMessageArchiver
			withUltimateBase: ultimateBaseExpression)
		withArguments: arguments
]

{ #category : 'debugging' }
MessageArchiver >> asText [
	^self basicPrintString asText
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> basicDoesNotUnderstand: aMessage [ 
	"Invoke this to avoid infinite recursion in the case of internal errors. We want a dialect-independent way of getting a walkback window, so we'll invoke it against a different object"


	(Array with: self) doesNotUnderstand: aMessage
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> basicDoesNotUnderstand: sel args: args [ 
	"Invoke this to avoid infinite recursion in the case of internal errors. We want a dialect-independent way of getting a walkback window, so we'll invoke it against a different object"

	(Array with: self) doesNotUnderstand: sel args: args
]

{ #category : 'debugging' }
MessageArchiver >> basicPrintString [

	^self printString
]

{ #category : 'debugging' }
MessageArchiver >> class [
	^MessageArchiver
]

{ #category : 'debugging' }
MessageArchiver >> displayString [
	"For use in by-hand debugging.  For more general use if the dialect has a #displayString implementation in Object that returns printString.  (If everything else is nil, we assume the receiver is too and we're the result of a
	MessageArchiver new
call at the base of the expression, but we print the receiver uppercase, both to distinguish this base case from any other nil and just in case it is not nil.)"

	| str |
	query isNil ifFalse: [^query printString].
	(mySelector isNil and: [myArguments isNil]) ifTrue:
		[^myReceiver displayString asUppercase].
	(str := (String new: 64) writeStream)
		nextPutAll: myReceiver displayString;
		space;
		nextPutAll: mySelector.
	myArguments do:
		[:each |
		str crtab; nextPutAll:
			(each displayString
				copyReplaceAll: (Array with: Character cr)
				with: (Array with: Character cr with: Character tab))].
	^str contents
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> doesNotUnderstand: aMessage [ 
	| sel |
	sel := aMessage selector.
	sel == #doesNotUnderstand: ifTrue: [self basicDoesNotUnderstand: aMessage].
	(sel size >= 8 and: [(sel copyFrom: 1 to: 8) = 'perform:']) 
		ifTrue: 
			[^self get: aMessage arguments first
				withArguments: (aMessage arguments copyFrom: 2 to: aMessage arguments size)].
	^self get: sel withArguments: aMessage arguments
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> doesNotUnderstand: sel args: args [ 
	"This is the variant for ObjectStudio"
	sel == #doesNotUnderstand: ifTrue: [self basicDoesNotUnderstand: sel args: args].
	(sel size >= 8 and: [(sel copyFrom: 1 to: 8) = 'perform:']) 
		ifTrue: 
			[^self get: args first
				withArguments: (args copyFrom: 2 to: args size)].
	^self get: sel withArguments: args
]

{ #category : 'expression protocol' }
MessageArchiver >> get: aSymbol [ 
	^MessageArchiver receiver: self
		selector: aSymbol
		arguments: #()
]

{ #category : 'expression protocol' }
MessageArchiver >> get: aSymbol withArguments: anArray [ 
	| arguments |
	arguments := anArray collect: [:each | each glorpIsBlock 
		ifTrue: [(Dialect argumentCountFor: each) = 1
			ifTrue: [each value: self]
			ifFalse: [each value]]
		ifFalse: [each]].
	^MessageArchiver receiver: self
		selector: aSymbol
		arguments: arguments
]

{ #category : 'expression protocol' }
MessageArchiver >> getMapping: aMapping named: aString [
	"In this case, the name may actually be a string rather than a symbol."
	^MessageArchiverForGetMapping
		receiver: self
		selector: aString
		arguments: (Array with: aMapping with: aString)
]

{ #category : 'testing' }
MessageArchiver >> glorpIsBlock [
	^false
]

{ #category : 'debugging' }
MessageArchiver >> halt [
	"Support this so that we can debug inside query blocks. For portability, send it to a different object so that we don't have to care how halt is implemented"

	(Array with: self) halt
]

{ #category : 'as yet unclassified' }
MessageArchiver >> hash [
	^(myReceiver hash bitXor: mySelector hash) bitXor: myArguments hash
]

{ #category : 'debugging' }
MessageArchiver >> inspect [
	"Not exactly the intended semantics, but should be portable"
	
	(Array with: self) inspect
]

{ #category : 'debugging' }
MessageArchiver >> inspectorSize [
  ^2
]

{ #category : 'debugging' }
MessageArchiver >> isBehavior [
	"Return true if the receiver is a behavior.
	Note: Do not override in any class except behavior."
	^false
]

{ #category : 'debugging' }
MessageArchiver >> mustBeBoolean [
	nil error: 'mustBeBoolean - this probably indicates you are trying to use an optimized message like and: or ifTrue: inside a Glorp expression block. Use AND: or & instead.'
]

{ #category : 'doesNotUnderstand' }
MessageArchiver >> os_Equal: anObject [
	^self = anObject
]

{ #category : 'debugging' }
MessageArchiver >> printOn: aStream [

	aStream nextPutAll: self printString
]

{ #category : 'debugging' }
MessageArchiver >> printString [

	"Hard-code this for maximum dialect portability"
	^'a MessageArchiver'
]

{ #category : 'debugging' }
MessageArchiver >> printStringLimitedTo: anInteger [

	^self printString
]

{ #category : 'private/accessing' }
MessageArchiver >> privateGlorpQuery [
	^query
]

{ #category : 'private/accessing' }
MessageArchiver >> privateGlorpQuery: aQuery [
	query := aQuery
]

{ #category : 'private/accessing' }
MessageArchiver >> privateGlorpReceiver [

	^myReceiver
]

{ #category : 'private/accessing' }
MessageArchiver >> privateGlorpSelector [

	^mySelector
]

{ #category : 'initialization' }
MessageArchiver >> receiver: aMessageCollector selector: aSymbol arguments: aCollection [

	myReceiver := aMessageCollector.
	mySelector := aSymbol.
	myArguments := aCollection
]

{ #category : 'expression creation' }
MessageArchiver >> sendMessageTo: anExpression withArguments: arguments [
	"Build our node by sending our message to anExpression"

	^anExpression get: mySelector withArguments: arguments
]
