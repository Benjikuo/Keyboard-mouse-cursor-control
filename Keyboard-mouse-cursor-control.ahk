global Step      := 15
global BigStep   := 25
global SmallStep := 5
global MouseMode := false

ReleaseMods() {
	DllCall("keybd_event", "UChar", 0x5B, "UInt", 0, "UInt", 2, "UPtr", 0) ; LWin up
    DllCall("keybd_event", "UChar", 0xA2, "UInt", 0, "UInt", 2, "UPtr", 0) ; Ctrl up
    DllCall("keybd_event", "UChar", 0xA4, "UInt", 0, "UInt", 2, "UPtr", 0) ; Alt up
    DllCall("keybd_event", "UChar", 0xA0, "UInt", 0, "UInt", 2, "UPtr", 0) ; Shift up
}

ShowFollowTip(text) {
    global FollowText
    FollowText := text
    SetTimer(UpdateTip, 100)
}

HideFollowTip() {
    SetTimer(UpdateTip, 0)
    ToolTip("",,,1)
}

UpdateTip() {
    global FollowText
    MouseGetPos &x, &y
    ToolTip(FollowText, x+20, y+20, 1)
}

^m:: {
	global MouseMode
    MouseMode := !MouseMode
    if MouseMode {
        ShowFollowTip("🖱️Mouse mode")
		AutoStop()
    } else {
        ShowFollowTip("⌨️Keyboard mode")
    }
    SetTimer(() => HideFollowTip(), -1000)
	ReleaseMods()
}

AutoStop() {
	HotIf(*) => MouseMode
	for k, v in StrSplit("BFGHNPRTVYbfghnprtvy0123456789-=[]'/") {
		Hotkey "~" v,(*) => StopMouseMode()
	}
	HotIf
}
StopMouseMode() {
	global MouseMode
	if MouseMode {
		MouseMode := false
		ToolTip "⌨️Keyboard mode 〔Disable on input onther letters〕"
		SetTimer(() => ToolTip(), -3000)
	}
}

SetTimer MoveLoop, 10
MoveLoop() {
    global Step, SmallStep, BigStep
	
	if(MouseMode) {
		dx := 0, dy := 0

		if GetKeyState("i","P")
			dy -= 1
		if GetKeyState("k","P")
			dy += 1
		if GetKeyState("j","P")
			dx -= 1
		if GetKeyState("l","P")
			dx += 1
			
		if GetKeyState("w","P")
			dy -= 1
		if GetKeyState("s","P")
			dy += 1
		if GetKeyState("a","P")
			dx -= 1
		if GetKeyState("d","P")
			dx += 1

		base := GetKeyState("`;","P") ? BigStep
			 :  GetKeyState("Lshift","P") ? BigStep
			 :  GetKeyState("Rshift","P") ? BigStep
			 :  GetKeyState("LAlt","P")  ? SmallStep
			 :  GetKeyState("RAlt","P")  ? SmallStep
			 :  Step
	
		MouseMove dx*base, dy*base, 0, "R"
	}
}


#HotIf MouseMode

*u:: Click "Left"
*o:: Click "Right"
*m:: Click "Middle"
*q:: Click "Left"
*e:: Click "Right"
*z:: Click "Middle"
*Space:: {
    Click "Down Left"
    KeyWait "Space"
    Click "Up Left"
	return
}

*,:: Click "WheelUp"
*.:: Click "WheelDown"
*^,:: Click "WheelLeft"
*^.:: Click "WheelRight"
*x:: Click "WheelUp"
*c:: Click "WheelDown"
*^x:: Click "WheelLeft"
*^c:: Click "WheelRight"

*i:: return
*k:: return
*j:: return
*l:: return
*`;:: return
*w:: return
*a:: return
*s:: return
*d:: return

#HotIf