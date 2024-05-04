Extension { #name : 'Object' }

{ #category : '*Glorp' }
Object >> asGlorpExpression [
	^GlorpHelper glorpConstantExpressionClass for: self.
]

{ #category : '*Glorp' }
Object >> asGlorpExpressionOn: anExpression [

	^self asGlorpExpression.
]

{ #category : '*Glorp' }
Object >> asGlorpExpressionOn: anExpression basedOn: aMessageArchiver withUltimateBase: aBaseExpression [

	^self asGlorpExpression.
]

{ #category : '*Glorp' }
Object >> glorpBasicSize [
	^self basicSize.
]

{ #category : '*Glorp' }
Object >> glorpCanHaveDescriptorDirectly [
	^self isBehavior.
]

{ #category : '*Glorp-Core' }
Object >> glorpCopyIn: aDictionary [
	"For non-storeForGlorp objects, just copy normally"
	^self copy.
]

{ #category : '*Glorp-Core' }
Object >> glorpEndOfIndexedInstVars [
	"Return the index at which indexed instance variables start. The same as basicSize for most dialects, but funny for ObjectStudio"

	^self basicSize.
]

{ #category : '*Glorp-Core' }
Object >> glorpIsBlock [
	^false.
]

{ #category : '*Glorp' }
Object >> glorpIsCollection [

	^false.
]

{ #category : '*Glorp' }
Object >> glorpPostFetch: aSession [
	"This is a selector that objects can implement in order to receive notification when Glorp has read them."
]

{ #category : '*Glorp' }
Object >> glorpPostFetchValidate: aSession [
	"This allows us to do post-read notification of the objects. Note that if this method explicitly returns a false, then we will treat that as meaning that the object is invalid and should not be read. Yes, this is kind of a hack."
]

{ #category : '*Glorp' }
Object >> glorpPostWrite: aSession [
]

{ #category : '*Glorp' }
Object >> glorpPreWrite: aSession [
	"This is a selector that objects can implement in order to receive notification when Glorp is about to write them. Only objects that have pending modifications will receive this notice. However, note that because of that, the data to be written will have already been calculated before this method is called, which makes it difficult to use this to update the method. If you want to put in audit information (e.g. the time at which the object was written, the associated username) then you probably want to use a generator associated with the field instead. See, for example GlorpRecordWithUpdate in the test suite."
]

{ #category : '*Glorp' }
Object >> glorpPrintSQLOn: aCommand [

	self printOn: aCommand.
]

{ #category : '*Glorp' }
Object >> glorpPrintSelectSQLOn: aCommand [

	self glorpPrintSQLOn: aCommand.
]

{ #category : '*Glorp' }
Object >> glorpRealObject [
	"Return the real object. Will force instantiation of a proxy, even on compilers which inline yourself"
	^self.
]

{ #category : '*Glorp-Core' }
Object >> glorpStartOfIndexedInstVars [
	"Return the index at which indexed instance variables start. 1 for most dialects, but funny for ObjectStudio"
	^1.
]

{ #category : '*Glorp' }
Object >> isGlorpExpression [
	^false.
]

{ #category : '*Glorp' }
Object >> isGlorpProxy [
	^false.
]

{ #category : '*Glorp' }
Object >> needsWork: aString [

	^self.
]

{ #category : '*Glorp' }
Object >> todo [
	"marker"
]

{ #category : '*Glorp' }
Object >> yourSelf [
	"Return the real object. Will force instantiation of a proxy, even on compilers which inline yourself"
	^self.
]
