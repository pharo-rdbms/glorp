"
This sorts a set of rows to determine the order in which they should be inserted into the database. It does this using a breadth first topological sort. What that means is that instead of traversing the graph depth first, as is normal for topological, we traverse it breadth first. This gives us the desirable property of keeping the child rows together as much as possible. Since the initial input will already have been sorted by the static table ordering that is implied by the foreign key constraints, this will also keep rows from the same table together, unless the sort algorithm finds a reason the order needs to be changed. This maximizes the opportunities for using optimizations like Oracle array binding, which want to write groups of similar rows all at once. Note that we can't just use the table order directly, because there may be row-level issues. That is, rows may need to be written before other rows in the same table, or even if there is a table constraint, it may only be relevant for a small number of rows.

Instance Variables:
	childCache	<IdentityDictionary from: Object to: Collection>	The calculation of children may be expensive, and may have to be done more than once for an item, so we cache the information here.
	childSelector	<Symbol | BlockClosure>	The zero-argument selector which we perform on an item, or the one-argument block which we evaluate in order to get the children.
	current	<DatabaseRow | GlorpBreadthFirstTopologicalSortItem>	The item we are currently examining.
	items	<ReadStream>	A stream on the items we are intended to sort.
	queue	<OrderedCollection>	This maintains the breadth first order. So, when we encounter an item, we add its children to the end of the queue. The Sorter processes the items in order off the queue, resulting in a breadth first traversal.
	sorted	<OrderedCollection>	The resulting collection, in sorted order.


"
Class {
	#name : #GlorpRowSorter,
	#superclass : #Object,
	#instVars : [
		'childSelector',
		'queue',
		'sorted',
		'current',
		'items',
		'childCache'
	],
	#category : 'Glorp-UnitOfWork'
}

{ #category : #'*Glorp' }
GlorpRowSorter class >> new [
	^super new initialize.
]

{ #category : #sorting }
GlorpRowSorter >> childrenOf: anItem [
	^childCache at: anItem ifAbsentPut: [
		childSelector isSymbol
			ifTrue: [anItem perform: childSelector]
			ifFalse: [childSelector value: anItem]].
]

{ #category : #sorting }
GlorpRowSorter >> currentChildren [
	^self childrenOf: current.
]

{ #category : #sorting }
GlorpRowSorter >> currentItemIsDone [
	^current status = #done.
]

{ #category : #sorting }
GlorpRowSorter >> currentItemIsInProgress [
	^current status = #visitedOnce.
]

{ #category : #sorting }
GlorpRowSorter >> currentItemIsNew [
	^current status = #notVisited.
]

{ #category : #accessing }
GlorpRowSorter >> getChildrenVia: aSelector [
	childSelector := aSelector.
]

{ #category : #sorting }
GlorpRowSorter >> hasSomethingToProcess [
	self next.
	^current notNil.
]

{ #category : #sorting }
GlorpRowSorter >> initialVisit [
	| children |
	children := self currentChildren select: [:each  | each status == #notVisited].
	children do: [:each | each parent: current].
	queue addAll: children.
	current status: #visitedOnce.
	children isEmpty ifTrue: [queue add: current].
]

{ #category : #initializing }
GlorpRowSorter >> initialize [
	queue := OrderedCollection new: 100.
	sorted := OrderedCollection new: 100.
	childCache := IdentityDictionary new: 100.
]

{ #category : #sorting }
GlorpRowSorter >> next [
	queue isEmpty ifTrue: [
		| candidate |
		candidate := items detect: [:each | each status == #notVisited] ifNone: [nil].
		candidate isNil ifTrue: [
			"We're probably at the end, but check again for part-way done nodes, which can happen if there are heavy cycles"
			items reset. 
			candidate := items detect: [:each | each status == #visitedOnce] ifNone: [nil]].
		candidate isNil ifFalse: [queue add: candidate]].
	current := queue isEmpty ifTrue: [nil] ifFalse: [queue removeFirst].
]

{ #category : #sorting }
GlorpRowSorter >> processCurrent [
	self currentItemIsNew ifTrue: [^self initialVisit].
	self currentItemIsInProgress ifTrue: [^self secondVisit].
	self currentItemIsDone ifTrue: [^self].
	self error: 'Unknown item status'.
]

{ #category : #sorting }
GlorpRowSorter >> secondVisit [
	sorted add: current.
	current status: #done.
	current parent isNil
		ifFalse:
			[((self childrenOf: current parent)
				allSatisfy: [:each | each status == #done])
				ifTrue: [queue add: current parent].
			current parent: nil].
]

{ #category : #sorting }
GlorpRowSorter >> sort: aCollection [
	items := aCollection readStream.
	aCollection do: [:each | each status: #notVisited].
	[self hasSomethingToProcess] whileTrue: [self processCurrent].
	^sorted.
]
