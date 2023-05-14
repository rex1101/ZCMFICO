*&---------------------------------------------------------------------*
*&  Include           LZFGCMFIC01F01
*&---------------------------------------------------------------------*


*----------------------------------------------------------------------*
***INCLUDE LZFI01F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form POST_INIT
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
FORM POST_INIT .

* 366 ~ 375 lines copy of 'RFBIBL01' program
  CLEAR: XEOF, XNEWG,
         GROUP_COUNT, BELEG_COUNT,
         SATZ2_COUNT, SATZ2_CNT_AKT,
         ERROR_RUN,
         WT_COUNT,
         COMMIT_COUNT, COUNT.
  MAX_COMMIT = MAX_COMM.

*------- init log
  CALL FUNCTION 'FI_MESSAGE_INIT'.

ENDFORM. " POST_INIT


*----------------------------------------------------------------------*
*& Form LOG_MSG
*&---------------------------------------------------------------------*
* collects info messages for log or displays pop up
*----------------------------------------------------------------------*
FORM LOG_MSG USING I_MSGID LIKE SY-MSGID
                      I_MSGTY LIKE SY-MSGTY
                      I_MSGNO LIKE SY-MSGNO
                      I_MSGV1
                      I_MSGV2
                      I_MSGV3
                      I_MSGV4.

* declaration
  DATA: H_FIMSG LIKE FIMSG.

  CHECK XINF EQ SPACE.

  IF XLOG = 'X'.

* log the message with the message handler
    H_FIMSG-MSGID = I_MSGID.
    H_FIMSG-MSGTY = I_MSGTY.
    H_FIMSG-MSGNO = I_MSGNO.
    H_FIMSG-MSGV1 = I_MSGV1. CONDENSE H_FIMSG-MSGV1.
    H_FIMSG-MSGV2 = I_MSGV2. CONDENSE H_FIMSG-MSGV2.
    H_FIMSG-MSGV3 = I_MSGV3. CONDENSE H_FIMSG-MSGV3.
    H_FIMSG-MSGV4 = I_MSGV4. CONDENSE H_FIMSG-MSGV4.
    CALL FUNCTION 'FI_MESSAGE_COLLECT'
      EXPORTING
        I_FIMSG       = H_FIMSG
        I_XAPPN       = 'X'
      EXCEPTIONS
        MSGID_MISSING = 1
        MSGNO_MISSING = 2
        MSGTY_MISSING = 3
        OTHERS        = 4.
    CLEAR: GT_FIMSG, GT_FIMSG[].                            "20041006
    APPEND H_FIMSG TO GT_FIMSG. "20041006 LOG#### APPEND

  ELSEIF XPOP = 'X'.
* popup
    MESSAGE ID     I_MSGID
            TYPE   I_MSGTY
            NUMBER I_MSGNO
            WITH   I_MSGV1 I_MSGV2 I_MSGV3 I_MSGV4.
  ENDIF.

ENDFORM. " LOG_MSG
*&---------------------------------------------------------------------*
*& Form log_print
*&---------------------------------------------------------------------*
* display log
*----------------------------------------------------------------------*
FORM LOG_PRINT.

  IF XLOG = 'X'.
    IF NOT SY-BATCH IS INITIAL.
      CALL FUNCTION 'FI_MESSAGE_PROTOCOL'
        EXCEPTIONS
          NO_MESSAGE = 1
          NOT_BATCH  = 2
          OTHERS     = 3.
    ELSE.

    ENDIF.
  ENDIF.

ENDFORM. " log_print

*&---------------------------------------------------------------------*
*& Form log_abort
*&---------------------------------------------------------------------*
* foreground: stop program / background: message aXXX
*----------------------------------------------------------------------*

