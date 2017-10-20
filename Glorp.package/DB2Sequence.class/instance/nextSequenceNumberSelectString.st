private
nextSequenceNumberSelectString
	"Using SYSIBM is not ideal because it's supposed to be internal, but it seems to be accepted."

	^'SELECT NEXT VALUE FOR ' , self qualifiedName , ' FROM SYSIBM.SYSDUMMY1'