"
This is a query that contains several sub-queries, and executes them all in sequence, returning the concatenation of all the results. This is different from a CompoundQuery, which groups multiple queries together according to operations like UNION ALL, or INTERSECT. This just puts together several different queries and executes them separately, combining the results in Smalltalk. CompoundQuery is more powerful, and can take advantage of database features, but this is more flexible.
"
Class {
	#name : 'CompositeQuery',
	#superclass : 'Query',
	#instVars : [
		'queries'
	],
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'accessing' }
CompositeQuery >> addQuery: aQuery [
	queries add: aQuery
]

{ #category : 'accessing' }
CompositeQuery >> baseExpression [
	^queries first baseExpression
]

{ #category : 'accessing' }
CompositeQuery >> collectionType [
	^self primaryQuery collectionType
]

{ #category : 'preparing' }
CompositeQuery >> copyOfBuilders [ 
	^self primaryQuery copyOfBuilders
]

{ #category : 'executing' }
CompositeQuery >> executeWithParameters: parameterArray in: aSession [
	| results |
	results := self collectionType new writeStream.
	queries do: [:each |
		results nextPutAll: (each executeWithParameters: parameterArray in: aSession)].
	^results contents
]

{ #category : 'initialization' }
CompositeQuery >> initialize [
	super initialize.
	queries := OrderedCollection new.
]

{ #category : 'copying' }
CompositeQuery >> postCopy [

	super postCopy.
	queries := queries collect: [:each | each copy].
]

{ #category : 'preparing' }
CompositeQuery >> prepare [
	queries do: [:each | each session: session].
	queries do: [:each | each prepare].
]

{ #category : 'accessing' }
CompositeQuery >> primaryQuery [
	^queries first
]

{ #category : 'accessing' }
CompositeQuery >> proxyType [
	^self primaryQuery proxyType
]

{ #category : 'accessing' }
CompositeQuery >> proxyType: aClass [	
	"We currently ignore proxy types and use the ones from our main query."
	^self
]
