*&---------------------------------------------------------------------*
* Program Name     : ZFIR001
* Program Purpose  : Batch Financial Document Posting
* Author           : Rex.Sun
* Date Written     : 2021/09/20
* Note             : N/A
*&---------------------------------------------------------------------*
REPORT ZCMFICOR01.

INCLUDE ZINCL_CMALV.
INCLUDE ZINCL_CMUPDOWN.
INCLUDE ZINCL_CMFRONTEND.

*----------------------------------------------------------------------*
*    Type Pool declarations
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*    Table definition
*----------------------------------------------------------------------*
TABLES: SSCRFIELDS.

*&---------------------------------------------------------------------*
*    Type definition
*&---------------------------------------------------------------------*
* Output
TYPES: BEGIN OF TY_OUT,
BELNR TYPE BSEG-BELNR,
GJAHR TYPE BKPF-GJAHR,
BUKRS TYPE BKPF-BUKRS,
ICON TYPE ICON_D,
MSG TYPE BAPI_MSG,
END OF TY_OUT.

DATA: GT_BKPF    LIKE BBKPF OCCURS 0 WITH HEADER LINE,
      GT_BSEG    LIKE BBSEG OCCURS 0 WITH HEADER LINE,
      GT_BTAX    LIKE BBTAX OCCURS 0 WITH HEADER LINE,
      GT_WITH    LIKE BWITH OCCURS 0 WITH HEADER LINE,
      GT_SELK    LIKE BSELK OCCURS 0 WITH HEADER LINE,
      GT_SELP    LIKE BSELP OCCURS 0 WITH HEADER LINE,
      GT_SELP2   LIKE Zcmfico_SFIBSELP OCCURS 0 WITH HEADER LINE,
      GT_MESSTAB LIKE FIMSG OCCURS 0 WITH HEADER LINE.

DATA: C_POST_TYPE  TYPE C VALUE 'C'.
*DATA: LV_BELNR LIKE BKPF-BELNR,
*      LV_GJAHR LIKE BKPF-GJAHR,
*      LV_BUKRS LIKE BKPF-BUKRS,
*      LV_MSGTXT(100).

DATA: GV_SCN_D TYPE CHAR10.
*----------------------------------------------------------------------*
*    Constants Description
*----------------------------------------------------------------------*
* 下载模版SMW0维护
CONSTANTS: C_TEMPLATE_ID TYPE WWWDATATAB-OBJID VALUE 'ZFIDOCUMENTPOSTING'.

*&---------------------------------------------------------------------*
*    Data Description
*&---------------------------------------------------------------------*
DATA: G_MODE. "展示模式

* Output
DATA: GT_OUT TYPE TABLE OF TY_OUT.

* Variables for ALV
DATA: GS_LAYO TYPE LVC_S_LAYO "Layout structure
      , GT_FCAT TYPE LVC_T_FCAT "Field Catalog Table
      , GT_SORT TYPE LVC_T_SORT "Sort Criteria Table
      , GT_EVTS TYPE LVC_T_EVTS "Events Table
      , GT_EXCL TYPE SLIS_T_EXTAB "Excluding Table
      .
*&---------------------------------------------------------------------*
*    PARAMETERS & SELECT-OPTIONS
*&---------------------------------------------------------------------*
*& Fuction key definition
SELECTION-SCREEN: FUNCTION KEY 1,
FUNCTION KEY 2.
SELECTION-SCREEN BEGIN OF BLOCK B00 WITH FRAME TITLE TEXT-B00.
PARAMETERS: P_FILE TYPE RLGRAP-FILENAME,
 BDC_MODE(1) DEFAULT 'N'.
SELECTION-SCREEN END OF BLOCK B00.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM GET_FILENAME.

*&---------------------------------------------------------------------*
*&      Form  get_filename
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM GET_FILENAME.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = 'P_FILE'
    IMPORTING
      FILE_NAME     = P_FILE.

ENDFORM.                    "get_filename
*&---------------------------------------------------------------------*
*    INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM FRM_SET_DEFAULT_VALUE. "Set default value

