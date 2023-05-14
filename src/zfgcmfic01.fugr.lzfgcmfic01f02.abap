*&---------------------------------------------------------------------*
*&  Include           LZFGCMFIC01F02
*&---------------------------------------------------------------------*


*eject.
************************************************************************
*        Interne Perform-Routinen
************************************************************************
*eject
*-----------------------------------------------------------------------
*        Form  AUGLV_PRUEFEN
*-----------------------------------------------------------------------
*        Ausgleichsvorgang aus T041A ermitteln;
*-----------------------------------------------------------------------
FORM AUGLV_PRUEFEN.
  IF TFILL_041A   = 0.
    SELECT * FROM T041A.
      XT041A-AUGLV = T041A-AUGLV.
      APPEND XT041A.
    ENDSELECT.
    DESCRIBE TABLE XT041A LINES TFILL_041A.
    IF TFILL_041A = 0.
      PERFORM LOG_MSG USING C_MSGID 'I' '171'
                            BELEG_COUNT SPACE SPACE SPACE.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.
  ENDIF.

  TABIX = 0.
  IF BBKPF-AUGLV(1) = NODATA
  OR BBKPF-AUGLV    = SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '162'
                          BELEG_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
  LOOP AT XT041A WHERE AUGLV = BBKPF-AUGLV.
    TABIX = SY-TABIX.
    EXIT.
  ENDLOOP.
  IF TABIX = 0.
    PERFORM LOG_MSG USING C_MSGID 'I' '163'
                          BELEG_COUNT BBKPF-AUGLV SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                         SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
ENDFORM.                               "auglv_pruefen

*eject
*-----------------------------------------------------------------------
*        Form  AUGLV_SETZEN
*-----------------------------------------------------------------------
*        Ausgleichsvorgang aus T041A ermitteln;
*        entsprechenden Ausgleichsvorgang im Loop ankreuzen.
*-----------------------------------------------------------------------
*ORM AUGLV_SETZEN.
* TABIX = 0.
* IF BBKPF-AUGLV(1) = NODATA
* OR BBKPF-AUGLV    = SPACE.
*   MESSAGE I162 WITH BELEG_COUNT.
*   MESSAGE I016.
*   PERFORM DUMP_WA USING 'BBKPF'.
*   MESSAGE A013.
* ENDIF.
* LOOP AT XT041A WHERE AUGLV = BBKPF-AUGLV.
*   TABIX = SY-TABIX.
*   EXIT.
* ENDLOOP.
* IF TABIX = 0.
*   MESSAGE I163 WITH BELEG_COUNT BBKPF-AUGLV.
*   MESSAGE I016.
*   PERFORM DUMP_WA USING 'BBKPF'.
*   MESSAGE A013.
* ENDIF.
*
*------- Ausgleichsvorgang im Loop ankreuzen ---------------------------
* IF FL_CHECK = SPACE.
*   CLEAR FTA.
*   FTA-FNAM(12)   = 'RF05A-XPOS1('.
*   FTA-FNAM+12(2) = TABIX.
*   FTA-FNAM+14(1) = ')'.
*   FTA-FVAL       = 'X'.
*   APPEND FTA.
* ENDIF.
*NDFORM.

*eject
*-----------------------------------------------------------------------
*        FORM BBKPF_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BBKPF-Struktur benutzt werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BBKPF_ERWEITERUNG_PRUEFEN.

  IF BBKPF-SENDE(1) NE NODATA.
* ------ BBKPF-VATDATE                                       N1023317
    IF bbkpf-vatdate(1) NE nodata.                          "N1023317
* ------ BBKPF-ENHANCEMENT ERP: LDGRP(2), PROPMANO
    IF BBKPF-LDGRP(1) NE NODATA.                               "/glflex
*------- BBKPF-Erweiterung um XBWAE zu 4.6C
      IF BBKPF-XBWAE(1) NE NODATA.
*------- BBKPF-Erweiterung um XPRFG zu 4.5B
        IF BBKPF-XPRFG(1) NE NODATA.
*------- BBKPF-Erweiterung zu 4.5B: AUGTX
          IF BBKPF-AUGTX(1) NE NODATA.
*------- BBKPF-Erweiterung zu 4.5B: KURSF_M(10)
            IF BBKPF-KURSF_M(1) NE NODATA.

*------- BBKPF-Erweiterung zu 4.0C: STGRD(2),
              IF BBKPF-STGRD(1) NE NODATA.
*------- BBKPF-Erweiterung zu 4.0A: BRNCH(4), NUMPG(3)
                IF BBKPF-BRNCH(1) NE NODATA.
*------- BBKPF-Erweiterung zu 3.0A: DOCID(10), BARCD(40),STODT
                  IF BBKPF-DOCID(1) NE NODATA.
*------- BBKPF-Erweiterung zu 2.2A: XMWST(1)
                    IF BBKPF-XMWST(1) NE NODATA.
*------- BBKPF-Erweiterung zu 2.1A: VBUND --
                      BBKPF-VBUND(1) = NODATA.
                    ENDIF.

                    BBKPF-XMWST(1) = NODATA.
                  ENDIF.

                  BBKPF-DOCID(1) = NODATA.
                  BBKPF-BARCD(1) = NODATA.
                  BBKPF-STODT(1) = NODATA.
                ENDIF.

                BBKPF-BRNCH(1) = NODATA.
                BBKPF-NUMPG(1) = NODATA.
              ENDIF.

              BBKPF-STGRD(1) = NODATA.
            ENDIF.

            BBKPF-KURSF_M(1) = NODATA.
          ENDIF.

          BBKPF-AUGTX(1) = NODATA.
        ENDIF.
        BBKPF-XPRFG(1) = NODATA.
      ENDIF.
      BBKPF-XBWAE(1) = NODATA.
    ENDIF.
    BBKPF-LDGRP(1) = NODATA.                                    "/glflex
    BBKPF-PROPMANO(1) = NODATA.                                 "RE
    ENDIF.                                                  "N1023317
    bbkpf-vatdate = nodata.                                 "N1023317

    IF XMESS_BBKPF_SENDE NE 'X'.
      PERFORM LOG_MSG USING C_MSGID 'I' '174'
                            BELEG_COUNT 'BBKPF' NODATA SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '023' 'BBKPF' SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '024' SPACE SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '025' 'BBKPF' SPACE SPACE SPACE.
      XMESS_BBKPF_SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.                               "bbkpf_erweiterung_pruefen



*eject
*-----------------------------------------------------------------------
*        FORM BBSEG_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BBSEG-Struktur benutzt, werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BBSEG_ERWEITERUNG_PRUEFEN.
  IF BBSEG-SENDE(1) NE NODATA.

* ueberpruefen, ob die in der BBSEG-Struktur vorhandenen Includes
* aktiv sind. Wenn ja kann Erweiterungspruefung (beruecksichtigt nur
* Felder aus dem Standard) nicht durchgefuehrt werden.

    CALL FUNCTION 'DD_EXIST_TABLE'
      EXPORTING
        TABNAME = 'SI_BBSEGV'
        STATUS  = 'A'
      IMPORTING
        SUBRC   = SUBRC.

    IF SUBRC = 0.
      PERFORM LOG_MSG USING C_MSGID 'I' '872'
                            'SI_BBSEGV' SPACE SPACE SPACE.
      EXIT.
    ENDIF.
*begin of insertion note 1115584
*----BBSEG-ENHANCEMENT: fields from Include REIT_TAX_CORR_ADD
    IF BBSEG-TCNO(1) NE NODATA.
*end of insertion note 1115584
*----BBSEG-Erweiterung: XSIWE
    IF BBSEG-XSIWE(1) NE NODATA.
*------- BBSEG-ENHANCEMENT ERP: SEGMNET, PSEGMNET, HKTID
      IF BBSEG-SEGMENT(1) NE NODATA.                          "/glflex
*------- BBSEG-Erweiterung 4.7: IBAN, VALID_FROM
        if BBSEG-VALID_FROM(1) ne NODATA.
*------- BBSEG-Erweiterung 4.7: GRANT_NBR, FKBER_LONG, ERLKZ
          IF BBSEG-ERLKZ(1) NE NODATA.

*--------BBSEG-Erweiterung CESSION_KZ
            IF BBSEG-CESSION_KZ(1) NE NODATA.
*------- BBSEG-Erweiterung 4.7: DTAMS
              IF BBSEG-DTAMS(1) NE NODATA.
*------- BBSEG-Erweiterung: BKREF
                IF BBSEG-BKREF(1) NE NODATA.
*------- BBSEG-Erweiterung: RECNNR, E_MIVE
                  IF BBSEG-RECNNR(1) NE NODATA.
*------- BBSEG-Erweiterung: ANRED (Anrede CpD)
                    IF BBSEG-ANRED  NE NODATA.
*------- BBSEG-Erweiterung: IDXSP
                      IF BBSEG-IDXSP(1) NE NODATA.
*------- BBSEG-Erweiterung zu 4.6B: J_1KFREPRE, J_1KFTBUS, J_1KFTIND
                        IF BBSEG-J_1KFREPRE(1) NE NODATA.

*------- BBSEG-Erweiterung Immobilien zu 4.5B, Umzug von KI3,
*------- WENR, GENR, GRNR, MENR, MIVE, NKSL, EMPSL, SVWNR, SBERI
*------- andere Felder: KKBER, EMPFB, KURSR_M
                          IF BBSEG-WENR(1) NE NODATA.
*------- BBSEG-Erweiterung zu 4.0C: PYCUR,PYAMT,BUPLA,SECCO,LSTAR,EGDEB
                            IF BBSEG-PYCUR(1) NE NODATA.
*------- BBSEG-Erweiterung zu 4.0B: DTAWS
                              IF BBSEG-DTAWS(1) NE NODATA.
*------- BBSEG-Erweiterung zu 4.0A: XNEGP,GRICD,GRIRG,GITYP,FITYP,
*                                   STCDT,STKZN,STCD3,STCD4,...,DTWS4
                                IF BBSEG-XNEGP(1) NE NODATA.

*------- BBSEG-Erweiterung zu 3.1H: FIPEX
                                  IF BBSEG-FIPEX(1) NE NODATA.
*------- BBSEG-Erweiterung zu 3.0F: RSTGR
                                    IF BBSEG-RSTGR(1) NE NODATA.
*------- BBSEG-Erweiterung zu 3.0E: VBUND,FKBER,DABRZ,XSTBA
                                      IF BBSEG-VBUND(1) NE NODATA.
*------- BBSEG-Erweiterung zu 3.0D: WDATE, WGBKZ, XAKTZ, WNAME, WORT1,
*                                   WBZOG, WORT2, WBANK, WLZBP, DISKP,
*                                   DISKT, WINFW, WINHW, WEVWV, WSTAT,
*                                   WMWKZ, WSTKZ
                                        IF BBSEG-WDATE(1) NE NODATA.

*------- BBSEG-Erweiterung zu 3.0A: XREF1(11), XREF2(12),
*                                   KBLPOS(3), KBLNR(10)
                                          IF BBSEG-XREF1(1) NE NODATA.
*------- BBSEG-Erweiterung zu 2.2A: PPRCT(10), PROJK(24), UZAWE(2),
*                                   TXJCD(10), FISTL(16), GEBER(10),
*                                   DMBE2(16), DMBE3(16), PARGB(4),
                                            IF BBSEG-PPRCT(1) NE NODATA.
*------- BBSEG-Erweiterung zu 2.1D: XEGDR, RECID
                                            IF BBSEG-XEGDR(1) NE NODATA.
