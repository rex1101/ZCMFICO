*&---------------------------------------------------------------------*
*&  Include           LZFGCMFIC01F03
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*&      Form  FRM_CHECK_INPUT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM FRM_CHECK_INPUT_DATA USING LS_BBKPF TYPE BBKPF CHANGING ET_RETURN TYPE BAPIRET2_T.



   PERFORM FRM_CHECK_BBKPF_HEADER USING LS_BBKPF.
   PERFORM FRM_CHECK_BBSEG_ITEM USING LS_BBKPF.

   IF GT_RETURN[] IS NOT INITIAL.
     ET_RETURN[] = GT_RETURN[].
   ENDIF.

 ENDFORM.                    "FRM_PROCESS_DOC_HEADER

*&---------------------------------------------------------------------*
*&      Form  frm_check_bkpf_header
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBKPF   text
*----------------------------------------------------------------------*
 FORM FRM_CHECK_BBKPF_HEADER USING LS_BBKPF TYPE BBKPF.







 ENDFORM.                    "frm_check_bkpf_header

*&---------------------------------------------------------------------*
*&      Form  frm_check_bkpf_header
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBKPF   text
*----------------------------------------------------------------------*
 FORM FRM_CHECK_BBSEG_ITEM USING LS_BBKPF TYPE BBKPF.

   DATA: LT_TAX_INFO TYPE STANDARD TABLE OF RTAX1U15,
         LS_TAX_INFO TYPE RTAX1U15.
   DATA: LV_WRBTR TYPE BSEG-WRBTR.
   DATA: LV_FWSTE TYPE FWSTE.


   DATA:LS_BBSEG TYPE BBSEG.

   DATA: LV_SHKZG TYPE SHKZG.

   LOOP AT GT_BBSEG INTO LS_BBSEG.


     SELECT SINGLE SHKZG FROM TBSL INTO LV_SHKZG WHERE BSCHL = LS_BBSEG-NEWBS.
     IF SY-SUBRC = 0.
       IF LV_SHKZG = 'H'.
         LS_BBSEG-WRBTR = 0 - LS_BBSEG-WRBTR.
       ENDIF.
     ENDIF.


     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
       EXPORTING
         INPUT  = LS_BBSEG-HKONT
       IMPORTING
         OUTPUT = LS_BBSEG-HKONT.

     CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
       EXPORTING
         INPUT  = LS_BBSEG-KOSTL
       IMPORTING
         OUTPUT = LS_BBSEG-KOSTL.


     IF LS_BBSEG-MWSKZ <> '' AND LS_BBKPF-XMWST = ''.

*  CALCULATE TAX FROM GROSSAMOUNT
       LV_WRBTR = LS_BBSEG-WRBTR + LS_BBSEG-FWBAS.
       CALL FUNCTION 'CALCULATE_TAX_FROM_GROSSAMOUNT'
         EXPORTING
           I_BUKRS = LS_BBKPF-BUKRS "公司代码
           I_MWSKZ = LS_BBSEG-MWSKZ "税码
           I_WAERS = LS_BBKPF-WAERS "'CNY'币种
           I_WRBTR = LV_WRBTR   "金额
         IMPORTING
           E_FWSTE = LV_FWSTE
         TABLES
           T_MWDAT = LT_TAX_INFO.

       IF LS_BBSEG-WRBTR <> LV_FWSTE .
         PERFORM FRM_CHECK_MSG USING 'E' 'AMT BASE ERROR'   .
       ENDIF.

     ENDIF.

     MODIFY GT_BBSEG FROM LS_BBSEG.
     CLEAR:LS_BBSEG.


   ENDLOOP.

   PERFORM FRM_CHECK_BBSEG_SA  USING LS_BBKPF."Finance Document Type “SA”




 ENDFORM.                    "frm_check_bkpf_header

*&---------------------------------------------------------------------*
*&      Form  FRM_CHECK_BBSEG_SA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBKPF   text
*----------------------------------------------------------------------*
 FORM FRM_CHECK_BBSEG_SA USING LS_BBKPF TYPE BBKPF.

   DATA: LS_BBSEG TYPE BBSEG.

   CHECK LS_BBKPF-BLART = 'SA'.

   LOOP AT GT_BBSEG INTO LS_BBSEG.

     IF LS_BBSEG-HKONT IS INITIAL.
       PERFORM FRM_CHECK_MSG USING 'E' 'SA凭证HKONT必填'   .
     ENDIF.


   ENDLOOP.



 ENDFORM.                    "frm_check_bkpf_header



