// THColorer.pkg
// This is header package for TheHammer 3.0 Code Colorer
// by Sergey V. Natarov

Use Font_dlg.pkg

// *** COLORS ***
// _WindowColr_ _LftMrgnClr_ _BookmarkCl_ _BookmarkBg_ _TextColorX_ _TextBackgr_ _NumberColr_ _NumberBkGr_ _KeywordsCl_ _KeywordsBg_ _OperatorCl_ _OperatorBg_ _ScopeKwClr_ _ScopeKwBkg_ _CommentClr_ _CommentBkg_ _StringColr_ _StringBkgr_ _TagTextClr_ _TagTextBkg_ _TagEntyClr_ _TagEntyBkg_ _TagElemClr_ _TagElemBkg_ _TagAttrClr_ _TagAttrBkg_ _LineNrColr_ _LineNrBkgr_ _HrDivLinCl_ _VrDivLinCl_ _HiLtLineCl_
// 255255255000 192192192000 255255255255 255255255255 000000000000 255255255000 255000255000 255255255000 000000255000 255255255000 255000000000 255255255000 000000255000 255255255000 000128000000 255255255000 128128128000 255255255000 000128128000 255255255255 255000000000 255255255255 000000255000 255255255255 128000000000 255255255255 255255255000 128128128000 255255255255 192192192000 192192192000 000
//      1            2             3           4             5           6             7            8            9           10            11          12            13          14           15           16            17          18           19          20            21            22           23         24            25           26           27           28          29            30          31

// *** FONTS *** (PSFONTSTYLES)
//      Nr       Sc Ct    TT En    At
//   _  _  _  _  _  _  _  _  _  _  _  _
// 000000000000000002000001000001000000000
//   _     -  -        -        -     -
//   Tx    Kw Op       St       El    Ln
//   1  2  3  4  5  6  7  8  9 10 11 12
//          1         2         3


// Normal           = 0
// Bold             = 1
// Italics          = 2
// Bold + Italics   = 3
// Underline        = 4
// B+U              = 5
// I+U              = 6
// B+I+U            = 7

// CodeMax: 31 elements as 3sRGBA + 3 zeroes
Define CM_COLORS_STRSIZE for (31*12 + 3)
// Scintilla: 37 elements as 3sRGBA + 3 zeroes
Define SC_COLORS_STRSIZE for (42*12 + 3)

// Define Default white schema:
Define TH_DEFSCHEMA_WHITE_STR   for "Default (White)"
Define TH_DEFSCHEMA_BLACK_STR   for "Default (Black)"
Define TH_DEFSCHEMA_BLUE_STR    for "Default (Blue)"
Define TH_DEFSCHEMA_LIME_STR    for "Default (Lime)"
Define TH_DEFSCHEMA_SERENE_STR  for "Default (Serene)"
Define TH_DEFSCHEMA_SAHARA_STR  for "Default (Sahara)"
Define TH_COLORSCHEMA_WHITE     for "255255255255220225240000255255255255255255255255000000000000255255255000255000255000255255255000000000255000255255255000255000000000255255255000000000255000255255255000000128000000255255255000128128128000255255255000000128128000255255255255255000000000255255255255000000255000255255255255128000000000255255255255105105105000190200225000255255255255192192192000220225240000128128128000255215215000000000000000200225255000255255000000255035035000000128128000255255255000170195240000215107000000255255255000000"
Define TH_COLORSCHEMA_BLACK     for "025025025000120120120000255255255255255255255255255255255000025025025000255185255000025025025000140215240000025025025000255108108000025025025000140215240000025025025000187255187000025025025000192192192000025025025000045255255000255255255255255000000000255255255255128128255000255255255255255147147000255255255255192192192000080080080000255255255255192192192000105105105000090090090000255215215000000000000000200225255000255255000000255000000000202255255000025025025000000000170000255190120000025025025000000"
Define TH_COLORSCHEMA_BLUE      for "000000128000000000128000255255255255255255255255255255255000000000128000255070255000000000128000115205235000000000128000255066066000000000128000115205235000000000128000147255147000000000128000190190190000000000128000000164164000255255255255255000000000255255255255166166255000255255255255255176176000255255255255255255255000000000128000255255255255192192192000000128128000090090090000255215215000000000000000200225255000255255000000255035035000179179000000000000128000000128128000255190120000000000128000000"
Define TH_COLORSCHEMA_LIME      for "049060083000069082104000255255255255255255255255255255255000049060083000255138021000049060083000156255000000049060083000249255013000049060083000156255000000049060083000255098255000049060083000180180180000049060083000000189095000255255255255255000000000255255255255171087255000255255255255255072164000255255255255096114145000028038060000255255255255192192192000028038060000070070070000253193220000255026026000049060083000255255000000255035035000000240240000049060083000001001001000255194034000049060083000000"
Define TH_COLORSCHEMA_SERENE    for "025025025000120120120000255255255255255255255255255255255000025025025000255185255000025025025000140215240000025025025000255108108000025025025000140215240000025025025000187255187000025025025000255255000000025025025000000174174000255255255255255000000000255255255255180104255000255255255255128128255000255255255255192192192000080080080000255255255255192192192000105105105000090090090000255215215000000000000000200225255000255255000000255000000000202255255000025025025000000000170000255190120000025025025000000,000000000000001000000001000001000000000000000000000000"
Define TH_COLORSCHEMA_SAHARA    for "255255187000220225240000255255255255255255187000000000000000255255187000255000255000255255187000000000255000255255187000255000000000255255187000000000255000255255187000000128000000255255187000255000128000255255187000000128128000255255187000255000000000255255187000000000255000255255187000128000000000255255187000105105105000190200225000255255255255192192192000220225240000128128128000255215215000000000000000200225255000255255000000255035035000000128128000255255187000170195240000215107000000255255187000000,000000000000000000000000000000000000000000000001000000"

