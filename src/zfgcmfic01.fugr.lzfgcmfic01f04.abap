*&---------------------------------------------------------------------*
*&  Include           LZFGCMFIC01F04
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  FRM_CHECK_INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
  FORM FRM_CHECK_INPUT.
    DATA: LS_RETURN TYPE BAPIRET2.

    PERFORM FRM_CHECK_INPUT_CONF.
*GS_ERROR_RETURN

    IF GT_RETURN[] IS NOT INITIAL.
      GS_ERROR_RETURN-TYPE = 'E'.
      LOOP AT GT_RETURN INTO LS_RETURN.
        CONCATENATE LS_RETURN-MESSAGE GS_ERROR_RETURN-MESSAGE INTO GS_ERROR_RETURN-MESSAGE.
      ENDLOOP.
    ENDIF.

    PERFORM FRM_CHECK_BDC_DATA.

  ENDFORM.                    "FRM_CHECK_INPUT
*&---------------------------------------------------------------------*
*&      Form  FRM_CLEAR_GLOBE_VARIABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
  FORM FRM_CLEAR_GLOBE_VARIABLE.

*  clear globe variable
    CLEAR: GS_DOCUMENTHEADER,GS_CONF." CLEAR BAPI
    CLEAR:  GT_FIMSG, GT_FIMSG[], G_BELNR, G_TCODE." CLEAR BDC
    CLEAR: GV_ERROR,GV_FNAM.

    REFRESH: GT_ACCOUNTGL[],GT_ACCOUNTPAYABLE[],GT_ACCOUNTRECEIVABLE[],
             GT_CURRENCYAMOUNT[],GT_EXT2[],GT_RETURN[],GT_BBKPF[],GT_BBSEG[].
*    REFRESH: GT_BBKPF[],GT_BBSEG[].


  ENDFORM.                    "FRM_CLEAR_GLOBE_VARIABLE

*&---------------------------------------------------------------------*
*&      Form  FRM_CHECK_INPUT_CONF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
  FORM FRM_CHECK_INPUT_CONF.

    RANGES:R_TCODE FOR SY-TCODE.

    R_TCODE-SIGN = 'I'.
    R_TCODE-OPTION = 'EQ'.
    R_TCODE-LOW = 'FB01'. "Post
    APPEND R_TCODE.
    R_TCODE-LOW = 'FBB1'.
    APPEND R_TCODE.
    R_TCODE-LOW = 'FB05'. "Clear
    APPEND R_TCODE.
    R_TCODE-LOW = 'FBS1'.
    APPEND R_TCODE.
    R_TCODE-LOW = 'FBV1'. "Park
    APPEND R_TCODE.




    IF GS_CONF-SUBFU = ''.
      PERFORM FRM_CHECK_MSG USING 'E' '凭证创建方式不能为空1、BAPI 2、BDC!'   .
    ENDIF.

    IF GS_CONF-UNAME = ''.
*      PERFORM FRM_CHECK_MSG USING 'E' '凭证创建方式不能为空1、BAPI 2、BDC!'   .
      GS_CONF-UNAME = SY-UNAME.
    ENDIF.
    IF GS_CONF-POST_TYPE = ''.
*      PERFORM FRM_CHECK_MSG USING 'E' '凭证创建方式不能为空1、BAPI 2、BDC!'   .
      GS_CONF-POST_TYPE = SY-UNAME.
    ENDIF.

    IF GS_CONF-BDC_MODE = ''.
*      PERFORM FRM_CHECK_MSG USING 'E' '凭证创建方式不能为空1、BAPI 2、BDC!'   .
      GS_CONF-BDC_MODE = 'N'.
    ENDIF.

    IF GS_CONF-MESSAGE = ''.
*      PERFORM FRM_CHECK_MSG USING 'E' '凭证创建方式不能为空1、BAPI 2、BDC!'   .
      GS_CONF-MESSAGE = 'X'.
    ENDIF.

    IF GS_CONF-SUBFU = '1' ."BAPI
      GV_FNAM = 'ZFI_POSTING_DOCUMENT_BAPI'.
      IF GS_CONF-GLVOR = ''.
        PERFORM FRM_CHECK_MSG USING 'E' '业务方式不能为空'   .
      ENDIF.
    ELSEIF GS_CONF-SUBFU = '2'."BDC
      GV_FNAM = 'ZFI_POSTING_DOCUMENT_BDC'.
      IF GS_CONF-TCODE = ''.
        PERFORM FRM_CHECK_MSG USING 'E' 'TCODE不能为空!'   .
      ELSE.
        IF GS_CONF-TCODE NOT IN R_TCODE.
          PERFORM FRM_CHECK_MSG USING 'E' 'BDC TCODE不合规!'   .
        ENDIF.

      ENDIF.
    ENDIF.

  ENDFORM.                    "FRM_CHECK_INPUT_CONF

