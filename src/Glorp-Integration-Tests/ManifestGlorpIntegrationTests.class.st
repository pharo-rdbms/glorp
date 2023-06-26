"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGlorpIntegrationTests,
	#superclass : #PackageManifest,
	#category : #'Glorp-Integration-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestGlorpIntegrationTests class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpReadingTest #testCompoundAND #false)) #'2023-06-26T21:14:20.981296+02:00') )
]