FORM LOG_ABORT USING I_MSGID LIKE SY-MSGID
                     I_MSGNO LIKE SY-MSGNO.

  IF SY-BATCH IS INITIAL.
    IF XLOG = 'X'.
      PERFORM LOG_MSG USING I_MSGID 'I' I_MSGNO
                            SPACE SPACE SPACE SPACE.
    ENDIF.
    PERFORM LOG_PRINT.
    ROLLBACK WORK.
    IF XPOP = 'X'.                                          "Note 559106
      MESSAGE ID I_MSGID                                    "Note 559106
              TYPE 'I'                                      "Note 559106
              NUMBER I_MSGNO.                               "Note 559106
    ELSEIF XLOG = 'X' OR XINF = 'X' .                       "Note 559106
      MESSAGE ID I_MSGID                                    "Note 559106
      TYPE 'S'                                              "Note 559106
      NUMBER I_MSGNO.                                       "Note 559106
    ENDIF.                                                  "Note 559106
* 20041117 KHLEE Prevent because of DUMP
* stop.
  ELSE.
    PERFORM LOG_PRINT.
    MESSAGE ID I_MSGID
            TYPE 'A'
            NUMBER I_MSGNO.
  ENDIF.

ENDFORM. " log_abort

* FORM that add 20041006 ===========================================
*&---------------------------------------------------------------------*
*& Form APPEND_T_MESSTAB
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_MESSTAB TABLES P_MESSTAB STRUCTURE FIMSG.
* In the case of session error, by 'SY' because can not know correct
* reason of document creation error alteration - 20041124 KHLEE
* P_MESSTAB[] = IT_FIMSG[].
  CLEAR: P_MESSTAB, P_MESSTAB[].
  P_MESSTAB-MSGTY  = SY-MSGTY.
  P_MESSTAB-MSGID  = SY-MSGID.
  P_MESSTAB-MSGNO  = SY-MSGNO.
  P_MESSTAB-MSGV1  = SY-MSGV1.
  P_MESSTAB-MSGV2  = SY-MSGV2.
  P_MESSTAB-MSGV3  = SY-MSGV3.
  P_MESSTAB-MSGV4  = SY-MSGV4.
  APPEND P_MESSTAB.
ENDFORM. " APPEND_T_MESSTAB
*&---------------------------------------------------------------------*
*& Form GET_FIELD_INFO
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM GET_FIELD_INFO.
  CLEAR: T_DD03L, T_DD03L[].

  SELECT * FROM DD03L INTO TABLE T_DD03L
          WHERE TABNAME IN ('BGR00','BBKPF','BBSEG','BBTAX','BWITH',
                            'BSELK','BSELP')
            AND AS4LOCAL = 'A'.

ENDFORM. " GET_FIELD_INFO
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BGR00
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BGR00.
  CLEAR: BGR00, TFILE, TFILE[].

  BGR00-STYPE = '0'.
  BGR00-GROUP = 'FI-DOC'.
  BGR00-MANDT = SY-MANDT.
  BGR00-USNAM = SY-UNAME.
  BGR00-NODATA = '/'.

  TFILE = BGR00.
  APPEND TFILE.

ENDFORM. " APPEND_TFILE_FROM_BGR00
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BBKPF
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BBKPF TABLES L_BBKPF STRUCTURE BBKPF.
  CLEAR: TFILE, BBKPF.

  LOOP AT L_BBKPF.

    MOVE-CORRESPONDING L_BBKPF TO BBKPF.
    BBKPF-STYPE = '1'.
    IF BBKPF-TCODE IS INITIAL.
      BBKPF-TCODE = C_TCODE_NORMAL.
    ENDIF.
    PERFORM FILL_NODATA USING 'BBKPF'.
    TFILE = BBKPF.
    APPEND TFILE.

  ENDLOOP.