*------- BBSEG-Erweiterung zu 2.1C: NPLNR, VORNR

                                              BBSEG-NPLNR(1)   = NODATA.
                                              BBSEG-VORNR(1)   = NODATA.
                                              ENDIF.

                                              BBSEG-XEGDR(1)   = NODATA.
                                              BBSEG-RECID(1)   = NODATA.
                                            ENDIF.

                                            BBSEG-PPRCT(1)  = NODATA.
                                            BBSEG-PROJK(1)  = NODATA.
                                            BBSEG-UZAWE(1)  = NODATA.
                                            BBSEG-TXJCD(1)  = NODATA.
                                            BBSEG-FISTL(1)  = NODATA.
                                            BBSEG-GEBER(1)  = NODATA.
                                            BBSEG-DMBE2(1)  = NODATA.
                                            BBSEG-DMBE3(1)  = NODATA.
                                            BBSEG-PARGB(1)  = NODATA.
                                          ENDIF.

                                          BBSEG-XREF1(1)   = NODATA.
                                          BBSEG-XREF2(1)   = NODATA.
                                          BBSEG-KBLPOS(1)  = NODATA.
                                          BBSEG-KBLNR(1)   = NODATA.

                                        ENDIF.
                                        BBSEG-WDATE(1)   = NODATA.
                                        BBSEG-WGBKZ(1)   = NODATA.
                                        BBSEG-XAKTZ(1)   = NODATA.
                                        BBSEG-WNAME(1)   = NODATA.
                                        BBSEG-WORT1(1)   = NODATA.
                                        BBSEG-WBZOG(1)   = NODATA.
                                        BBSEG-WORT2(1)   = NODATA.
                                        BBSEG-WBANK(1)   = NODATA.
                                        BBSEG-WLZBP(1)   = NODATA.
                                        BBSEG-DISKP(1)   = NODATA.
                                        BBSEG-DISKT(1)   = NODATA.
                                        BBSEG-WINFW(1)   = NODATA.
                                        BBSEG-WINHW(1)   = NODATA.
                                        BBSEG-WEVWV(1)   = NODATA.
                                        BBSEG-WSTAT(1)   = NODATA.
                                        BBSEG-WMWKZ(1)   = NODATA.
                                        BBSEG-WSTKZ(1)   = NODATA.
                                      ENDIF.

                                      BBSEG-VBUND(1)   = NODATA.
                                      BBSEG-FKBER(1)   = NODATA.
                                      BBSEG-DABRZ(1)   = NODATA.
                                      BBSEG-XSTBA(1)   = NODATA.
                                    ENDIF.

                                    BBSEG-RSTGR(1)   = NODATA.
                                  ENDIF.

                                  BBSEG-FIPEX(1)   = NODATA.

                                ENDIF.

                                BBSEG-XNEGP(1)   = NODATA.
                                BBSEG-GRICD(1)   = NODATA.
                                BBSEG-GRIRG(1)   = NODATA.
                                BBSEG-GITYP(1)   = NODATA.
                                BBSEG-FITYP(1)   = NODATA.
                                BBSEG-STCDT(1)   = NODATA.
                                BBSEG-STKZN(1)   = NODATA.
                                BBSEG-STCD3(1)   = NODATA.
                                BBSEG-STCD4(1)   = NODATA.
                                BBSEG-XREF3(1)   = NODATA.
                                BBSEG-KIDNO(1)   = NODATA.
                                BBSEG-DTWS1(1)   = NODATA.
                                BBSEG-DTWS2(1)   = NODATA.
                                BBSEG-DTWS3(1)   = NODATA.
                                BBSEG-DTWS4(1)   = NODATA.
                              ENDIF.

                              BBSEG-DTAWS(1)   = NODATA.
                            ENDIF.

                            BBSEG-PYCUR(1)   = NODATA.
                            BBSEG-PYAMT(1)   = NODATA.
                            BBSEG-BUPLA(1)   = NODATA.
                            BBSEG-SECCO(1)   = NODATA.
                            BBSEG-LSTAR(1)   = NODATA.
                            BBSEG-EGDEB(1)   = NODATA.

                          ENDIF.
                          BBSEG-WENR(1)   = NODATA.
                          BBSEG-GENR(1)   = NODATA.
                          BBSEG-GRNR(1)   = NODATA.
                          BBSEG-MENR(1)   = NODATA.
                          BBSEG-MIVE(1)   = NODATA.
                          BBSEG-NKSL(1)   = NODATA.
                          BBSEG-EMPSL(1)   = NODATA.
                          BBSEG-SVWNR(1)   = NODATA.
                          BBSEG-SBERI(1)   = NODATA.
                          BBSEG-KKBER(1)   = NODATA.
                          BBSEG-EMPFB(1)   = NODATA.
                          BBSEG-KURSR_M(1) = NODATA.

                        ENDIF.
                        BBSEG-J_1KFREPRE(1) = NODATA.
                        BBSEG-J_1KFTBUS(1)  = NODATA.
                        BBSEG-J_1KFTIND(1)  = NODATA.
                      ENDIF.
                      BBSEG-IDXSP(1) = NODATA.
                    ENDIF.
                    BBSEG-ANRED(1) = NODATA.
                  ENDIF.
                  BBSEG-RECNNR(1) = NODATA.
                  BBSEG-E_MIVE(1) = NODATA.
                ENDIF.
                BBSEG-BKREF(1) = NODATA.
              ENDIF.
              BBSEG-DTAMS(1) = NODATA.
            ENDIF.
            BBSEG-CESSION_KZ(1) = NODATA.
          ENDIF.
          BBSEG-GRANT_NBR(1) = NODATA.
          BBSEG-FKBER_LONG(1) = NODATA.
          BBSEG-ERLKZ(1) = NODATA.
        ENDIF.
        BBSEG-IBAN(1) = NODATA.
        BBSEG-VALID_FROM = NODATA.
      ENDIF.
      BBSEG-SEGMENT(1) = NODATA.                                "/glflex
      BBSEG-PSEGMENT(1) = NODATA.                               "/glflex
      BBSEG-HKTID(1) = NODATA.
    ENDIF.
    BBSEG-XSIWE(1) = NODATA.
    ENDIF.
*begin of insertion note 1115584
    BBSEG-TCNO(1)            = NODATA.
    BBSEG-DATEOFSERVICE(1)   = NODATA.
    BBSEG-NOTAXCORR(1)       = NODATA.
    BBSEG-DIFFOPTRATE(1)     = NODATA.
    BBSEG-HASDIFFOPTRATE(1)  = NODATA.
*end of insertion note 1115584
    IF XMESS_BBSEG_SENDE NE 'X'.
      PERFORM LOG_MSG USING C_MSGID 'I' '174'
                            BELEG_COUNT 'BBSEG' NODATA SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '023'
                            'BBSEG' SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '024'
                            SPACE SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '025'
                            'BBSEG' SPACE SPACE SPACE.
      XMESS_BBSEG_SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.                               "bbseg_erweiterung_pruefen

*eject
*-----------------------------------------------------------------------
*        FORM BBTAX_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BBTAX-Struktur benutzt werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BBTAX_ERWEITERUNG_PRUEFEN.

  IF BBTAX-SENDE(1) NE NODATA.
*------- BBTAX-Erweiterung zu 4.0A: H2STE(16), H3STE(16)
    BBTAX-H2STE(1) = NODATA.
    BBTAX-H3STE(1) = NODATA.


    IF XMESS_BBTAX_SENDE NE 'X'.
      PERFORM LOG_MSG USING C_MSGID 'I' '174'
                            BELEG_COUNT 'BBTAX' NODATA SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '023'
                            'BBTAX' SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '024'
                            SPACE SPACE SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '025'
                            'BBTAX' SPACE SPACE SPACE.
      XMESS_BBTAX_SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.                               "bbtax_erweiterung_pruefen
*eject
*-----------------------------------------------------------------------
*        Form  BELEG_ABSCHLIESSEN
*-----------------------------------------------------------------------
FORM BELEG_ABSCHLIESSEN.

*  break sunhm.
  CHECK FL_CHECK = SPACE.
  IF BBKPF-TCODE = 'FB01'
  OR BBKPF-TCODE = 'FBB1'                                   "P30K125019
  OR BBKPF-TCODE = 'FBS1'
  OR BBKPF-TCODE = 'FBV1'.             "4.0
    CALL FUNCTION 'POSTING_INTERFACE_DOCUMENT'
      EXPORTING
        I_TCODE  = BBKPF-TCODE
      IMPORTING
        E_SUBRC  = SUBRC
        E_MSGID  = MSGID
        E_MSGTY  = MSGTY
        E_MSGNO  = MSGNO
        E_MSGV1  = MSGV1
        E_MSGV2  = MSGV2
        E_MSGV3  = MSGV3
        E_MSGV4  = MSGV4
      TABLES
        T_FTPOST = FTPOST
        T_FTTAX  = FTTAX
        T_BLNTAB = XBLNTAB
      EXCEPTIONS
        OTHERS   = 1.

  ELSEIF BBKPF-TCODE = 'FB05'.
* Falls nur BSELK aber kein BSELP übergeben wurde, so wurden die Daten
* aus der int. Tabelle SAVE_FTCLEAR noch nicht in die Tabelle FTCLEAR
* uebertragen.

    IF NOT XFTCLEAR IS INITIAL.
      FTCLEAR = SAVE_FTCLEAR.
      APPEND FTCLEAR.
    ENDIF.

    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        I_AUGLV   = BBKPF-AUGLV
        I_TCODE   = BBKPF-TCODE
      IMPORTING
        E_SUBRC   = SUBRC
        E_MSGID   = MSGID
        E_MSGTY   = MSGTY
        E_MSGNO   = MSGNO
        E_MSGV1   = MSGV1
        E_MSGV2   = MSGV2
        E_MSGV3   = MSGV3
        E_MSGV4   = MSGV4
      TABLES
        T_FTPOST  = FTPOST
        T_FTCLEAR = FTCLEAR
        T_FTTAX   = FTTAX
        T_BLNTAB  = XBLNTAB
      EXCEPTIONS
        OTHERS    = 1.
  ENDIF.



  IF FUNCTION = 'B'.
*------- Batch Input  ------------------------------------------------
    IF NOT SY-SUBRC IS INITIAL.
      IF NOT ERROR_RUN IS INITIAL.
        PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                              SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        PERFORM LOG_MSG USING C_MSGID 'I' '622'
                              BELEG_COUNT GROUP_COUNT SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '014'
                              'BBKPF' SPACE SPACE SPACE.
      ELSE.
        PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                              SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        PERFORM LOG_MSG USING C_MSGID 'I' '622'
                              BELEG_COUNT GROUP_COUNT SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
    ENDIF.
    IF NOT SY-SUBRC IS INITIAL.
      PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                            SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      PERFORM LOG_MSG USING C_MSGID 'I' '622'
                            BELEG_COUNT GROUP_COUNT SPACE SPACE.
      PERFORM DUMP_WA USING 'BBKPF'.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.
*------- Commit Work? ------------------------------------------------
    COMMIT_COUNT = COMMIT_COUNT + 1.
    IF COMMIT_COUNT = MAX_COMMIT.
      COMMIT WORK.
      CALL FUNCTION 'DEQUEUE_ALL'.
      CLEAR COMMIT_COUNT.
    ENDIF.
  ELSE.
*------- Call Transaction --------------------------------------------
    IF SUBRC IS INITIAL AND SY-SUBRC IS INITIAL.
* Clear Variable
      CLEAR : G_BELNR, G_BUKRS, G_GJAHR.
      LOOP AT XBLNTAB.
        PERFORM LOG_MSG USING 'F5' 'I' '312'
                              XBLNTAB-BELNR XBLNTAB-BUKRS SPACE SPACE.
* Created document number export
        G_BELNR = XBLNTAB-BELNR.
        G_BUKRS = XBLNTAB-BUKRS.
        G_GJAHR = XBLNTAB-GJAHR.

      ENDLOOP.
    ELSE.
      IF NOT SUBRC IS INITIAL.
        PERFORM LOG_MSG USING MSGID 'I' MSGNO
                              MSGV1 MSGV2 MSGV3 MSGV4.
      ELSE.
        PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                              SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      PERFORM EXPORT_ERROR_DATA.
    ENDIF.
    COMMIT_COUNT = COMMIT_COUNT + 1.