*&---------------------------------------------------------------------*
*    AT SELECTION-SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM FRM_MODIFY_SCREEN. "Set screen fields attribute


AT SELECTION-SCREEN.
  PERFORM FRM_INPUT_CHECK.  "Selection screen input check
  PERFORM FRM_USER_COMMAND. "User command

*&---------------------------------------------------------------------*
*    START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM FRM_INITIALIZE_DATA. "Initialize data
  PERFORM FRM_SELECT_DATA.     "Select data from database
  PERFORM FRM_OUTPUT_DATA.
*&---------------------------------------------------------------------*
*    END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Form  FRM_SET_DEFAULT_VALUE
*&---------------------------------------------------------------------*
*       Set default value of screen fields
*----------------------------------------------------------------------*
FORM FRM_SET_DEFAULT_VALUE .
  CONCATENATE ICON_TREND_DOWN: '下载模版' INTO SSCRFIELDS-FUNCTXT_01.
  CONCATENATE ICON_TREND_UP:   '上传数据' INTO SSCRFIELDS-FUNCTXT_02.
ENDFORM.                    " FRM_SET_DEFAULT_VALUE
*&---------------------------------------------------------------------*
*&      Form  FRM_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       Set screen fields attribute
*----------------------------------------------------------------------*
FORM FRM_MODIFY_SCREEN .

ENDFORM.                    " FRM_MODIFY_SCREEN
*&---------------------------------------------------------------------*
*&      Form  FRM_INPUT_CHECK
*&---------------------------------------------------------------------*
*       Selection screen input check
*----------------------------------------------------------------------*
FORM FRM_INPUT_CHECK .

ENDFORM.                    " FRM_INPUT_CHECK
*&---------------------------------------------------------------------*
*&      Form  FRM_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FRM_USER_COMMAND .
  DATA: L_FILENAME TYPE RLGRAP-FILENAME.
  CASE SSCRFIELDS-UCOMM.
    WHEN 'FC01'. "下载模版
      PERFORM FRM_FILE_SAVE_DIALOG USING '目录选择' 'ZFIDOCUMENTPOSTING'
            'Excel Files (*.xls)|*.xls'
            SPACE
            L_FILENAME.
      IF L_FILENAME IS NOT INITIAL.
        PERFORM FRM_DOWNLOAD_TEMPLATE USING C_TEMPLATE_ID L_FILENAME.
      ENDIF.
    WHEN 'FC02'. "上传数据
      PERFORM FRM_FILE_OPEN_DIALOG USING '文件选择' 'ZFIDOCUMENTPOSTING'
            'Excel Files (*.xls)|*.xls'
            L_FILENAME.
      IF L_FILENAME IS NOT INITIAL.
        PERFORM FRM_INITIALIZE_DATA.
        PERFORM FRM_UPLOAD_DATA USING L_FILENAME.
      ENDIF.
    WHEN OTHERS.
      IF P_FILE IS NOT INITIAL.
        PERFORM FRM_INITIALIZE_DATA.
        PERFORM FRM_UPLOAD_DATA USING P_FILE.
      ENDIF.


  ENDCASE.
ENDFORM.                    " FRM_USER_COMMAND
*&---------------------------------------------------------------------*
*&      Form  upload_data
*&---------------------------------------------------------------------*
*       上载数据
*----------------------------------------------------------------------*
FORM FRM_UPLOAD_DATA USING I_FILENAME TYPE RLGRAP-FILENAME.

  DATA: IS_OPTIONS TYPE ZCM_DOIUPOPTS.

  DATA: LS_OUT TYPE TY_OUT.
  DATA: LT_HEADER TYPE  TABLE OF ZCMFICOR01_EXCEL_H,
        LT_ITEM TYPE  TABLE OF ZCMFICOR01_EXCEL_I,
        LS_HEADER TYPE ZCMFICOR01_EXCEL_H,
        LS_ITEM TYPE ZCMFICOR01_EXCEL_I.

  IS_OPTIONS-TABNAME = 'ZCMFICOR01_EXCEL_H'.
  IS_OPTIONS-BEGIN_COL = 1.
  IS_OPTIONS-BEGIN_ROW = 5.
