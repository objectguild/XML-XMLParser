"
A write stream adapter that encodes stream contents using a stream converter.
"
Class {
	#name : #XMLEncodingWriteStreamAdapter,
	#superclass : #XMLWriteStreamAdapter,
	#instVars : [
		'streamConverter'
	],
	#category : #'XML-Parser-Streams'
}

{ #category : #'instance creation' }
XMLEncodingWriteStreamAdapter class >> on: aStream [
	^ self
		on: aStream
		streamConverter: XMLStreamConverter default
]

{ #category : #'instance creation' }
XMLEncodingWriteStreamAdapter class >> on: aStream streamConverter: aStreamConverter [
	^ self new
		on: aStream;
		streamConverter: aStreamConverter
]

{ #category : #private }
XMLEncodingWriteStreamAdapter >> basicNextPut: aCharacter [
	stream nextPut: aCharacter
]

{ #category : #private }
XMLEncodingWriteStreamAdapter >> basicNextPutByte: aByteValue [
	self basicNextPut: (Character value: aByteValue)
]

{ #category : #testing }
XMLEncodingWriteStreamAdapter >> hasDefaultStreamConverter [
	^ streamConverter isDefault
]

{ #category : #testing }
XMLEncodingWriteStreamAdapter >> isConvertingStreamAdapter [
	^ true
]

{ #category : #accessing }
XMLEncodingWriteStreamAdapter >> nextPut: aCharacter [
	streamConverter
		nextPut: aCharacter
		toStream: self.
	^ aCharacter.
]

{ #category : #accessing }
XMLEncodingWriteStreamAdapter >> nextPutAll: aCollection [
	"to:do: for speed"
	1 to: aCollection size do: [:i | self nextPut: (aCollection at: i)].
	^ aCollection.
]

{ #category : #accessing }
XMLEncodingWriteStreamAdapter >> nextPutByteOrderMark [
	streamConverter nextPutByteOrderMarkToStream: self
]

{ #category : #printing }
XMLEncodingWriteStreamAdapter >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: streamConverter;
		nextPut: $).
]

{ #category : #accessing }
XMLEncodingWriteStreamAdapter >> streamConverter [
	^ streamConverter
]

{ #category : #accessing }
XMLEncodingWriteStreamAdapter >> streamConverter: aStreamConverter [
	streamConverter :=
		(aStreamConverter ifNil: [XMLNullStreamConverter new])
]