// Font Styles
Define THFS_NORMAL      for 0
Define THFS_BOLD        for 1
Define THFS_ITALICS     for 2
Define THFS_UNDERLINE   for 4

// Editor Colors
Enum_List
    Define EC_WINDOW            // 00
    Define EC_LEFTMARGIN        // 01
    Define EC_BOOKMARK          // 02
    Define EC_TEXT              // 03
    Define EC_NUMBERS           // 04
    Define EC_KEYWORDS          // 05
    Define EC_OPERATORS         // 06
    Define EC_SCOPEKWORDS       // 07
    Define EC_COMMENTS          // 08
    Define EC_STRINGS           // 09
    Define EC_TAGTEXT           // 10
    Define EC_TAGENTITIES       // 11
    Define EC_TAGELEMENT        // 12
    Define EC_TAGATTRIBUTE      // 13
    Define EC_LINENUMBERS       // 14
    Define EC_HDIVLINES         // 15
    Define EC_VDIVLINES         // 16
    Define EC_HLIGHTEDLINE      // 17
    // Scintilla Only
    Define EC_STRINGTYPING      // 18
    Define EC_BRACEHLIGHT       // 19
    Define EC_UNMATCHEDBRACE    // 20
    Define EC_METATAGS          // 21
    Define EC_SELECTION         // 22
    Define EC_PREPROCESSOR      // 23
End_Enum_List

Struct tColorer
    String  sName       // Color element
    Integer iForeOff    // Front Color Required
    Integer iBackOff    // Back Color Required
    Integer iFont       // Font Allowed
    Integer iStyle      // Font Style
    Integer iCM         // CodeMax Support
    Integer iForeC      // Actual Text Color
    Integer iBackC      // Actual Background Color
    Integer iBold       // Font Bold
    Integer iItalics    // Font Italics
    Integer iUnderline  // Font Underline
End_Struct

// Charset
// Commented out defines are already defined in Font_dlg package
//Define ANSI_CHARSET             for 0
//Define DEFAULT_CHARSET          for 1
//Define SYMBOL_CHARSET           for 2
//Define SHIFTJIS_CHARSET         for 128
Define HANGEUL_CHARSET          for 129
//Define HANGUL_CHARSET           for 129
//Define GB2312_CHARSET           for 134
//Define CHINESEBIG5_CHARSET      for 136
//Define OEM_CHARSET              for 255
Define JOHAB_CHARSET            for 130
Define HEBREW_CHARSET           for 177
Define ARABIC_CHARSET           for 178
Define GREEK_CHARSET            for 161
Define TURKISH_CHARSET          for 162
Define VIETNAMESE_CHARSET       for 163
Define THAI_CHARSET             for 222
Define EASTEUROPE_CHARSET       for 238
Define RUSSIAN_CHARSET          for 204

Define MAC_CHARSET              for 77
Define BALTIC_CHARSET           for 186

tColorer[] gtColorer
