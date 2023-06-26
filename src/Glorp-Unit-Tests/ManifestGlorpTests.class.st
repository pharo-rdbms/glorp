"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGlorpTests,
	#superclass : #PackageManifest,
	#category : #'Glorp-Unit-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleEqualNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpExpressionTest #testIsNullPrint #false)) #'2023-06-26T17:18:01.373504+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionTest #testNotNullPrint #false)) #'2023-06-26T17:18:26.409147+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpExpressionTest #testTwoLevelMappingExpressionIdentity #false)) #'2023-06-26T17:19:32.656259+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpExpressionTest #testAndOperation2 #false)) #'2023-06-26T17:13:37.574583+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionTest #testOrOperation2 #false)) #'2023-06-26T17:18:49.992423+02:00') )
]
