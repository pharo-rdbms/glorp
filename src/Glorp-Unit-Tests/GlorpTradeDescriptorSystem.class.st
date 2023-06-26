Class {
	#name : #GlorpTradeDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models - Trade'
}

{ #category : #accessing }
GlorpTradeDescriptorSystem >> allTableNames [

	^#('ACCOUNT' 'TRADE')
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> classModelForGlorpAccount: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #name type: String
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> classModelForGlorpTrade: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #account type: GlorpAccount
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> constructAllClasses [

	^(super constructAllClasses)
		add: GlorpAccount;
		add: GlorpTrade; 
		yourself
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> descriptorForGlorpAccount: aDescriptor [

	| table |

	table := self tableNamed: 'ACCOUNT'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) from: #name to: (table fieldNamed: 'NAME')
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> descriptorForGlorpTrade: aDescriptor [

	| table accountTable |

	table := self tableNamed: 'TRADE'.
	accountTable := self tableNamed: 'ACCOUNT'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping) from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #account;
		join: (Join from: (table fieldNamed: 'ACCOUNT_ID') to: (accountTable fieldNamed: 'ID'))
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> tableForACCOUNT: aTable [

	(aTable createFieldNamed: 'ID' type: platform sequence) bePrimaryKey.
	(aTable createFieldNamed: 'NAME' type: (platform varchar: 20)) beNullable: false
]

{ #category : #accessing }
GlorpTradeDescriptorSystem >> tableForTRADE: aTable [

	| accountId |

	(aTable createFieldNamed: 'ID' type: platform sequence) bePrimaryKey.
	accountId := aTable createFieldNamed: 'ACCOUNT_ID' type: (platform int4).
	aTable addForeignKeyFrom: accountId to: ((self tableNamed: 'ACCOUNT') fieldNamed: 'ID')
]
