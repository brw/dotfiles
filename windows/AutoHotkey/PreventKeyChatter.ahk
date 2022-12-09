#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force
;~ OutputDebug DBGVIEWCLEAR
db := new Debouncer(65)	; Set Debounce Time here
db.AddKey("r")
db.AddKey("l")
db.AddKey("c")
db.AddKey("t")
db.AddKey("f")
return

class Debouncer{
	KeyFns := {}

	__New(debounceTime := 80){
		this.DebounceTime := debounceTime
	}
	
	AddKey(key, pfx := "$*"){
		fn := this.KeyEvent.Bind(this, key, 1)
		hotkey, % pfx key, % fn
		fn := this.KeyEvent.Bind(this, key, 0)
		hotkey, % pfx key " up", % fn
	}
	
	KeyEvent(key, state){
		if (state){
			fn := this.KeyFns[key]
			if (fn != ""){
				; Down event while release timer running - bounce!
				SetTimer, % fn, Off
				;~ OutputDebug % "AHK| Bounce!"
			} else {
				; Down event while release timer not running - normal press
				this.SendKey(key, state)
				;~ OutputDebug % "AHK| Normal press of " key
			}
		} else {
			; Release key - block and set timer running instead
			;~ OutputDebug % "AHK| Release of " key "... Starting timer"
			fn := this.ReleaseKey.Bind(this, key)
			SetTimer, % fn, % - this.DebounceTime
			this.KeyFns[key] := fn
		}
	}
	
	SendKey(key, state){
		Send % "{Blind}{" key (state ? " down" : " up") "}"
	}
	
	; Timer expired before key went back down again - normal release
	ReleaseKey(key){
		this.KeyFns[key] := ""
		this.SendKey(key, 0)
		;~ OutputDebug % "AHK| Timer finished.. " key " released"
	}
}
