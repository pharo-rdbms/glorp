DB2IdentitySequence is the sequence class for DB2 identity columns. Glorp prefers sequence objects over identity columns, and although DB2 has both, Glorp defaults to using sequences. Therefore there is no code here to create an identity column. Primary keys will use sequences instead. DB2IdentitySequence primarily helps in the analysis of tables that were created outside Glorp.

One can obtain the most recently installed number using a query like this.
	VALUES IDENTITY_VAL_LOCAL().
