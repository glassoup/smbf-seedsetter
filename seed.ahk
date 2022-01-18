#Include <classMemory>
SetWorkingDir %A_ScriptDir%

if (_ClassMemory.__Class != "_ClassMemory")
{
msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
ExitApp
}

f1::
{
if !FileExist("seed.txt")
	msgbox, seed.txt is missing

seedFile := FileOpen("seed.txt", "r")
seedTarget := []
loop 8 {
	seedTarget[A_Index] := Format("{:i}", "0x" seedFile.read(1))
}
seedFile.close()

if WinExist("Super Meat Boy Forever v. 6202.1271.1563.138") {
	smbf := new _ClassMemory("Super Meat Boy Forever v. 6202.1271.1563.138", "", hProcessCopy)
	memoryOffset := 0x5E2540
} else if WinExist("Super Meat Boy Forever v. 6314.1573.1853.145") {
	smbf := new _ClassMemory("Super Meat Boy Forever v. 6314.1573.1853.145", "", hProcessCopy)
	memoryOffset := 0x558370
}

addressArr := []
addressArr[1] := smbf.baseAddress + memoryOffset
loop 7 {
	addressArr[A_Index + 1] := (addressArr[A_Index] + 8)
}
seedArr := []
loop 8 {
	seedArr[A_Index] := (smbf.read(addressArr[A_Index], "UChar", 0x18))
}

send {LCtrl down}
sleep 20
send {LCtrl up}
sleep 50
loop 8 {
	diff := seedArr[A_Index] - seedTarget[A_Index]
	isDown := true
	if (diff < 0) {
		diff := abs(diff)
		isDown := !isDown
	}
	if (diff > 8) {
		diff := 16 - diff
		isDown := !isDown
	}
	dirKey = Down
	if !isDown
	  dirKey = Up
	loop % diff {
		send {%dirKey% down}
		sleep 20
		send {%dirKey% up}
		sleep 50
	}
	send {Right down}
	sleep 20
	send {Right up}
	sleep 50
}
return
}
