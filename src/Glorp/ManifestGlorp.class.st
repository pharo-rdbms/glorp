"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGlorp,
	#superclass : #PackageManifest,
	#category : #'Glorp-Manifest'
}

{ #category : #coverage }
ManifestGlorp class >> classNamesNotUnderTest [

	"Everything here has extensions in Glorp so the coverage tries to install the wrappers on them and the image hangs"

	^ #(ProtoObject Object Association BlockClosure Collection Dictionary IdentityDictionary WeakValueDictionary SequenceableCollection ByteArray SortedCollection String Date DateAndTime Integer PositionableStream ReadStream ProcessorScheduler ScaledDecimal Time UndefinedObject)
]

{ #category : #'code-critics' }
ManifestGlorp class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMetaclassDefinition #(#'ManifestGlorp class' #ManifestGlorp)) #'2023-03-29T12:44:09.96564+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorp class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#Glorp)) #'2020-01-24T01:58:46.992497-08:00') )
]

{ #category : #'code-critics' }
ManifestGlorp class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ActiveRecordDescriptorSystem #tableClassForClass: #false)) #'2023-03-29T12:43:49.630529+02:00') )
]
