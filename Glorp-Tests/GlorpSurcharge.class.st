Class {
	#name : #GlorpSurcharge,
	#superclass : #GlorpTax,
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpSurcharge class >> glorpSetupDescriptor: aDescriptor forSystem: aSystem [
	| table |
	table := aSystem tableNamed: 'TAX'.
	self glorpCommonSetupDescriptor: aDescriptor forSystem: aSystem.
	(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		keyedBy: 'S'
		field: (table fieldNamed: 'TYPE').
]
