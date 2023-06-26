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
ManifestGlorpTests class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMetaclassDefinition #(#'ManifestGlorpTests class' #ManifestGlorpTests)) #'2023-06-26T17:49:36.133076+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleSentNotImplementedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpExpressionTest #testTwoLevelMappingExpressionIdentity #false)) #'2023-06-26T17:19:32.656259+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionRebuildingTest #testRebuildDoubleInnerScopeNormallyWithExists #false)) #'2023-06-26T17:23:00.60756+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionRebuildingTest #testRebuildDoubleInnerScopeNormallyWithJoins #false)) #'2023-06-26T17:23:08.036157+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionRebuildingTest #testRebuildInnerScopeForSubquery #false)) #'2023-06-26T17:23:32.681276+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionRebuildingTest #testRebuildInnerScopeNormally #false)) #'2023-06-26T17:23:39.17862+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpVideoStore #computeCollections #false)) #'2023-06-26T19:30:25.8836+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleUncommonMessageSendRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#GlorpExpressionTest #testAndOperation2 #false)) #'2023-06-26T17:13:37.574583+02:00') #(#(#RGMethodDefinition #(#GlorpExpressionTest #testOrOperation2 #false)) #'2023-06-26T17:18:49.992423+02:00') )
]

{ #category : #'code-critics' }
ManifestGlorpTests class >> ruleUtilityMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#GlorpDatabasePlatformTest)) #'2023-06-26T17:48:39.700269+02:00') #(#(#RGMethodDefinition #(#GlorpBreadthFirstTopologicalSortTest #dataForGroupNamed: #false)) #'2023-06-26T17:48:57.821673+02:00') )
]
