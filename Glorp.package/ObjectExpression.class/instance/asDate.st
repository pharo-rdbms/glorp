api-aggregates
asDate
	"Cast the receiver to be a date"
	^self getFunction: #cast: withArguments: (Array with: self system platform date asGlorpExpression).