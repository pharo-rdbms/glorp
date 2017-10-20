examples
exampleInStorePurchase3
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 103.
	purchase title: 'Cambodia, Swimming To'.
	purchase price: 3.00.
	purchase inStore: true.
	^purchase.