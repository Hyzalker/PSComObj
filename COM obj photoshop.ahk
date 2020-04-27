#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force



^1::

; execute an action, this one is super simple, just change the "Mask Selection" to your action name and "Default Actions" to your action group.
 app := ComObjActive("Photoshop.Application")
 app.doAction("Mask selection", "Default Actions")

return

^2::
SetBrushSize(20)

return

^3::

SetBrush("grain_2")

return




; Below is the chunk of code I got from the Script Listener when I switched to a different brush called "grain_2", you'll notice I changed to the var "brushName" so I could use it in the function SetBrush().

; var idslct = charIDToTypeID( "slct" );
;     var desc11 = new ActionDescriptor();
;     var idnull = charIDToTypeID( "null" );
;         var ref2 = new ActionReference();
;         var idBrsh = charIDToTypeID( "Brsh" );
;         ref2.putName( idBrsh, "grain_2" );
;     desc11.putReference( idnull, ref2 );
; executeAction( idslct, desc11, DialogModes.NO );

SetBrush(brushName)
{
	app := ComObjActive("Photoshop.Application") ;we need to add this line so ahk can create the COM object targeting photoshop.
	idslct := app.charIDToTypeID( "slct" ) 
	; above I removed the "var" statement from all of the original lines, changed = to := and removed the ; at the ends to make it work with ahk syntax. Also, any photoshop function, in this case charIDToTypeID(), needs to have "app." added before it, which is our ahk COM object.
	    desc11 := ComObjCreate("Photoshop.ActionDescriptor") ; We need to create a new COM object for everything that is created through new on the original code, such as the ActionDescriptor() and ActionReference().
	    idnull := app.charIDToTypeID( "null" ) ; for these following lines you can apply the same concepts I talked about earlier, just a matter of switching the syntax to work with ahk and sometimes creating more com objects.
	        ref2 := ComObjCreate("Photoshop.ActionReference")
	        idBrsh := app.charIDToTypeID( "Brsh" )
	        ref2.putName( idBrsh, brushName )
	    desc11.putReference( idnull, ref2 )
	app.executeAction( idslct, desc11, psDisplayNoDialogs := 3 )  ; Important!  DialogModes.NO was the original 3rd statement, but needs to be replaced by psDisplayNoDialogs for COM to work. Don't remember why.

}




; Below is the function to change the brush size, you can dissect it but it's way more confusing because it was my original try messing with com objects and I didn't bother to organize it.

SetBrushSize(brushSize)
{
app := ComObjActive("Photoshop.Application")

    desc12 := ComObjCreate("Photoshop.ActionDescriptor")
        ref5 := ComObjCreate("Photoshop.ActionReference")
        ref5.putEnumerated( app.charIDToTypeID( "Brsh" ), app.charIDToTypeID( "Ordn" ), app.charIDToTypeID( "Trgt" ) )
        ; originally this > var idBrsh = charIDToTypeID( "Brsh" );   needs to become idBrsh := app.charIDToTypeID( "Brsh" ), or just add above directly as one of the statements
    desc12.putReference( app.charIDToTypeID( "null" ), ref5 )
        desc13 := ComObjCreate("Photoshop.ActionDescriptor")
        desc13.putUnitDouble( app.stringIDToTypeID( "masterDiameter" ), app.charIDToTypeID( "#Pxl" ), brushSize)
    desc12.putObject( app.charIDToTypeID( "T   " ), app.charIDToTypeID( "Brsh" ), desc13 )
app.executeAction( app.charIDToTypeID( "setd" ), desc12, psDisplayNoDialogs := 3 ) ; DialogModes.NO was original, needs to become psDisplayNoDialogs := 3                          
}