*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_DOC_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBKPF           text
*      -->LS_DOCUMENTHEADER  text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_DOC_HEADER USING LS_BBKPF TYPE BBKPF .

*  Document Header
   GS_DOCUMENTHEADER-DOC_DATE   = LS_BBKPF-BLDAT.
   GS_DOCUMENTHEADER-PSTNG_DATE = LS_BBKPF-BUDAT.
   GS_DOCUMENTHEADER-DOC_TYPE   = LS_BBKPF-BLART.
   GS_DOCUMENTHEADER-COMP_CODE  = LS_BBKPF-BUKRS.
   GS_DOCUMENTHEADER-HEADER_TXT = LS_BBKPF-BKTXT.
   GS_DOCUMENTHEADER-REF_DOC_NO = LS_BBKPF-XBLNR.
   GS_DOCUMENTHEADER-BUS_ACT    = GS_CONF-GLVOR. "'RFBU'.
   GS_DOCUMENTHEADER-USERNAME   = GS_CONF-UNAME.



 ENDFORM.                    "FRM_PROCESS_DOC_HEADER

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_GL_ACCOUNTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_GL_ACCOUNTS USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF CHANGING LINES TYPE POSNR_ACC.

   DATA:LS_ACCOUNTGL TYPE BAPIACGL09.

*   CHECK LS_BBKPF-BLART = 'SA'.
   CHECK LS_BBSEG-NEWBS = '40' OR LS_BBSEG-NEWBS = '50'.

*   CHECK LS_BBSEG-MWSKZ IS INITIAL and LS_BBKPF-XMWST = ''.

   LS_ACCOUNTGL-COMP_CODE = LS_BBKPF-BUKRS.
   LS_ACCOUNTGL-PSTNG_DATE = LS_BBKPF-BUDAT.
   LS_ACCOUNTGL-DOC_TYPE = LS_BBKPF-BLART.

   LS_ACCOUNTGL-ITEMNO_ACC = LINES.
   LS_ACCOUNTGL-GL_ACCOUNT = LS_BBSEG-HKONT.
   LS_ACCOUNTGL-ITEM_TEXT = LS_BBSEG-SGTXT.
   LS_ACCOUNTGL-COSTCENTER = LS_BBSEG-KOSTL.
   LS_ACCOUNTGL-PROFIT_CTR = LS_BBSEG-PRCTR.

   LS_ACCOUNTGL-VALUE_DATE = LS_BBSEG-VALUT.
   LS_ACCOUNTGL-ALLOC_NMBR = LS_BBSEG-ZUONR.
   LS_ACCOUNTGL-WBS_ELEMENT  = LS_BBSEG-PROJK.
   LS_ACCOUNTGL-REF_KEY_1 = LS_BBSEG-XREF1.
   LS_ACCOUNTGL-REF_KEY_2 = LS_BBSEG-XREF2.
   LS_ACCOUNTGL-REF_KEY_3 = LS_BBSEG-XREF3.
   LS_ACCOUNTGL-TAX_CODE  = LS_BBSEG-MWSKZ.
   LS_ACCOUNTGL-BUS_AREA  = LS_BBSEG-GSBER.
   LS_ACCOUNTGL-ORDERID = LS_BBSEG-AUFNR.
   LS_ACCOUNTGL-CS_TRANS_T = LS_BBSEG-BEWAR."事务类型

   APPEND LS_ACCOUNTGL TO GT_ACCOUNTGL.
   CLEAR: LS_ACCOUNTGL.


 ENDFORM.                    "FRM_PROCESS_GL_ACCOUNTS

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_CURRENCY_AMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_CURRENCY_AMT USING LS_BBSEG TYPE BBSEG
                                     LS_BBKPF TYPE BBKPF
                               CHANGING LINES TYPE POSNR_ACC.


   DATA: LS_ACCOUNTTAX TYPE BAPIACTX09.


   DATA: LS_CURRENCYAMOUNT TYPE BAPIACCR09.
   DATA: LT_TAX_INFO TYPE STANDARD TABLE OF RTAX1U15,
      LS_TAX_INFO TYPE RTAX1U15.

   LS_CURRENCYAMOUNT-ITEMNO_ACC = LINES.
   LS_CURRENCYAMOUNT-CURR_TYPE = '00'.

   LS_CURRENCYAMOUNT-AMT_DOCCUR = LS_BBSEG-WRBTR. "人民币原币金额
   LS_CURRENCYAMOUNT-AMT_BASE   = LS_BBSEG-FWBAS.
   LS_CURRENCYAMOUNT-CURRENCY   = LS_BBKPF-WAERS.
   LS_CURRENCYAMOUNT-EXCH_RATE  = LS_BBKPF-KURSF.
   APPEND LS_CURRENCYAMOUNT TO GT_CURRENCYAMOUNT.
   CLEAR:LS_CURRENCYAMOUNT.

 ENDFORM.                    "FRM_PROCESS_CURRENCY_AMT

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*      -->LINES      text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_PROCESS_TAX USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF CHANGING LINES TYPE POSNR_ACC.



   DATA: LS_ACCOUNTTAX        TYPE BAPIACTX09.
   DATA: LV_SHKZG TYPE SHKZG.

   DATA: LS_CURRENCYAMOUNT TYPE BAPIACCR09.
   DATA: LT_TAX_INFO TYPE STANDARD TABLE OF RTAX1U15,
         LS_TAX_INFO TYPE RTAX1U15.
   DATA: LV_WRBTR TYPE BSEG-WRBTR.
   DATA: LV_FWSTE TYPE FWSTE.
   FIELD-SYMBOLS: <FS_CURRENCYAMOUNT> TYPE BAPIACCR09.
   FIELD-SYMBOLS: <FS_ACCOUNTGL> TYPE BAPIACGL09.


   REFRESH LT_TAX_INFO.

   CHECK LS_BBSEG-MWSKZ IS NOT INITIAL.

