descriptors/employees
descriptorForGlorpOffice: aDescriptor
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