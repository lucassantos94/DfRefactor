Use DFAllEnt.pkg
Use cUnattendedErrorSystem.pkg

Object oApplication is a cApplication
    Set psAutoOpenWorkspace to ""
End_Object
Object oUnattendedErrorSystem is a cUnattendedErrorSystem
    Move Self to Error_Object_Id
    If (IsDebuggerPresent()) Begin
        Set pbShowErrorDialog to True
    End
End_Object

Use cTestFixture.pkg
Use cTest.pkg

Object oMain is a Panel
    
    Property Boolean pbAutoRunTests Public True
    
    Set Label to "DFUnit TestRunner"
    Set Size to 213 433
    
    Object oClientArea is a ClientArea
        Object Total_test_run is a cTestFixture
            
            Use oDFUnitTests.pkg
            
        End_Object
        Use DFUnitTestRunner.vw
    End_Object
    
    Procedure End_Construct_Object
        Forward Send End_Construct_Object
        Handle hoClient
        Get Client_Id to hoClient
        Send Activate_DFUnitTestRunner_vw of hoClient
        If (pbAutoRunTests(Self)) Send Execute to (DFUnitTestRunner_vw(hoClient))
    End_Procedure

End_Object

Start_UI