*  CALCULATE TAX FROM GROSSAMOUNT
   LV_WRBTR = LS_BBSEG-WRBTR.
   CALL FUNCTION 'CALCULATE_TAX_FROM_GROSSAMOUNT'
     EXPORTING
       I_BUKRS = LS_BBKPF-BUKRS "公司代码
       I_MWSKZ = LS_BBSEG-MWSKZ "税码
       I_WAERS = LS_BBKPF-WAERS "'CNY'币种
       I_WRBTR = LV_WRBTR   "金额
     IMPORTING
       E_FWSTE = LV_FWSTE
     TABLES
       T_MWDAT = LT_TAX_INFO.


   LOOP AT LT_TAX_INFO INTO LS_TAX_INFO.
     CLEAR LS_ACCOUNTTAX.
     LS_ACCOUNTTAX-ITEMNO_ACC = LINES."sy-tabix + 1.
     LS_ACCOUNTTAX-GL_ACCOUNT = LS_TAX_INFO-HKONT.
     LS_ACCOUNTTAX-TAX_CODE = LS_BBSEG-MWSKZ.               "'X1'.
     LS_ACCOUNTTAX-ACCT_KEY   = LS_TAX_INFO-KTOSL.
     LS_ACCOUNTTAX-COND_KEY   = LS_TAX_INFO-KSCHL.
     LS_ACCOUNTTAX-TAX_RATE = LS_TAX_INFO-MSATZ.
     LS_ACCOUNTTAX-TAXJURCODE = LS_TAX_INFO-TXJCD.
     LS_ACCOUNTTAX-TAXJURCODE_DEEP  = LS_TAX_INFO-TXJCD_DEEP.
     LS_ACCOUNTTAX-TAXJURCODE_LEVEL = LS_TAX_INFO-TXJLV.
     LS_ACCOUNTTAX-DIRECT_TAX = 'X'.
   ENDLOOP.


   IF  LS_BBKPF-XMWST = 'X'." auto process tax

     READ TABLE GT_CURRENCYAMOUNT ASSIGNING <FS_CURRENCYAMOUNT> WITH KEY ITEMNO_ACC = LINES.
     IF SY-SUBRC = 0.