*    IS_OPTIONS-END_COL   = 20.
  IS_OPTIONS-END_ROW   = 5.


  CALL FUNCTION 'ZCM_EXCEL_UPLOAD'
    EXPORTING
*     IT_FIELDCAT_LVC       =
      IS_OPTIONS            = IS_OPTIONS
      I_FILENAME            = I_FILENAME
      I_ATTACHMENTS         = 'B'
    TABLES
      T_OUTTAB              = LT_HEADER
            .
  READ TABLE LT_HEADER INTO LS_HEADER INDEX 1.
  MOVE-CORRESPONDING LS_HEADER TO GT_BKPF.
  APPEND GT_BKPF .


  CLEAR:IS_OPTIONS.
  IS_OPTIONS-TABNAME = 'ZCMFICOR01_EXCEL_I'.
  IS_OPTIONS-BEGIN_COL = 1.
  IS_OPTIONS-BEGIN_ROW = 9.
*    IS_OPTIONS-END_COL   = 20.
*  IS_OPTIONS-END_ROW   = 5.


  CALL FUNCTION 'ZCM_EXCEL_UPLOAD'
    EXPORTING
*     IT_FIELDCAT_LVC       =
      IS_OPTIONS            = IS_OPTIONS
      I_FILENAME            = I_FILENAME
    TABLES
      T_OUTTAB              = LT_ITEM
            .

  LOOP AT LT_ITEM INTO LS_ITEM.
    MOVE-CORRESPONDING LS_ITEM TO GT_BSEG.
    APPEND GT_BSEG .
    CLEAR:LS_ITEM,GT_BSEG.
  ENDLOOP.

* 上传数据检查
  PERFORM FRM_UPLOAD_DATA_CHECK.

ENDFORM.                    " upload_data
*&---------------------------------------------------------------------*
*&      Form  FRM_UPLOAD_DATA_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FRM_UPLOAD_DATA_CHECK .
* 检查
  CHECK GT_OUT[] IS NOT INITIAL.

  FIELD-SYMBOLS: <FS_OUT> TYPE TY_OUT.
  DATA: L_MATNR TYPE MATNR.
  LOOP AT GT_OUT ASSIGNING <FS_OUT>.

    WRITE ICON_RED_LIGHT TO <FS_OUT>-ICON.
*-- 正确
    WRITE ICON_GREEN_LIGHT TO <FS_OUT>-ICON.
  ENDLOOP.
ENDFORM.                    " FRM_UPLOAD_DATA_CHECK
*&---------------------------------------------------------------------*
*&      Form  FRM_INITIALIZE_DATA
*&---------------------------------------------------------------------*
*       Initialize data
*----------------------------------------------------------------------*
FORM FRM_INITIALIZE_DATA .
*  REFRESH: GT_OUT.
ENDFORM.                    " FRM_INITIALIZE_DATA
*&---------------------------------------------------------------------*
*&      Form  FRM_SELECT_DATA
*&---------------------------------------------------------------------*
*       Select data from database
*----------------------------------------------------------------------*
FORM FRM_SELECT_DATA .

*  最后一张凭证
  PERFORM FRM_PROCESS_DOCUMENT .

ENDFORM.                    " FRM_SELECT_DATA
*&---------------------------------------------------------------------*
*&      Form  FRM_OUTPUT_DATA
*&---------------------------------------------------------------------*
*       Output result to file or spool/screen
*----------------------------------------------------------------------*
FORM FRM_OUTPUT_DATA .

  PERFORM FRM_BUILD_FCAT. "Field Catalog Table
  PERFORM FRM_BUILD_SORT. "Sort Criteria Table
  PERFORM FRM_BUILD_EVTS. "Events Table
  PERFORM FRM_BUILD_EXCL. "Excluding Table

  PERFORM FRM_SHOW_ALV.   "Display ALV List


ENDFORM.                    " FRM_OUTPUT_DATA