ENDFORM. " APPEND_TFILE_FROM_BBKPF
*&---------------------------------------------------------------------*
*& Form FILL_NODATA
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* -->P_5202 text
*----------------------------------------------------------------------*
FORM FILL_NODATA USING P_TABNAME.
  DATA LV_FIELDNAME(20).
  FIELD-SYMBOLS <B>.

  DATA: LV_DATASTR TYPE STRING.
  DATA: LV_DATA TYPE DATUM.

  SORT T_DD03L BY POSITION.
  LOOP AT T_DD03L WHERE TABNAME = P_TABNAME.
    CONCATENATE T_DD03L-TABNAME '-' T_DD03L-FIELDNAME
                INTO LV_FIELDNAME.
    ASSIGN (LV_FIELDNAME) TO <B>.

    IF LV_FIELDNAME = 'BBSEG-VALUT' AND BBSEG-VALUT = '00000000'.
      MOVE '/' TO <B>.
    ENDIF.
    IF LV_FIELDNAME = 'BBSEG-ZFBDT' AND BBSEG-ZFBDT = '00000000'.
      MOVE '/' TO <B>.
    ENDIF.
    IF LV_FIELDNAME = 'BBSEG-ZBD1T' AND BBSEG-ZBD1T = '000'.
      MOVE '/' TO <B>.
    ENDIF.
    IF LV_FIELDNAME = 'BBSEG-AUFNR' AND BBSEG-AUFNR = '000000000000'.
      MOVE '/' TO <B>.
    ENDIF.
    IF LV_FIELDNAME = 'BBSEG-REBZJ' AND BBSEG-REBZJ = '0000000000'.
      MOVE '/' TO <B>.
    ENDIF.
    IF LV_FIELDNAME = 'BBSEG-PROJK' AND BBSEG-PROJK = '00000000'.
      MOVE '/' TO <B>.
    ENDIF.

    IF LV_FIELDNAME = 'BBKPF-VATDATE' AND BBKPF-VATDATE = '00000000'.
      MOVE '/' TO <B>.
    ENDIF.

    IF LV_FIELDNAME = 'BBKPF-XBWAE' AND BBKPF-XBWAE = ''.
      IF BBKPF-TCODE = 'FBV1'.   "##### ##

        DATA : LV_WAERS LIKE T001-WAERS.
        SELECT SINGLE WAERS INTO LV_WAERS
          FROM T001 WHERE BUKRS = BBKPF-BUKRS.
        IF LV_WAERS <> BBKPF-WAERS.
          <B> = '!'.
        ENDIF.
      ENDIF.
    ENDIF.
    IF <B> IS INITIAL.
      <B> = '/'.
    ELSEIF <B> = '!'.      "space# ## ### # ### #### ##
      <B> = ' '.           "space# ### default## #######
    ENDIF.

  ENDLOOP.

ENDFORM. " FILL_NODATA
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BBSEG
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BBSEG TABLES L_BBSEG STRUCTURE BBSEG.
  CLEAR: TFILE, BBSEG.

  LOOP AT L_BBSEG.
    MOVE-CORRESPONDING L_BBSEG TO BBSEG.
    BBSEG-STYPE = '2'.
    BBSEG-TBNAM = 'BBSEG'.

    PERFORM FILL_NODATA USING 'BBSEG'.
    TFILE = BBSEG.
    APPEND TFILE.
  ENDLOOP.

ENDFORM. " APPEND_TFILE_FROM_BBSEG
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BBTAX
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BBTAX TABLES L_BBTAX STRUCTURE BBTAX.
  CLEAR: TFILE, BBTAX.

  LOOP AT L_BBTAX.
    MOVE-CORRESPONDING L_BBTAX TO BBTAX.
    BBTAX-STYPE = '2'.
    BBTAX-TBNAM = 'BBTAX'.
    PERFORM FILL_NODATA USING 'BBTAX'.
    TFILE = BBTAX.
    APPEND TFILE.
  ENDLOOP.

ENDFORM. " APPEND_TFILE_FROM_BBTAX
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BWITH
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BWITH TABLES L_BWITH STRUCTURE BWITH.
  CLEAR: TFILE, BWITH.

  LOOP AT L_BWITH.
    MOVE-CORRESPONDING L_BWITH TO BWITH.
    BWITH-STYPE = '2'.
    BWITH-TBNAM = 'BWITH'.
    PERFORM FILL_NODATA USING 'BWITH'.
    TFILE = BWITH.
    APPEND TFILE.
  ENDLOOP.