*       modify document currency of source line
       <FS_CURRENCYAMOUNT>-AMT_DOCCUR = <FS_CURRENCYAMOUNT>-AMT_DOCCUR - LV_FWSTE.
     ENDIF.

     READ TABLE GT_ACCOUNTGL ASSIGNING <FS_ACCOUNTGL> WITH KEY ITEMNO_ACC = LINES.
     IF SY-SUBRC = 0.
*       modify document currency of source line
       <FS_ACCOUNTGL>-TAX_CODE = ''.
     ENDIF.

*       add new tax line
     LINES = LINES + 1.

     CLEAR LS_CURRENCYAMOUNT.
     LS_ACCOUNTTAX-ITEMNO_ACC = LINES.
     LS_CURRENCYAMOUNT-ITEMNO_ACC = LINES.
     LS_CURRENCYAMOUNT-CURRENCY   = 'CNY'.
     LS_CURRENCYAMOUNT-AMT_DOCCUR = LS_TAX_INFO-WMWST.
     LS_CURRENCYAMOUNT-AMT_BASE = LS_TAX_INFO-KAWRT."<-----------It's not the base, but gross amount
     APPEND LS_CURRENCYAMOUNT TO GT_CURRENCYAMOUNT.

   ELSE."manual process tax
     DELETE GT_ACCOUNTGL WHERE ITEMNO_ACC = LINES.


   ENDIF.


   APPEND LS_ACCOUNTTAX TO GT_ACCOUNTTAX.

 ENDFORM.                    "FRM_PROCESS_TAX
*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_ACCOUNTPAYABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*      -->LINES      text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_ACCOUNTPAYABLE USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF CHANGING LINES TYPE POSNR_ACC.

   DATA: LS_ACCOUNTPAYABLE TYPE BAPIACAP09.
*   CHECK LS_BBKPF-BLART = 'KR' OR LS_BBKPF-BLART = 'KG'.
   CHECK LS_BBSEG-NEWBS > 20.
   CHECK LS_BBSEG-NEWBS <> 40.
   CHECK LS_BBSEG-NEWBS <> 50.


   LS_ACCOUNTPAYABLE-ITEMNO_ACC = LINES.

   LS_ACCOUNTPAYABLE-VENDOR_NO    = LS_BBSEG-HKONT.
   LS_ACCOUNTPAYABLE-SP_GL_IND    = LS_BBSEG-NEWUM.
   LS_ACCOUNTPAYABLE-PMNTTRMS     = LS_BBSEG-ZTERM.
   LS_ACCOUNTPAYABLE-BLINE_DATE   = LS_BBSEG-ZFBDT.
   LS_ACCOUNTPAYABLE-ALLOC_NMBR   = LS_BBSEG-ZUONR.
   LS_ACCOUNTPAYABLE-ITEM_TEXT    = LS_BBSEG-SGTXT.
   LS_ACCOUNTPAYABLE-PYMT_CUR_ISO = LS_BBKPF-WAERS.

   LS_ACCOUNTPAYABLE-REF_KEY_1 = LS_BBSEG-XREF1.
   LS_ACCOUNTPAYABLE-REF_KEY_2 = LS_BBSEG-XREF2.
   LS_ACCOUNTPAYABLE-REF_KEY_3 = LS_BBSEG-XREF3.
   LS_ACCOUNTPAYABLE-TAX_CODE = LS_BBSEG-MWSKZ.
   LS_ACCOUNTPAYABLE-BUS_AREA = LS_BBSEG-GSBER.

*应付的利润中心
   IF NOT LS_BBSEG-PRCTR IS INITIAL.
     LS_ACCOUNTPAYABLE-PROFIT_CTR = LS_BBSEG-PRCTR.
   ENDIF.

   APPEND LS_ACCOUNTPAYABLE TO GT_ACCOUNTPAYABLE.
   CLEAR:LS_ACCOUNTPAYABLE.

 ENDFORM.                    "FRM_PROCESS_ACCOUNTPAYABLE

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_CURRENCY_AMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_EXTENSION2 USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF LINES TYPE POSNR_ACC.

********     Activate user exit(ZFI_DOCUMENT_POSTING)     *********************
********     SE19 CREATE USER EXIT BADI_ACC_DOCUMENT      *********************
********     Defined structure reference ACCIT or ACCCR   *********************

* For example
*   DATA: LS_EXTEN TYPE BAPIPAREX.
* Extension field value
*   CLEAR LS_EXTEN.