*&---------------------------------------------------------------------*
*&      Form  frm_process_document
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FRM_PROCESS_DOCUMENT .

  DATA: LS_OUT TYPE TY_OUT.
  DATA: LT_RETURN TYPE TABLE OF BAPIRET2,
        LS_RETURN TYPE BAPIRET2.
  DATA: LS_I_RETURN TYPE ZFI_DOCUMENT_POSTING_EXPORT.
  DATA: LS_I_CONF TYPE ZFI_DOCUMENT_POSTING_CNF.

  CHECK GT_BKPF[] IS NOT INITIAL.
  CHECK GT_BSEG[] IS NOT INITIAL.
*  CLEAR:LV_BUKRS,LV_BELNR,LV_GJAHR.


**********  Golabe paramater **********
  LS_I_CONF-SUBFU = '2'." 1. bapi 2.BDC
*---------  BDC paramater-------------*
  LS_I_CONF-POST_TYPE = C_POST_TYPE.
  LS_I_CONF-BDC_MODE = BDC_MODE.
  LS_I_CONF-TCODE = 'FB01'.
  LS_I_CONF-MESSAGE = 'X'.
*--------BAPI paramater----------------*
  LS_I_CONF-GLVOR = 'RFBU'.
  LS_I_CONF-UNAME = SY-UNAME.
**********  Golabe paramater **********

  CALL FUNCTION 'ZFI_POSTING_DOCUMENT'
    EXPORTING
      ES_CONF   = LS_I_CONF
    IMPORTING
      I_RETURN  = LS_I_RETURN
    TABLES
      T_BBKPF   = GT_BKPF
      T_BBSEG   = GT_BSEG
      T_MESSTAB = GT_MESSTAB
      T_RETURN  = LT_RETURN[].

  IF LS_I_RETURN-BELNR <> SPACE OR LS_I_RETURN-TYPE = 'S'.  "성공시

    LS_OUT-BELNR = LS_I_RETURN-BELNR.
    LS_OUT-BUKRS = LS_I_RETURN-BUKRS.
    LS_OUT-GJAHR = LS_I_RETURN-GJAHR.
    CONCATENATE GV_SCN_D '创建成功' LS_I_RETURN-MESSAGE INTO LS_OUT-MSG.
    APPEND LS_OUT TO GT_OUT.
    CLEAR:LS_OUT,GT_BSEG.
  ELSE.

    CONCATENATE GV_SCN_D '创建失败原因：' LS_I_RETURN-MESSAGE INTO LS_OUT-MSG.
    APPEND LS_OUT TO GT_OUT.
    CLEAR LS_OUT.

  ENDIF.


  REFRESH:GT_BSEG,GT_MESSTAB.

ENDFORM.                    "frm_process_document

*&---------------------------------------------------------------------*
*&      Form  FRM_BUILD_FCAT
*&---------------------------------------------------------------------*
*       Build Field Catalog Table
*----------------------------------------------------------------------*
FORM FRM_BUILD_FCAT .
  REFRESH: GT_FCAT.
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      I_STRUCTURE_NAME = 'SFLIGHT'
*    CHANGING
*      CT_FIELDCAT      = GT_FCAT.

  PERFORM FRM_ADD_FIELD USING:
        'BELNR'      'Document Number' ,
        'GJAHR'      'Fiscal Year' ,
        'BUKRS'      'Company Code' ,
*        'ICON'       'State' ,
        'MSG'        'Messsage' .

ENDFORM.                    " FRM_BUILD_FCAT
*&---------------------------------------------------------------------*
*&      Form  FRM_ADD_FIELD
*&---------------------------------------------------------------------*
*       添加Field Catalog字段
*----------------------------------------------------------------------*
*  -->  I_FIELDNAME     字段名称
*  <--  I_REPTEXT       标题
*----------------------------------------------------------------------*
FORM FRM_ADD_FIELD USING I_FIELDNAME TYPE LVC_FNAME
                         I_REPTEXT TYPE REPTEXT.
  DATA: LS_FCAT TYPE LVC_S_FCAT.
  LS_FCAT-TABNAME   = 'GT_OUT'.
