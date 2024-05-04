Extension { #name : 'Collection' }

{ #category : '*Glorp-Core' }
Collection >> copyEmpty: aSize [
	^self species new: aSize
]

{ #category : '*Glorp' }
Collection >> glorpAddAll: aCollection [
	^self addAll: aCollection.
]

{ #category : '*Glorp' }
Collection >> glorpAddAllToDictionary: aDictionary [
	"Assumes that we are a collection of associations"
	self do: [:each | aDictionary add: each].
]

{ #category : '*Glorp' }
Collection >> glorpGroupedBy: aBlock [
	"Same as VW groupedBy:. This is too useful not to be able to use, but we don't want to conflict with other dialects/extensions that might implement, so make our own prefixed version"

	"Return a dictionary whose keys are the result of evaluating aBlock for all elements in
	 the collection, and the value for each key is the collection of elements that evaluated
	 to that key. e.g.
	     #(1 2 3 4 5) groupedBy: [:each | each odd]
	   a Dictionary  
	     true ---> #( 1 3 5)
	     false --> #(2 4)"

	| result |
	result := Dictionary new.
	self do:
		[:each | | key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [OrderedCollection new].
		collection add: each].
	self species ~~ OrderedCollection ifTrue:
		["Convert the result collections to be the right type.
		  Note that it should be safe to modify the dictionary
		  while iterating because we only replace values for existing keys"
		result keysAndValuesDo:
			[:key :value | result at: key put: (self species withAll: value)]].

	^result
]

{ #category : '*Glorp' }
Collection >> glorpIsCollection [

	^true.
]

{ #category : '*Glorp' }
Collection >> glorpPrintSQLOn: aCommand [
	aCommand nextPut: $(.
	self isEmpty
		ifTrue: [aCommand nextPutAll: 'NULL']
		ifFalse:
			[GlorpHelper
				do: [:each | each glorpPrintSQLOn: aCommand]
				for: self
				separatedBy: [aCommand nextPutAll: ', ']].
	aCommand nextPut: $).
]

{ #category : '*Glorp' }
Collection >> glorpPrintSQLOn: aStream for: aType [
	aStream nextPut: $(.
	self isEmpty
		ifTrue: [aStream nextPutAll: 'NULL']
		ifFalse:
			[GlorpHelper
				do: [:each | aType print: each on: aStream]
				for: self
				separatedBy: [aStream nextPutAll: ', ']].
	aStream nextPut: $).
]

{ #category : '*Glorp' }
Collection >> glorpRegisterCollectionInternalsIn: anObjectTransaction [ 
	"Explicitly register any internal structures (e.g. a VW identity dictionary's valueArray) with the transaction. Assume we can safely register everything inside the collection reflectively. The obvious exceptions would be dependents and sortblocks. This is a cheat, and for peculiar cases you'll need to override this in the subclass"

	| names |
	names := self class allInstVarNames.
	(1 to: names size) do: 
			[:index | 
			(#('dependents' 'sortBlock') includes: (names at: index)) 
				ifFalse: [anObjectTransaction register: (self instVarAt: index)]]
]

{ #category : '*Glorp' }
Collection >> writeStream [
	^AddingWriteStream on: self
]
