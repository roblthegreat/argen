#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Close()
		  try
		    DB.Close
		    
		  catch
		    
		  end try
		End Sub
	#tag EndEvent

	#tag Event
		Sub NewDocument()
		  winProjectList.Show
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  // Setup platform specific needs
		  DisableMacosTabs
		  SetupWindowMenu
		  
		  // Load preferences
		  SetupSettings
		  
		  // Connect to the main database
		  if SetupMainConnection = false then
		    App.Terminate
		    return
		    
		  end
		  // Now that this is all done, AutoQuit=true
		  App.AutoQuit = TargetWindows Or TargetLinux
		  
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditPreferences() As Boolean Handles EditPreferences.Action
			winPrefs.show
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpAboutARGen() As Boolean Handles HelpAboutARGen.Action
			winAbout.Show
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpUsersGuide() As Boolean Handles HelpUsersGuide.Action
			var fHelp as FolderItem = SpecialFolder.Resources.Child("Help Book").Child("index.html")
			
			if fHelp <> nil and fHelp.Exists = true then
			#If TargetMacOS And useMBS Then
			// What opens websites?
			Var tsAppPath As String = NSWorkspaceMBS.URLForApplicationToOpenURL("https://strawberrysw.com")
			
			// Strip file://
			tsAppPath = tsAppPath.Right(tsAppPath.Len - 7)
			
			// Get bundle
			var toBundle as NSBundleMBS = NSBundleMBS.bundleWithPath(tsAppPath)
			if toBundle <> nil then
			if NSWorkspaceMBS.openURL(fHelp.URLPath, toBundle.bundleIdentifier) then
			// Success!
			return true
			
			end
			
			end
			
			#endif
			
			fHelp.Launch
			
			else
			// Could not find built in help, revert to website.
			MsgBox("Help Not Available")
			
			end
			
			return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpWebsite() As Boolean Handles HelpWebsite.Action
			ShowURL("https://strawberrysw.com/argen")
			
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function WindowProjectList() As Boolean Handles WindowProjectList.Action
			winProjectList.Show
			
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Function BuildDateTime() As DateTime
		  // Manually set the build date so that changing the 
		  // modification date doesn't circumvent the DRM
		  const kYear  = 2021
		  const kMonth = 04
		  const kDay   = 02
		  
		  #if DebugBuild then
		    return DateTime.Now
		    return new DateTime(1970, 01, 01)
		    
		  #else
		    return new DateTime(kYear, kMonth, kDay)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DataFolder() As FolderItem
		  // App Support folder
		  static sIdentifier as String = "com.strawberrysw.argen"
		  
		  #if TargetMacOS then
		    return SpecialFolder.ApplicationData.Child(sIdentifier)
		    
		  #elseif TargetWin32 then
		    return SpecialFolder.ApplicationData.Child(sIdentifier)
		    
		  #ElseIf TargetLinux Then
		    return SpecialFolder.ApplicationData.Child("." + sIdentifier)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DisableMacosTabs()
		  // https://forum.xojo.com/conversation/post/396640 source
		  
		  #if TargetCocoa then
		    Declare Function NSClassFromString Lib "Cocoa" (s As CFStringRef) As Ptr
		    Declare Function NSSelectorFromString Lib "Cocoa" (s As CFStringRef) As Ptr
		    Declare Sub setAllowsAutomaticWindowTabbing Lib "Cocoa" selector "setAllowsAutomaticWindowTabbing:" (cls As Ptr, ena As Boolean)
		    Declare Function respondsToSelector Lib "Cocoa" selector "respondsToSelector:" (p As Ptr, sel As Ptr) As Boolean
		    
		    var nswCls As Ptr = NSClassFromString ("NSWindow")
		    if respondsToSelector (nswCls, NSSelectorFromString ("setAllowsAutomaticWindowTabbing:")) then
		      setAllowsAutomaticWindowTabbing (nswCls, False)
		      
		    end
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SetupMainConnection() As Boolean
		  // Connect to main database
		  // Return false to quit
		  DataFile.OpenDB
		  
		  if DataFile.DB = nil then
		    MsgBox("Initialization Error" + EndOfLine + EndOfLine + _
		    "Could not connect to the central data storage.")
		    App.Terminate
		    return false
		    
		  end
		  
		  return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupSettings()
		  // Create the app dir if needed
		  if App.DataFolder.Exists = false then
		    App.DataFolder.CreateAsFolder
		    
		  end
		  
		  TPSettings.Load
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupWindowMenu()
		  
		  #If TargetMacOS And useMBS Then
		    // Set the Window menu
		    Var oNSMenuItemMaster As New NSMenuItemMBS(mbMain.Handle(MenuItem.HandleType.CocoaNSMenuItem))
		    Var mnuMain As NSMenuMBS = oNSMenuItemMaster.submenu
		    
		    Var iMax As Integer = mnuMain.numberOfItems - 1
		    For i As Integer = 0 To iMax
		      Var oThisItem As NSMenuItemMBS = mnuMain.Item(i)
		      If oThisItem.Title = "Window" And oThisItem.hasSubmenu = True Then
		        Var mnuWindow As NSMenuMBS = oThisItem.submenu
		        If mnuWindow <> Nil Then
		          NSApplicationMBS.sharedApplication.windowsMenu = mnuWindow
		          
		        End
		        
		        Exit For i
		        
		      End
		      
		    Next i
		    
		    // File menu is empty, Quit is in the App menu
		    mbMain.Child("FileMenu").Close
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Terminate()
		  #if TargetMacOS then
		    declare function NSClassFromString lib "Cocoa" (aClassName as CFStringRef) as Integer
		    declare function sharedApplication lib "Cocoa" selector "sharedApplication" (classRef as Integer) as Integer
		    declare sub terminate lib "Cocoa" selector "terminate:" (appRef as Integer, sender as Integer)
		    
		    var iPID as Integer = sharedApplication(NSClassFromString("NSApplication"))
		    terminate(iPID, iPID)
		    
		  #else
		    Quit
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VersionString() As String
		  var sVersion as String = Str(App.MajorVersion) + "." + _
		  Str(App.MinorVersion) + "." + _
		  Str(App.BugVersion) + "." + _
		  Str(App.NonReleaseVersion)
		  
		  return sVersion
		End Function
	#tag EndMethod


	#tag Note, Name = useMBS_const
		If you have a license for MBS plugins, you can set the value of the useMBS constant 
		in the modGlobals module from the default value of 'false' to 'true'.
		
	#tag EndNote


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant

	#tag Constant, Name = kPrefs, Type = String, Dynamic = False, Default = \"Preferences...", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Options"
	#tag EndConstant

	#tag Constant, Name = kPrefsShortCut, Type = String, Dynamic = False, Default = \"\x2C", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"H"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
