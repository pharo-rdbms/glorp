Class {
	#name : #GlorpTax,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'taxes',
		'supertax'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #'as yet unclassified' }
GlorpTax class >> glorpCommonSetupDescriptor: aDescriptor forSystem: aSystem [
	| table |
	table := aSystem tableNamed: 'TAX'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping:
			((OneToManyMapping new)
				attributeName: #taxes;
				referenceClass: GlorpTax;
				join: (Join from: (table fieldNamed: 'ID') to: (table fieldNamed: 'TAX_ID'))).
	aDescriptor addMapping:
			((OneToOneMapping new)
				attributeName: #supertax;
				referenceClass: GlorpTax;
				join: (Join from: (table fieldNamed: 'TAX_ID') to: (table fieldNamed: 'ID'))).
]

{ #category : #'as yet unclassified' }
GlorpTax class >> glorpSetupDescriptor: aDescriptor forSystem: aSystem [
	| table |
	table := aSystem tableNamed: 'TAX'.
	aDescriptor table: table.

	"(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		keyedBy: 'XXX'
		field: (table fieldNamed: 'TYPE')."

	(aSystem typeResolverFor: GlorpTax)
		register: aDescriptor
		abstract: true
]

{ #category : #'as yet unclassified' }
GlorpTax class >> glorpTypeResolver [
	^FilteredTypeResolver forRootClass: GlorpTax.
]

{ #category : #'add/remove' }
GlorpTax >> addTax: aTax [
	self taxes add: aTax.
	aTax supertax: self.
]

{ #category : #accessing }
GlorpTax >> id [
	^id
]

{ #category : #private }
GlorpTax >> id: anObject [
	id := anObject.
]

{ #category : #accessing }
GlorpTax >> name [
	^name
]

{ #category : #accessing }
GlorpTax >> name: anObject [
	name := anObject.
]

{ #category : #accessing }
GlorpTax >> supertax [
	^supertax
]

{ #category : #private }
GlorpTax >> supertax: anObject [
	supertax := anObject.
]

{ #category : #accessing }
GlorpTax >> taxes [
	taxes ifNil: [taxes := IdentitySet new].
	^taxes.
]
