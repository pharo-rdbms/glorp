Class {
	#name : #GlorpTypeComparisonTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'platform'
	],
	#category : #'Glorp-Unit-Tests-DatabaseTypes'
}

{ #category : #running }
GlorpTypeComparisonTest >> setUp [

	super setUp.
	platform := DatabasePlatform new
]

{ #category : #testing }
GlorpTypeComparisonTest >> testIntegerToInteger [

	self
		assert: (GlorpIntegerType new platform: platform)
		equals: (GlorpIntegerType new platform: platform).
	self
		assert: (GlorpIntegerType new platform: platform) hash
		equals: (GlorpIntegerType new platform: platform) hash
]

{ #category : #testing }
GlorpTypeComparisonTest >> testIntegerToIntegerishNumber [

	self
		assert: (GlorpIntegerType new platform: platform)
		equals: (GlorpNumericType new platform: platform).
	self
		assert: (GlorpIntegerType new platform: platform) hash
		equals: (GlorpNumericType new platform: platform) hash.
	self
		assert: (GlorpNumericType new platform: platform)
		equals: (GlorpIntegerType new platform: platform).
	self
		assert: (GlorpNumericType new platform: platform) hash
		equals: (GlorpIntegerType new platform: platform) hash
]

{ #category : #testing }
GlorpTypeComparisonTest >> testIntegerToNumber [

	self
		deny: (GlorpIntegerType new platform: platform)
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2).
	self
		deny: (GlorpIntegerType new platform: platform) hash
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash.
	self
		deny: (GlorpNumericType new
				 platform: platform;
				 precision: 2)
		equals: (GlorpIntegerType new platform: platform).
	self
		deny: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash
		equals: (GlorpIntegerType new platform: platform) hash
]

{ #category : #testing }
GlorpTypeComparisonTest >> testIntegerishNumberToNumber [

	self
		deny: (GlorpNumericType new platform: platform)
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2).
	self
		deny: (GlorpNumericType new platform: platform) hash
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash.
	self
		deny: (GlorpNumericType new
				 platform: platform;
				 precision: 2)
		equals: (GlorpNumericType new platform: platform).
	self
		deny: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash
		equals: (GlorpNumericType new platform: platform) hash
]

{ #category : #testing }
GlorpTypeComparisonTest >> testNumberToNumber [

	self
		assert: (GlorpNumericType new
				 platform: platform;
				 precision: 2)
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2).
	self
		assert: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash.
	self
		assert: (GlorpNumericType new
				 platform: platform;
				 precision: 2)
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2).
	self
		assert: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash
		equals: (GlorpNumericType new
				 platform: platform;
				 precision: 2) hash
]
