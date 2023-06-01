"
This is a to-many relationship in which we use a link table to the collection, rather than a foreign key in the items of the collection pointing back to the ""owner"". Using this class is exactly equivalent to just using a ToManyMapping and setting the useLinkTable field to true.
"
Class {
	#name : #ManyToManyMapping,
	#superclass : #ToManyMapping,
	#category : #'Glorp-Mappings'
}

{ #category : #initialization }
ManyToManyMapping >> initialize [
	super initialize.
	usesLinkTable := true.
]
