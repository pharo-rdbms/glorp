api-aggregates
asTimestamp
	"Cast the receiver to be a timestamp"
	^self getFunction: #cast: withArguments: (Array with: self system platform timestamp asGlorpExpression).