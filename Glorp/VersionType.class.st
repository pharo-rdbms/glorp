"
This represents the type of something used for a version field.

Instance Variables:
	underlyingType	<DatabaseType>	The underlying type of our field.
	sequence <> The generator used to generate the next value.


"
Class {
	#name : #VersionType,
	#superclass : #GlorpDatabaseType,
	#instVars : [
		'underlyingType',
		'generator',
		'generatesOverExistingValues'
	],
	#category : 'Glorp-Database'
}

{ #category : #'as yet unclassified' }
VersionType class >> underlyingType: aDatabaseType [
	^self new underlyingType: aDatabaseType.
]

{ #category : #'as yet unclassified' }
VersionType class >> underlyingType: aDatabaseType generator: aGenerator [
	^self new underlyingType: aDatabaseType generator: aGenerator.
]

{ #category : #converting }
VersionType >> converterForStType: aClass [

	^underlyingType converterForStType: aClass.
]

{ #category : #testing }
VersionType >> generateOverExistingValues [
	generatesOverExistingValues := true.
]

{ #category : #testing }
VersionType >> generatesOverExistingValues [
	"Do we generate our value even if there's alread one present in the field"
	^generatesOverExistingValues.
]

{ #category : #testing }
VersionType >> generatesOverExistingValues: aBoolean [
	"Do we generate our value even if there's alread one present in the field"
	generatesOverExistingValues := aBoolean.
]

{ #category : #accessing }
VersionType >> generator [
	^generator
]

{ #category : #accessing }
VersionType >> generator: aDatabaseValueGenerator [
	generator := aDatabaseValueGenerator
]

{ #category : #initializing }
VersionType >> generatorFor: aDatabaseType [
	aDatabaseType impliedSmalltalkType == Integer ifTrue: [^VersionNumberVersionGenerator new].
	aDatabaseType impliedSmalltalkType == Dialect timestampClass ifTrue: [^TimestampVersionGenerator new].
	self error: 'unknown version type'.
]

{ #category : #testing }
VersionType >> hasParameters [
	"Instances of this class are not cached, so this implementor is less often than others.  However the method is also used by regenerators to determine bracketting."

	^true
]

{ #category : #initializing }
VersionType >> initialize [
	super initialize.
	generatesOverExistingValues := false.
]

{ #category : #testing }
VersionType >> isGenerated [
	^true.
]

{ #category : #sequencing }
VersionType >> postWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	^self.
]

{ #category : #sequencing }
VersionType >> preWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor [

	^generator preWriteAssignSequenceValueFor: aDatabaseField in: aDatabaseRow using: anAccessor.
]

{ #category : #SQL }
VersionType >> print: aValue on: aStream [
	self underlyingType print: aValue on: aStream.
]

{ #category : #SQL }
VersionType >> typeString [
	^underlyingType typeString.
]

{ #category : #accessing }
VersionType >> underlyingType [
	^underlyingType
]

{ #category : #accessing }
VersionType >> underlyingType: aDatabaseType [
	underlyingType := aDatabaseType.
	platform := aDatabaseType platform.
	generator := self generatorFor: aDatabaseType.
]

{ #category : #accessing }
VersionType >> underlyingType: aDatabaseType generator: aGenerator [
	underlyingType := aDatabaseType.
	platform := aDatabaseType platform.
	generator := aGenerator.
]

{ #category : #accessing }
VersionType >> width [
	^self underlyingType width.
]
