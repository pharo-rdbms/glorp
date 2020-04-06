"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGlorp,
	#superclass : #PackageManifest,
	#category : #'Glorp-Manifest'
}

{ #category : #'code-critics' }
ManifestGlorp class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Glorp)) #'2020-01-24T01:58:46.992497-08:00') )
]