*------- bei Call Trans Commit Work nach jedem Beleg -------------------
    PERFORM CALL_BI_END_AKT_NUMBER.
    COMMIT WORK.
    CALL FUNCTION 'DEQUEUE_ALL'.
  ENDIF.

  REFRESH: FTPOST, FTCLEAR, FTTAX, XBLNTAB.
  CLEAR:   FTPOST, FTCLEAR, FTTAX, XBLNTAB.
ENDFORM.                               "beleg_abschliessen


*eject
*-----------------------------------------------------------------------
*        Form  BELEG_ABSCHLIESSEN_OLD.
*-----------------------------------------------------------------------
FORM BELEG_ABSCHLIESSEN_OLD.
* CHECK FL_CHECK = SPACE.
*
*------- Batch-Input erstellen -----------------------------------------
* IF XCALL = SPACE.
*   CALL FUNCTION 'BDC_INSERT'
*     EXPORTING TCODE     = BBKPF-TCODE
*     TABLES    DYNPROTAB = FT.
*
*------- zunächst 'Call Transaction', nur bei Fehlern Batch-Input ------
* ELSE.
*   CALL TRANSACTION BBKPF-TCODE USING  FT
*                                MODE   ANZ_MODE
*                                UPDATE UPDATE.
*   SUBRC = SY-SUBRC.
*   PERFORM MESSAGE_CALL_TRANSACTION.
*   IF SUBRC NE 0.
*     IF GROUP_OPEN NE 'X'.
*       PERFORM MAPPE_OEFFNEN.
*     ENDIF.
*     CALL FUNCTION 'BDC_INSERT'
*       EXPORTING TCODE     = BBKPF-TCODE
*       TABLES    DYNPROTAB = FT.
*   ENDIF.
* ENDIF.
*
*------- Commit Work? ------------------------------------------------
* COMMIT_COUNT = COMMIT_COUNT + 1.
* IF COMMIT_COUNT = MAX_COMMIT.
*   COMMIT WORK.
*   CLEAR COMMIT_COUNT.
* ENDIF.
ENDFORM.                               "beleg_abschliessen_old


*eject
*-----------------------------------------------------------------------
*        Form  DATENSATZ_PRUEFEN
*-----------------------------------------------------------------------
*        Prüfung des Datensatzes (Typ 2):
*        Tabellenname angegeben und gültig ?
*        Tabellen in richtiger Reihenfolge übergeben ?
*-----------------------------------------------------------------------
FORM DATENSATZ_PRUEFEN.
  SATZ2_COUNT = SATZ2_COUNT + 1.

*------- wurde ein Kopfsatz übergeben ? --------------------------------
  IF BBKPF_OK IS INITIAL.
    PERFORM LOG_MSG USING C_MSGID 'I' '151'
                          GROUP_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- Kennzeichen für Datensatz (Typ 2) gesetzt ? -------------------
  IF WA(1) NE '2'.
    PERFORM LOG_MSG USING C_MSGID 'I' '152'
                          BELEG_COUNT SATZ2_COUNT WA(1) SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

* Daten werden wegen der Feldlänge-Erweiterung des Feldes TBNAM
* von 10B (<4.0) auf 30B verschoben
  IF ( OS_XON = XON ) AND ( ERROR_RUN NE 'X' ).
    SHIFT WA BY 20 PLACES RIGHT.
    WA(31) = WA+20(11).
    IF WA+2(29) = 'SELP'.
      PERFORM BSELP_FIELD_LENGHT_CONVERT CHANGING WA.
    ENDIF.
  ENDIF.

*------- Tabellenname angegeben ? --------------------------------------
  IF WA+1(1)  = NODATA
  OR WA+1(30) = SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '153'
                          BELEG_COUNT SATZ2_COUNT SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- erlaubte Tabellen? --------------------------------------------
  IF  WA+1(30) NE 'BBSEG'
  AND WA+1(30) NE 'BWITH'
  AND WA+1(30) NE 'BBTAX'
  AND WA+1(30) NE 'BSELK'
  AND WA+1(30) NE 'BSELP'
  AND WA+1(13) NE 'ZBSEG'
  AND WA+1(30) NE 'ZSELP'.
    PERFORM LOG_MSG USING C_MSGID 'I' '164'
                          BELEG_COUNT SATZ2_COUNT WA+1(30) SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
  IF (   BBKPF-TCODE EQ 'FB01'
      OR BBKPF-TCODE EQ 'FBB1'                              "P30K125019
      OR BBKPF-TCODE EQ 'FBS1'
      OR BBKPF-TCODE EQ 'FBV1' )       "4.0
  AND NOT (    WA+1(30)    EQ 'BBSEG'
            OR WA+1(30)    EQ 'ZBSEG'
            OR WA+1(30)    EQ 'BWITH'
            OR WA+1(30)    EQ 'BBTAX' ).
    PERFORM LOG_MSG USING C_MSGID 'I' '165'
                       BELEG_COUNT SATZ2_COUNT WA+1(30) BBKPF-TCODE(20).
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    IF WA+1(30) = 'BSELK'.
      BSELK = I_BSELK.
      BSELK = WA.                                           "#EC ENHOK
      PERFORM LOG_MSG USING C_MSGID 'I' '017'
                          SPACE SPACE SPACE SPACE.
      PERFORM DUMP_WA USING 'BSELK'.
    ENDIF.
    IF WA+1(30) = 'BSELP'.
      BSELP = I_BSELP.
      BSELP = WA.                                           "#EC ENHOK
      PERFORM LOG_MSG USING C_MSGID 'I' '017'
                          SPACE SPACE SPACE SPACE.
      PERFORM DUMP_WA USING 'BSELP'.
    ENDIF.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
*------ Quellensteuer
  IF ( BBKPF-TCODE NE 'FB01' AND
       BBKPF-TCODE NE 'FBV1' )
       AND WA+1(30) EQ 'BWITH'.
    PERFORM LOG_MSG USING C_MSGID 'I' '165'
                       BELEG_COUNT SATZ2_COUNT WA+1(30) BBKPF-TCODE(20).
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    BWITH = I_BWITH.
    BWITH = WA.                                             "#EC ENHOK
    PERFORM LOG_MSG USING C_MSGID 'I' '017'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BWITH'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
*------ Quellensteuer: Direct Input erst zu 4.0C
*  if wa+1(10) eq 'BWITH' and
*     function = 'D'.
*    message i199 with beleg_count satz2_count wa+1(10).
*    message i016.
*    perform dump_wa using 'BBKPF'.
*    bwith = i_bwith.
*    bwith = wa.
*    message i017.
*    perform dump_wa using 'BWITH'.
*    message a013.
*  endif.

*------- Tabellen in erlaubter Reihenfolge (bei FB05)? -----------------
  IF BBKPF-TCODE = 'FB05'.
    IF WA+1(30) EQ 'BBSEG'.
      IF BSELK NE I_BSELK
      OR BSELP NE I_BSELP.
        PERFORM LOG_MSG USING C_MSGID 'I' '166'
                              BELEG_COUNT SPACE SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        BBSEG = I_BBSEG.
        BBSEG = WA.                                         "#EC ENHOK
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBSEG'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
    ENDIF.
    IF  WA+1(30)   EQ 'BSELP'
    OR  WA+1(30)   EQ 'ZSELP'.
      IF BSELK      EQ I_BSELK.
        PERFORM LOG_MSG USING C_MSGID 'I' '167'
                              BELEG_COUNT SPACE SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        BSELP = I_BSELP.
        BSELP = WA.                                         "#EC ENHOK
        PERFORM DUMP_WA USING 'BSELP'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                               "datensatz_pruefen

*eject
*-----------------------------------------------------------------------
*        Form  DATENSATZ_TRANSPORTIEREN
*-----------------------------------------------------------------------
*        Datensatz (Typ 2) verarbeiten
*        Falls der Kunde eigene Strukturen verwendet, sind diese
*        bereits in die B-Strukturen übertragen worden
*-----------------------------------------------------------------------
FORM DATENSATZ_TRANSPORTIEREN.

  data: bankdata(1) type c.

  CASE WA+2(09).

*-----------------------------------------------------------------------
*        BBSEG Belegsegment
*-----------------------------------------------------------------------
    WHEN 'BSEG'.
      SAVE_TBNAM = 'BBSEG'.

      PERFORM BBSEG_ERWEITERUNG_PRUEFEN.

*------- Prüfen und Übertragen der Kontonummer (DUMMYX/NEWKO) ----------
      IF  BBSEG-DUMMYX(1) NE NODATA                         "Note 559106
      AND BBSEG-DUMMYX    NE SPACE                          "Note 559106
      AND BBSEG-NEWKO(1)  NE NODATA
      AND BBSEG-NEWKO     NE SPACE
      AND BBSEG-DUMMYX    NE BBSEG-NEWKO.                   "Note 559106
        PERFORM LOG_MSG USING C_MSGID 'I' '175'
                BELEG_COUNT SATZ2_COUNT BBSEG-DUMMYX SPACE. "Note 559106
        PERFORM LOG_MSG USING C_MSGID 'I' '176'
                              BBSEG-NEWKO SPACE SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '177'
                              SPACE SPACE SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBSEG'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
      IF  BBSEG-DUMMYX(1) NE NODATA                         "Note 559106
      AND BBSEG-DUMMYX    NE SPACE                          "Note 559106
      AND BBSEG-NEWKO(1)  NE NODATA
      AND BBSEG-NEWKO     NE SPACE
      AND BBSEG-DUMMYX    EQ BBSEG-NEWKO.                   "Note 559106
        CLEAR BBSEG-DUMMYX.                                 "Note 559106
        BBSEG-DUMMYX = NODATA.                              "Note 559106
      ENDIF.
      IF  BBSEG-DUMMYX(1) NE NODATA                         "Note 559106
      AND BBSEG-DUMMYX    NE SPACE.                         "Note 559106
        BBSEG-NEWKO = BBSEG-DUMMYX.                         "Note 559106
        CLEAR BBSEG-DUMMYX.                                 "Note 559106
        BBSEG-DUMMYX = NODATA.                              "Note 559106
      ENDIF.

      IF BBSEG-NEWKO    EQ SPACE
      OR BBSEG-NEWKO    EQ NODATA.
        PERFORM LOG_MSG USING C_MSGID 'I' '145'
                              BELEG_COUNT SATZ2_COUNT SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBSEG'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.

* Entweder Finanzposition FIPOS oder FIPEX füllen.
* Beim gefülltem FIPOS wird das FIPEX ignoriert.
      IF  BBSEG-FIPOS(1) NE NODATA
      AND BBSEG-FIPOS    NE SPACE
      AND BBSEG-FIPEX(1) NE NODATA
      AND BBSEG-FIPEX    NE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '060'
                              BELEG_COUNT SATZ2_COUNT 'FIPOS' 'FIPEX'.
        PERFORM LOG_MSG USING C_MSGID 'I' '061'
                              BELEG_COUNT SATZ2_COUNT 'FIPEX' SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '899'
                              'BBSEG-FIPOS' '=' BBSEG-FIPOS SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '899'
                              'BBSEG-FIPEX' '=' BBSEG-FIPEX SPACE.
        CLEAR BBSEG-FIPEX.
        BBSEG-FIPEX = NODATA.
      ENDIF.