*&---------------------------------------------------------------------*
*&      Form  FRM_ERRO_MSG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_TYID     text
*      -->I_MESSAGE  text
*      -->I_TYMES    text
*----------------------------------------------------------------------*
  FORM FRM_CHECK_MSG USING I_TYMES TYPE CHAR1  I_MESSAGE TYPE BAPI_MSG .

    DATA: LS_RETURN LIKE BAPIRET2.

    LS_RETURN-TYPE = I_TYMES.
    LS_RETURN-MESSAGE = I_MESSAGE.
    LS_RETURN-MESSAGE_V4 = 'CHECK ERROR'.


    IF LS_RETURN-TYPE = 'E'.
      GV_ERROR = GV_ERROR + 1.
    ENDIF.

    APPEND LS_RETURN TO GT_RETURN.
    CLEAR:LS_RETURN.

  ENDFORM.                    "FRM_ERRO_MSG

*&---------------------------------------------------------------------*
*&      Form  FRM_CHECK_BDC_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
  FORM FRM_CHECK_BDC_DATA.
    TYPES: BEGIN OF TY_SHKZG_AMOUNT,
      SHKZG TYPE TBSL,
      WRBTR TYPE WRBTR,
      END OF TY_SHKZG_AMOUNT.

    DATA: LS_SHKZH TYPE TY_SHKZG_AMOUNT,
          LT_SHKZH TYPE TABLE OF TY_SHKZG_AMOUNT.
    DATA: LS_SHKZS TYPE TY_SHKZG_AMOUNT,
          LT_SHKZS TYPE TABLE OF TY_SHKZG_AMOUNT.

    DATA: LS_BBSEG TYPE BBSEG.
    DATA: LS_TBSL TYPE TBSL.
    DATA: LT_TBSL TYPE TABLE OF TBSL.
    SELECT * FROM TBSL INTO TABLE LT_TBSL.

    LOOP AT GT_BBSEG INTO LS_BBSEG.
      IF LS_BBSEG-NEWKO = ''.
        PERFORM FRM_CHECK_MSG USING 'E' 'BDC NEWKO科目不能为空!'   .
      ENDIF.
      IF LS_BBSEG-NEWBS = ''.
        PERFORM FRM_CHECK_MSG USING 'E' 'BDC NEWBS记账不能不能为空!'   .
      ENDIF.

      READ TABLE LT_TBSL INTO LS_TBSL WITH KEY BSCHL = LS_BBSEG-NEWBS SHKZG = 'S'.
      IF SY-SUBRC = 0.
        LS_SHKZS-SHKZG = LS_TBSL-SHKZG.
        LS_SHKZS-WRBTR = LS_BBSEG-WRBTR.
        COLLECT LS_SHKZS INTO LT_SHKZS.
        CLEAR:LS_SHKZS.
      ENDIF.

      READ TABLE LT_TBSL INTO LS_TBSL WITH KEY BSCHL = LS_BBSEG-NEWBS SHKZG = 'H'.
      IF SY-SUBRC = 0.
        LS_SHKZH-SHKZG = LS_TBSL-SHKZG.
        LS_SHKZH-WRBTR = LS_BBSEG-WRBTR.
        COLLECT LS_SHKZH INTO LT_SHKZH.
        CLEAR:LS_SHKZH.
      ENDIF.

    ENDLOOP.

    READ TABLE LT_SHKZH INTO LS_SHKZH INDEX 1.
    READ TABLE LT_SHKZS INTO LS_SHKZS INDEX 1.

    IF LS_SHKZH-WRBTR <> LS_SHKZS-WRBTR.
      PERFORM FRM_CHECK_MSG USING 'E' 'BDC 借贷不平请检查!'   .
    ENDIF.

  ENDFORM.                    "FRM_CHECK_BDC_DATA
