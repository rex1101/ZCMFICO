FUNCTION-POOL ZFGCMFIC01 MESSAGE-ID fb.                    "MESSAGE-ID ..

* INCLUDE LZFGCMFIC01D...                    " Local class definition
************************************************************************
*        Der Generierungsreport RFBIBLG0
*            generiert das Coding von RFBIBL02
*            RFBIBL02 wird in RFBIBL01 includiert
************************************************************************
*-----------------------------------------------------------------------
*        Tabellen
*-----------------------------------------------------------------------
TABLES:  BGR00,                        " Mappenvorsatz
         BBKPF,                        " Belegkopf + Tcode
         BBSEG,                        " Belegsegment.
         BBTAX,                        " Belegsteuern.
         BWITH,                        " Quellensteuer
         BSELK,                        " Selektionsdaten Kopf
         BSELP.                        " Selektionsdaten Position

TABLES:  TBSL.                         " Buchungsschlüssel
TABLES:  T041A.                        " Ausgleichsvorgänge
TABLES:  T100.                         " Nachrichten


DATA:   BEGIN OF FTPOST OCCURS 100.
        INCLUDE STRUCTURE FTPOST.
DATA:   END OF FTPOST.

DATA:   BEGIN OF FTCLEAR OCCURS 20.
        INCLUDE STRUCTURE FTCLEAR.
DATA:   END OF FTCLEAR.

DATA:   BEGIN OF FTTAX OCCURS 0.
        INCLUDE STRUCTURE FTTAX.
DATA:   END OF FTTAX.

DATA:   BEGIN OF XBLNTAB  OCCURS 2.
        INCLUDE STRUCTURE BLNTAB.
DATA:   END OF XBLNTAB.


DATA:    BEGIN OF SAVE_FTCLEAR.
        INCLUDE STRUCTURE FTCLEAR.
DATA:    END OF SAVE_FTCLEAR.

*------- Tabelle T_BBKPF enthält Belegkopf + Tcode  --------------------
DATA:    T_BBKPF LIKE BBKPF OCCURS 1.

*------- Tabelle T_BBSEG enthält Belegsegment --------------------------
DATA:    T_BBSEG LIKE BBSEG_DI OCCURS 50.

*------- Tabelle T_BBTAX enthält Steuerdaten ---------------------------
DATA:    T_BBTAX LIKE BBTAX OCCURS 50.

*------- Tabelle T_BWITH enthält Quellensteuerdaten --------------------
DATA:    T_BWITH LIKE BWITH_DI OCCURS 50.

*------- Tabelle FFILE enthält alle Datensätze -------------------------
DATA:    BEGIN OF TFILE OCCURS 0,
           REC(3300)  TYPE C,
         END OF TFILE.
DATA:    BEGIN OF EFILE OCCURS 100,
           REC(3300)  TYPE C,
         END OF EFILE.
DATA:    BEGIN OF ERTAB OCCURS 5,
           REC(3300)  TYPE C,
         END OF ERTAB.

*------- Feld-Informationen aus NAMETAB --------------------------------
DATA:    BEGIN OF NAMETAB OCCURS 120.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB.

*------- Tabelle XT001 -------------------------------------------------
DATA:    BEGIN OF XT001 OCCURS 5.
        INCLUDE STRUCTURE T001.
DATA:    END OF XT001.

*------- Tabelle XTBSL -------------------------------------------------
DATA:    BEGIN OF XTBSL OCCURS 10.
        INCLUDE STRUCTURE TBSL.
DATA:    END OF XTBSL.


*------- Tabelle XT041A ------------------------------------------------
DATA:    BEGIN OF XT041A OCCURS 5,
           AUGLV        LIKE T041A-AUGLV,
         END OF XT041A.

*eject
*---------------------------------------------------------------------*
*        Strukturen
*---------------------------------------------------------------------*
*------- Initialstrukturen --------------------------------------------
DATA:    BEGIN OF I_BBKPF.
        INCLUDE STRUCTURE BBKPF.       " Belegkopf
