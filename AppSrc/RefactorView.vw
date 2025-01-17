Use cRefactorDbView.pkg
Use Cursor.pkg
Use dfLine.pkg
Use cCJCommandBarSystem.pkg
Use DFEnChk.pkg
Use dfTabDlg.pkg

Use cRDCDbCJGrid.pkg  
Use cRDCDbCJGridColumn.pkg
Use cRDCCJSelectionGrid.pkg
Use cRDCDbComboForm.pkg
Use cRDCDbHeaderGroup.pkg
Use cRDCDbForm.pkg
Use cRDCDbSpinForm.pkg
Use cRDCButton.pkg
Use cRDCForm.pkg
Use StatusLog.dg

Use cFunctionsDataDictionary.dd
Use cSysFileDataDictionary.dd
Use cFolderSelHeaDataDictionary.dd
Use cFolderSelDtlDataDictionary.dd

Enum_List
    Integer Ico_Folders
    Integer Ico_Functions
End_Enum_List

Object oImageList is a cImageList32
    Set piMaxImages to 2
    Set piImageHeight to 24
    Set piImageWidth to 24
    Procedure OnCreate
        Get AddImage "Folder.ico"          to Ico_Folders
        Get AddImage "FunctionLibrary.ico" to Ico_Functions
    End_Procedure
End_Object

Activate_View Activate_oRefactorView for oRefactorView
Object oRefactorView is a cRefactorDbView
    Set Location to 1 0
    Set Size to 315 642
    Set Label to "Refactoring Selections"
    Set Icon to "DFRefactor.ico"
    Set pbAcceptDropFiles to True
    Set Auto_Clear_DEO_State to False  
    Set Auto_Top_Panel_State to False
    Set phoRefactorView of ghoApplication to Self   
    
    Object oSysFile_DD is a cSysFileDataDictionary
    End_Object

    Object oFolderSelHea_DD is a cFolderSelHeaDataDictionary
        Set private.phoFolderSelHeaDD of ghoApplication to Self
    End_Object

    Object oFolderSelDtl_DD is a cFolderSelDtlDataDictionary
        Set DDO_Server to oFolderSelHea_DD
    End_Object

    Object oFunctions_DD is a cFunctionsDataDictionary  
        
        Procedure Request_Save
            Send Request_Save of oSysFile_DD
            Forward Send Request_Save
        End_Procedure
        
        Procedure OnConstrain
            If (piFunctionType(Self) <> eAll_Functions) Begin
                Constrain Functions.Type eq (piFunctionType(Self))
            End
        End_Procedure
    End_Object

    Procedure Request_Save
        Send Request_Save of oFunctions_DD
    End_Procedure
    
    Set Main_DD to oFunctions_DD
    Set Server to oFunctions_DD
                                    
    // *** BPO Object ***
    #Include oBPO.pkg
                                    
    Object oMain_TabDialog is a dbTabDialog
        Set Size to 258 642
        Set piMinSize to 140 510
        Set Location to 0 -2
        Set Rotate_Mode to RM_Rotate
        Set peAnchors to anAll
        Set Auto_Clear_DEO_State to False  
        Set Auto_Top_Panel_State to False
        Set phoImageList to oImageList
        Set Default_Tab to -1

        Object oSelectFunctions_tp is a dbTabPage
            Set Label to "Select Functions"

            Object oSelectFunctions_grp is a cRDCDbHeaderGroup
                Set Size to 239 634
                Set piMinSize to 126 490
                Set Location to 4 0
                Set Label to "Function List"             
                Set psImage to "FunctionLibrary.ico"
                Set psNote to "Select functions. Right click grid for options."
                Set psToolTip to "Standard refactoring functions are functions that are called once for each source line."
                Set Border_Style to Border_None
                Set peAnchors to anAll
                Set piImageIndex to Ico_Functions

