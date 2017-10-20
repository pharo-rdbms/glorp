*Glorp
glorpPrintSQLOn: aCommand
	"Print as 24 hour time"

	aCommand 
		nextPut: $';
		nextPutAll: 	(self glorpPadToTwoDigits: self hours);
		nextPut: $:;
		nextPutAll: (self glorpPadToTwoDigits: self minutes);
		nextPut: $:;
		nextPutAll: (self glorpPadToTwoDigits: self seconds);
		nextPut: $'.