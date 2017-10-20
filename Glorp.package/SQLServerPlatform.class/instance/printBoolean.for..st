conversion-boolean
printBoolean: aBoolean for: aType
	"If the platform is MS SQL Server, a boolean object in a SELECT needs to be converted to  BIT type, since T, Y, or true make SQLServer complain. "
	
	| string |
	aBoolean isNil ifTrue: [^'NULL'].
	"We may be getting passed something that's already 1 or 0, or something else instead of a boolean. That probably shouldn't be happening, but let's handle it gracefully. We define gracefully to mean 1 is true, and everything else is false"
	string := (aBoolean == 1 or: [aBoolean = true]) 
		ifTrue: ['1'] 
		ifFalse: ['0'].
	^'CONVERT( BIT, ' , string , ' )'.