Register_Procedure RefreshSelectionUpdate

                Object oFunctionSelection_grd is a cRDCDbCJGrid
                    Set Size to 211 621
                    Set Location to 27 10
                    Set Ordering to 5
                    Set pbAllowAppendRow to False
                    Set pbAllowDeleteRow to False
                    Set pbAllowInsertRow to False
                    Set pbAutoAppend to False
                    Set pbEditOnTyping to False
                    Set piLayoutBuild to 4
                    Set pbHeaderReorders to True
                    Set pbHeaderTogglesDirection to True
                        
                    Procedure Activating
                        Forward Send Activating  
                        Send DoChangeFontSize
                    End_Procedure
            
                    Object oFunctions_ID is a cRDCDbCJGridColumn
                        Entry_Item Functions.ID
                        Set piWidth to 32
                        Set psCaption to "ID"
                        Set pbEditable to False
                    End_Object

                    Object oFunctions_Function_Name is a cRDCDbCJGridColumn
                        Entry_Item Functions.Function_Name
                        Set piWidth to 291
                        Set psCaption to "Function Name"
                        Set pbEditable to False   
                        Set phoData_Col to Self   
                        Set psToolTip to "The name of the refactoring function. Hover the mouse over a function row to see more help on what it does."
                                    
                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Get RowValue of oFunctions_Function_Help iRow to sText
                            Function_Return sText
                        End_Function
            
                    End_Object
                        
                    Object oFunctions_Function_Description is a cRDCDbCJGridColumn
                        Entry_Item Functions.Function_Description
                        Set piWidth to 397
                        Set psCaption to "Description"
                        Set pbEditable to False
                        Set psToolTip to "A short description of whate the refactoring function does. Hover the mouse over a function row to see more help on what it does."
            
                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Get RowValue of oFunctions_Function_Help iRow to sText
                            Function_Return sText
                        End_Function
            
                    End_Object

                    Object oFunctions_Type is a cRDCDbCJGridColumn
                        Entry_Item Functions.Type
                        Set piWidth to 154
                        Set psCaption to "Type"
                        Set peHeaderAlignment to xtpAlignmentCenter  
                        Set pbComboButton to True
                        Set psToolTip to "The function type rules how data is feed to the function. For 'Standard' and 'Remove' functions one source line at a time are send. To others either a full source file as a string array is passed, or the last option is to pass all selected files as a string array with full pathing."
            
                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Get RowValue of oFunctions_Function_Help iRow to sText
                            Function_Return sText
                        End_Function
            
                    End_Object                    

                    Object oFunctions_Parameter is a cDbCJGridColumn
                        Entry_Item Functions.Parameter
                        Set piWidth to 74
                        Set psCaption to "Option"
                        Set psToolTip to "For some functions an extra parameter can be passed. You can only change existing values. Hover the mouse over a value to see valid values to be selected from."
            
                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Get RowValue of oFunctions_ParameterHelp iRow to sText
                            Move (Replaces("\n", sText, CS_CRLF)) to sText
                            Function_Return sText
                        End_Function
            
                    End_Object

                    Object oFunctions_ParameterHelp is a cDbCJGridColumn
                        Entry_Item Functions.ParameterHelp
                        Set piWidth to 200
                        Set psCaption to "Parameter Help"
                        Set pbVisible to False
                    End_Object

                    Object oFunctions_Function_Help is a cRDCDbCJGridColumn
                        Entry_Item Functions.Function_Help
                        Set piWidth to 221
                        Set psCaption to "Help"
                        Set pbVisible to False
                    End_Object
            
                    Object oFunctions_Selected is a cRDCDbCJGridColumn
                        Entry_Item Functions.Selected
                        Set piWidth to 87
                        Set psCaption to "Select"
                        Set pbCheckbox to True
                        Set peHeaderAlignment to xtpAlignmentCenter  
                        Set phoCheckbox_Col to Self
                        Set peFooterAlignment to  xtpAlignmentCenter
            
                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Get RowValue of oFunctions_Function_Help iRow to sText
                            Function_Return sText
                        End_Function
            
                    End_Object

                    Procedure Refresh Integer eMode
                        Integer iChecked iSelectedFolders
                        Forward Send Refresh eMode
                        Set Value of oNoOfSelectedFunctions2_fm to SysFile.SelectedFunctionTotal
                        Get CheckedItems of oFolders_grd to iSelectedFolders
                        Set Value of oNoOfSelectedFolders_fm to iSelectedFolders
                    End_Procedure
                                
                End_Object

                Object oSelectAll_btn is a Button
                    Set Size to 14 62
                    Set Location to 10 267
                    Set Label to "Select All"
                    Set psImage to "SelectAll.ico"
                    Set peAnchors to anTopRight
                    Procedure OnClick
                        Send SelectAll of (Main_DD(Self))
                        Send RefreshSelectionUpdate of oFunctionSelection_grd
                    End_Procedure
                End_Object

                Object oDeselectAll_btn is a Button
                    Set Size to 14 62
                    Set Location to 10 333
                    Set Label to "Select None"
                    Set psImage to "SelectNone.ico"
                    Set peAnchors to anTopRight
                    Procedure OnClick
                        Send DeSelectAll of (Main_DD(Self))
                        Send RefreshSelectionUpdate of oFunctionSelection_grd
                    End_Procedure
                End_Object

                Object oConstrainByType_cf is a ComboForm
                    Set Size to 14 99
                    Set Location to 10 461
                    Set peAnchors to anTopRight
                    Set Label_Col_Offset to 2
                    Set Label_Justification_Mode to JMode_Right
                    Set Label to "Constrain by Type:"
                    Set Entry_State to False
                    Set Combo_Sort_State to False
                  
                    Procedure Combo_Fill_List
                        Send Combo_Add_Item CS_All_Functions
                        Send Combo_Add_Item CS_Standard_Function
                        Send Combo_Add_Item CS_Remove_Function
                        Send Combo_Add_Item CS_Editor_Function
                        Send Combo_Add_Item CS_Report_Function   
                        Send Combo_Add_Item CS_Report_FunctionAll
                        Send Combo_Add_Item CS_Other_Function   
                        Send Combo_Add_Item CS_Other_FunctionAll
                    End_Procedure
                  
                    Procedure OnChange
                        String sValue                      
                        Integer iType
                        
                        Get Value to sValue
                        Case Begin
                            Case (sValue = CS_All_Functions)
                                Move eAll_Functions to iType
                                Case Break
                            Case (sValue = CS_Standard_Function)
                                Move eStandard_Function to iType
                                Case Break
                            Case (sValue = CS_Remove_Function)
                                Move eRemove_Function to iType
                                Case Break                            
                            Case (sValue = CS_Editor_Function)
                                Move eEditor_Function to iType
                                Case Break
                            Case (sValue = CS_Report_Function)
                                Move eReport_Function to iType
                                Case Break
                            Case (sValue = CS_Report_FunctionAll)
                                Move eReport_FunctionAll to iType
                                Case Break
                            Case (sValue = CS_Other_Function)
                                Move eOther_Function to iType
                                Case Break
                            Case (sValue = CS_Other_FunctionAll)
                                Move eOther_FunctionAll to iType
                                Case Break
                            Case Else
                        Case End
                            
                        Set piFunctionType of (Main_DD(Self)) to iType
                        Send Rebuild_Constraints of (Main_DD(Self)) 
                        Send RefreshDataFromDD of oFunctionSelection_grd 0
                    End_Procedure
                  
                End_Object
    
                Object oDisabledInfo_txt is a TextBox
                    Set Auto_Size_State to False
                    Set Size to 22 100
                    Set Location to 2 153
                    Set Justification_Mode to JMode_Left
                    Set FontWeight to fw_Bold
                    Set peAnchors to anTopRight
                    
                    Object oDisabledInfo_Idle is an cIdleHandler
                        Set pbEnabled to True
                        Procedure OnIdle
                            String sText sSWSFile 
                            Boolean bSelected
                            
                            Get Field_Current_Value of oSysFile_DD Field SysFile.bCountSourceLines to bSelected
                            If (bSelected = True) Begin
                                Move 'Grid Disabled! Function: "Only count Source Lines" is selected!' to sText
                            End                 
                            Else Begin
                                Move "" to sText
                            End
                            Set Value of oDisabledInfo_txt to sText  
                            Get psSWSFile of ghoApplication to sSWSFile
                            Set Enabled_State of oFunctionSelection_grd to (sSWSFile <> "" and bSelected = False)  
                        End_Procedure
                    End_Object
            
                End_Object
                
            End_Object
                    
        End_Object
        
        Object oFolders_tp is a dbTabPage
            Set Label to "Select Folders"
            Set piImageIndex to Ico_Folders
            Set pbAcceptDropFiles to True

            Procedure OnFileDropped String sFileFolderName Boolean bLast
                String sFileExt
                Boolean bFile bFolder
        
                Delegate Send OnFileDropped sFileFolderName bLast
            End_Procedure
    
            Object oSourceFolders_grp is a cRDCDbHeaderGroup
                Set Location to 4 0
                Set Size to 233 634
                Set Label to "Folders List"
