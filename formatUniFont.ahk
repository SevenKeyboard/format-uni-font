#Requires AutoHotkey v1.1.31+
;==============================================================
; formatUniFont — Unicode "font-style" formatter for ASCII letters/digits
;
; GitHub: https://github.com/SevenKeyboard/format-uni-font
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;
; Documentation / References:
;   Mathematical Alphanumeric Symbols
;     https://symbl.cc/en/unicode/blocks/mathematical-alphanumeric-symbols/
;   Make Highlighted Text Bold, Italic, Serif, Title Case, Sentence Case, & more!
;     https://www.autohotkey.com/boards/viewtopic.php?t=28349
;==============================================================
class VersionManager_formatUniFont
{
    static _ := VersionManager_formatUniFont._init()
    _init()    {
        global
        FORMATUNIFONT_VERSION := "1.0.0"
    }
}
formatUniFont(byRef rawStr, alphaFont, numericFont:="Default")    {
    /*
    List of currently supported fonts
        Mathematical Bold Script
        Mathematical Sans-Serif Bold
        Mathematical Sans-Serif Italic
        
        Unicode Name                   Unicode Number
            Latin Capital Letter A          U+0041
            Latin Capital Letter Z          U+005A
            Latin Small Letter A            U+0061
            Latin Small Letter Z            U+007A
            Digit Zero                      U+0030
            Digit Nine                      U+0039
    */
    stringCaseSense % format("{2}",prevSCS:=A_StringCaseSense,"On")
    if (numericFont="Default")    {
        switch (alphaFont)
        {
            case "Fullwidth Latin":                 numericFont:="Fullwidth Digit"
            case "Mathematical Bold Script":        numericFont:="Mathematical Bold Digit"
            case "Mathematical Sans-Serif Italic":  numericFont:="Mathematical Sans-Serif Digit"
            default:                                numericFont:=alphaFont
        }
    }  else if (numericFont=="")    {
        numericFont:=alphaFont
    }
    loop Parse, % rawStr
    {
        i:=ord(A_LoopField)
        if (0x0030<=i && i<=0x0039)    { ;  A_LoopField~="\d"
            switch (numericFont)
            {
                case "Fullwidth Digit":                     returnStr.=chr(i+0xFF10-0x0030)  ;  0       U+FF10
                case "Mathematical Bold Digit":             returnStr.=chr(i+0x1D7CE-0x0030) ;  0       U+1D7CE
                case "Mathematical Sans-Serif Digit":       returnStr.=chr(i+0x1D7E2-0x0030) ;  0       U+1D7E2
                case "Mathematical Sans-Serif Bold":        returnStr.=chr(i+0x1D7EC-0x0030) ;  0       U+1D7EC
                default:
                    returnStr.=A_LoopField
            }
            continue
        }
        if (isLoopFieldAlpha:=(0x0041<=i && i<=0x005A)?"U" ;  A_LoopField~="[A-Z]"
            :(0x0061<=i && i<=0x007A)?"L" ;  A_LoopField~="[a-z]"
            :false)    {
            switch (alphaFont)
            {
                case "Fullwidth Latin":
                    ;  A        U+FF21
                    ;  Z        U+FF3A
                    ;  a        U+FF41
                    ;  z        U+FF5A
                    returnStr.=(isLoopFieldAlpha=="U")
                                ?chr(i+0xFF21-0x0041)
                                :chr(i+0xFF41-0x0061)
                case "Mathematical Bold Script":
                    ;  A        U+1D4D0
                    ;  Z        U+1D4E9
                    ;  a        U+1D4EA
                    ;  z        U+1D503
                    returnStr.=(isLoopFieldAlpha=="U")
                                ?chr(i+0x1D4D0-0x0041)
                                :chr(i+0x1D4EA-0x0061)
                case "Mathematical Sans-Serif Bold":
                    ;  A        U+1D5D4
                    ;  Z        U+1D5ED
                    ;  a        U+1D5EE
                    ;  z        U+1D607
                    returnStr.=(isLoopFieldAlpha=="U")
                                ?chr(i+0x1D5D4-0x0041)
                                :chr(i+0x1D5EE-0x0061)
                case "Mathematical Sans-Serif Italic":
                    ;  A        U+1D608
                    ;  Z        U+1D621
                    ;  a        U+1D622
                    ;  z        U+1D63B
                    returnStr.=(isLoopFieldAlpha=="U")
                                ?chr(i+0x1D608-0x0041)
                                :chr(i+0x1D622-0x0061)
                    
                default:
                    returnStr.=A_LoopField
            }    
            continue
        }
        switch (alphaFont) ;  exception chars
        {
            case "Fullwidth Latin":
                switch (i)
                {
                    case 0x0020:        returnStr.=chr(0x3000) ;  Space
                    case 0x002E:        returnStr.=chr(0xFF0E) ;  Full Stop
                }
            default:
                returnStr.=A_LoopField
        }
        
    }
    stringCaseSense % prevSCS
    return returnStr
}