DATA:    END OF I_BBKPF.

DATA:    BEGIN OF I_BBSEG.
        INCLUDE STRUCTURE BBSEG.       " Belegsegment
DATA:    END OF I_BBSEG.

DATA:    BEGIN OF I_BBTAX.
        INCLUDE STRUCTURE BBTAX.       " Belegsteuern
DATA:    END OF I_BBTAX.

DATA:    BEGIN OF I_BSELK.
        INCLUDE STRUCTURE BSELK.       " Selektionsdaten Kopf
DATA:    END OF I_BSELK.

DATA:    BEGIN OF I_BSELP.
        INCLUDE STRUCTURE BSELP.       " Selektionsdaten Position
DATA:    END OF I_BSELP.

DATA:    BEGIN OF I_BWITH.
        INCLUDE STRUCTURE BWITH.       " Quellensteuer
DATA:    END OF I_BWITH.

*------- Hilfsstrukturen für Direct Input ------------------------------
DATA:    BEGIN OF WA_BBSEG_DI.
        INCLUDE STRUCTURE BBSEG_DI.
DATA:    END OF WA_BBSEG_DI.

DATA:    BEGIN OF WA_BWITH_DI.
        INCLUDE STRUCTURE BWITH_DI.
DATA:    END OF WA_BWITH_DI.

DATA:    BEGIN OF TRANS OCCURS 0,
           X     TYPE C,
           C_00  TYPE C VALUE ' ',
           SOH   TYPE C,
           C_01  TYPE C VALUE ' ',
           STX   TYPE C,
           C_02  TYPE C VALUE ' ',
           ETX   TYPE C,
           C_03  TYPE C VALUE ' ',
           EOT   TYPE C,
           C_04  TYPE C VALUE ' ',
           ENQ   TYPE C,
           C_05  TYPE C VALUE ' ',
           ACK   TYPE C,
           C_06  TYPE C VALUE ' ',
           BEL   TYPE C,
           C_07  TYPE C VALUE ' ',
           BS    TYPE C,
           C_08  TYPE C VALUE ' ',
           HT    TYPE C,
           C_09  TYPE C VALUE ' ',
           LF    TYPE C,
           C_0A  TYPE C VALUE ' ',
           VT    TYPE C,
           C_0B  TYPE C VALUE ' ',
           FF    TYPE C,
           C_0C  TYPE C VALUE ' ',
           CR    TYPE C,
           C_0D  TYPE C VALUE ' ',
           SO    TYPE C,
           C_0E  TYPE C VALUE ' ',
           SI    TYPE C,
           C_0F  TYPE C VALUE ' ',
           DLE   TYPE C,
           C_10  TYPE C VALUE ' ',
           DC1   TYPE C,
           C_11  TYPE C VALUE ' ',
           DC2   TYPE C,
           C_12  TYPE C VALUE ' ',
           DC3   TYPE C,
           C_13  TYPE C VALUE ' ',
           DC4   TYPE C,
           C_14  TYPE C VALUE ' ',
           NAK   TYPE C,
           C_15  TYPE C VALUE ' ',
           SYN   TYPE C,
           C_16  TYPE C VALUE ' ',
           ETB   TYPE C,
           C_17  TYPE C VALUE ' ',
           CAN   TYPE C,
           C_18  TYPE C VALUE ' ',
           EM    TYPE C,                                "#EC NO_M_RISC3
           C_19  TYPE C VALUE ' ',
           SUB   TYPE C,
           C_1A  TYPE C VALUE ' ',
           ESC   TYPE C,
           C_1B  TYPE C VALUE ' ',
           FS    TYPE C,
           C_1C  TYPE C VALUE ' ',
           GS    TYPE C,
           C_1D  TYPE C VALUE ' ',
           RS    TYPE C,
           C_1E  TYPE C VALUE ' ',
           US    TYPE C,
           C_1F  TYPE C VALUE ' ',
         END OF TRANS.