//                Set Label to "Select Source Code Folders"
                Set psImage to "Folder.ico"
                Set psNote to "Select Folders. Right click grid for options"
                Set psToolTip to "You can add a folder with drag and drop from Windows Explorer, or by using the right-click mouse menu."
                Set peAnchors to anAll
                Set Border_Style to Border_None
                Set piMinSize to 126 490
    
                Object oFolders_grd is a cRDCCJSelectionGrid
                    Set Size to 204 621
                    Set Location to 27 9
                    Set psNoItemsText to "No Workspace selected yet..."
                    Set pbShowAddFolderMenuItem to True
                    Set pbShowRemoveFolderMenuItem to True 

                    Object oCJGridColumnRowIndicator is a cCJGridColumnRowIndicator
                        Set piWidth to 30
                    End_Object

                    Object oFoldername_Col is a cCJGridColumn
                        // NOTE: This must be set here for selections to work!
                        Set phoData_Col to Self
                        Set piWidth to 797
                        Set psCaption to "Folder Name"
                        Set psToolTip to "The process will run on all files that match the 'File Extensions Filter' comboform for the selected folders and all subfolders"
                        Set pbEditable to False
                        Set psFooterText to "No of Folders Selected:"

                        Function OnGetTooltip Integer iRow String sValue String sText Returns String
                            Move "The process will run on all files that match the 'File Extensions Filter' comboform for the selected folders and all subfolders" to sText
                            Function_Return sText
                        End_Function
                        
                        Procedure Set psFooterText String sValue  
                            Integer iPos
                            String sFolderNo
                            
                            Move "0" to sFolderNo
                            Forward Set psFooterText to sValue
                            Move (Pos(":", sValue)) to iPos
                            If (iPos <> 0) Begin
                                Move (Mid(sValue, 6, (iPos + 1))) to sFolderNo
                                Move (Pos(" of ", sFolderNo)) to iPos
                                If (iPos <> 0) Begin
                                    Move (Left(sFolderNo, iPos)) to sFolderNo
                                    Move (Trim(sFolderNo)) to sFolderNo        
                                End
                            End
                            Set Value of oNoOfSelectedFolders_fm to sFolderNo
                        End_Procedure

                    End_Object

                    // A "oCheckbox_Col" column is created automatically by the cRDCCJGrid class.
                    // Object oCheckbox_Col is a cCJGridColumn
                    // End_Object

                    Procedure LoadData
                        String sHomePath sFolderName sDefaultFolders
                        String[] asNoFolderList asStartFolder asFolderArray asDefaultFolders asSavedFolders
                        Handle hoDataSource hoFolderSelHeaDD
                        tDataSourceRow[] TheData TheDataEmpty
                        Integer iSize iRow iCount iSavedSize iFolderCol iCheckBoxCol iDefaultFolders iFolder
                        Boolean bChecked bUseDDO bExists

                        If (not(IsComObjectCreated(Self))) Begin
                            Procedure_Return
                        End

                        Get psWorkspaceHomePath of ghoApplication to sHomePath
                        If (sHomePath = "") Begin
                            Procedure_Return
                        End

                        Send Cursor_Wait of Cursor_Control
                        Get vFolderFormat sHomePath to sHomePath
                        Move sHomePath to asStartFolder[0]
                        Get AllSourceFolders of ghoApplication asStartFolder to asFolderArray
                        Move (SizeOfArray(asFolderArray)) to iSize
                        If (iSize = 0) Begin
                            Send Cursor_Ready of Cursor_Control
                            Procedure_Return
                        End
                        Decrement iSize   
                        
                        // If saved folders exists, they have previously been selected and
                        // will take precedense over other "standard" selections
                        // in the loop below.
                        Move 0 to iSavedSize
                        Get private.phoFolderSelHeaDD of ghoApplication to hoFolderSelHeaDD
                        Move (hoFolderSelHeaDD <> 0) to bUseDDO
                        If (bUseDDO = True) Begin
                            Get psHomePath of ghoApplication to sHomePath 
                            Get IsSavedFolders of hoFolderSelHeaDD sHomePath to bExists
                            If (bExists = True) Begin
                                Get FindSavedFolders of hoFolderSelHeaDD sHomePath to asSavedFolders
                            End
                            Move (SizeOfArray(asSavedFolders)) to iSavedSize
                            Decrement iSavedSize
                            Move (iSavedSize >= 0) to bUseDDO
                        End

                        Move 0 to iCount
                        Get phoDataSource to hoDataSource
                        Get DataSource of hoDataSource to TheData
                        Move TheDataEmpty to TheData
                        Get piColumnId of (phoData_Col(Self))     to iFolderCol
                        Get piColumnId of (phoCheckbox_Col(Self)) to iCheckBoxCol
                        Get NoFolderListAsArray of ghoApplication False to asNoFolderList

                        Move CS_DefaultSourceFolders to sDefaultFolders
                        Move (Lowercase(sDefaultFolders)) to sDefaultFolders
                        Move (StrSplitToArray(sDefaultFolders, "|")) to asDefaultFolders
                        Move (SizeOfArray(asDefaultFolders)) to iDefaultFolders
                        Decrement iDefaultFolders

                        Move 0 to iRow
                        For iCount from 0 to iSize
                            Move asFolderArray[iCount] to sFolderName
                            Move sFolderName to TheData[iRow].sValue[iFolderCol]
                            Get IsFolderInDefaultsFolderList of ghoApplication sFolderName to bChecked
                            If (bUseDDO = True) Begin
                                Get IsFolderName sFolderName asSavedFolders to bChecked
                            End
                            Move bChecked to TheData[iRow].sValue[iCheckBoxCol]
                            Increment iRow
                        Loop

                        If (iRow <> 0) Begin
                            Send ReInitializeData TheData False
                            Send MoveToFirstRow
                        End
                        Else Begin
                            Send InitializeData TheDataEmpty
                        End
                        Get CheckedItems to iCount
                        Set psFooterText of oFoldername_Col  to ("Selected Items:" * String(iCount) * "of" * String(iSize + 1))
                        Send Cursor_Ready of Cursor_Control
                    End_Procedure
                    
                    Function IsFolderName String sFolderName String[] asSavedFolders Returns Boolean
                        Integer iRow
                        Move (SearchArray(sFolderName, asSavedFolders)) to iRow
                        Function_Return (iRow <> -1)
                    End_Function 
                    
                    Procedure SaveSelectedFolders
                        Boolean bSave bOK
                        Handle hoDD        
                        String sHomeFolder
                        String[] asSelectedFolders asSavedFolders
                        
                        Move False to bSave
                        Get SelectedItems to asSelectedFolders
                        Get psHomePath of ghoApplication to sHomeFolder
                        Get private.phoFolderSelHeaDD of ghoApplication to hoDD
                        Get FindSavedFolders of hoDD sHomeFolder to asSavedFolders
                        Move (not(IsSameArray(asSelectedFolders, asSavedFolders))) to bSave
                        If (bSave = True) Begin
                            Get SaveSelectedFolders of hoDD sHomeFolder asSelectedFolders to bOK
                            If (bOK = False) Begin
                                Send Info_Box "Could not save selected folders." 
                            End
                        End
                    End_Procedure

                    On_Key kClear         Send ActivateProcess  
                    On_Key Key_F2         Send SaveSelectedFolders
                    On_Key Key_Ctrl+Key_S Send SaveSelectedFolders
                End_Object

                Procedure UpdateEnabledState
                    Boolean bWorkspaceMode
                    String sSWSFile
                    Get psSWSFile of ghoApplication to sSWSFile
                    Get pbWorkspaceMode of ghoApplication to bWorkspaceMode
                    Set Enabled_State to (bWorkspaceMode = True and sSWSFile <> "")
                End_Procedure

            End_Object

            Procedure OnExitArea Handle hoFrom
                Send SaveSelectedFolders of oFolders_grd
                Forward Send OnExitArea hoFrom
            End_Procedure
                     
        End_Object
    
        Procedure UpdateEnabledState
            String sSWSFile
            Get psSWSFile of ghoApplication to sSWSFile
            Set Enabled_State to (sSWSFile <> "")
        End_Procedure   
        
    End_Object
                
    Procedure UpdateEnabledState
        String sSWSFile
        Get psSWSFile of ghoApplication to sSWSFile
        Set Enabled_State to (sSWSFile <> "")
    End_Procedure

    Object oSelectFiles_grp is a cRDCDbHeaderGroup
        Set Size to 48 260
        Set Location to 262 6
        Set psLabel to "File Filter"
        Set psNote to "File Extensions Filter"
        Set psToolTip to "Select file extensions filter. Each extension must start with a wildcard character and a dot (*.) and file extensions must be separated with a semicolon (;)"
        Set psImage to "FileExtensions.ico"
        Set peAnchors to anBottomLeft

        Procedure UpdateEnabledState
            String sSWSFile
            Get psSWSFile of ghoApplication to sSWSFile
            Set Enabled_State to (sSWSFile <> "")
        End_Procedure

        Object oFileNameFilters_cf is a cRDCDbComboForm 
            Entry_Item SysFile.FileExtensionFilter
            Set Server to oSysFile_DD
            Set Size to 12 250
            Set Location to 30 4
            Set psToolTip to "Select file extensions filter. Each extension must start with a wildcard character and a dot (*.) and file extensions must be separated with a semicolon (;)"
            Set Status_Help to (psToolTip(Self))
            Set Combo_Sort_State to False
            Set pbAutoEnable to True
            Set peAnchors to anTopLeftRight

            Property Integer piMaxUserFilters 8
            Set Label_Row_Offset to 1
            Set Label_Justification_Mode to JMode_Top
            Set Label_Col_Offset to 0

            Procedure Combo_Fill_List
                String sDFExtensions sDFVersion
                Integer iMajorVersion iMinorVersion iCount iSize
                String[] asUserExtensions

                Forward Send Combo_Fill_List
                Move FMAC_VERSION  to iMajorVersion
                Move FMAC_REVISION to iMinorVersion
                Move (String(iMajorVersion) + "." + String(iMinorVersion)) to sDFVersion
                Get StudioFileExtensions of ghoApplication sDFVersion to sDFExtensions

                Send Combo_Add_Item CS_StdExtensions
                Send Combo_Add_Item CS_DFAndTemplExt
                Send Combo_Add_Item CS_PkgIncExt
                Send Combo_Add_Item CS_SrcPkgExt

                If (sDFExtensions <> String(cx_RegKeyDFKeyDoesNotExist)) Begin
                    Send Combo_Add_Item sDFExtensions
                End

                Get UserSavedExtensions to asUserExtensions
                Move (SizeOfArray(asUserExtensions)) to iSize
                Decrement iSize
                For iCount from 0 to iSize
                    Send Combo_Add_Item (Trim(asUserExtensions[iCount]))
                Loop

                Set Value to CS_StdExtensions
            End_Procedure

            Function UserSavedExtensions Returns String[]
                String[] asUserExtensions
                String sExt
                Integer iCount iSize

                Get piMaxUserFilters to iSize
                For iCount from 0 to iSize
                    Get ReadString  of ghoApplication CS_Settings (CS_DFExtensionsKey + String(iCount)) "" to sExt
                    If (sExt <> "") Begin
                        Move sExt to asUserExtensions[SizeOfArray(asUserExtensions)]
                    End
                Loop

                Function_Return asUserExtensions
            End_Function

            // Note: Can't save new extensions entered by user with the
            // OnChange event, as it would save character per character.
            Procedure OnExitObject
                String sDFExtensions sDFVersion sNewExt
                Integer iMajorVersion iMinorVersion iCount iSize iMaxUserFilters iItem
                String[] asUserExtensions
                Boolean bExists

                Move FMAC_VERSION  to iMajorVersion
                Move FMAC_REVISION to iMinorVersion
                Move (String(iMajorVersion) + "." + String(iMinorVersion)) to sDFVersion
                Get StudioFileExtensions of ghoApplication sDFVersion to sDFExtensions

                Get piMaxUserFilters to iSize
                Get Value to sNewExt
                If (sNewExt <> CS_StdExtensions and ;
                    sNewExt <> CS_DFAndTemplExt and ;
                    sNewExt <> CS_PkgIncExt and ;
                    sNewExt <> CS_SrcPkgExt and ;
                    sNewExt <> sDFExtensions) Begin

                    Get IsExtensionInRegistry sNewExt to bExists

                    If (bExists = False) Begin
                        Get UserSavedExtensions to asUserExtensions
                        // Push the new item on top of the list
                        Send WriteString of ghoApplication CS_Settings (CS_DFExtensionsKey + String("0")) sNewExt
                        Get piMaxUserFilters to iMaxUserFilters
                        Move (SizeOfArray(asUserExtensions)) to iSize
                        Move (iMaxUserFilters min iSize) to iSize
                        Decrement iSize
                        Move 0 to iItem
                        For iCount from 0 to iSize
                            Send WriteString of ghoApplication CS_Settings (CS_DFExtensionsKey + String(iCount + 1)) asUserExtensions[iItem]
                            Increment iItem
                        Loop
                        Get piMaxUserFilters to iSize
                        Move iSize to iCount // Get out of loop
                    End
                End

            End_Procedure

            Function IsExtensionInRegistry String sExt Returns Boolean
                Boolean bExists
                String[] asUserExtensions
                Integer iCount iSize

                Move False to bExists
                Get UserSavedExtensions to asUserExtensions
                Move (SizeOfArray(asUserExtensions)) to iSize
                Decrement iSize
                For iCount from 0 to iSize
                    If (Lowercase(asUserExtensions[iCount]) = Lowercase(sExt)) Begin
                        Move True to bExists
                        Move iSize to iCount // We're done.
                    End
                Loop
                Function_Return bExists
            End_Function

        End_Object

    End_Object

    Object oRunNow_grp is a cRDCDbHeaderGroup
        Set Size to 48 367
        Set Location to 262 270
        Set piMinSize to 48 367
        Set psLabel to "Refactor Code"
        Set psNote to "Calls the selected functions for selected folders/source files" 
        Set psToolTip to "Calls the selected functions for the matching selected folders and file extensions."
        Set psImage to "DFRefactor.ico"
        Set peAnchors to anBottomLeftRight
        Set pbUseLargeFontHeight to True

        Object oNoOfSelectedFolders_fm is a cRDCForm
            Set Size to 13 15
            Set Location to 28 105
            Set Label_Justification_Mode to JMode_Right
            Set Label to "Number of Selected Folders:"
            Set psToolTip to "Total number of folders selected."
            Set Enabled_State to False
            Set Label_FontWeight to fw_Bold
            Set Label_Col_Offset to 0
            Set FontWeight to fw_Bold  
            Set Form_Datatype to Mask_Numeric_Window   
            Set Form_Mask to "####"   
            Set pbAutoEnable to True
            Set peAnchors to anBottomRight

            // This will show/hide the control:
            Function IsEnabled Returns Boolean
                Boolean bEnabled bWorkspaceMode
                String sSWSFile
                Get pbWorkspaceMode of ghoApplication to bWorkspaceMode
                Get psSWSFile       of ghoApplication to sSWSFile
                Move (bWorkspaceMode = True and sSWSFile <> "") to bEnabled
                Set Visible_State to bEnabled
                Function_Return bEnabled
            End_Function

        End_Object

        Object oNoOfSelectedFunctions2_fm is a cRDCDbForm
            Entry_Item SysFile.SelectedFunctionTotal
            Set Server to oSysFile_DD
            Set Size to 13 15
            Set Location to 28 230
            Set Label_Justification_Mode to JMode_Right
            Set Label to "Number of Selected Functions:"
            Set psToolTip to "Total number of functions selected."
            Set Enabled_State to False
            Set peAnchors to anBottomRight
            Set Label_FontWeight to fw_Bold
            Set Label_Col_Offset to 0
            Set FontWeight to fw_Bold              
        End_Object

        Object oExecute_btn is a cRDCButton
            Set Size to 25 109
            Set Location to 16 252
            Set Label to "Start &Refactoring!" //"&Refactor Code Now!"
            Set psToolTip to "Start processing the selected refactoring functions. If 'Workspace' mode has been selected from the toolbar all source files that matches the 'File Extensions Filter' will be processed. Else the operations will take place on a single file only. (Alt+R or Ctrl+R)"
