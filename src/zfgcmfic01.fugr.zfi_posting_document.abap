FUNCTION ZFI_POSTING_DOCUMENT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(ES_CONF) TYPE  ZFI_DOCUMENT_POSTING_CNF
*"     REFERENCE(ES_EXTRA) TYPE  ZFI_DOCUMENT_POSTING_EXT_FIELD
*"  EXPORTING
*"     REFERENCE(I_RETURN) TYPE  ZFI_DOCUMENT_POSTING_EXPORT
*"  TABLES
*"      T_BBKPF STRUCTURE  BBKPF
*"      T_BBSEG STRUCTURE  BBSEG
*"      T_BBTAX STRUCTURE  BBTAX OPTIONAL
*"      T_BWITH STRUCTURE  BWITH OPTIONAL
*"      T_BSELK STRUCTURE  BSELK OPTIONAL
*"      T_BSELP STRUCTURE  BSELP OPTIONAL
*"      T_MESSTAB STRUCTURE  FIMSG OPTIONAL
*"      T_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
*{   INSERT         DEQK900284                                        1
*&---------------------------------------------------------------------*
* Function Name     : Z_FI_DOCUMENT_POSTING
* Program Purpose  : Z_FI_DOCUMENT_POSTING
* Author           : SUN HUIMING
* Date Written     : 2014/12/04
* Note             : N/A
*&---------------------------------------------------------------------*
  DATA: LV_FNAM TYPE RS38L_FNAM.

*  CLEAR GLOBE VARIABLE
  PERFORM FRM_CLEAR_GLOBE_VARIABLE.

*  assignment input fields to globe variable
  GS_CONF = ES_CONF.

*  Check Input Data
  PERFORM FRM_CHECK_INPUT.

* assignment errors messages to output if errors exist
  T_RETURN[] = GT_RETURN.
  I_RETURN = GS_ERROR_RETURN.

  CHECK GV_ERROR = ''.

*  call FUNCTION and posting document
  CALL FUNCTION GV_FNAM
    EXPORTING
      ES_CONF  = ES_CONF
      ES_EXTRA  = ES_EXTRA
    IMPORTING
      I_RETURN = I_RETURN
    TABLES
      T_BBKPF  = T_BBKPF
      T_BBSEG  = T_BBSEG
      T_RETURN = T_RETURN
      .


*}   INSERT




ENDFUNCTION.
