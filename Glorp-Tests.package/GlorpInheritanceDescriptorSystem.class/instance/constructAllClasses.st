misc
constructAllClasses
	^(super constructAllClasses)
		add: GlorpOffice;
		add: GlorpEmployee;
		add: GlorpManager;
		add: GlorpRegionalManager;
		add: GlorpLineWorker;
		add: GlorpInventoryItem;
		add: GlorpPerishableItem;
		add: GlorpNonperishableItem;
		add: GlorpUnassembledItem;
		add: GlorpWorkingStiff;
		add: GlorpPoultry;
		add: GlorpTax;
		add: GlorpBasicTax;
		add: GlorpSurcharge;
		add: GlorpWarehouse;
		add: GlorpTag;
		add: GlorpTaggableObject;
		add: GlorpImage;
		yourself