//            Set MultiLineState to True
            Set psImage to "Start.ico"
            Set pbAutoEnable to True
            Set peAnchors to anBottomRight
            Set Default_State to True
            Set piImageMarginLeft to 7
            Set piImageSize to 32

            Procedure End_Construct_Object
                Forward Send End_Construct_Object
                // Note: We use Form_FontWeight instead of FontWeight to _not_ make the object larger
                // because of the bold font.
                Set Form_FontWeight to FW_BOLD
            End_Procedure

            Procedure OnClick  
                Send START_MAIN_PROCESS
            End_Procedure

            Function IsEnabled Returns Boolean
                Boolean bEnabled bWorkspaceMode
                String sFileName sSWSFile sHomePath
                Integer iSelectedFunctions iFolders 
                Handle hoFolderSelHeaDD
                Boolean bExists bUseDDO  
                String[] asSavedFolders

                Get pbWorkspaceMode         of ghoApplication to bWorkspaceMode
                Get psSWSFile               of ghoApplication to sSWSFile
                Get psCurrentSourceFileName of ghoApplication to sFileName

                If (bWorkspaceMode = True) Begin
                    Move (sSWSFile <> "") to bEnabled
                End
                Else Begin
                    Move (sFileName <> "") to bEnabled
                End

                If (bEnabled = True) Begin
                    Move (SysFile.SelectedFunctionTotal > 0) to bEnabled
                End

                If (bEnabled = True) Begin
                    Get CheckedItems of oFolders_grd to iFolders
                    If (iFolders = 0) Begin
                        Get private.phoFolderSelHeaDD of ghoApplication to hoFolderSelHeaDD
                        Move (hoFolderSelHeaDD <> 0) to bUseDDO
                        If (bUseDDO = True) Begin
                            Get psHomePath of ghoApplication to sHomePath 
                            Get IsSavedFolders of hoFolderSelHeaDD sHomePath to bExists
                            If (bExists = True) Begin
                                Get FindSavedFolders of hoFolderSelHeaDD sHomePath to asSavedFolders
                            End
                            Move (SizeOfArray(asSavedFolders)) to iFolders
                        End
                    End
                    Move (iFolders <> 0) to bEnabled
                End          
                If (bEnabled = False) Begin
                    Get Field_Current_Value of oSysFile_DD Field SysFile.bCountSourceLines to bEnabled
                End

                Function_Return bEnabled
            End_Function

        End_Object

        Procedure UpdateEnabledState
            String sSWSFile
            Get psSWSFile of ghoApplication to sSWSFile
            Set Enabled_State to (sSWSFile <> "")
        End_Procedure

        Object oSysFile_CountSourceLines_cb is a dbCheckBox
            Entry_Item SysFile.bCountSourceLines
            Set Server to oSysFile_DD
            Set Location to 4 261
            Set Size to 8 109
            Set Label to "Only count Source Lines"   
            Set FontWeight to fw_Bold
            Set peAnchors to anBottomRight 
            Set psToolTip to (String("This function will tell you have big your workspace is by counting the number of real source lines for all selected folders and file extensions.") + String(CS_CR) + String("Note: It will skip blank or comments lines, and it will not count files generated by the Studio from COM components.") + String(CS_CR) + String(CS_CR) + String("This function needs be run alone, all other functions will be ignored."))
            
            Procedure OnChange
                Boolean bChecked
                Integer iSelectedFunctions iSelectedFolders
                
                Set Changed_State of oSysFile_DD to False
                Get CheckedItems of oFolders_grd to iSelectedFolders
                // If selected folders = 0, it is probably because the
                // tab-page/folders grid hasn't been activated and thus
                // it is empty. Activate it, and switch back to fill the folders grid.
                // This is essential for the "Refactor" button routine to work.
                If (iSelectedFolders = 0 and oFolders_tp(Self) <> 0) Begin
                    Send Request_Next_Tab of (oMain_TabDialog(Self)) 3 
                    Send Request_Next_Tab of (oMain_TabDialog(Self)) 3
                End
                Set Value of oNoOfSelectedFolders_fm to iSelectedFolders

                Get Checked_State to bChecked
                If (bChecked = True) Begin
                    Move 1 to iSelectedFunctions
                End                             
                Else Begin
                    Move SysFile.SelectedFunctionTotal to iSelectedFunctions
                End
                Set Value of oNoOfSelectedFunctions2_fm to iSelectedFunctions
            End_Procedure

        End_Object

    End_Object

    // Hidden object!
    // This _must_ be here, else we will get infinite recursion and a crash because there
    // will be no object to take the focus when the view is disabled.