*   IF LS_BBSEG-PRCTR NE ''. "
*     LS_EXTEN-STRUCTURE = 'PRCTR'.  "bseg field name
*     LS_EXTEN-VALUEPART1 = LINES.   "bseg lines
*     LS_EXTEN-VALUEPART2 = '0000001100'. "bseg field value
*     LS_EXTEN-VALUEPART3 = 'ACCIT'."Please fill Structure Name ACCIT or ACCCR
*     APPEND LS_EXTEN TO GT_EXT2..
*     CLEAR LS_EXTEN.
*   ENDIF.

 ENDFORM.                    "FRM_PROCESS_CURRENCY_AMT

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_ACCOUNTPAYABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*      -->LINES      text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_ACCOUNTRECEIVABLE USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF CHANGING LINES TYPE POSNR_ACC.

   DATA: LS_ACCOUNTRECEIVABLE TYPE BAPIACAR09.

   CHECK LS_BBSEG-NEWBS <= 20.

   LS_ACCOUNTRECEIVABLE-ITEMNO_ACC = LINES.
   LS_ACCOUNTRECEIVABLE-PMNT_BLOCK = LS_BBSEG-ZLSPR.
   LS_ACCOUNTRECEIVABLE-CUSTOMER   = LS_BBSEG-NEWKO.
   LS_ACCOUNTRECEIVABLE-SP_GL_IND  = LS_BBSEG-NEWUM.
   LS_ACCOUNTRECEIVABLE-PMNTTRMS   = LS_BBSEG-ZTERM.
   LS_ACCOUNTRECEIVABLE-BLINE_DATE = LS_BBSEG-ZFBDT.
   LS_ACCOUNTRECEIVABLE-ALLOC_NMBR = LS_BBSEG-ZUONR.
   LS_ACCOUNTRECEIVABLE-ITEM_TEXT  = LS_BBSEG-SGTXT.

   LS_ACCOUNTRECEIVABLE-REF_KEY_1 = LS_BBSEG-XREF1.
   LS_ACCOUNTRECEIVABLE-REF_KEY_2 = LS_BBSEG-XREF2.
   LS_ACCOUNTRECEIVABLE-REF_KEY_3 = LS_BBSEG-XREF3.
   LS_ACCOUNTRECEIVABLE-BUS_AREA = LS_BBSEG-GSBER."业务范围
   LS_ACCOUNTRECEIVABLE-TAX_CODE = LS_BBSEG-MWSKZ."税码
   LS_ACCOUNTRECEIVABLE-PROFIT_CTR = LS_BBSEG-PRCTR."税码

   APPEND LS_ACCOUNTRECEIVABLE TO  GT_ACCOUNTRECEIVABLE.
   CLEAR:LS_ACCOUNTRECEIVABLE.


 ENDFORM.                    "FRM_PROCESS_ACCOUNTPAYABLE

*&---------------------------------------------------------------------*
*&      Form  FRM_PROCESS_ACCOUNTPAYABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BBSEG   text
*      -->LS_BBKPF   text
*      -->LINES      text
*----------------------------------------------------------------------*
 FORM FRM_PROCESS_CRITERIA USING LS_BBSEG TYPE BBSEG LS_BBKPF TYPE BBKPF LINES TYPE POSNR_ACC.

   DATA: LS_CRITERIA          TYPE BAPIACKEC9.

*        IF LS_BBSEG-kndnr <> ''  .
*          LS_CRITERIA-itemno_acc = LINES."凭证行项目
*          LS_CRITERIA-fieldname  = 'KNDNR'."获利能力段的客户
*          LS_CRITERIA-character  = wa_itab-kndnr.
*          APPEND LS_CRITERIA TO Gt_criteria.
*          CLEAR LS_CRITERIA.
*          ENDIF.
*          IF  LS_BBSEG-prodh <> '' .
*          LS_CRITERIA-itemno_acc = LINES.
*          LS_CRITERIA-fieldname  = 'PRODH'."获利能力段的产品层次
*          LS_CRITERIA-character  = wa_itab-prodh.
*          APPEND LS_CRITERIA TO Gt_criteria.
*          CLEAR LS_CRITERIA.
*        ENDIF.

 ENDFORM.                    "FRM_PROCESS_ACCOUNTPAYABLE