* Inhalt von FKBER in FKBER_LONG schreiben.
* Falls beide Felder gefüllt sind, wird FKBER ignoriert
      IF BBSEG-FKBER(1) NE NODATA

      AND BBSEG-FKBER   NE SPACE.
        IF BBSEG-FKBER_LONG(1) NE NODATA
        AND BBSEG-FKBER_LONG NE SPACE.
          PERFORM LOG_MSG USING C_MSGID 'I' '060'
                          BELEG_COUNT SATZ2_COUNT 'FKBER' 'FKBER_LONG'.
          PERFORM LOG_MSG USING C_MSGID 'I' '061'
                          BELEG_COUNT SATZ2_COUNT 'FKBER' SPACE.
          PERFORM LOG_MSG USING C_MSGID 'I' '899'
                          'BBSEG-FKBER' '=' BBSEG-FKBER SPACE.
          PERFORM LOG_MSG USING C_MSGID 'I' '899'
                          'BBSEG-FKBER_LONG' '=' BBSEG-FKBER_LONG SPACE.
        ELSE.
          BBSEG-FKBER_LONG = BBSEG-FKBER.
        ENDIF.
        CLEAR BBSEG-FKBER.
        BBSEG-FKBER(1) = NODATA.
      ENDIF.

      IF  BBSEG-KURSR(1)   NE NODATA
      AND BBSEG-KURSR      NE SPACE
      AND BBSEG-KURSR_M(1) NE NODATA
      AND BBSEG-KURSR_M    NE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '060'
                              BELEG_COUNT SATZ2_COUNT 'KURSR' 'KURSR_M'.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBSEG'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.

*---- IBAN -------------------------------------------------------
      if BBSEG-IBAN ne NODATA or BBSEG-VALID_FROM ne NODATA.
        call function 'FUNCTION_EXISTS'
          exporting
            funcname = 'FI_TECH_ACCNO_CHECK'
          exceptions
            function_not_exist = 1
            others             = 2.

        if sy-subrc ne 0.
*         IBAN with bank account no.
          if BBSEG-IBAN       eq NODATA or
             BBSEG-VALID_FROM eq NODATA or
             BBSEG-BANKN      eq NODATA or
             BBSEG-BANKL      eq NODATA or
             BBSEG-BANKS      eq NODATA.
            BBSEG-IBAN  = NODATA.
            BBSEG-VALID_FROM = NODATA.
            perform LOG_MSG using C_MSGID 'I' '061'
                    BELEG_COUNT SATZ2_COUNT 'IBAN' SPACE.
            if BBSEG-BANKN eq NODATA or
               BBSEG-BANKS eq NODATA or
               BBSEG-BANKL eq NODATA.
              perform LOG_MSG using 'F8' 'I' '025'
                      SPACE SPACE SPACE SPACE.
            endif.
          endif.
        else.
*         IBAN with or without account no.
          if BBSEG-IBAN ne NODATA.
            If BBSEG-BANKN  ne NODATA and
               BBSEG-BANKL  ne NODATA and
               BBSEG-BANKS  ne NOData.
              bankdata = 'C'.    "complete
            elseif BBSEG-BANKN eq NODATA and
                   BBSEG-BANKL eq NODATA and
                   BBSEG-BANKS eq NOData.
              bankdata = 'E'.   "empty
            else.
              bankdata = 'I'.   "incomplete
            endif.

            if BBSEG-VALID_FROM eq NODATA.     "no valid_from
              case bankdata.
                when 'I'.
*                 domestic bank data incomplete => Iban without account no.
                  BBSEG-BANKN = NODATA.
                  perform LOG_MSG using 'F8' 'I' '025'
                       SPACE SPACE SPACE SPACE.
                  perform LOG_MSG using C_MSGID 'I' '061'
                       BELEG_COUNT SATZ2_COUNT 'BANKN' SPACE.
                when 'C'.
*                 domestic data complete => Iban with account no.
                  write sy-datum to bbseg-VALID_FROM.
                  perform LOG_MSG using C_MSGID 'I' '624' SPACE SPACE SPACE SPACE.
                when 'E'.
*                 no domestic bank data => Iban without account no.
              endcase.
            else.                             "with valid_from
              case bankdata.
                when 'I'.
*                 domestic bank data incomplete => Iban without account no.
                  BBSEG-BANKN = NODATA.
                  BBSEG-VALID_FROM = NODATA.
                  perform LOG_MSG using 'F8' 'I' '025'
                       SPACE SPACE SPACE SPACE.
                  perform LOG_MSG using C_MSGID 'I' '061'
                       BELEG_COUNT SATZ2_COUNT 'BANKN' SPACE.
                  perform LOG_MSG using C_MSGID 'I' '061'
                       BELEG_COUNT SATZ2_COUNT 'VALID_FROM' SPACE.
                when 'C'.
*                 domestic data complete => Iban with account no.
                when 'E'.
*                 no domestic data complete => Iban without account no.
                  bbseg-VALID_FROM = NODATA.
                  perform LOG_MSG using C_MSGID 'I' '625' SPACE SPACE SPACE SPACE.
                  perform LOG_MSG using C_MSGID 'I' '061'
                     BELEG_COUNT SATZ2_COUNT 'VALID_FROM' SPACE.
              endcase.
            endif.         "no valid_from
          endif.           "IBAN without account no.
        endif.             "function exists
      endif.               "batch input file contains iban

*------ Kontoart ermitteln
      perform KONTOART_ERMITTELN.
      BBSEG_COUNT = BBSEG_COUNT + 1.

*------ Quellensteuer: Zähler inkrementieren (Debitor/Kreditor-Zeilen)
      IF XTBSL-KOART = 'D' OR
         XTBSL-KOART = 'K'.
        WT_COUNT = WT_COUNT + 1.
      ENDIF.

      PERFORM FILL_FTPOST_WITH_BBSEG_DATA USING BBSEG_COUNT.
      PERFORM FILL_FTTAX_FROM_BBSEG.

*-----------------------------------------------------------------------
*        BWITH Quellensteuer
*-----------------------------------------------------------------------
    WHEN 'WITH'.
      IF BWITH-WITHT    EQ SPACE
      OR BWITH-WITHT    EQ NODATA.
        PERFORM LOG_MSG USING C_MSGID 'I' '145'
                              BELEG_COUNT SATZ2_COUNT SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BWITH'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.

      PERFORM FILL_FTPOST_WITH_BWITH_DATA USING BBSEG_COUNT.

*-----------------------------------------------------------------------
*        BBSEG Belegsteuern
*-----------------------------------------------------------------------
    WHEN 'BTAX'.
      IF ( BBTAX-FWBAS(1) NE NODATA                        "note 692986
      OR   BBTAX-HWBAS(1) NE NODATA                        "note 692986
      OR   BBTAX-H2BAS(1) NE NODATA                        "note 692986
      OR   BBTAX-H3BAS(1) NE NODATA )                      "note 692986
      AND  FUNCTION NE 'D'.                                "note 692986
        PERFORM LOG_MSG USING C_MSGID 'I' '196'            "note 692986
                              'BBTAX-FWBAS' 'BBTAX-HWBAS'  "note 692986
                              'BBTAX-H2BAS' SPACE.         "note 692986
      ENDIF.                                               "note 692986
      IF BBSEG_TAX = 'X'.
*       Abbruch: Steuern entweder neu oder alt übergeben
        PERFORM LOG_MSG USING C_MSGID 'I' '178'
                              BELEG_COUNT SATZ2_COUNT SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '179'
                              SPACE SPACE SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBSEG'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
      IF BBKPF-XMWST = 'X'.
*------ Abbruch: Steuern entweder rechnen oder BBTAX übergeben -------
        PERFORM LOG_MSG USING C_MSGID 'I' '149'
                              BELEG_COUNT SATZ2_COUNT SPACE SPACE.
        PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBKPF'.
        PERFORM LOG_MSG USING C_MSGID 'I' '017'
                              SPACE SPACE SPACE SPACE.
        PERFORM DUMP_WA USING 'BBTAX'.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.

      PERFORM FILL_FTTAX_WITH_BBTAX_DATA.

*-----------------------------------------------------------------------
*        BSELK Selektionskopf (FB05)
*-----------------------------------------------------------------------
    WHEN 'SELK'.
      CLEAR XFTCLEAR.
      PERFORM MOVE_BSELK_TO_SAVE_FTCLEAR.
*-------- Selektion mit Avis , Nach Alter sortieren ---------------
      IF BSELK-AVSID(1) NE NODATA.     "Avis
        FTCLEAR = SAVE_FTCLEAR.
        APPEND FTCLEAR.
        CLEAR SAVE_TBNAM.
      ELSE.
        XFTCLEAR = 'X'.
        SAVE_TBNAM = 'BSELK'.
      ENDIF.

*-----------------------------------------------------------------------
*        BSELP Selektionspositionen (FB05)
*-----------------------------------------------------------------------
    WHEN 'SELP'.
      IF SAVE_TBNAM NE SPACE.
        CASE SAVE_TBNAM.
          WHEN 'BSELP'.
          WHEN 'BSELK'.
          WHEN OTHERS.
*           vor BSELP muß BSELP oder BSELK kommen!
            PERFORM LOG_MSG USING C_MSGID 'I' '146'
                                  BELEG_COUNT WA+1(10) SPACE SPACE.
            PERFORM LOG_MSG USING C_MSGID 'I' '016'
                              SPACE SPACE SPACE SPACE.
            PERFORM DUMP_WA USING 'BBKPF'.
            PERFORM LOG_ABORT USING C_MSGID '013'.
        ENDCASE.
      ENDIF.
      SAVE_TBNAM = 'BSELP'.
      PERFORM FILL_FTCLEAR_WITH_BSELP_DATA.
  ENDCASE.
ENDFORM.                               "datensatz_transportieren

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_WA
*-----------------------------------------------------------------------
*        Im Abbruchfall soll der fehlerhafte Satz ausgedumpt werden.
*-----------------------------------------------------------------------
FORM DUMP_WA USING TABLE.
  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      LANGU          = SY-LANGU
      TABNAME        = TABLE
    TABLES
      NAMETAB        = NAMETAB
    EXCEPTIONS
      NO_TEXTS_FOUND = 1.
  LOOP AT NAMETAB.
    CLEAR CHAR.
    CHAR(5)    = NAMETAB-TABNAME.
    CHAR+5(1)  = '-'.
    CHAR+6(10) = NAMETAB-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    WERT = <F1>.
    PERFORM LOG_MSG USING C_MSGID 'I' '014'
                           CHAR WERT SPACE SPACE.

  ENDLOOP.
ENDFORM.                               "dump_wa


*eject
*-----------------------------------------------------------------------
*        Form  KOPFSATZ_LESEN
*-----------------------------------------------------------------------
*        Kopfdaten in Workarea lesen
*-----------------------------------------------------------------------
FORM KOPFSATZ_LESEN.
  CLEAR WA.
  READ DATASET DS_NAME INTO WA.

*------- End of File erreicht ? --> Exit -------------------------------
  IF SY-SUBRC NE 0.
    XEOF = 'X'.
    EXIT.
  ENDIF.

  IF WA(1) NE '1'.
    PERFORM LOG_MSG USING C_MSGID 'I' '151'
                          GROUP_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
ENDFORM.                               "kopfsatz_lesen

*eject
*-----------------------------------------------------------------------
*        Form  KOPFSATZ_BEARBEITEN
*-----------------------------------------------------------------------
*        Transportieren und bearbeiten
*        der eingelesenen Belegkopfdaten.
*        Globale BI-Feldtabelle initialisieren .
*        Schalter und Strukturen initialisieren.
*-----------------------------------------------------------------------
FORM KOPFSATZ_BEARBEITEN.
* REFRESH FT.
  BBKPF =  I_BBKPF.
  BBSEG =  I_BBSEG.
  BBTAX =  I_BBTAX.
  BSELK =  I_BSELK.
  BSELP =  I_BSELP.
  BWITH =  I_BWITH.
  CLEAR: SATZ2_COUNT, SATZ2_CNT_AKT, WT_COUNT, BBSEG_COUNT.
  CLEAR: SAVE_TBNAM, FCODE, BBSEG_TAX.
  REFRESH: FTPOST, FTCLEAR, FTTAX.
  REFRESH: T_BBKPF, T_BBSEG, T_BBTAX, T_BWITH.