//    Object oHidden_Focus_Object is a Form
//        Set Size to 13 27
//        Set Location to 280 150
//        Set Label to "Hidden focus object!"
//        Set Visible_State to False
//        Set Label_Justification_Mode to JMode_Right
//        Set Label_Col_Offset to 2
//    End_Object


    Procedure InitializeCounters
        Send ResetLineCounters of (Main_DD(Self))
        Set piNoOfUnusedLocalVariables of (phoRemoveUnusedLocals(ghoRefactorFunctionLibrary)) to 0
    End_Procedure

    // Collect all settings to one common struct to be passed amongst the main operating procedures.
    Procedure CollectSettings
        tRefactorSettings RefactorSettings                   
        String sPath sFileName 
        Boolean bWorkspaceMode
                                                                                
        Get SelectedItems of oFolders_grd         to RefactorSettings.asFolderNames
        Move (Trim(SysFile.FileExtensionFilter))  to RefactorSettings.sFileFilter
                                                
        Move SysFile.SelectedStandardFunctions    to RefactorSettings.iSelectedStandardFunctions
        Move SysFile.SelectedRemoveFunctions      to RefactorSettings.iSelectedRemoveFunctions
        Move SysFile.SelectedEditorFunctions      to RefactorSettings.iSelectedEditorFunctions
        Move SysFile.SelectedReportFunctions      to RefactorSettings.iSelectedReportFunctions
        Move SysFile.SelectedReportAllFunctions   to RefactorSettings.iSelectedReportAllFunctions
        Move SysFile.SelectedOtherFunctions       to RefactorSettings.iSelectedOtherFunctions
        Move SysFile.SelectedOtherAllFunctions    to RefactorSettings.iSelectedOtherAllFunctions
        
        // All functions that work on a line-by-line basis.
        Move (SysFile.SelectedStandardFunctions + SysFile.SelectedRemoveFunctions) ;
            to RefactorSettings.iSelectedLineByLineFunctions
        
        // All functions that are feed with a full source file as a string array:
        Move (SysFile.SelectedEditorFunctions + SysFile.SelectedReportFunctions + SysFile.SelectedOtherFunctions) ;
            to RefactorSettings.iSelectedFullFileFunctions

        // All functions that are feed with a string array containing all selected files (including path):
        Move (SysFile.SelectedReportAllFunctions + SysFile.SelectedOtherAllFunctions) ;
            to RefactorSettings.iSelectedAllFilesFunctions

        Move SysFile.bCountSourceLines            to RefactorSettings.bCountSourceLines
        Move SysFile.bEditorDropSelf              to RefactorSettings.bEditorDropSelf

        Set pRefactorSettings of ghoRefactorFunctionLibrary to RefactorSettings
    End_Procedure

    // At least one action should have been selected, unless we're counting source lines.
    // Also checks that spinform values are correct.
    Function IsValidActions Returns Boolean
        Boolean bOK bWorkspaceMode bFileExists                
        Handle hoDD
        Integer iTabSize iSelectedFunctions iMaxLines iMinLines iRetval
        String  sFileName sFileFilter
        tRefactorSettings RefactorSettings
        
        Move (Main_DD(Self)) to hoDD
        Get pRefactorSettings of ghoRefactorFunctionLibrary to RefactorSettings
        
        If (RefactorSettings.bCountSourceLines = True) Begin
            Get YesNo_Box "The Function 'Count number of source lines' needs to be run in solitude! All other functions will be ignored. Continue?" to iRetval
            If (iRetval <> MBR_Yes) Begin
                Function_Return False
            End                  
            Function_Return True
        End
        
        Get SelectedFunctions of hoDD to iSelectedFunctions
        Move (iSelectedFunctions > 0) to bOK
        If (bOK = False) Begin
            Send Info_Box "You should at least check ONE action/function for the process to run."
            Function_Return False
        End

