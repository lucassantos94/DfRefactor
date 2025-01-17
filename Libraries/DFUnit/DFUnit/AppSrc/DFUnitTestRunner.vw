Use DFClient.pkg
Use cRichEdit.pkg
Use cProgressBar.pkg
Use DFUnit.pkg
Use cDFUnitResultList.pkg
Use cDFUnitResultXml.pkg
Use Windows.pkg

Function FilenameFromCommandLine Returns String
    Handle hCmdLine
    String sArgument
    Integer i iNumArgs
    Move (phoCommandLine(ghoApplication)) to hCmdLine
    Get CountOfArgs of hCmdLine to iNumArgs
    For i from 1 to iNumArgs
        Move (Argument(hCmdLine, i)) to sArgument
        If (Lowercase(Left(sArgument, 5)) = "/xml:") Begin
            Function_Return (Mid(sArgument, Length(sArgument) - 5, 6))
        End
    Loop
    Function_Return ""
End_Function

Object oResultXml is a cDFUnitResultXml
    Function XmlResultFileName Returns String
        String sFilename
        Get FilenameFromCommandLine to sFilename
        If (sFilename <> "") Begin
            Function_Return sFilename
        End
        Move (psHome(phoWorkspace(ghoApplication)) + "test_results.xml") to sFilename
        Function_Return sFilename
    End_Function
    Set psDocumentName to (XmlResultFileName(Self))
End_Object

Activate_View Activate_DFUnitTestRunner_vw for DFUnitTestRunner_vw
Object DFUnitTestRunner_vw is a View
    Set Size to 545 279
    Set Location to 0 0
    Set Maximize_Icon to True
    Set Minimize_Icon to False
    Set pbSizeToClientArea to False
    Set pbAutoActivate to True
    
    Object oOutputBox is a cDFUnitResultList
        Set Size to 468 244
        Set Location to 46 13
        Set peAnchors to anAll
    End_Object

    Object oRunTestsButton is a Button
        Set Size to 30 87
        Set Location to 9 12
        Set Label to "Run again"
        Set peAnchors to anNone
        Set psImage to "RunProgram.ico"
        Set piImageSize to 42
//        Set FontPointHeight to 18  
        // We use this instead so we can align in the Studio.
        Set Form_FontWeight to FW_BOLD 
        Set piImageMarginLeft to 15
        Set MultiLineState to True
    
        Procedure OnClick
            Send Execute to (Parent(Self))
        End_Procedure
    
    End_Object

    Object oClose_btn is a Button
        Set Size to 30 61
        Set Location to 9 105
        Set Label to "Exit"
        Set psImage to "ActionExit.ico"
        Set piImageSize to 36
        Set peAnchors to anNone
        Set piImageMarginLeft to 20
    
        Procedure OnClick
            Send Exit_Application    
        End_Procedure
    
    End_Object

    Procedure ScaleFont Integer iDirection 
    End_Procedure 

    On_Key Key_Ctrl+Key_F4 Send None
    On_Key Key_Escape      Send None
End_Object

Object oTestFixtureCatalog is a cTestFixtureCatalog
    Set phTestFixtureNeighborhood to (Parent(Self))
    Send InitTestFixtureCatalog
End_Object

Object oTestFixtureRunner is a cTestFixtureRunner
    Procedure Execute Handle hOutput
        Send OnExecute to hOutput
        Move False to Err
        Send RunTestFixtures
        If (pbFailureOccured(Self)) Begin
            Send OnFail to hOutput
        End
        Else Begin
            Send OnSuccess to hOutput
        End
        Send OnExecuteFinished to hOutput
    End_Procedure
    
    Procedure OutputResults Handle hOutput
        Send OutputResults to hOutput oTestFixtureCatalog
    End_Procedure
    
    Set phTestFixtureCatalog to (oTestFixtureCatalog(Self))
End_Object

Procedure Execute
    Send Execute to oTestFixtureRunner (oOutputBox(DFUnitTestRunner_vw(Self)))
    Send OutputResults to oTestFixtureRunner (oOutputBox(DFUnitTestRunner_vw(Self)))
    Send OutputResults to oTestFixtureRunner oResultXml
End_Procedure
