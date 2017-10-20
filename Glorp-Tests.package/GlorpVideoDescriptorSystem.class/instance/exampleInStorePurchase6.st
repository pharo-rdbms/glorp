examples
exampleInStorePurchase6
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 106.
	purchase title: 'Fargo'.
	purchase price: 6.00.
	purchase inStore: true.
	^purchase.