*------- Workarea zum Lesen der BI-Sätze -------------------------------
*------- wa, ertab, tfile und efile muessen mindestens so lang sein
*------- wie die laengste Batchinput-Struktur BBSEG + kundeneigene
*------- Felder im Include CI_COBL_BI.
*------- Laenge der BBSEG ohne CI_COBL_BI (Stand 3.0F) 1861 Bytes
DATA:    BEGIN OF WA,
           CHAR1(3300)  TYPE C,
         END OF WA.

*eject
*---------------------------------------------------------------------*
*        Einzelfelder
*---------------------------------------------------------------------*
DATA:    BELEG_COUNT(6) TYPE C,        " Anz. Belege je Mappe
         BELEG_BREAK(6) TYPE C,        " Anz. Belege je Mappe
         BUKRS          LIKE BBSEG-NEWBK,   " Buchungskreis
         BBKPF_OK(1)    TYPE C,        " Belegkopf übergeben
         BBSEG_COUNT(3) TYPE N,        " Anz. BSEGS pro Beleg
         BBSEG_TAX(1)   TYPE C.        " Steuer über BBSEG eingegeb

DATA:    CHAR(40)       TYPE C,        " Char. Hilfsfeld
         CHAR1(1)       TYPE C,        " Char. Hilfsfeld
         CHAR2(40)      TYPE C,        " Char. Hilfsfeld
         TFILE_FILL(1)  TYPE C,        " X=TFILE schon gefüllt
         TFSAVE_FILL(1)  TYPE C,       " X=TFSAVE schon gefüllt
         COMMIT_COUNT(4) TYPE N,       " Zähler für Commit
         ALL_COMMIT LIKE TBIST-AKTNUM. " Anzahl der Belege bis zum
" letzten COMMIT

DATA:    DYN_NAME(12)   TYPE C.        " Dynproname

DATA:    ERROR_RUN(1)   TYPE C.        " X = error processing

DATA:    FCODE(5)       TYPE C,        " Funktionscode
         FUNCTION       LIKE  RFIPI-FUNCT.  " B= BDC, C= Call Trans
" D-DIRECT INPUT
DATA:    GROUP_COUNT(6) TYPE C,        " Anzahl Mappen
         GROUP_OPEN(1)  TYPE C.        " X=Mappe schon geöffnet

DATA:    LN_BBSEG(8)    TYPE P,        " Länge des BBSEG
         LN_BBKPF(8)    TYPE P,        " Länge des BBKPF
         LN_BSELK(8)    TYPE P,        " Länge des BSELK
         LN_BSELP(8)    TYPE P.        " Länge des BSELP

DATA:    MODE           LIKE  RFPDO-ALLGAZMD.
DATA:    MSGVN          LIKE SY-MSGV1, " Hilfsfeld Message-Variable
         MSGID          LIKE SY-MSGID,
         MSGTY          LIKE SY-MSGTY,
         MSGNO          LIKE SY-MSGNO,
         MSGV1          LIKE SY-MSGV1,
         MSGV2          LIKE SY-MSGV2,
         MSGV3          LIKE SY-MSGV3,
         MSGV4          LIKE SY-MSGV4.

DATA:    N(2)           TYPE N,        " Hilfsfeld num.
         NODATA(1)      TYPE C,        " Keine BI-Daten für Feld
         NODATA_OLD     LIKE NODATA.   " NODATA gemerkt

DATA:    PREFIX_P       LIKE TCURP-PREFIX_P, "price-based rate prefix
         PREFIX_M       LIKE TCURP-PREFIX_P. "quantity-based rate prefix

DATA:    REFE1(8)       TYPE P.        " Hilfsfeld gepackt

DATA:    SATZ2_COUNT(6) TYPE C,        " Anz. Sätze(Typ2) je Trans.
         SATZ2_CNT_AKT  LIKE SATZ2_COUNT,   " Anz. Sätze(Typ2) - 1
         SAVE_TBNAM     LIKE BBSEG-TBNAM,   " gemerkter Tabellenname
         SAVE_BGR00     LIKE BGR00,    " gemerkter BGR00
         SUBRC          LIKE SY-SUBRC, " Subrc
         COUNT          TYPE I.        " Anz. Belege

