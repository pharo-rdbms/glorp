examples
exampleOnlinePurchase3
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 3.
	purchase title: 'Cabaret'.
	purchase price: 3.33.
	purchase inStore: false.
	^purchase.