*  LS_FCAT-REF_TABLE = 'SFLIGHT'.
  LS_FCAT-FIELDNAME = I_FIELDNAME. "字段名称
  LS_FCAT-REF_FIELD = I_FIELDNAME. "字段名称
  LS_FCAT-REPTEXT   = I_REPTEXT.   "标题
*  LS_FCAT-LZERO     = ''.          "输出前导零
*  LS_FCAT-NO_ZERO   = ''.          "隐藏零
*  LS_FCAT-NO_SIGN   = ''.          "抑制符号
*  LS_FCAT-EMPHASIZE = 'C310'.      "列颜色
*  LS_FCAT-CHECKBOX  = ''.          "作为复选框输出
*  LS_FCAT-DECIMALS  = 0.           "小数位数

* 特殊处理(仅改变显示样式,不应涉及逻辑)
  CASE I_FIELDNAME.
    WHEN 'SEATSOCC'.
      LS_FCAT-NO_ZERO = 'X'.
    WHEN OTHERS.
  ENDCASE.

* 添加
  APPEND LS_FCAT TO GT_FCAT.
  CLEAR  LS_FCAT.
ENDFORM.                    " FRM_ADD_FIELD
*&---------------------------------------------------------------------*
*&      Form  FRM_BUILD_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FRM_BUILD_SORT .
  REFRESH: GT_SORT.
ENDFORM.                    " FRM_BUILD_SORT
*&---------------------------------------------------------------------*
*&      Form  FRM_BUILD_EVTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FRM_BUILD_EVTS .
  REFRESH: GT_EVTS.

*  FIELD-SYMBOLS: <FS_EVTS> TYPE LVC_S_EVTS.
*  DATA: LS_EVTS TYPE LVC_S_EVTS.
  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE = 4
    IMPORTING
      ET_EVENTS   = GT_EVTS.

*  READ TABLE GT_EVTS ASSIGNING <FS_EVTS>
*                     WITH KEY NAME = 'CALLER_EXIT'.
*  IF SY-SUBRC EQ 0.
*    <FS_EVTS>-FORM = 'FRM_CALLER_EXIT'.
*  ENDIF.
ENDFORM.                    " FRM_BUILD_EVTS
*&---------------------------------------------------------------------*
*&      Form  FRM_BUILD_EXCL
*&---------------------------------------------------------------------*
FORM FRM_BUILD_EXCL .
  APPEND CL_GUI_ALV_GRID=>MC_FC_LOC_CUT TO GT_EXCL.
ENDFORM.                    " FRM_BUILD_EXCL
*&---------------------------------------------------------------------*
*&      Form  FRM_SHOW_ALV
*&---------------------------------------------------------------------*
*       Display ALV List
*----------------------------------------------------------------------*
FORM FRM_SHOW_ALV .
  DATA: LV_TITLE TYPE LVC_TITLE,
        LS_VARIANT TYPE DISVARIANT.
*  LV_TITLE = SY-TITLE.
  LS_VARIANT-REPORT = SY-REPID.

  CLEAR GS_LAYO.
  GS_LAYO-CWIDTH_OPT = 'X'.  "优化列宽度
  GS_LAYO-ZEBRA      = 'X'.  "可选行颜色, 间隔色带
  GS_LAYO-SEL_MODE   = ' '.  "选择模式 SPACE, 'A', 'B', 'C', 'D'
*  GS_LAYO-SMALLTITLE = 'X'.  "小标题
  GS_LAYO-STYLEFNAME = 'CELLSTYLE'. "单元格样式

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
  EXPORTING
    I_CALLBACK_PROGRAM       = SY-REPID