DATA:    TABIX(2)       TYPE N,        " Tabelleninex
         TBIST_AKTIV(1) TYPE C,        " Restart aktiv?
         TEXT(200)      TYPE C,        " Messagetext
         TEXT1(40)      TYPE C,        " Messagetext
         TEXT2(40)      TYPE C,        " Messagetext
         TEXT3(40)      TYPE C,        " Messagetext
         TFILL_FTPOST   TYPE I,        " Anz. Einträge in FTPOST
         TFILL_T_BBSEG  TYPE I,        " Anz. Einträge in T_BBSEG
         TFILL_T_BWITH  TYPE I,        " Anz. Einträge in T_BWITH
         TFILL_TFILE    TYPE I,        " Anz. Einträge in TFILE
         TFILL_ERTAB    TYPE I,        " Anz. Einträge in ERTAB
         TFILL_FTC(3)   TYPE N,        " Anz. Einträge in FTC
         TFILL_FTK(3)   TYPE N,        " Anz. Einträge in FTK
         TFILL_FTZ(3)   TYPE N,        " Anz. Einträge in FTZ
         TFILL_041A(1)  TYPE N.        " Anz. Einträge in XT041A


DATA:    WERT(60)       TYPE C,        " Hilfsfeld Feldinhalt
         WT_COUNT       TYPE I.        " Zähler Quellensteuer

DATA:    XBDCC          LIKE RFIPI-XBDCC,   " X=BDC bei Error in CallTra
         XEOF(1)        TYPE C,        " X=End of File erreicht
         XMESS_BBKPF_SENDE(1) TYPE C,  " Message gesendet für BBKPF
         XMESS_BBSEG_SENDE(1) TYPE C,  " Message gesendet für BBSEG
         XMESS_BBTAX_SENDE(1) TYPE C,  " Message gesendet für BBTAX
*        XMWST          LIKE BKPF-XMWST,    " Steuer rechnen
         XNEWG(1)       TYPE C,        " X=Neue Mappe
         XFTCLEAR(1).                  " Append FTCLEAR durchfuehren?

* DATAs wichtig für Wiederaufsetzbarkeit
DATA: AKTNUM LIKE TBIST-AKTNUM.   " Zähler für aktuell bearbeiteter Satz
DATA: STARTNUM LIKE TBIST-AKTNUM.      " erster zu bearbeitender Satz
*ata: is_error.                   " übergebene Satznummer war fehlerhaft
DATA: NUMERROR LIKE TBIST-NUMERROR.    " Anzahl Fehler in diesem Schritt
DATA: OLDERROR LIKE TBIST-NUMERROR.    " Anzahl Fehler aus dem
" vorherigen Job.
DATA: LASTERRNUM LIKE TBIST-LASTNUM.   "Letzte Fehlernummer
DATA: NOSTART LIKE TBIST-NOSTARTING VALUE 'X'. " Start-Infos schreiben ?
DATA: JOBID LIKE TBTCO-JOBNAME.
DATA: JOBID_EXT LIKE TBTCO-JOBNAME.
CONSTANTS:   PACK_SIZE TYPE I VALUE '250',
             C_MSGID   LIKE SY-MSGID VALUE 'FB'.

TABLES: TERRD,
        TFSAVE.

*-----------------------------------------------------------------------
*        Konstanten und Field-Symbols
*-----------------------------------------------------------------------
DATA:    C_NODATA(1)    TYPE C VALUE '/',   " Default für NODATA
         XON                   VALUE 'X'.   " Flag eingeschaltet

DATA:    FMF1GES(1)     TYPE X VALUE '20'.  " Beide Flags aus: Input.
DATA:    FMB1NUM(1)     TYPE X VALUE '10'.  "       "

DATA:    MAX_COMMIT(4)  TYPE N.        " Max. Belege je Commit