ENDFORM. " APPEND_TFILE_FROM_BWITH
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BSELK
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BSELK TABLES L_BSELK STRUCTURE BSELK.
  CLEAR: TFILE, BSELK.

  LOOP AT L_BSELK.
    MOVE-CORRESPONDING L_BSELK TO BSELK.
    BSELK-STYPE = '2'.
    BSELK-TBNAM = 'BSELK'.
    PERFORM FILL_NODATA USING 'BSELK'.
    TFILE = BSELK.
    APPEND TFILE.
  ENDLOOP.
ENDFORM. " APPEND_TFILE_FROM_BSELK
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BSELP
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BSELP TABLES L_BSELP STRUCTURE BSELP.
  CLEAR: TFILE, BSELP.

  LOOP AT L_BSELP.
    MOVE-CORRESPONDING L_BSELP TO BSELP.
    BSELP-STYPE = '2'.
    BSELP-TBNAM = 'BSELP'.
    PERFORM FILL_NODATA USING 'BSELP'.
    TFILE = BSELP.
    APPEND TFILE.
  ENDLOOP.

ENDFORM. " APPEND_TFILE_FROM_BSELP
*&---------------------------------------------------------------------*
*& Form APPEND_TFILE_FROM_BSELK_BSELP
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* -->L_BSELK text
* -->L_BSELP text
*----------------------------------------------------------------------*
FORM APPEND_TFILE_FROM_BSELK_BSELP TABLES L_BSELK STRUCTURE BSELK
                                          L_BSELP STRUCTURE BSELP.
  CLEAR : TFILE, BSELK.
  LOOP AT L_BSELK.
    MOVE-CORRESPONDING L_BSELK TO BSELK.
    BSELK-STYPE = '2'.
    BSELK-TBNAM = 'BSELK'.
    PERFORM FILL_NODATA USING 'BSELK'.
    TFILE = BSELK.
    APPEND TFILE.

    CLEAR : TFILE, BSELP.
    LOOP AT L_BSELP WHERE STYPE EQ L_BSELK-AGKOA.
* ### #### #### ## ###..
      IF L_BSELP-TBNAM+9(1) NE SPACE.
        CHECK L_BSELP-TBNAM+9(1) = L_BSELK-TBNAM+9(1).
      ENDIF.
* ### #### ### ## ## ### ### #### ##20060227
      IF L_BSELP-TBNAM+10(10) NE SPACE.
        CHECK L_BSELP-TBNAM+10(10) = L_BSELK-AGKON.
      ENDIF.
* ### ### SPECIAL G/L# #### ### ### ######0227
      IF L_BSELP-TBNAM+20(1) NE SPACE.
        CHECK L_BSELP-TBNAM+20(1) = L_BSELK-AGUMS(1).
      ENDIF.
      CLEAR : L_BSELP-STYPE.
      MOVE-CORRESPONDING L_BSELP TO BSELP.
      BSELP-STYPE = '2'.
      BSELP-TBNAM = 'BSELP'.
      PERFORM FILL_NODATA USING 'BSELP'.
      TFILE = BSELP.
      APPEND TFILE.
    ENDLOOP.

  ENDLOOP.
ENDFORM. " APPEND_TFILE_FROM_BSELK_BSELP
*&---------------------------------------------------------------------*
*& Form CONVERT_AMOUNT
*&---------------------------------------------------------------------*
* ### ### ## #### ##
*----------------------------------------------------------------------*
* -->P_BBSEG ####
* -->P_BBTAX ##
* -->P_BWITH ###
* -->P_BSELP2 ####
*----------------------------------------------------------------------*
FORM CONVERT_AMOUNT TABLES P_BBSEG STRUCTURE BBSEG
                            P_BBTAX  STRUCTURE BBTAX
                            P_BWITH  STRUCTURE BWITH.

