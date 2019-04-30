Class {
	#name : #GlorpBasicTax,
	#superclass : #GlorpTax,
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpBasicTax class >> glorpSetupDescriptor: aDescriptor forSystem: aSystem [
	| table |
	table := aSystem tableNamed: 'TAX'.
	self glorpCommonSetupDescriptor: aDescriptor forSystem: aSystem.
	(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		keyedBy: 'T'
		field: (table fieldNamed: 'TYPE').
]
