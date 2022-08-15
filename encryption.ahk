#SingleInstance, force

;Opening GUI
Gui, Color, 000000
Gui, Add, Button,w175 h50 x25 y12.5, Encrypt a message
Gui, Add, Button,w175 h50 x300 y12.5, Decrypt a file

Gui, Show,w500 h75, Opening Menu | TMC's Encryption
Return
;Open GUI w/ choices to create file or decrypt a file
;--Make file
;	Ask for message in new GUI with text input and have button to submit
;	Ask for password and put it into numbers somehow
;	Put that many random characters in between each actual letter
;	Save it as requested
;	==DONE==
;
;--Decrypt file
;	Prompt for file
;	Prompt for pass
;	Decrypt according to pass but DO NOT SAVE TO COMPUTER
;	--Decryption
;		Remove random characters after number conversion
;	Display decrypted message in GUI

;Functions:
GuiClose:
	ExitApp
Return

ButtonEncryptamessage:
	InputBox, msgToEnc, Message To Encrypt, Type your message to encrypt here.
	InputBox, passwordForEncryption, Password for Encryption, Type your password for encryption here! Remember to make it a significant length and save it somewhere. You can use any characters you want!
	FileSelectFile, storeEncrypted, S, , Save your encrypted message (type a new name), TMC files (*.tmc)
	StringLower, passwordForEncryption, passwordForEncryption
	Len := StrLen(passwordForEncryption)
	Num := 0
	Loop, Parse, passwordForEncryption
	{
 	   ThisNum := Asc(A_LoopField) - 96
 	   Num += (Len - A_Index)
 	   Num := Abs(Num)
	}
	;MsgBox,,,%Num%

	FileAppend, % Insert(RegExReplace(RandomStr(Num), "\W", " "), msgToEnc), %storeEncrypted%.tmc
Return

ButtonDecryptafile:
	FileDelete, decmsg 
	InputBox, passwordForDecryption, Password for Decryption, Type your password for decryption here!
	FileSelectFile, chooseDecrypted,,, Open a message to decrypt, TMC files (*.tmc)

	Len := StrLen(passwordForDecryption)
	Num := 0
	Loop, Parse, passwordForDecryption
	{
	   ThisNum := Asc(A_LoopField) - 96
 	   Num += (Len - A_Index)
 	   Num := Abs(Num)
	}


	FileRead, msgToDec, %chooseDecrypted%
	i := 0
	r := Num

	Loop, Parse, msgToDec
	{
		i := i + 1
		r := r - 1
		ThisChar := A_LoopField
		if (i < 2)
		{
			r := r + 1
			FileAppend, %ThisChar%, decmsg
		}
		else if (r = -1)
		{
			FileAppend, %ThisChar%, decmsg
			r := Num
		}
	}
	FileRead, ldecmsg, decmsg
	MsgBox,,Decrypted Message, %ldecmsg%
	FileDelete, decmsg
Return

Insert(Char, Str)
{
	Loop, Parse, Str
		If (Mod(A_Index, 1) = 0) && (A_Index != StrLen(Str))
			NewStr := NewStr A_LoopField Char
		Else 
			NewStr := NewStr A_LoopField
	Return NewStr
}

RandomStr(l, i = 48, x = 123) { ; length, lowest and highest Asc value
	Loop, %l% {
		Random, r, i, x
		s .= Chr(r)
	}
	Return, s
}