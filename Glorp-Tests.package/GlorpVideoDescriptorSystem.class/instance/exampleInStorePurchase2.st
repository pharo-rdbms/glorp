examples
exampleInStorePurchase2
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 102.
	purchase title: 'Brazil'.
	purchase price: 2.00.
	purchase inStore: true.
	^purchase.