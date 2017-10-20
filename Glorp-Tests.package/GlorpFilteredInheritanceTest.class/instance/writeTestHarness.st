support
writeTestHarness
	| office1 office2  eom1 eom2 jim bob |
	session register: (office1 := GlorpOffice new id: 1; yourself).
	session register: (office2 := GlorpOffice new id: 2; yourself).
	office1 addEmployee: (eom1 := GlorpEmployee new id: 1; name: 'Bob'; yourself).
	office1 addEmployee: (GlorpEmployee new id: 2; name: 'Jim'; yourself).
	office1 addEmployee: (GlorpManager new id: 3; name: 'Bob'; branch: 'West'; yourself).
	office2 addEmployee: (eom2 := GlorpManager new id: 4; name: 'Steve'; branch: 'East'; yourself).
	office2 addEmployee: (GlorpManager new id: 5; name: 'Bob'; branch: 'South'; yourself).
	office1 addEmployee: (GlorpLineWorker new id: 6; name: 'Wally'; productionLine: 'Gold'; yourself).
	office1 addEmployee: (GlorpLineWorker new id: 7; name: 'Bob'; productionLine: 'Silver'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 8; name: 'Bob'; productionLine: 'Tin'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 9; name: 'Bob'; productionLine: 'Copper'; yourself).
	office2 addEmployee: (GlorpLineWorker new id: 10; name: 'Bob'; productionLine: 'Steel'; yourself).
	office1 addEmployee: (GlorpRegionalManager new id: 11; name: 'Bob'; branch: 'South'; region: 'MidWest'; yourself).
	office2 addEmployee: (GlorpRegionalManager new id: 12; name: 'Mike'; branch: 'North'; region: 'NorthEast'; yourself).
	office1 employeeOfMonth: eom1.
	office2 employeeOfMonth: eom2.

	session register: (jim := GlorpWorkingStiff new id: 13; name: 'Jim'; yourself).
	session register: (bob := GlorpWorkingStiff new id: 14; name: 'Bob'; yourself).

	allEmployees := (Array with: jim with: bob), office1 employees, office2 employees.