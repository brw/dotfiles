#MenuMaskKey vkFF
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"

#Z::  Winset, Alwaysontop, , A