* Daten werden wegen der Feldlänge-Erweiterung des Feldes TCODE
* von 4B (<4.0) auf 20B verschoben
  IF ( OS_XON = XON ) AND ( ERROR_RUN NE 'X' ).
    SHIFT WA BY 16 PLACES RIGHT.
    WA(21) = WA+16(5).
  ENDIF.

  BBKPF = WA.                                               "#EC ENHOK

  PERFORM BBKPF_ERWEITERUNG_PRUEFEN.

  BELEG_COUNT = BELEG_COUNT + 1.
  COUNT = COUNT + 1.

*------ Place to set a soft break-point -------------------------------
  IF BELEG_COUNT = BELEG_BREAK.
    BELEG_BREAK = BELEG_COUNT.
  ENDIF.

*------- Tcode übergeben / Tcode erlaubt ? ----------------------------
  IF BBKPF-TCODE(1) EQ NODATA
  OR BBKPF-TCODE    EQ SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '161'
                          BELEG_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
  IF  BBKPF-TCODE NE 'FB01'
  AND BBKPF-TCODE NE 'FBS1'
  AND BBKPF-TCODE NE 'FBB1'                                 "P30K125019
  AND BBKPF-TCODE NE 'FB05'
  AND BBKPF-TCODE NE 'FBV1'.           "4.0
    PERFORM LOG_MSG USING C_MSGID 'I' '154'
                          BELEG_COUNT BBKPF-TCODE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- FB05: --> Ausgleichsvorgang auf Gültigkeit überpruefne --------
  IF  BBKPF-TCODE  = 'FB05'.
    PERFORM AUGLV_PRUEFEN.
  ENDIF.

*------- BBKPF-Bukrs übergeben / merken ------------------------
  IF BBKPF-BUKRS(1) EQ NODATA
  OR BBKPF-BUKRS    EQ SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '160'
                          BELEG_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

  BUKRS = BBKPF-BUKRS.

  IF  BBKPF-KURSF(1)   NE NODATA
  AND BBKPF-KURSF      NE SPACE
  AND BBKPF-KURSF_M(1) NE NODATA
  AND BBKPF-KURSF_M    NE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '210'
                          BELEG_COUNT 'KURSF' 'KURSF_M' SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BBKPF'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

  PERFORM FILL_FTPOST_WITH_BBKPF_DATA.
  BBKPF_OK = 'X'.
ENDFORM.                               "kopfsatz_bearbeiten

*eject
*-----------------------------------------------------------------------
*        Form  MAPPE_OEFFNEN
*-----------------------------------------------------------------------
*        Öffnen der Buchungsschnittstelle
*-----------------------------------------------------------------------
FORM MAPPE_OEFFNEN.

  CHECK FUNCTION NE 'D'.

*-------- Interne Buchungsschnittstelle initialisieren
  CALL FUNCTION 'POSTING_INTERFACE_START'
    EXPORTING
      I_FUNCTION = FUNCTION
      I_CLIENT   = BGR00-MANDT
      I_GROUP    = BGR00-GROUP
      I_XBDCC    = XBDCC
      I_HOLDDATE = BGR00-START
      I_KEEP     = BGR00-XKEEP
      I_MODE     = ANZ_MODE
      I_UPDATE   = UPDATE
      I_USER     = BGR00-USNAM.

  IF FUNCTION = 'B'.
    PERFORM LOG_MSG USING C_MSGID 'I' '007'
                          GROUP_COUNT BGR00-GROUP SPACE SPACE.
  ENDIF.
  GROUP_OPEN = 'X'.
ENDFORM.                               "mappe_oeffnen


*eject
*-----------------------------------------------------------------------
*        Form  MAPPE_PRUEFEN_OEFFNEN
*-----------------------------------------------------------------------
*        Prüfen/Bearbeiten der Daten im Mappenvorsatz.
*        Sonderzeichen für NODATA bestimmen
*        Öffnen der BDC-Queue für Datentransfer
*        Initialstrukturen mit NODATA erzeugen
*-----------------------------------------------------------------------
FORM MAPPE_PRUEFEN_OEFFNEN.
  CLEAR BGR00.
  BGR00 = WA.                                               "#EC ENHOK
  GROUP_COUNT = GROUP_COUNT + 1.

*------- Mappenname gesetzt ? ------------------------------------------
  IF BGR00-GROUP = SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '011'
                          GROUP_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- Mandant gesetzt / richtig gesetzt? ----------------------------
  IF BGR00-MANDT IS INITIAL.
    PERFORM LOG_MSG USING C_MSGID 'I' '005'
                          GROUP_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.
  IF BGR00-MANDT NE SY-MANDT.
    PERFORM LOG_MSG USING C_MSGID 'I' '006'
                          GROUP_COUNT BGR00-MANDT SY-MANDT SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- Username gesetzt ? --------------------------------------------
  IF BGR00-USNAM = SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '009'
                          GROUP_COUNT SPACE SPACE SPACE.
    PERFORM LOG_MSG USING C_MSGID 'I' '015'
                          SPACE SPACE SPACE SPACE.
    PERFORM DUMP_WA USING 'BGR00'.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- Sonderzeichen NODATA prüfen/übernehmen -----------------------
  IF BGR00-NODATA = SPACE.
    NODATA = C_NODATA.
  ELSE.
    IF BGR00-NODATA BETWEEN '0' AND '9'
    OR BGR00-NODATA BETWEEN 'A' AND 'I'
    OR BGR00-NODATA BETWEEN 'J' AND 'R'
    OR BGR00-NODATA BETWEEN 'S' AND 'Z'
    OR BGR00-NODATA BETWEEN 'a' AND 'i'
    OR BGR00-NODATA BETWEEN 'j' AND 'r'
    OR BGR00-NODATA BETWEEN 's' AND 'z'
    OR BGR00-NODATA EQ      '+'        " wegen Zentrale
    OR BGR00-NODATA EQ      '*'        " wegen Mehrwertst. rechnen
    OR BGR00-NODATA EQ      '='.       " wegen Matchcode
      PERFORM LOG_MSG USING C_MSGID 'I' '010'
                            GROUP_COUNT BGR00-NODATA SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '015'
                            SPACE SPACE SPACE SPACE.
      PERFORM DUMP_WA USING 'BGR00'.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.
    NODATA = BGR00-NODATA.
  ENDIF.
  PERFORM LOG_MSG USING C_MSGID 'I' '012'
                        GROUP_COUNT NODATA SPACE SPACE.


*------- Mappe öffnen --------------------------------------------------
  IF  FL_CHECK = SPACE.
    PERFORM MAPPE_OEFFNEN.
  ENDIF.

*------- Flags, Zähler initialisieren ----------------------------------
  CLEAR: XNEWG, BELEG_COUNT, SATZ2_COUNT, SATZ2_CNT_AKT, WT_COUNT.