* ###### ## ### ##### ##### #### ### ##
  DATA : LV_DCPFM LIKE USR01-DCPFM,
         LV_CHAR(1).
  SELECT SINGLE USR01~DCPFM
    INTO LV_DCPFM
    FROM USR01
   WHERE USR01~BNAME EQ SY-UNAME.

* ## ### ### '.'## ### ### ##.
  CHECK LV_DCPFM NE 'X'.

  CASE LV_DCPFM.
    WHEN SPACE.
      LV_CHAR = ','.
    WHEN 'X'.
      LV_CHAR = '.'.
    WHEN 'Y'.
      LV_CHAR = ','.
  ENDCASE.

  LOOP AT P_BBSEG.
    PERFORM CHANGE_FORMAT USING : P_BBSEG-DMBTR LV_CHAR,
                                  P_BBSEG-WRBTR LV_CHAR,
                                  P_BBSEG-WMWST LV_CHAR,
                                  P_BBSEG-MWSTS LV_CHAR,
                                  P_BBSEG-QSSHB LV_CHAR,
                                  P_BBSEG-QSFBT LV_CHAR.
    MODIFY P_BBSEG.
  ENDLOOP.

ENDFORM. " CONVERT_AMOUNT
*&---------------------------------------------------------------------*
*& Form CHANGE_FORMAT
*&---------------------------------------------------------------------*
* #### ##
*----------------------------------------------------------------------*
* -->P_WRBTR ####
* -->P_CHAR ### ###
*----------------------------------------------------------------------*
FORM CHANGE_FORMAT USING P_WRBTR
                             P_CHAR.
  CHECK NOT P_WRBTR IS INITIAL.

  DATA : LV_LEN      TYPE I,
         LV_POS      TYPE I,
         LV_AMT1(20) TYPE C,
         LV_AMT2(03) TYPE C.
  CONDENSE P_WRBTR NO-GAPS.

  LV_LEN  = STRLEN( P_WRBTR ).
  IF LV_LEN > 3.
    LV_POS  = LV_LEN - 3.
    LV_AMT2 = P_WRBTR+LV_POS(3).
  ENDIF.
* ###### ### #### #### ## ###.
  IF LV_AMT2(1) EQ ',' OR LV_AMT2(1) EQ '.'.
    LV_AMT1 = P_WRBTR(LV_POS).
    TRANSLATE : LV_AMT1 USING ', ',
                LV_AMT1 USING '. '.
    CONDENSE LV_AMT1 NO-GAPS.
    CONCATENATE LV_AMT1 P_CHAR LV_AMT2+1(2) INTO P_WRBTR.
  ELSEIF LV_AMT2+1(1) EQ ',' OR LV_AMT2+1(1) EQ '.'.
    LV_AMT1 = P_WRBTR(LV_POS).
    TRANSLATE : LV_AMT1 USING ', ',
                LV_AMT1 USING '. '.
    CONDENSE LV_AMT1 NO-GAPS.
    CONCATENATE LV_AMT1 LV_AMT2(1) P_CHAR LV_AMT2+2(1) INTO P_WRBTR.
  ELSEIF LV_AMT2+2(1) EQ ',' OR LV_AMT2+2(1) EQ '.'.
    LV_AMT1 = P_WRBTR(LV_POS).
    TRANSLATE : LV_AMT1 USING ', ',
                LV_AMT1 USING '. '.
    CONDENSE LV_AMT1 NO-GAPS.
    CONCATENATE LV_AMT1 LV_AMT2+(2) P_CHAR INTO P_WRBTR.
* ###### ### ## ### ####.
  ELSE.
    TRANSLATE : P_WRBTR USING ', ',
                P_WRBTR USING '. '.
    CONDENSE P_WRBTR NO-GAPS.
  ENDIF.
ENDFORM. " CHANGE_FORMAT