DATA:    REP_NAME_A(8)  TYPE C VALUE 'SAPMF05A'. " Mpool SAPMF05A
DATA:    REP_NAME_C(8)  TYPE C VALUE 'SAPLFCPD'. " Mpool SAPLFCPD
DATA:    REP_NAME_K(8)  TYPE C VALUE 'SAPLKACB'. " Mpool SAPLKACB

FIELD-SYMBOLS: <F1>.


*************************************end copy RFBIBL01************************************




* 332 ~ 359 line copies that is RFBIBL01's parameters part
* PARAMETERS, SELECT-OPTIONS to data declaration
DATA: DS_NAME LIKE RFPDO-RFBIFILE. " Dateiname

DATA: FL_CHECK LIKE RFPDO-RFBICHCK, " Datei nur pr?en
      OS_XON      LIKE RFPDO-RFBIOLDSTR.  " Alte Strukturen

DATA: MAX_COMM(4) TYPE N VALUE '1000', " Max Belege pro Commit
      PA_XPROT(1) TYPE C,        " erweitertes Protokoll
      ANZ_MODE    LIKE RFPDO-ALLGAZMD    VALUE 'N',
      UPDATE      LIKE RFPDO-ALLGVBMD    VALUE 'S',
      XPOP  TYPE C,
* Do not by XPOP and alteration by XLOG
      XLOG  TYPE C VALUE 'X',
      XINF  TYPE C.

* Addition data declaration
DATA: G_BELNR LIKE BKPF-BELNR,
      G_GJAHR LIKE BKPF-GJAHR,
      G_BUKRS LIKE BKPF-BUKRS,
      G_TCODE LIKE BKPF-TCODE.

DATA: T_DD03L LIKE DD03L OCCURS 0 WITH HEADER LINE,
      GT_FIMSG LIKE FIMSG OCCURS 0 WITH HEADER LINE.

* Normalcy journalizing
CONSTANTS: C_TCODE_NORMAL LIKE SY-TCODE VALUE 'FB01'.


************************************************************************************************
************************************************************************************************

*************************   CUSTOMER STRUCTRE DEFINED ******************************************

************************************************************************************************
************************************************************************************************

DATA:
       GS_DOCUMENTHEADER    TYPE BAPIACHE09,
       GT_ACCOUNTGL         TYPE STANDARD TABLE OF BAPIACGL09,
       GT_ACCOUNTPAYABLE    TYPE STANDARD TABLE OF BAPIACAP09,
       GT_ACCOUNTRECEIVABLE TYPE STANDARD TABLE OF BAPIACAR09,
       GT_CURRENCYAMOUNT    TYPE STANDARD TABLE OF BAPIACCR09,
       GT_EXT2              TYPE STANDARD TABLE OF BAPIPAREX WITH HEADER LINE,
       GT_RETURN            TYPE STANDARD TABLE OF BAPIRET2,
       GT_ACCOUNTTAX        TYPE STANDARD TABLE OF BAPIACTX09 , "WITH HEADER LINE, "税务项目
       GT_CRITERIA          TYPE STANDARD TABLE OF BAPIACKEC9 . "WITH HEADER LINE, "会计记帐：CO-PA 科目分配特性

DATA: GS_CONF TYPE ZFI_DOCUMENT_POSTING_CNF.
DATA: GS_EXTRA TYPE ZFI_DOCUMENT_POSTING_EXT_FIELD.

DATA: GV_ERROR TYPE CHAR2."ERROR FLAG.
DATA: GV_FNAM TYPE RS38L_FNAM.
DATA: GS_ERROR_RETURN TYPE ZFI_DOCUMENT_POSTING_EXPORT.

DATA: GT_BBKPF TYPE TABLE OF BBKPF.
DATA: GT_BBSEG TYPE TABLE OF BBSEG.
*
DATA: MSG_TAB TYPE STANDARD TABLE OF MSG_TAB_LINE           "Note482563
              WITH HEADER LINE.                             "Note482563