*------- Initialstrukturen erzeugen (NODATA-Sonderzeichen --------------
  IF NODATA NE NODATA_OLD.
    PERFORM INIT_STRUKTUREN_ERZEUGEN(RFBIBLI0) USING NODATA.
    PERFORM INIT_BBKPF(RFBIBLI0) USING I_BBKPF.
    PERFORM INIT_BBSEG(RFBIBLI0) USING I_BBSEG.
    PERFORM INIT_BBTAX(RFBIBLI0) USING I_BBTAX.
    PERFORM INIT_BSELK(RFBIBLI0) USING I_BSELK.
    PERFORM INIT_BSELP(RFBIBLI0) USING I_BSELP.
    PERFORM INIT_BWITH(RFBIBLI0) USING I_BWITH.
    NODATA_OLD = NODATA.
  ENDIF.
ENDFORM.                               "mappe_pruefen_oeffnen

*eject
*-----------------------------------------------------------------------
*        Form  MAPPE_SCHLIESSEN
*-----------------------------------------------------------------------
FORM MAPPE_SCHLIESSEN.
  IF FL_CHECK = SPACE.
    IF GROUP_OPEN = 'X'.
      CALL FUNCTION 'POSTING_INTERFACE_END'.
      IF FUNCTION = 'B'.
        PERFORM LOG_MSG USING C_MSGID 'I' '008'
                        GROUP_COUNT BGR00-GROUP SPACE SPACE.
      ENDIF.
      CLEAR GROUP_OPEN.
    ENDIF.
  ELSE.
    IF GROUP_COUNT > 0.
      PERFORM LOG_MSG USING C_MSGID 'I' '019'
                      GROUP_COUNT BGR00-GROUP SPACE SPACE.
    ENDIF.
  ENDIF.
ENDFORM.                               "mappe_schliessen

*eject
*-----------------------------------------------------------------------
*        Form  MAPPEN_WECHSEL
*-----------------------------------------------------------------------
*        Neuer Mappenvorsatz wurde gesendet.
*        Aktuelle Mappe wird geschlosssen, neue Mappe geöffnet.
*-----------------------------------------------------------------------
FORM MAPPEN_WECHSEL.
  PERFORM MAPPE_SCHLIESSEN.
  PERFORM MAPPE_PRUEFEN_OEFFNEN.
ENDFORM.                               "mappen_wechsel

*eject
*-----------------------------------------------------------------------
*        Form  MESSAGE_AUSGEBEN
*-----------------------------------------------------------------------
*        'Call Transaction .. Using ..'
*        Meldung ins Protokoll ausgeben.
*-----------------------------------------------------------------------
FORM MESSAGE_CALL_TRANSACTION.

*------- neuer Eintrag aus T100 ----------------------------------------
  IF T100-SPRSL NE SY-LANGU
  OR T100-ARBGB NE SY-MSGID
  OR T100-MSGNR NE SY-MSGNO.
    CLEAR: TEXT, TEXT1, TEXT2, TEXT3, MSGVN.
    SELECT SINGLE * FROM T100 WHERE SPRSL = SY-LANGU
                              AND   ARBGB = SY-MSGID
                              AND   MSGNR = SY-MSGNO.
    IF SY-SUBRC = 0.
      TEXT = T100-TEXT.
      DO 4 TIMES VARYING MSGVN FROM SY-MSGV1 NEXT SY-MSGV2.
        IF TEXT CA '$'.
          REPLACE '$' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
        IF TEXT CA '&'.
          REPLACE '&' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
      ENDDO.
      TEXT1 = TEXT(40).
      TEXT2 = TEXT+40(40).
      TEXT3 = TEXT+80(40).
      PERFORM LOG_MSG USING C_MSGID 'I' '172'
                      BELEG_COUNT TEXT1 TEXT2 TEXT3.
    ELSE.
      PERFORM LOG_MSG USING C_MSGID 'I' '173'
                      BELEG_COUNT SY-MSGNO SY-MSGV1 SY-MSGV2.
    ENDIF.

*------- gleicher Eintrag aus T100 -------------------------------------
  ELSE.
    IF TEXT NE SPACE.
      CLEAR: TEXT, TEXT1, TEXT2, TEXT3, MSGVN.
      TEXT = T100-TEXT.
      DO 4 TIMES VARYING MSGVN FROM SY-MSGV1 NEXT SY-MSGV2.
        IF TEXT CA '$'.
          REPLACE '$' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
        IF TEXT CA '&'.
          REPLACE '&' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
      ENDDO.
      TEXT1 = TEXT(40).
      TEXT2 = TEXT+40(40).
      TEXT3 = TEXT+80(40).
      PERFORM LOG_MSG USING C_MSGID 'I' '172'
                      BELEG_COUNT TEXT1 TEXT2 TEXT3.
    ELSE.
      PERFORM LOG_MSG USING C_MSGID 'I' '173'
                      BELEG_COUNT SY-MSGNO SY-MSGV1 SY-MSGV2.
    ENDIF.
  ENDIF.
ENDFORM.                               "message_call_transaction

*eject
*-----------------------------------------------------------------------
*        Form  SAVE_DATENSATZ_BEARBEITEN
*-----------------------------------------------------------------------
FORM SAVE_DATENSATZ_BEARBEITEN.
  SATZ2_CNT_AKT = SATZ2_COUNT.

ENDFORM.                               "save_datensatz_bearbeiten

*eject
*-----------------------------------------------------------------------
*        Form  KONTOART_ERMITTELN.
*-----------------------------------------------------------------------
FORM KONTOART_ERMITTELN.

  LOOP AT XTBSL WHERE BSCHL = BBSEG-NEWBS.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM TBSL WHERE BSCHL = BBSEG-NEWBS.
    IF SY-SUBRC = 0.
      XTBSL = TBSL.
      APPEND XTBSL.
    ELSE.
      PERFORM LOG_MSG USING C_MSGID 'I' '156'
                            BELEG_COUNT SATZ2_CNT_AKT BBSEG-NEWBS SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '016'
                            SPACE SPACE SPACE SPACE.
      PERFORM DUMP_WA USING 'BBKPF'.
      PERFORM LOG_MSG USING C_MSGID 'I' '017'
                            SPACE SPACE SPACE SPACE.
      PERFORM DUMP_WA USING 'BBSEG'.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.
  ENDIF.
ENDFORM.                               "kontoart_ermitteln

*eject
*-----------------------------------------------------------------------
*        Form  VBUND_SENDEN
*-----------------------------------------------------------------------
FORM VBUND_SENDEN.
* CHECK FL_CHECK = SPACE.
*
* CLEAR FT.
* FT-PROGRAM  = 'SAPLF014'.
* FT-DYNPRO   = '0100'.
* FT-DYNBEGIN = 'X'.
* APPEND FT.
*
* CLEAR FT.
* FT-FNAM = 'RF014-VBUND'.
* FT-FVAL = BBKPF-VBUND.
* APPEND FT.
*
ENDFORM.                               "vbund_senden


*eject
*-----------------------------------------------------------------------
*        Form  MOVE_BSELK_TO_SAVE_FTCLEAR.
*-----------------------------------------------------------------------
*        Selektionskopfdaten in SAVE_FTCLEAR sichern für
*        Initialisierung von FTCLEAR
*-----------------------------------------------------------------------
FORM MOVE_BSELK_TO_SAVE_FTCLEAR.
  CLEAR SAVE_FTCLEAR.
  IF BSELK-AGKON(1) NE NODATA.
    SAVE_FTCLEAR-AGKON = BSELK-AGKON.
  ENDIF.
  IF BSELK-AGKOA(1) NE NODATA.
    SAVE_FTCLEAR-AGKOA = BSELK-AGKOA.
  ENDIF.
  IF BSELK-XNOPS(1) NE NODATA.
    SAVE_FTCLEAR-XNOPS = BSELK-XNOPS.
  ENDIF.
  IF BSELK-AGBUK(1) NE NODATA.
    SAVE_FTCLEAR-AGBUK = BSELK-AGBUK.
  ENDIF.
  IF BSELK-AGUMS(1) NE NODATA.
    SAVE_FTCLEAR-AGUMS = BSELK-AGUMS.
  ENDIF.
  IF BSELK-AVSID(1) NE NODATA.         "Avis
    SAVE_FTCLEAR-AVSID = BSELK-AVSID.  "Avis
  ENDIF.                               "Avis
  IF BSELK-XFIFO(1) NE NODATA.
    SAVE_FTCLEAR-XFIFO = BSELK-XFIFO.
  ENDIF.
ENDFORM.                               "move_bselk_to_save_ftclear


*eject
*-----------------------------------------------------------------------
*        Form  FILL_FTTAX_FROM_BBSEG.
*-----------------------------------------------------------------------
*  Diese Routine hat die Aufgabe die FTTAX mit Daten aus BBSEG zu füllen
*  Durch das neue Steuerhandling ab 2.2 sind die Steuerdaten in FTTAX
*  zu übergeben.
*  Durch diese Routine wird in einfachen Fällen eine Aufwärts-
*  kompatibilität gewährleistet
*-----------------------------------------------------------------------
FORM FILL_FTTAX_FROM_BBSEG.
  CLEAR FTTAX.
  IF       XTBSL-KOART  =  'S'
  AND (    BBSEG-WMWST(1) NE NODATA
        OR BBSEG-MWSTS(1) NE NODATA ).
    IF BBKPF-XMWST  = 'X'.
*     Abbruch: Wenn XMWST übergeben,muß in Steuerfeldern NODATA stehen
      PERFORM LOG_MSG USING C_MSGID 'I' '148'
                            BELEG_COUNT SATZ2_COUNT SPACE SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '899'
                            'BBSEG-WMWST' '=' BBSEG-WMWST SPACE.
      PERFORM LOG_MSG USING C_MSGID 'I' '899'
                            'BBSEG-MWSTS' '=' BBSEG-MWSTS SPACE.
      PERFORM DUMP_WA USING 'BBKPF'.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.

*------- Steuer wird über BBSEG versorgt ------------------------------
    BBSEG_TAX = 'X'.

*------- Ausstieg bei Direct Input wg. Performance --------------------
    CHECK FUNCTION NE 'D'.                                  "30C

    IF BBSEG-WMWST = '*' OR BBSEG-MWSTS = '*'.
      READ TABLE FTPOST INDEX 1.
      IF FTPOST-FNAM NE 'BKPF-XMWST'.
        CLEAR: FTPOST.
        FTPOST-STYPE = 'K'.
        FTPOST-COUNT = '001'.
        FTPOST-FNAM = 'BKPF-XMWST'.
        FTPOST-FVAL = 'X'.
        INSERT FTPOST INDEX 1.
      ENDIF.
    ELSE.
      IF BBSEG-WMWST(1) NE NODATA.
        FTTAX-FWSTE = BBSEG-WMWST.
      ENDIF.
      IF BBSEG-MWSTS(1) NE NODATA.
        FTTAX-HWSTE = BBSEG-MWSTS.
      ENDIF.
      FTTAX-MWSKZ = BBSEG-MWSKZ.
      FTTAX-BSCHL = BBSEG-NEWBS.
      APPEND FTTAX.
    ENDIF.
  ENDIF.
ENDFORM.                               "fill_fttax_from_bbseg

*eject
************************************************************************
*      Include   Generiertes Coding ......
************************************************************************
INCLUDE ZCMFICO_RFBIBL02.

*&---------------------------------------------------------------------*
*&      Form  LOOP_AT_TABLE_TFILE
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM LOOP_AT_TABLE_TFILE.
  DATA: COUNTER(5) TYPE N.
  CLEAR GROUP_COUNT .

  PERFORM SET_GLOBAL_VARIABLE.

  DO.
    COUNTER = COUNTER + 1.
    IF FUNCTION NE 'B' AND SY-BATCH = 'X'.
      JOBID_EXT+27(5) = COUNTER.
      IMPORT TFILE FROM DATABASE TFSAVE(FI) ID JOBID_EXT.
      IF SY-SUBRC <> 0 .
        EXIT.
      ENDIF.
    ELSE.
      IF COUNTER > 1.
        EXIT.
      ENDIF.
    ENDIF.

    LOOP AT TFILE.
      WA = TFILE-REC.
      IF SY-TABIX = 1 AND COUNTER = 1.
*------- erster Satz muss Mappensatz sein ------------------------------
        IF WA(1) NE '0'.
          PERFORM LOG_MSG USING C_MSGID 'I' '004'
                                DS_NAME SPACE SPACE SPACE.
          PERFORM LOG_ABORT USING C_MSGID '013'.
        ENDIF.
        SAVE_BGR00 = WA.                                    "#EC ENHOK
      ENDIF.

      CASE WA(1).
        WHEN '0'.
*------- neue Mappe ----------------------------------------------------
          PERFORM LETZTEN_BELEG_ABSCHLIESSEN.
          PERFORM MAPPEN_WECHSEL.
        WHEN '1'.

*------- Kopfsatz ------------------------------------------------------
*------- Beleg abschliessen --------------------------------------------
          PERFORM LETZTEN_BELEG_ABSCHLIESSEN.
          PERFORM KOPFSATZ_BEARBEITEN.
          PERFORM FILL_T_BBKPF.
          REFRESH ERTAB.
          ERTAB = WA.
          APPEND ERTAB.
        WHEN '2'.
*------- Belegsegment --------------------------------------------------
          PERFORM DATENSATZ_PRUEFEN.
          SATZ2_CNT_AKT = SATZ2_COUNT - 1.
          PERFORM WA_DATEN_UEBERTRAGEN.
          PERFORM DATENSATZ_TRANSPORTIEREN.
          PERFORM FILL_T_BBSEG.
          PERFORM FILL_T_BWITH.
          PERFORM FILL_T_BBTAX.
          ERTAB = WA.
          APPEND ERTAB.
        WHEN OTHERS.
*------- ungültiger Satztyp --------------------------------------------
          SATZ2_COUNT = SATZ2_COUNT + 1.
          PERFORM LOG_MSG USING C_MSGID 'I' '152'
                          BELEG_COUNT SATZ2_COUNT WA(1) SPACE.
          PERFORM LOG_MSG USING C_MSGID 'I' '016'
                          SPACE SPACE SPACE SPACE.
          PERFORM DUMP_WA USING 'BBKPF'.
          PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDCASE.
    ENDLOOP.

    REFRESH TFILE.
  ENDDO.
  PERFORM LETZTEN_BELEG_ABSCHLIESSEN.

  PERFORM MAPPE_SCHLIESSEN.
*------- letzter CALL_BI_END_AKT_NUMBER  -------------------------------
  PERFORM CALL_BI_END_AKT_NUMBER.
  COMMIT WORK.
  CALL FUNCTION 'DEQUEUE_ALL'.
  CLEAR COMMIT_COUNT.
ENDFORM.                               " LOOP_AT_TABLE_TFILE



*&---------------------------------------------------------------------*
*&      Form  READ_DATASET_INTO_TABLE_TFILE
*&---------------------------------------------------------------------*
*       lesen der Datei und speichers der Sätze in Tabelle TFILE       *
*----------------------------------------------------------------------*
FORM READ_DATASET_INTO_TABLE_TFILE.
  DATA: NEW_PAK TYPE I.
  DATA: COUNTER(5) TYPE N.
*------- Datei öffnen -----------------------------------------------
  OPEN DATASET DS_NAME IN TEXT MODE ENCODING DEFAULT FOR INPUT.
*
*  if XNONUNIC = SPACE.
*    open dataset DS_NAME in text mode
*      encoding UTF-8
*      for input
*      skipping byte-order mark
*      ignoring conversion errors.
*  else.
*    open dataset DS_NAME in text mode encoding non-unicode
*      for input ignoring conversion errors.
*  endif.
  IF SY-SUBRC NE 0.
    PERFORM LOG_MSG USING C_MSGID 'I' '002'
                          DS_NAME SPACE SPACE SPACE.
    PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDIF.

*------- Sonderzeichen in Struktur trans definieren-----------------

  CLASS CL_ABAP_CONV_IN_CE DEFINITION LOAD.

  TRANS-X   = CL_ABAP_CONV_IN_CE=>UCCP( '0000' ).
  TRANS-SOH = CL_ABAP_CONV_IN_CE=>UCCP( '0001' ).
  TRANS-STX = CL_ABAP_CONV_IN_CE=>UCCP( '0002' ).
  TRANS-ETX = CL_ABAP_CONV_IN_CE=>UCCP( '0003' ).
  TRANS-EOT = CL_ABAP_CONV_IN_CE=>UCCP( '0004' ).
  TRANS-ENQ = CL_ABAP_CONV_IN_CE=>UCCP( '0005' ).
  TRANS-ACK = CL_ABAP_CONV_IN_CE=>UCCP( '0006' ).
  TRANS-BEL = CL_ABAP_CONV_IN_CE=>UCCP( '0007' ).
  TRANS-BS  = CL_ABAP_CONV_IN_CE=>UCCP( '0008' ).
  TRANS-HT  = CL_ABAP_CONV_IN_CE=>UCCP( '0009' ).
  TRANS-LF  = CL_ABAP_CONV_IN_CE=>UCCP( '000A' ).
  TRANS-VT  = CL_ABAP_CONV_IN_CE=>UCCP( '000B' ).
  TRANS-FF  = CL_ABAP_CONV_IN_CE=>UCCP( '000C' ).
  TRANS-CR  = CL_ABAP_CONV_IN_CE=>UCCP( '000D' ).
  TRANS-SO  = CL_ABAP_CONV_IN_CE=>UCCP( '000E' ).
  TRANS-SI  = CL_ABAP_CONV_IN_CE=>UCCP( '000F' ).
  TRANS-DLE = CL_ABAP_CONV_IN_CE=>UCCP( '0010' ).
  TRANS-DC1 = CL_ABAP_CONV_IN_CE=>UCCP( '0011' ).
  TRANS-DC2 = CL_ABAP_CONV_IN_CE=>UCCP( '0012' ).
  TRANS-DC3 = CL_ABAP_CONV_IN_CE=>UCCP( '0013' ).
  TRANS-DC4 = CL_ABAP_CONV_IN_CE=>UCCP( '0014' ).
  TRANS-NAK = CL_ABAP_CONV_IN_CE=>UCCP( '0015' ).
  TRANS-SYN = CL_ABAP_CONV_IN_CE=>UCCP( '0016' ).
  TRANS-ETB = CL_ABAP_CONV_IN_CE=>UCCP( '0017' ).
  TRANS-CAN = CL_ABAP_CONV_IN_CE=>UCCP( '0018' ).
  TRANS-EM  = CL_ABAP_CONV_IN_CE=>UCCP( '0019' ).
  TRANS-SUB = CL_ABAP_CONV_IN_CE=>UCCP( '001A' ).
  TRANS-ESC = CL_ABAP_CONV_IN_CE=>UCCP( '001B' ).
  TRANS-FS  = CL_ABAP_CONV_IN_CE=>UCCP( '001C' ).
  TRANS-GS  = CL_ABAP_CONV_IN_CE=>UCCP( '001D' ).
  TRANS-RS  = CL_ABAP_CONV_IN_CE=>UCCP( '001E' ).
  TRANS-US  = CL_ABAP_CONV_IN_CE=>UCCP( '001F' ).

*------- Datei lesen   -----------------------------------------------
  DO.

    CLEAR TFILE.
    READ DATASET DS_NAME INTO TFILE.

*------- End of File erreicht ? Exit Do-Schleife -------------------
    IF SY-SUBRC NE 0.
      EXIT.
    ENDIF.

    TRANSLATE TFILE USING TRANS.

*------- Satz in Tabelle füllen, falls ungleich Space ---------------
    IF NOT TFILE IS INITIAL.
      PERFORM CHECK_TFILE.
      APPEND TFILE.
    ENDIF.

*------ beim BI (und evtl. CT und DI, falls diese nicht ueber BMV0
*------ sondern direkt durch RFBIBL00 aufgerufen wurden) existiert
*------ keine eindeutige Job-Id, daher wird die interne Tabelle TFILE
*------ am Stueck und nicht paketweise abgespeichert.
*------ Wenn man CT oder DI ueber BMV0 einplant, so ist SY-BATCH
*------ gesetzt.
    IF FUNCTION NE 'B' AND SY-BATCH = 'X'.
      NEW_PAK = SY-TABIX MOD PACK_SIZE.
      IF NEW_PAK = 0.
        COUNTER = COUNTER + 1.
        JOBID_EXT+27(5) = COUNTER.
        EXPORT TFILE TO DATABASE TFSAVE(FI) ID JOBID_EXT.
        REFRESH TFILE.
      ENDIF.
    ENDIF.

  ENDDO.
  IF NEW_PAK NE 0.                     "gibt es Zeilen zum Uebertragen?
    COUNTER = COUNTER + 1.
    JOBID_EXT+27(5) = COUNTER.
    EXPORT TFILE TO DATABASE TFSAVE(FI) ID JOBID_EXT.
    REFRESH TFILE.
  ENDIF.

*------- Datei schliessen -------------------------------------------
  CLOSE DATASET DS_NAME.
ENDFORM.                               " READ_DATASET_INTO_TABLE_TFILE



*&---------------------------------------------------------------------*
*&      Form  CHECK_TFILE
*&---------------------------------------------------------------------*
*       Prüfen der Tabelle TFILE                                       *
*----------------------------------------------------------------------*
FORM CHECK_TFILE.
  STATICS: BBKPF_CNT TYPE I.

*------- Plausibilitätsprüfungen bei Belegköpfen ----------------------
  IF TFILE+0(1) = '1'.
    IF  FUNCTION CA 'DC'
    AND FL_CHECK IS INITIAL.
      BBKPF_CNT = BBKPF_CNT + 1.
      IF SY-BATCH NE 'X'
      AND BBKPF_CNT > 20.
        PERFORM LOG_MSG USING C_MSGID 'I' '032'
                              SPACE SPACE SPACE SPACE.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDIF.
    ENDIF.
    IF FUNCTION = 'D'
    AND ( TFILE+1(4) EQ 'FB05'
    OR    TFILE+1(4) EQ 'FBS1' ).
      PERFORM LOG_MSG USING C_MSGID 'I' '033'
                              SPACE SPACE SPACE SPACE.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDIF.
  ENDIF.

ENDFORM.                               " CHECK_TFILE


*&---------------------------------------------------------------------*
*&      Form  ERROR_PROCESSING
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM ERROR_PROCESSING.
  CHECK FUNCTION NE 'B'.
  CHECK FL_CHECK = SPACE.
  REFRESH: EFILE, TFILE.
  IMPORT SAVE_BGR00 EFILE FROM DATABASE TERRD(FI) ID JOBID.
  LOOP AT EFILE.
    TFILE = EFILE.
    APPEND TFILE.
  ENDLOOP.
  DESCRIBE TABLE TFILE LINES TFILL_TFILE.

  IF TFILL_TFILE > 0.
    IF TBIST_AKTIV NE 'X'.
      DELETE FROM DATABASE TERRD(FI) ID JOBID.
    ENDIF.
    FUNCTION = 'B'.
    ERROR_RUN = 'X'.
    CLEAR: STARTNUM, ALL_COMMIT, COMMIT_COUNT, NUMERROR,  COUNT.
    TFILE = SAVE_BGR00.                                     "#EC ENHOK
    INSERT TFILE INDEX 1.
    PERFORM LOOP_AT_TABLE_TFILE.
  ENDIF.
ENDFORM.                               " ERROR_PROCESSING

*&---------------------------------------------------------------------*
*&      Form  LETZTEN_BELEG_ABSCHLIESSEN
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM LETZTEN_BELEG_ABSCHLIESSEN.

  IF COUNT > STARTNUM.
    IF FUNCTION = 'D'.
      DESCRIBE TABLE T_BBSEG LINES TFILL_T_BBSEG.
      IF TFILL_T_BBSEG > 0.
        PERFORM FAST_INPUT.
      ENDIF.
    ELSE.
      DESCRIBE TABLE FTPOST LINES TFILL_FTPOST.
      IF TFILL_FTPOST > 0.
        PERFORM BELEG_ABSCHLIESSEN.
      ENDIF.
    ENDIF.
  ENDIF.
  CLEAR: BBKPF_OK.
ENDFORM.                               " LETZTEN_BELEG_ABSCHLIESSEN

*&---------------------------------------------------------------------*
*&      Form  FAST_ENTRY
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM FAST_INPUT.
  DATA: BUKRS LIKE BKPF-BUKRS,
        GJAHR LIKE BKPF-GJAHR,
        BELNR LIKE BKPF-BELNR.

  CHECK FL_CHECK = SPACE.
  IF BBKPF-TCODE = 'FB01' OR BBKPF-TCODE = 'FBB1'.
*  Batch-Input FLAG for Check doc type
    SY-BINPT = 'X'.
    CALL FUNCTION 'AC_DOCUMENT_DIRECT_INPUT'
      EXPORTING
        I_NODATA      = NODATA
        I_GRPID       = BGR00-GROUP
      IMPORTING
        E_BUKRS       = BUKRS
        E_GJAHR       = GJAHR
        E_BELNR       = BELNR
      TABLES
        T_BBKPF       = T_BBKPF
        T_BBSEG       = T_BBSEG
        T_BBTAX       = T_BBTAX
        T_BWITH       = T_BWITH
      EXCEPTIONS
        ERROR_MESSAGE = 01.
    IF SY-SUBRC IS INITIAL.
      IF PA_XPROT = 'X'.
        PERFORM LOG_MSG USING 'F5' 'I' '312'
                        BELNR BUKRS SPACE SPACE.
      ENDIF.
    ELSE.
      IF SY-MSGTY = 'A'.
        PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                              SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      ELSE.
        IF SY-BATCH IS INITIAL.
          PERFORM LOG_MSG USING SY-MSGID 'I' SY-MSGNO
                                SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      PERFORM EXPORT_ERROR_DATA.
    ENDIF.
  ELSE.
    MESSAGE W033.
    PERFORM EXPORT_ERROR_DATA.
  ENDIF.

*------- Commit Work? ------------------------------------------------
  COMMIT_COUNT = COMMIT_COUNT + 1.
  IF COMMIT_COUNT = MAX_COMMIT.
    PERFORM CALL_BI_END_AKT_NUMBER.
    COMMIT WORK.
    CALL FUNCTION 'DEQUEUE_ALL'.
    CLEAR COMMIT_COUNT.
  ENDIF.

* Refresh muß hier erfolgen, da im Fehlerfall nicht im FBS initialisiert
* werden kann
*
  REFRESH: T_BBKPF,
           T_BBSEG,
           T_BWITH,
           T_BBTAX.
  CLEAR:   T_BBKPF,                                         "30C
           T_BBSEG,                                         "30C
           T_BWITH,
           T_BBTAX.                                         "30C
ENDFORM.                               " FAST_ENTRY

*&---------------------------------------------------------------------*
*&      Form  FILL_T_BBKPF
*&---------------------------------------------------------------------*
FORM FILL_T_BBKPF.
  CHECK FUNCTION = 'D'.
  APPEND BBKPF TO T_BBKPF.
ENDFORM.                               " FILL_T_BBKPF

*&---------------------------------------------------------------------*
*&      Form  FILL_T_BBSEG
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM FILL_T_BBSEG.
  CHECK FUNCTION = 'D'.
  IF WA+2(9) = 'BSEG'.
*------- falls ZBSEG wurde diese bereits in BBSEG gemoved -------------
*    append bbseg to t_bbseg.
    CLEAR WA_BBSEG_DI.
    MOVE-CORRESPONDING BBSEG TO WA_BBSEG_DI.
    IF XTBSL-KOART = 'D' OR
       XTBSL-KOART = 'K'.
      WA_BBSEG_DI-WT_KEY = WT_COUNT.
    ENDIF.
    APPEND WA_BBSEG_DI TO T_BBSEG.
  ENDIF.
ENDFORM.                               " FILL_T_BBSEG

*&---------------------------------------------------------------------*
*&      Form  FILL_T_BBTAX
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM FILL_T_BBTAX.
  CHECK FUNCTION = 'D'.
  IF WA+2(9) = 'BTAX'.
    APPEND BBTAX TO T_BBTAX.
  ENDIF.
ENDFORM.                               " FILL_T_BBSEG

*eject
*&---------------------------------------------------------------------*
*&      Form  GET_RESTART_INFO
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM GET_RESTART_INFO.
  DATA: ACTION.                                             " thk 30F
  DATA: COUNTER(5) TYPE N.

  CHECK FUNCTION NE 'B'.                                    "30C+
  CHECK FL_CHECK = SPACE.                                   "30C
* Startnummer holen
  IF SY-BATCH = 'X'.
* THK zu 30F: Aufruf jetzt mit importing-parameter (Periodische Jobs)
*   CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
*        IMPORTING
*             JOBNAME         = JOBNAME
*        EXCEPTIONS
*             NO_RUNTIME_INFO = 01.
*   IF SY-SUBRC NE 0.
*     MESSAGE A051.
*   ENDIF.
    CALL FUNCTION 'BI_GET_STARTING_NUMBER'
      IMPORTING
        JOBID              = JOBID
        ACTUAL_NUMBER      = STARTNUM
        ACTION             = ACTION
        LASTERRNUM         = LASTERRNUM
        NUMERRORS          = OLDERROR
      EXCEPTIONS
        WRONG_STATUS_FOUND = 02
        NOT_FOUND          = 03.

    IF FUNCTION NE 'B'.                                     "QHA30C+
      CASE SY-SUBRC.
        WHEN 0.                                             "QHA30C+
* begin P30K110179
          IF JOBID+27(5) NE SPACE.
            PERFORM LOG_MSG USING C_MSGID 'I' '209'
                                  JOBID '27' SPACE SPACE.
            PERFORM LOG_ABORT USING C_MSGID '013'.
          ENDIF.
          JOBID_EXT = JOBID.
          CASE ACTION.
            WHEN 'E'.                  " Fehler nachbuchen
              PERFORM LOG_MSG USING C_MSGID 'I' '034'
                              SPACE SPACE SPACE SPACE.
              PERFORM LOG_ABORT USING C_MSGID '013'.
            WHEN ' '.                  " Neustart
              DELETE FROM DATABASE TERRD(FI) ID JOBID.      "31H
              DO.
                COUNTER = COUNTER + 1.
                JOBID_EXT+27(5) = COUNTER.
                DELETE FROM DATABASE TFSAVE(FI) ID JOBID_EXT.
                IF SY-SUBRC <> 0 .
                  EXIT.
                ENDIF.
              ENDDO.
              PERFORM EXECUTE_BI_END_AKT_NUMBER.
            WHEN 'R'.                  " Wiederaufsetzen (Restart)
              ALL_COMMIT = STARTNUM.
              TFSAVE_FILL = 'X'.
              PERFORM LOG_MSG USING C_MSGID 'I' '059'
                                    JOBID SPACE SPACE SPACE.
          ENDCASE.
* end P30K110179

          TBIST_AKTIV = 'X'.                                "QHA30C+
        WHEN 2.
          PERFORM LOG_MSG USING C_MSGID 'I' '053'
                                SPACE SPACE SPACE SPACE.
          PERFORM LOG_ABORT USING C_MSGID '013'.
        WHEN 3.
          PERFORM LOG_MSG USING C_MSGID 'I' '054'
                                SPACE SPACE SPACE SPACE.
          PERFORM LOG_ABORT USING C_MSGID '013'.
      ENDCASE.

      IF STARTNUM NE 0.
        PERFORM LOG_MSG USING C_MSGID 'I' '055'
                              STARTNUM SPACE SPACE SPACE.
      ENDIF.
    ELSE.
      IF SY-SUBRC = 0.
        TBIST_AKTIV = 'X'.
      ENDIF.
    ENDIF.
*   ELSEIF STARTNUM = 0.
*     MESSAGE I899 WITH 'Diese Mappe wird zum ersten Mal angefasst'.
*      "WICHTIG!
*      DELETE ETAB FROM DATABASE ....
*   ELSE.
*     IF IS_ERROR = 'X'.
*      MESSAGE I899 WITH 'File' DS_NAME 'letzter Fehler bei' STARTNUM.
*     ELSE.
*        MESSAGE I899 WITH 'File' DS_NAME 'Fortsetzung bei' STARTNUM.
*     ENDIF.
*   ENDIF.
  ELSE.
    STARTNUM = 0.
*   IS_ERROR = SPACE.
    JOBID   = 'RFBIBL00_'.
    JOBID+9 = SY-UNAME.
    DELETE FROM DATABASE TERRD(FI) ID JOBID.
  ENDIF.

ENDFORM.                               " GET_STARTING_NUMBER

*&---------------------------------------------------------------------*
*&      Form  CALL_BI_END_AKT_NUMBER
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM CALL_BI_END_AKT_NUMBER.
* CHECK SY-BATCH = 'X'.
  CHECK FL_CHECK = SPACE.              "QHA->Steinwedel
* CHECK NOT jobid IS INITIAL.
  CHECK FUNCTION NE 'B'.
  CHECK TBIST_AKTIV = 'X'.

  ALL_COMMIT = ALL_COMMIT + COMMIT_COUNT.
  PERFORM EXECUTE_BI_END_AKT_NUMBER.
  CLEAR COMMIT_COUNT.
  CLEAR NUMERROR.

ENDFORM.                               " CALL_BI_END_AKT_NUMBER


*&---------------------------------------------------------------------*
*&      Form  EXECUTE_BI_END_AKT_NUMBER
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM EXECUTE_BI_END_AKT_NUMBER.

  CALL FUNCTION 'BI_END_AKT_NUMBER'
       EXPORTING
            JOBNAME          = JOBID
            ACTUAL_NUMBER    = ALL_COMMIT
            NUMBER_OF_ERRORS = NUMERROR"eine relative Zahl,
               "Anzahl Fehler seit dem letzem(!) COMMIT, wird im FB
                                       "kumuliert.
*           EXTERNAL_NUMBER  = 'interne Nummernvergabe'
       EXCEPTIONS
            INTERNAL_ERROR   = 01
            NOT_FOUND        = 02.

  CASE SY-SUBRC.
    WHEN 0.
*       MESSAGE I899 WITH 'BI_END_AKT_NUMBER' BELEG_COUNT.     "30Ctest
    WHEN 1.
      ROLLBACK WORK.
      PERFORM LOG_MSG USING C_MSGID 'I' '056'
                              SPACE SPACE SPACE SPACE.
      PERFORM LOG_ABORT USING C_MSGID '013'.
    WHEN 2.
      ROLLBACK WORK.
      PERFORM LOG_MSG USING C_MSGID 'I' '054'
                              JOBID SPACE SPACE SPACE.
      PERFORM LOG_ABORT USING C_MSGID '013'.
  ENDCASE.

ENDFORM.                               " EXECUTE_BI_END_AKT_NUMBER



*eject
*&---------------------------------------------------------------------*
*&      Form  EXPORT_ERROR_DATA
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM EXPORT_ERROR_DATA.
  DESCRIBE TABLE ERTAB LINES TFILL_ERTAB.
  CHECK TFILL_ERTAB > 0.

  IMPORT SAVE_BGR00 EFILE FROM DATABASE TERRD(FI) ID JOBID.

  LOOP AT ERTAB.
    EFILE = ERTAB.
    APPEND EFILE.
  ENDLOOP.

  EXPORT SAVE_BGR00 EFILE TO DATABASE TERRD(FI) ID JOBID.
  NUMERROR = NUMERROR + 1.
ENDFORM.                               " EXPORT_ERROR_DATA

*eject
*&---------------------------------------------------------------------*
*&      Form  CALL_BI_CLOSE_ENTRY
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
FORM CALL_BI_CLOSE_ENTRY.
  DATA: COUNTER(5) TYPE N.
  IF TBIST_AKTIV = 'X' AND SY-BATCH = 'X'.
    CALL FUNCTION 'BI_CLOSE_ENTRY'
      EXPORTING
        JOBNAME        = JOBID
      EXCEPTIONS
        INTERNAL_ERROR = 01
        NOT_FOUND      = 02.

    CASE SY-SUBRC.
      WHEN 0.
        DELETE FROM DATABASE TERRD(FI) ID JOBID.
        DO.
          COUNTER = COUNTER + 1.
          JOBID_EXT+27(5) = COUNTER.
          DELETE FROM DATABASE TFSAVE(FI) ID JOBID_EXT.
          IF SY-SUBRC <> 0 .
            EXIT.
          ENDIF.
        ENDDO.
      WHEN 1.
        PERFORM LOG_MSG USING C_MSGID 'I' '057'
                             SPACE SPACE SPACE SPACE.
        PERFORM LOG_ABORT USING C_MSGID '013'.
      WHEN 2.
        PERFORM LOG_MSG USING C_MSGID 'I' '054'
                              JOBID SPACE SPACE SPACE.
        PERFORM LOG_ABORT USING C_MSGID '013'.
    ENDCASE.
  ELSE.
    IF FUNCTION NE 'B'.
      DELETE FROM DATABASE TERRD(FI) ID JOBID.
    ENDIF.
  ENDIF.

* delete tfsave also in test run
  IF FL_CHECK EQ 'X' AND FUNCTION NE 'B' AND SY-BATCH = 'X'.
    COUNTER = 0.
    DO.
      COUNTER = COUNTER + 1.
      JOBID_EXT+27(5) = COUNTER.
      DELETE FROM DATABASE TFSAVE(FI) ID JOBID_EXT.
      IF SY-SUBRC <> 0 .
        EXIT.
      ENDIF.
    ENDDO.
  ENDIF.

ENDFORM.                               " CALL_BI_CLOSE_ENTRY
*&---------------------------------------------------------------------*
*&      Form  FILL_T_BWITH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FILL_T_BWITH.
  CHECK FUNCTION = 'D'.
  IF WA+2(9) = 'WITH'.
*    append bwith to t_bwith.
    CLEAR WA_BWITH_DI.
    MOVE-CORRESPONDING BWITH TO WA_BWITH_DI.
    WA_BWITH_DI-WT_KEY = WT_COUNT.
    APPEND WA_BWITH_DI TO T_BWITH.
  ENDIF.
ENDFORM.                               " FILL_T_BWITH

*eject
*&---------------------------------------------------------------------*
*&      Form  BSELP_FIELD_LENGHT_CONVERT
*&---------------------------------------------------------------------*
*       Die Länge der Felder BSELP-FELDN, BSELP-SLVON und BSELP-SLBIS
*       wird angepasst                                                 *
*       Feld           Länge vor 4.0A        Länge ab 4.0A             *
*       BSELP-FELDN     5                    30
*       BSELP-SLVON    20                    30
*       BSELP-SLBIS    20                    30
*
*  ---> p_wa          aktuelle Zeile mit alten Feldlängen
*  <--- p_wa          aktuelle Zeile mit neuen Feldlängen
*----------------------------------------------------------------------*
FORM BSELP_FIELD_LENGHT_CONVERT CHANGING P_WA.
  DATA: WA_TMP(2600) TYPE C,           " help work area
        OFFSET_O TYPE I,               " old offset (<4.0A)
        OFFSET_N TYPE I.               " new offset (>= 4.0A)

  CLEAR WA_TMP.
  WA_TMP(31) = P_WA(31).
  OFFSET_N = 31.
  OFFSET_O = 31.
  DO 18 TIMES.
    WA_TMP+OFFSET_N(5) = P_WA+OFFSET_O(5).
    OFFSET_N = OFFSET_N + 30.
    OFFSET_O = OFFSET_O + 5.
    DO 2 TIMES.
      WA_TMP+OFFSET_N(20) = P_WA+OFFSET_O(20).
      OFFSET_N = OFFSET_N + 30.
      OFFSET_O = OFFSET_O + 20.
    ENDDO.
  ENDDO.
  CLEAR P_WA.
  P_WA = WA_TMP.
ENDFORM.                               "bselp_field_lenght_convert

*&---------------------------------------------------------------------*
*&      Form  set_global_variable
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SET_GLOBAL_VARIABLE.

  CHECK FUNCTION NE 'D'.
* -----  read currency exchange rate prefixes --------------------------
  CALL FUNCTION 'RATE_GET_PREFIXES'
    EXPORTING
      CLIENT   = SY-MANDT
    IMPORTING
      PREFIX_P = PREFIX_P
      PREFIX_M = PREFIX_M.


ENDFORM.                               " set_global_variable
