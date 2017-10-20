delete-insert-update tests
testDeleteShallowCopyInsertIsUpdate
	"This is like testDeleteOldCopyInsertNewIsUpdate but demonstrates a workaround for the case when the user knows the object is already in the database but did not capture a shallowCopy before changing it.  It exploits the Glorp shortcut that, when delete and insert are combined to update, Glorp does not check which fields have changed but updates all fields, even though in this example the object and copy are unchanged."

	| person address otherSession |
	person := GlorpPerson example2.
	person address: nil.

	[address := self setUpPersonWithAddress address getValue.
	address street: 'Change Street'.
	otherSession := GlorpDemoDescriptorSystem sessionForLogin: GlorpDatabaseLoginResource current login.
	otherSession  accessor: GlorpDatabaseLoginResource current accessor.
	otherSession beginUnitOfWork.
	otherSession delete: address shallowCopy.
	person address: address.
	otherSession register: person.
	otherSession commitUnitOfWork]
			ensure: [session rollbackTransaction.  otherSession rollbackTransaction]