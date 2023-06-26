Class {
	#name : #GlorpInheritanceDescriptorSystem,
	#superclass : #GlorpTestDescriptorSystem,
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #misc }
GlorpInheritanceDescriptorSystem >> allTableNames [

	^#('EMPLOYEE' 'OFFICE' 'PERISHABLE_ITEM' 'NONPERISHABLE_ITEM' 'UNASSEMBLED_ITEM' 'WORKING_STIFF' 'POULTRY' 'TAX' 'WAREHOUSE' 'WAREHOUSE_ITEM_LINK'  'GLORP_IMAGE' 'GLORP_TAG' 'GLORP_TAGS').
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> classModelForGlorpImage: aClassModel [ 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #location.
	aClassModel newAttributeNamed: #tags collectionOf: GlorpTag.
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> classModelForGlorpTag: aClassModel [ 
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #key.
	aClassModel newAttributeNamed: #label
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> classModelForGlorpTaggableObject: aClassModel [
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> classModelForGlorpWarehouse: aClassModel [
	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #address.
	aClassModel newAttributeNamed: #currentItem type: GlorpInventoryItem.
	aClassModel newAttributeNamed: #items collectionOf: GlorpInventoryItem.
]

{ #category : #misc }
GlorpInheritanceDescriptorSystem >> constructAllClasses [
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
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpEmployee: aDescriptor [
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'E' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	^aDescriptor
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpImage: aDescriptor [
	| table |
	table := self tableNamed: 'GLORP_IMAGE'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'id').
	(aDescriptor newMapping: DirectMapping)
		from: #location
		to: (table fieldNamed: 'location').
	(aDescriptor newMapping: ManyToManyMapping) attributeName: #tags;
		 referenceClass: GlorpTag;

		join: (Join
				from: (table fieldNamed: 'id')
				to: ((self tableNamed: 'IMAGETAGS')
						fieldNamed: 'obj_id')).
	(self typeResolverFor: GlorpTaggableObject)
		register: aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpInventoryItem: aDescriptor [

	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor abstract: true.
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpLineWorker: aDescriptor [
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'W' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	aDescriptor addMapping: (DirectMapping from: #productionLine to: (table fieldNamed: 'PRODUCTION_LINE')).
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpManager: aDescriptor [
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #branch to: (table fieldNamed: 'BRANCH')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'M' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpNonperishableItem: aDescriptor [

	| table |
	table := self tableNamed: 'NONPERISHABLE_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #serialNumber to: (table fieldNamed: 'SERIAL_NUMBER')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpOffice: aDescriptor [
	| table |
	table := self tableNamed: 'OFFICE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (OneToManyMapping new
			attributeName: #employees;
			referenceClass: GlorpEmployee;
			join: (Join 
				from: (table fieldNamed: 'ID')
				to: ((self tableNamed: 'EMPLOYEE') fieldNamed: 'OFFICE_ID'))).
	aDescriptor addMapping: (OneToOneMapping new
		attributeName: #employeeOfMonth;
		referenceClass: GlorpEmployee;
		join: (Join
				from: (table fieldNamed: 'EMPLOYEE_OF_MONTH')
				to: ((self tableNamed: 'EMPLOYEE') fieldNamed: 'ID'))).
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpPerishableItem: aDescriptor [

	| table |
	table := self tableNamed: 'PERISHABLE_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #age to: (table fieldNamed: 'AGE')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpPoultry: aDescriptor [
	"Poultry does not participate in the InventoryItem heirarchy (ie it will not be retrieved when asking for an InventoryItem)"
	| table |
	table := self tableNamed: 'POULTRY'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #age to: (table fieldNamed: 'AGE')).
	aDescriptor addMapping: (DirectMapping from: #featherColor to: (table fieldNamed: 'FEATHER_COLOR')).
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpRegionalManager: aDescriptor [
	| table |
	table := self tableNamed: 'EMPLOYEE'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #branch to: (table fieldNamed: 'BRANCH')).
	aDescriptor addMapping: (DirectMapping from: #region to: (table fieldNamed: 'REGION')).
	(self typeResolverFor: GlorpEmployee) register: aDescriptor keyedBy: 'R' field: (table fieldNamed: 'EMPLOYEE_TYPE').
	^aDescriptor
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpTag: aDescriptor [ 
	| table |
	table := self tableNamed: 'GLORP_TAG'.
	aDescriptor table: table.
	(aDescriptor newMapping: DirectMapping)
		from: #id
		to: (table fieldNamed: 'id').
	(aDescriptor newMapping: DirectMapping)
		from: #key
		to: (table fieldNamed: 'key').
	(aDescriptor newMapping: DirectMapping)
		from: #label
		to: (table fieldNamed: 'label').
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpTaggableObject: aDescriptor [ 
	(self typeResolverFor: GlorpTaggableObject)
		register: aDescriptor
		abstract: true
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpUnassembledItem: aDescriptor [

	| table |
	table := self tableNamed: 'UNASSEMBLED_ITEM'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	aDescriptor addMapping: (DirectMapping from: #serialNumber to: (table fieldNamed: 'SERIAL_NUMBER')).
	aDescriptor addMapping: (DirectMapping from: #assemblyCost to: (table fieldNamed: 'ASSEM_COST')).
	(self typeResolverFor: GlorpInventoryItem) register: aDescriptor.
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpWarehouse: aDescriptor [
	| table linkTable |
	table := self tableNamed: 'WAREHOUSE'.
	aDescriptor table: table.
	aDescriptor
		addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor
		addMapping:
			(DirectMapping from: #address to: (table fieldNamed: 'ADDRESS')).
	(aDescriptor newMapping: OneToOneMapping) 
		attributeName: #currentItem;
		join: (self polymorphicJoinToItemFromField: (table fieldNamed: 'CURRENT_ITEM_ID')).
		
	linkTable := self tableNamed: 'WAREHOUSE_ITEM_LINK'.
	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #items;
		join:
				(Join
						from: (table fieldNamed: 'ID')
						to: (linkTable fieldNamed: 'WAREHOUSE_ID'));
		reverseJoin: (self polymorphicJoinToItemFromField: (linkTable fieldNamed: 'ITEM_ID')).
	^aDescriptor.
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> descriptorForGlorpWorkingStiff: aDescriptor [
	"Working stiff does not participate in the Employee type mapping scheme (it uses its own table)"
	| table |
	table := self tableNamed: 'WORKING_STIFF'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #name to: (table fieldNamed: 'NAME')).
	^aDescriptor
]

{ #category : #'descriptors - employees' }
GlorpInheritanceDescriptorSystem >> polymorphicJoinToItemFromField: aField [
	"Return a polymorphic join to the GlorpInventoryItem subclasses from the given field."
	| polymorphicJoin |
	polymorphicJoin := VariableJoin new.
	(Array with: GlorpNonperishableItem with: GlorpPerishableItem with: GlorpUnassembledItem)
		do:
			[:eachClass | 
			polymorphicJoin
				addJoinFor: eachClass
				as:
					(Join
						from: aField
						to: ((self descriptorFor: eachClass) primaryTable fieldNamed: 'ID'))].
	^polymorphicJoin
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForEMPLOYEE: aTable [
	| officeId |
	aTable name: 'EMPLOYEE'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	officeId := aTable createFieldNamed: 'OFFICE_ID' type: platform int4.
	aTable addForeignKeyFrom: officeId
		to: ((self tableNamed: 'OFFICE') fieldNamed: 'ID').
	aTable createFieldNamed: 'EMPLOYEE_TYPE' type: (platform varChar: 20).
	aTable createFieldNamed: 'BRANCH' type: (platform varChar: 20).
	aTable createFieldNamed: 'REGION' type: (platform varChar: 20).
	aTable createFieldNamed: 'PRODUCTION_LINE' type: (platform varChar: 20).
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> tableForGLORP_IMAGE: aTable [ 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable
		createFieldNamed: 'location'
		type: (platform varChar: 250).
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> tableForGLORP_TAG: aTable [ 
	(aTable createFieldNamed: 'id' type: platform sequence) bePrimaryKey.
	aTable
		createFieldNamed: 'key'
		type: (platform varChar: 200).
	aTable
		createFieldNamed: 'label'
		type: (platform varChar: 200).
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> tableForGLORP_TAGS: aTable [ 
	| tagKey tagObjKey |
	tagKey := aTable createFieldNamed: 'tag_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagKey
		to: ((self tableNamed: 'GLORP_TAG')
				fieldNamed: 'id').
	tagObjKey := aTable createFieldNamed: 'obj_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagObjKey
		to: ((self tableNamed: 'GLORP_IMAGE')
				fieldNamed: 'id')
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> tableForIMAGETAGS: aTable [ 
	| tagKey tagObjKey |
	tagKey := aTable createFieldNamed: 'tag_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagKey
		to: ((self tableNamed: 'GLORP_TAG')
				fieldNamed: 'id').
	tagObjKey := aTable createFieldNamed: 'obj_id' type: platform int4.
	aTable
		addForeignKeyFrom: tagObjKey
		to: ((self tableNamed: 'GLORP_IMAGE')
				fieldNamed: 'id')
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForNONPERISHABLE_ITEM: aTable [
	aTable name: 'NONPERISHABLE_ITEM'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'SERIAL_NUMBER' type: platform int4.
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForOFFICE: aTable [
	| empOfMonth |
	aTable name: 'OFFICE'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	empOfMonth := aTable createFieldNamed: 'EMPLOYEE_OF_MONTH' type: platform int4.
	"Cheat by removing this, because it makes a cycle that we can't really handle yet"
	"aTable addForeignKeyFrom: empOfMonth
		to: ((self tableNamed: 'EMPLOYEE') fieldNamed: 'ID')."
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForPERISHABLE_ITEM: aTable [
	aTable name: 'PERISHABLE_ITEM'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AGE' type: platform int4.
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForPOULTRY: aTable [
	aTable name: 'POULTRY'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'AGE' type: platform int4.
	aTable createFieldNamed: 'FEATHER_COLOR' type: (platform varChar: 20).
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForTAX: aTable [
	| superTaxId |
	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: platform text.
	aTable createFieldNamed: 'TYPE' type: (platform varchar: 16).
	superTaxId := aTable createFieldNamed: 'TAX_ID' type: platform int4.
	aTable addForeignKeyFrom: superTaxId to: ((self tableNamed: 'TAX') fieldNamed: 'ID').
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForUNASSEMBLED_ITEM: aTable [

	aTable name: 'UNASSEMBLED_ITEM'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
	aTable createFieldNamed: 'SERIAL_NUMBER' type: platform int4.
	aTable createFieldNamed: 'ASSEM_COST' type: platform int4.
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForWAREHOUSE: aTable [

	(aTable createFieldNamed: 'ID' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'ADDRESS' type: (platform varChar: 50).
	aTable createFieldNamed: 'CURRENT_ITEM_ID' type: platform int4.
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForWAREHOUSE_ITEM_LINK: aTable [

	| warehouseId |
	warehouseId := aTable createFieldNamed: 'WAREHOUSE_ID' type: platform int4.
	aTable addForeignKeyFrom: warehouseId to: ((self tableNamed: 'WAREHOUSE') fieldNamed: 'ID').
	aTable createFieldNamed: 'ITEM_ID' type: platform int4.
]

{ #category : #tables }
GlorpInheritanceDescriptorSystem >> tableForWORKING_STIFF: aTable [
	aTable name: 'WORKING_STIFF'.
	(aTable createFieldNamed: 'ID' type: platform int4) bePrimaryKey.
	aTable createFieldNamed: 'NAME' type: (platform varChar: 20).
]

{ #category : #'type resolvers' }
GlorpInheritanceDescriptorSystem >> typeResolverForGlorpInventoryItem [
	^HorizontalTypeResolver forRootClass: GlorpInventoryItem.
]

{ #category : #descriptors }
GlorpInheritanceDescriptorSystem >> typeResolverForGlorpTaggableObject [
   ^(HorizontalTypeResolver forRootClass: GlorpTaggableObject).
]
