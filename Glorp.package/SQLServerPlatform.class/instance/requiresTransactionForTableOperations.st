constants
requiresTransactionForTableOperations
	"SQL Server, over ODBC doesn't support DDL transactions reliably, since the current transaction can be rolled back without notice. So we avoid this."
	^false.