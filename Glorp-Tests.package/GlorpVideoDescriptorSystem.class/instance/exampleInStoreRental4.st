examples
exampleInStoreRental4
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1004.
	rental title: 'Down By Law'.
	rental price: 24.00.
	rental dueDate: Date today.
	^rental.