//        Get Minimum_Position of oMaxBlankLines_sf to iMinLines
//        Get Maximum_Position of oMaxBlankLines_sf to iMaxLines
//
//        If (RefactorSettings.iMaxBlankLines < iMinLines or SysFile.MaxBlankLines > iMaxLines) Begin
//            Send Info_Box ("The number of blank lines needs to be between" * String(iMinLines) * String("and") * String(iMaxLines))
//            Move False to bOK
//        End

        Get pbWorkspaceMode of ghoApplication to bWorkspaceMode
        If (bWorkspaceMode = True) Begin
            Move RefactorSettings.sFileFilter to sFileFilter
            If (not(sFileFilter contains "." and (not(sFileFilter contains "*") or not(sFileFilter contains "?")))) Begin
                Send Info_Box "You need to select at least one file name extenstion. Please adjust and try again."
                Move False to bOK
            End
        End
        Else Begin
            Get psCurrentSourceFileName of ghoApplication to sFileName
            Get FileExists of ghoFileSystem sFileName DIRMODE_FILES_ONLY to bFileExists
            If (bFileExists = False) Begin
                Send Info_Box "The specified source file couldn't be found." "Process Halted"
                Move False to bOK
            End
        End

        Function_Return bOK
    End_Function
    
    //
    // ToDo: *** MAIN REFACTORING ROUTINE ***
    //
    Procedure START_MAIN_PROCESS
        String[] asFolderNames
        String sFileFilter sPath sFileName sText sTotalTime sFolderName
        Handle hoBPO
        Boolean bOK bWorkspaceMode bEditorFunctions bExists
        Integer eResponse iErrors
        DateTime dtExecStart dtExecEnd
        TimeSpan tsTotalTime
        tRefactorSettings RefactorSettings 

        Send Request_Save
        Send CollectSettings
        Get IsValidActions to bOk
        If (bOk = False) Begin
            Procedure_Return
        End    

        Get IsBackupFolder of ghoApplication to bExists
        If (bExists = False) Begin
            Get CreateBackupFolder of ghoApplication "" to sFolderName
        End    
        Get IsBackupFolder of ghoApplication to bExists
        If (bExists = False) Begin
            Send Info_Box ("Backup folder could not be created! Cannot continue:" * String(sFolderName + CS_BackupFolder))
            Procedure_Return
        End

        Get pbWorkspaceMode         of ghoApplication to bWorkspaceMode
        Get psCurrentSourceFileName of ghoApplication to sFileName
        Get pRefactorSettings       of ghoRefactorFunctionLibrary to RefactorSettings

        If (RefactorSettings.bCountSourceLines = False) Begin
            Get StartWarning bWorkspaceMode sFileName to eResponse
            If (eResponse <> MBR_Yes) Begin
                Procedure_Return
            End
        End

        Move False to Err
        Move 0 to LastErr
        Send InitializeCounters 
        Move (CurrentDateTime()) to dtExecStart
        
        // *** Business Process where the calls to selected refactoring functions are made ***
        Get phoBPO to hoBPO
        Send DoProcess of hoBPO

        Get Error_Count of hoBPO to iErrors
        If (iErrors = 0) Begin
            Move (CurrentDateTime()) to dtExecEnd
            Move (dtExecEnd - dtExecStart) to tsTotalTime
            Get TimeSpanToString tsTotalTime to sTotalTime
            Send UpdateStatusBar (CS_CRLF + "Process completed. Elapsed Time:" * sTotalTime) True
            Get vFolderFormat sPath to sPath

            Set Changed_State of (phoEditorView(ghoApplication)) to False
            Get SummaryText True to sText
            Send ActivateLogFile

            If (SysFile.iCountUnusedSourceFiles <> 0) Begin
                Send DisplayUnusedSourceFilesDialog of (Client_Id(ghoCommandBars))
            End
        End
        Else Begin
            Send Info_Box "The Process was unsuccessful." (psProduct(ghoApplication))
            Send Popup of (oStatusLog_dg(Client_Id(phoMainPanel(ghoApplication))))
        End

    End_Procedure

    // ToDo: *** Text Messages ***
    //
    Function StartWarning Boolean bWorkspaceMode String sFileName Returns Integer
        Boolean bSaveBak
        Integer eResponse iSelectedFunctionsCount
        String  sMessage

        Get SelectedFunctions of (Main_DD(Self)) to iSelectedFunctionsCount
        If (bWorkspaceMode) Begin
            Append sMessage ("You have selected" * String(iSelectedFunctionsCount) * "refactoring functions that will be applied ")
            Append sMessage ("to files for the selected folders and subfolders that matches these extensions:" * Trim(SysFile.FileExtensionFilter))
            Append sMessage "\n\nPrior running these routines you should ALWAYS have checked in the source code with a version control system and/or "
            Append sMessage "made a backup of the source code!"
            Append sMessage "\n\nContinue?"
        End
        Else Begin
            Append sMessage ("You have selected" * String(iSelectedFunctionsCount) * "refactoring functions that will be applied to this source file:\n ")
            Append sMessage sFileName
            Append sMessage "\n\nContinue?"
        End

        Get YesNo_Box sMessage "" MB_DEFBUTTON2 to eResponse
        Function_Return eResponse
    End_Function

    Function SummaryText Boolean bWriteLogFile Returns String
        String sText sLogText sLogFile sPath sTimeText sProgram sFormatString sValue sSWSFile
        Integer iChangedFiles iCount iSize
        Integer iFileCount iChannel
        tRefactorSettings RefactorSettings
        DateTime dtToday
        Boolean bExists
        
        Move SysFile.iCountNumberOfChangedFiles to iChangedFiles
        Move SysFile.iCountNumberOfFiles        to iFileCount
        Get pRefactorSettings  of ghoRefactorFunctionLibrary to RefactorSettings             
        Get psSWSFile of ghoApplication to sSWSFile
        Append sText ("  SWS File:  " * Trim(sSWSFile) + "\n")
        Append sText ("  File Filter:  " * Trim(RefactorSettings.sFileFilter) + "\n")
        Move (SizeOfArray(RefactorSettings.asFolderNames)) to iSize
        Append sText ("Number of Folders:" * String(iSize) + "\n")
        Decrement iSize
        For iCount from 0  to iSize
            Append sText "  " RefactorSettings.asFolderNames[iCount] "\n"
        Loop

        Append sText "\nStatistics:\n==========="
        
        // If source line counting this will be the only action for this run:
        If (RefactorSettings.bCountSourceLines = True) Begin
            Move ",#." to sFormatString
            Move (FormatValue(SysFile.iCountNumberOfLines, sFormatString)) to sValue
            Append sText ("\no Count of Source lines. Number of files:" * String(SysFile.iCountNumberOfFiles) * String("Total Number of Lines:") * String(sValue))
            Append sText (String("\n  Skipped all COM wrapper files generated by the Studio, blank and commented lines"))
        End

        Else Begin
            
            // Remove functions:
            // One source line at a time was passed to these fucntions.
            If (RefactorSettings.iSelectedRemoveFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Remove_Function +"(s):")
                Constraint_Set (Self + 1) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eRemove_Function
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "lines" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End
            
            // Standard functions:
            // One source line at a time was passed to these fucntions.
            If (RefactorSettings.iSelectedStandardFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Standard_Function +"(s):")
                Constraint_Set (Self) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eStandard_Function        
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "lines" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End
            
            // Editor functions:
            // One source file at a time was passed as a string array.
            If (RefactorSettings.iSelectedEditorFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Editor_Function +"(s):")
                Constraint_Set (Self + 2) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eEditor_Function
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "file(s)" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End
            
            // Other functions:
            // One source file at a time was passed as a string array.
            If (RefactorSettings.iSelectedOtherFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Other_Function +"(s):")
                Constraint_Set (Self + 5) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eOther_Function
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "lines" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End

            // OthertAll functions:
            // All selected files were passed as a string array (with full path)
            If (RefactorSettings.iSelectedOtherAllFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Other_FunctionAll +"(s):")
                Constraint_Set (Self + 6) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eOther_FunctionAll
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "file(s)" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End
            
            // Report functions: These makes no code changes.
            // One source file at a time was passed as a string array.
            If (RefactorSettings.iSelectedReportFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Report_Function +"(s):")
                Constraint_Set (Self + 3) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eReport_Function
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "file(s)" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End

            // ReportAll functions: These makes no code changes.
            // All selected files were passed as a string array (with full path)
            If (RefactorSettings.iSelectedReportAllFunctions <> 0) Begin
                Append sText ("\n\n" + CS_Report_FunctionAll +"(s):")
                Constraint_Set (Self + 4) Clear
                Constrained_Clear eq FunctionsA by Index.4  
                Constrain FunctionsA.Selected eq True
                Constrain FunctionsA.Type eq eReport_FunctionAll
                Constrained_Find First FunctionsA by Index.4
                While (Found)
                    Append sText ("\no" * Trim(FunctionsA.Count) * "file(s)" * Trim(FunctionsA.Function_Summary))
                    Constrained_Find Next            
                Loop
            End
            
            // ToDo: This needs to be handled in a different way.
            //       Perhaps in the function library function itself?
            //       Or perhaps in Functions.Lines?
