accessing
constructAllClasses
	^(super constructAllClasses)
		add: GlorpVideoStore;
		add: GlorpVideoCreditStatus;
		add: GlorpVideoCustomer;
		add: GlorpVideoPurchase;
		add: GlorpVideoRental;
		yourself