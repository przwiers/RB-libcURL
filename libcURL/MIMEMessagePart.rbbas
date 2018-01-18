#tag Class
Protected Class MIMEMessagePart
	#tag Method, Flags = &h0
		Sub Constructor(ItemStruct As Ptr, Owner As libcURL.MIMEMessage)
		  ' Constructs a new MIMEMessagePart. Generally, you should not construct instances of
		  ' this class. Use the value returned from MIMEMessage.FirstPart, MIMEMessagePart.NextPart,
		  ' or MIMEMessage.SubPart instead.
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Constructor
		  
		  mOwner = Owner
		  mStruct = ItemStruct
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(OtherMIMEPart As libcURL.MIMEMessagePart) As Integer
		  ' Overloads the comparison operator(=), permitting direct comparisons between instances of MIMEMessagePart.
		  '
		  ' See:
		  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Operator_Compare
		  
		  If OtherMIMEPart Is Nil Then Return 1
		  Return Sign(Integer(mStruct) - Integer(OtherMIMEPart.mStruct))
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' If the message part is a file part (regardless of whether an actual file is used), then this
			  ' property will return the MIMEType being used.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.ContentType
			  
			  Dim mb As MemoryBlock = Struct.MIMEType
			  If mb <> Nil Then Return mb.CString(0)
			End Get
		#tag EndGetter
		ContentType As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' If the message part is not a Readable object, then this property will return a copy of the value.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Data
			  
			  If Me.Type = MIMEPartType.Callback Then Return "" ' callbacks doesn't store the contents
			  Dim mb As MemoryBlock = Struct.Data
			  If mb <> Nil Then
			    If Struct.DataSize > 0 Then
			      Return mb.StringValue(0, Struct.DataSize)
			    Else
			      Return mb.CString(0)
			    End If
			  End If
			End Get
		#tag EndGetter
		Data As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' If the message part is not a Readable object, then this property will return the size of the value.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.DataSize
			  
			  Return Struct.DataSize
			End Get
		#tag EndGetter
		DataSize As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' If the message part is a file part (regardless of whether an actual file is used), then
			  ' this property will return the file name being used.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.FileName
			  
			  Dim mb As MemoryBlock = Struct.FileName
			  If mb <> Nil Then Return mb.CString(0)
			End Get
		#tag EndGetter
		FileName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns the flags for the message part.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Flags
			  
			  Return Struct.Flags
			End Get
		#tag EndGetter
		Flags As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' A list of default headers that will be included with the message part. If no default
			  ' headers were specified then this property will be Nil.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Headers
			  
			  If mHeaders = Nil Then
			    Dim p As Ptr = Struct.Headers
			    If p <> Nil Then mHeaders = New ListPtr(p, mOwner.Flags)
			  End If
			  Return mHeaders
			End Get
		#tag EndGetter
		Headers As libcURL.ListPtr
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mHeaders As libcURL.ListPtr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwner As libcURL.MIMEMessage
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStruct As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUserHeaders As libcURL.ListPtr
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns the name of the message part.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Name
			  
			  Dim mb As MemoryBlock = Struct.Name
			  If mb <> Nil Then
			    If Struct.NameSize > 0 Then
			      Return mb.StringValue(0, Struct.NameSize)
			    Else
			      Return mb.CString(0)
			    End If
			  End If
			End Get
		#tag EndGetter
		Name As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' MIME messages are stored as a linked list. This property allows you to traverse the list from first to last.
			  ' The last part will have Nil as its NextPart.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.NextPart
			  
			  Dim p As Ptr = Struct.NextPart
			  If p <> Nil Then Return New MIMEMessagePart(p, mOwner)
			End Get
		#tag EndGetter
		NextPart As libcURL.MIMEMessagePart
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns a reference to the Readable object from which the message part contents will be read when
			  ' the message is actually sent to a server. If the part Type is not MIMEPartType.Callback then
			  ' this will be Nil.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Stream
			  
			  If Struct.UserData <> Nil Then Return FormStreamGetter(mOwner).GetStream(Struct.UserData)
			End Get
		#tag EndGetter
		Stream As Readable
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mStruct <> Nil Then Return mStruct.curl_mimepart
			End Get
		#tag EndGetter
		Protected Struct As curl_mimepart
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' If the message contains several file parts then this property returns the first extra file. Use the
			  ' NextPart property of the returned MIMEMessagePart to iterate over the file list. If the part
			  ' Type is not MIMEPartType.Multipart then this will be Nil.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.SubPart
			  
			  #pragma Warning "Fixme"
			  'Dim p As Ptr = Struct.MoreFiles
			  'If p = Nil Then Return Nil
			  'Return New MIMEMessagePart(p, mOwner)
			End Get
		#tag EndGetter
		SubPart As libcURL.MIMEMessagePart
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' Returns a member of the MIMEPartType enum.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.Type
			  
			  Return MIMEPartType(Struct.Kind)
			End Get
		#tag EndGetter
		Type As libcURL.MIMEPartType
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ' A list of custom headers that will be included with the message part. If no custom
			  ' headers were specified then this property will be Nil.
			  '
			  ' See:
			  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.MIMEMessagePart.UserHeaders
			  
			  If mUserHeaders = Nil Then
			    Dim p As Ptr = Struct.UserHeaders
			    If p <> Nil Then mUserHeaders = New ListPtr(p, mOwner.Flags)
			  End If
			  Return mUserHeaders
			End Get
		#tag EndGetter
		UserHeaders As libcURL.ListPtr
	#tag EndComputedProperty


	#tag Structure, Name = curl_mimepart, Flags = &h21
		Easy As Integer
		  Parent As Ptr
		  NextPart As Ptr
		  Kind As Integer
		  Data As Ptr
		  ReadFunc As Ptr
		  SeekFunc As Ptr
		  FreeFunc As Ptr
		  UserData As Ptr
		  FilePtr As Ptr
		  Headers As Ptr
		  UserHeaders As Ptr
		  MIMEType As Ptr
		  FileName As Ptr
		  Name As Ptr
		  NameSize As Integer
		  DataSize As UInt32
		  Flags As UInt32
		  State As Integer
		  Encoder As Ptr
		EncoderState As Integer
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="ContentType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Data"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Flags"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
