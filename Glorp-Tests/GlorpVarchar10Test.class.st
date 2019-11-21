Class {
	#name : #GlorpVarchar10Test,
	#superclass : #GlorpDatabaseTypeIndividualDBTests,
	#category : 'Glorp-Tests-DatabaseTypes'
}

{ #category : #types }
GlorpVarchar10Test >> defaultDatabaseType [
	^self platform varchar: 10.
]

{ #category : #tests }
GlorpVarchar10Test >> testVarCharWithEscapedCharacters [
	stType := String.
	self helpTestValue: nil.
	#($\ $~ $` $! $@ $# $$ $% $^ $& $* $( $) $_ $- $+ $= $| $} ${ $] $[ $" $' $: $; $? $/ $> $. $< $,)
		do: [:ea | self helpTestValue: 'abc' , (String with: ea) , 'def']
]