//            If (RefactorSettings.bRemoveUnusedLocals = True) Begin
//                If (SysFile.iCountUnusedLocals <> 0) Begin
//                    Append sText ("\noRemoved Unused local variables:" * String(SysFile.iCountUnusedLocals))
//                End
//            End
        End
        
        If (bWriteLogFile = True) Begin
            Get psIdleText of (phoStatusBar(ghoCommandBars)) to sTimeText    
            Move (Replace(CS_CRLF, sTimeText, "")) to sTimeText
            Get psHomePath of ghoApplication to sPath
            Get vFolderFormat sPath to sPath
            Move (sPath + CS_BackupFolder + CS_DirSeparator + CS_SummaryLogfileName) to sLogFile
            Get Seq_New_Channel to iChannel
            // No channel available 
            If (iChannel = DF_SEQ_CHANNEL_NOT_AVAILABLE) Begin
                Error "No Channel Available for Process: Procedure 'SummaryText'"
                Function_Return ""
            End
            Append_Output channel iChannel sLogFile
            Move (Replaces("\n", sText, (Character(13) + Character(10)))) to sLogText
            Get psProduct of ghoApplication to sProgram
            Move (CurrentDateTime()) to dtToday
            Writeln channel iChannel "====================================================================================="
            Writeln channel iChannel "CREATED BY: " sProgram " -- " dtToday
            Writeln channel iChannel sLogText
            Writeln channel iChannel
            Writeln channel iChannel ("Total number of files changed:" * String(iChangedFiles) * "out of" * String(iFileCount) * "Files.")
            Writeln channel iChannel sTimeText
            Writeln channel iChannel
            Close_Input channel iChannel
            Send Seq_Release_Channel iChannel
        End

        Function_Return sText
    End_Function

    Function pbShouldSave Returns Boolean
        Function_Return (Changed_State(Self))
    End_Function

    Procedure Request_Clear
        Set Changed_State to False
        Forward Send Request_Clear
    End_Procedure

    Procedure Request_Clear_All
        Set Changed_State to False
        Send Request_Clear_All of oFolders_grd
        Forward Send Request_Clear_All
    End_Procedure

    Procedure Close_Panel
    End_Procedure

    Procedure OnSetFocus
        Boolean bCountSourceLines 
        Integer iSelectedFunctions iSelectedFolders                

        Set piActiveView of ghoApplication to CI_CleanupSource Self

        Get CheckedItems of oFolders_grd to iSelectedFolders
        Set Value of oNoOfSelectedFolders_fm to iSelectedFolders
        Move (SysFile.bCountSourceLines = True) to bCountSourceLines
        If (bCountSourceLines = True) Begin
            Move 1 to iSelectedFunctions
        End                             
        Else Begin
            Move SysFile.SelectedFunctionTotal to iSelectedFunctions
        End
        Set Value of oNoOfSelectedFunctions2_fm to iSelectedFunctions
        Set Changed_State of oSysFile_DD to False
    End_Procedure

    Procedure OnWorkspaceLoaded
        Integer iSelectedFolders  
        Handle hoFolderSelHeaDD
        Boolean bExists bUseDDO
        String sHomePath 
        String[] asSavedFolders
                      
        Send LoadData of oFolders_grd
        Send OnChange of oSysFile_CountSourceLines_cb
        Get CheckedItems of oFolders_grd to iSelectedFolders
        If (iSelectedFolders = 0) Begin
            Get private.phoFolderSelHeaDD of ghoApplication to hoFolderSelHeaDD
            Move (hoFolderSelHeaDD <> 0) to bUseDDO
            If (bUseDDO = True) Begin
                Get psHomePath of ghoApplication to sHomePath 
                Get IsSavedFolders of hoFolderSelHeaDD sHomePath to bExists
                If (bExists = True) Begin
                    Get FindSavedFolders of hoFolderSelHeaDD sHomePath to asSavedFolders
                End
                Move (SizeOfArray(asSavedFolders)) to iSelectedFolders
            End
        End
        Set Value of oNoOfSelectedFolders_fm to iSelectedFolders
    End_Procedure

    // Allow a source file, .sws file or a folder to be dropped on the view:
    Procedure OnFileDropped String sFileFolderName Boolean bLast
        String sFileExt
        Boolean bFile bFolder bSWSFile

        Forward Send OnFileDropped sFileFolderName bLast

        // Try to find out if a file or a folder name was dropped on the view:
        Get ParseFileExtension sFileFolderName to sFileExt
        Move (Lowercase(sFileExt)) to sFileExt
        Move (sFileExt = "")    to bFolder
        Move (sFileExt = "sws") to bSWSFile
        Move (bSWSFile = False and bFolder = False) to bFile
        
        If (bFolder = True) Begin
            Send AddItem of oFolders_grd sFileFolderName
        End
        Else If (bLast = True) Begin
            If (bFile = True) Begin
                Send UpdateSourceFileNameDisplay of ghoApplication sFileFolderName
                Set pbWorkspaceMode of ghoApplication to False
            End
            If (bSWSFile = True) Begin
                Send UpdateWorkspaceSelectorDisplay of ghoApplication sFileFolderName
                Set pbWorkspaceMode of ghoApplication to True
            End
        End
        Else Begin
            Send Info_Box "Only on file can be dropped on the view at a time. The last will be used."
        End
    End_Procedure

    Object oView_IdleHandler is a cIdleHandler
        Set pbEnabled to True
        Procedure OnIdle 
            Broadcast Recursive Send UpdateEnabledState of (Parent(Self))
        End_Procedure
    End_Object

End_Object