*    I_CALLBACK_PF_STATUS_SET = 'FRM_PF_STATUS_SET'
    I_CALLBACK_USER_COMMAND  = 'FRM_USER_COMMAND2'
    I_GRID_TITLE             = LV_TITLE
    I_SAVE                   = 'A'
    IS_VARIANT               = LS_VARIANT
    IS_LAYOUT_LVC            = GS_LAYO
    IT_FIELDCAT_LVC          = GT_FCAT
    IT_SORT_LVC              = GT_SORT
    IT_EVENTS                = GT_EVTS
    IT_EXCLUDING             = GT_EXCL
  TABLES
    T_OUTTAB                 = GT_OUT
  EXCEPTIONS
    PROGRAM_ERROR            = 1
    OTHERS                   = 2.
ENDFORM.                    " FRM_SHOW_ALV

*&---------------------------------------------------------------------*
*&      Form  FRM_PF_STATUS_SET_SGL
*&---------------------------------------------------------------------*
FORM FRM_PF_STATUS_SET USING PT_EXTAB TYPE SLIS_T_EXTAB.
* 设置工具栏
  SET PF-STATUS 'MAIN' EXCLUDING PT_EXTAB.
* 设置标题栏
  SET TITLEBAR 'MAIN'.
ENDFORM.                    "FRM_PF_STATUS_SET_SGL

*&---------------------------------------------------------------------*
*&      Form  FRM_CALLER_EXIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_DATA    text
*----------------------------------------------------------------------*
FORM FRM_CALLER_EXIT USING IS_DATA TYPE SLIS_DATA_CALLER_EXIT.
*  DATA: LR_ALV TYPE REF TO CL_GUI_ALV_GRID.
** 获取ALV instance
*  PERFORM FRM_GET_ALV_INSTANCE CHANGING LR_ALV.
**  * 设置下拉列表
*  DATA: LT_DROP TYPE LVC_T_DROP,
*        LS_DROP TYPE LVC_S_DROP.
*
*
** 加回车事件处理
*  CALL METHOD LR_ALV->REGISTER_EDIT_EVENT
*    EXPORTING
*      I_EVENT_ID = CL_GUI_ALV_GRID=>MC_EVT_ENTER.
ENDFORM.                    " FRM_CALLER_EXIT
*&---------------------------------------------------------------------*
FORM FRM_USER_COMMAND2 USING I_UCOMM LIKE SY-UCOMM
                            IS_SELFIELD TYPE SLIS_SELFIELD.
* 0. 数据不能为空
  CHECK GT_OUT[] IS NOT INITIAL.

* 1. 检查数据变化
  PERFORM FRM_CHECK_CHANGED_DATA.

* 2. 处理
  CASE I_UCOMM.
    WHEN '&IC1'.  "下钻
      PERFORM FRM_DRILL_DOWN USING IS_SELFIELD.
    WHEN '&SLA'. "全选
      PERFORM FRM_SELECT_CELL USING GT_OUT 'CHBOX' 'CELLSTYLE' IS_SELFIELD.
    WHEN '&DSA'. "全不选
      PERFORM FRM_DESELECT_ALL USING GT_OUT 'CHBOX' IS_SELFIELD.
    WHEN '&PRT'. "保存
*      PERFORM FRM_PRINT USING IS_SELFIELD.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "FRM_USER_COMMAND

*&---------------------------------------------------------------------*
*&      Form  FRM_DRILL_DOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IS_SELFIELD  text
*----------------------------------------------------------------------*
FORM FRM_DRILL_DOWN USING IS_SELFIELD TYPE SLIS_SELFIELD.
  DATA: LS_OUT TYPE TY_OUT.

* 字段不为空
  CHECK IS_SELFIELD-VALUE IS NOT INITIAL.

  READ TABLE GT_OUT INTO LS_OUT INDEX IS_SELFIELD-TABINDEX.
  CHECK SY-SUBRC EQ 0.

  CASE IS_SELFIELD-FIELDNAME.
    WHEN 'BELNR'. "销售订单号
      SET PARAMETER ID 'BLN' FIELD LS_OUT-BELNR.
      SET PARAMETER ID 'BUK' FIELD LS_OUT-BUKRS.
      SET PARAMETER ID 'GJR' FIELD LS_OUT-GJAHR.
      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    " FRM_DRILL_DOWN
