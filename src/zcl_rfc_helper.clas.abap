CLASS zcl_rfc_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rfc_helper IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


***************************************************************************************
* ABAP DDIC types
* https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenddic_builtin_types.htm
***************************************************************************************
* ABAP CDS types
* https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abencds_typing.htm
***************************************************************************************
*    DATA:
*      lo_struct_desc           TYPE REF TO cl_abap_structdescr,
*      lo_type_desc             TYPE REF TO cl_abap_typedescr,
*      lo_elem_desc             TYPE REF TO cl_abap_elemdescr,
*      lt_comp_table            TYPE cl_abap_structdescr=>component_table,
*      lv_length                TYPE i,
*      lv_p_length              TYPE i,
*      lv_decimals              TYPE i,
*      lv_abap_cds_data_type    TYPE abap_typename,
*      lv_abap_ddic_data_type   TYPE string,
*      lv_property              TYPE string,
*      ls_ddic_fields           TYPE dfises,
*      lv_ddl_source_code_line  TYPE string,
*      lt_ddl_source_code       TYPE STANDARD TABLE OF string,
*      lv_abap_source_code_line TYPE string,
*      lt_abap_source_code      TYPE STANDARD TABLE OF string,
*      lv_reffield_abap         TYPE dd03l-reffield,
*      lv_refproperty           TYPE string.
*
*    DATA: lv_rfc_input_structure TYPE string VALUE 'bapi_epm_product_header'.
*
*    "name of structure must be in uppercase because otherwise reference fields for currency and unit
*    "are not found in DD03L
*    lv_rfc_input_structure = to_upper( lv_rfc_input_structure ).
*
*    lo_type_desc =  cl_abap_typedescr=>describe_by_name( lv_rfc_input_structure ).
*
*    "check that the object is a structure
*    TRY.
*        IF lo_type_desc->kind = lo_type_desc->kind_struct.
*          lo_struct_desc ?= lo_type_desc.
*          "this method retrieves the components also from structures with append structures
*          /iwbep/cl_mgw_med_model_util=>get_structure_components(
*            EXPORTING
*              io_structure_descriptor = lo_struct_desc
*            CHANGING
*              ct_components = lt_comp_table ).
*        ELSE.
*          "@todo: raise a more meaningful exception here
*          RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
*            EXPORTING
*              textid = /iwbep/cx_mgw_med_exception=>otr_text_read_error.
*        ENDIF.
*
*      CATCH /iwbep/cx_mgw_med_exception.
*        "handle exception
*        EXIT.
*    ENDTRY.
*
*    "add a comment that contains the name of the structure being used as input
*    lv_ddl_source_code_line = |// DDL source code for custom entity for { lv_rfc_input_structure }|.
*    lv_abap_source_code_line = |" ABAP source code for type definition for { lv_rfc_input_structure }|.
*    APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*    APPEND lv_abap_source_code_line TO lt_abap_source_code.
*    "add a comment that contains information when and where the code has been generated
*    lv_ddl_source_code_line = |// generated on: { sy-datum } at: { sy-uzeit } in: { sy-sysid } |.
*    lv_abap_source_code_line = |" generated on: { sy-datum } at: { sy-uzeit } in: { sy-sysid } |.
*    APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*    APPEND lv_abap_source_code_line TO lt_abap_source_code.
*
*    "first line of TYPES statement
*    lv_abap_source_code_line = |TYPES : BEGIN OF ty_{ lv_rfc_input_structure }, | .
*    APPEND lv_abap_source_code_line TO lt_abap_source_code.
*
*    LOOP AT lt_comp_table INTO DATA(ls_comp_table)  .
*
*      "only elements
*      IF ls_comp_table-type->kind <> cl_abap_typedescr=>kind_elem.
*        CONTINUE.
*      ENDIF.
*
*      lo_elem_desc  ?= ls_comp_table-type.
*
*      lo_elem_desc->get_ddic_field(
*          EXPORTING
*              p_langu      = sy-langu
*          RECEIVING
*              p_flddescr   = ls_ddic_fields
*          EXCEPTIONS
*              not_found    = 1
*              no_ddic_type = 2
*              OTHERS       = 3
*              ).
*
*
*      lv_property = to_mixed( val = ls_comp_table-name sep = '_' ).
*      lv_length = ls_ddic_fields-leng.
*      lv_p_length = lv_length DIV 2 + 1.
*      lv_decimals = ls_ddic_fields-decimals.
*
*      "add the ABAP field name of the structure as a comment
*      "lv_ddl_source_code_line = |// { ls_comp_table-name } |.
*      "APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*
*      "first check for the domain name
*      CASE ls_ddic_fields-domname.
*
*        WHEN 'TZNTSTMPL' OR 'TZNTSTMPSL' OR 'TZNTSTMPS' OR 'TIMESTAMP_CHAR'.
*          lv_ddl_source_code_line  = |{ lv_property } : timestampl; | .
*          lv_abap_source_code_line = |{ lv_property } TYPE timestampl , | .
*        WHEN 'TZNTIMELOC'.
*          lv_abap_cds_data_type = 'tims'.
*          lv_abap_ddic_data_type = ls_ddic_fields-domname.
*          lv_ddl_source_code_line = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*          lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*        WHEN OTHERS.
*
*          "if none of the obvious domain names is found check the data type
*          CASE ls_ddic_fields-datatype.
*
*            WHEN 'CHAR'.
*              "if char is used sap.displayformat = uppercase is enforced
*              IF ls_ddic_fields-lowercase = abap_true.
*                lv_abap_cds_data_type = 'sstring'.
*                lv_abap_ddic_data_type = 'c'.
*              ELSE.
*                lv_abap_cds_data_type = 'char'.
*                lv_abap_ddic_data_type = 'c'.
*              ENDIF.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_length }, | .
*            WHEN 'CLNT'.
*              lv_abap_cds_data_type = 'clnt'.
*              lv_abap_ddic_data_type = 'c'.
*              lv_p_length = 3.
*              lv_ddl_source_code_line = |//{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_p_length }, | .
*            WHEN  'CUKY'.
*              lv_ddl_source_code_line = '@Semantics.currencyCode: true'.
*              APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*
*              lv_abap_cds_data_type = 'cuky'.
*              lv_abap_ddic_data_type = 'c'.
*              lv_p_length = 5.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_p_length }, | .
*            WHEN  'CURR'.
*              SELECT SINGLE reffield INTO lv_reffield_abap FROM dd03l WHERE tabname = lv_rfc_input_structure AND fieldname = ls_comp_table-name.
*              IF lv_reffield_abap IS NOT INITIAL.
*                lv_refproperty = to_mixed( val = lv_reffield_abap sep = '_' ).
*              ELSE.
*                lv_refproperty = '<enter property name>'.
*              ENDIF.
*              lv_ddl_source_code_line = |@Semantics.amount.currencyCode: '{ lv_refproperty }' |.
*              APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*
*              lv_abap_cds_data_type = 'curr'.
*              lv_abap_ddic_data_type = 'p'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length }, { lv_decimals } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_p_length } DECIMALS { lv_decimals } , | .
*
*            WHEN  'DATS' .
*              lv_abap_cds_data_type = 'dats'.
*              lv_abap_ddic_data_type = 'dats'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'DEC'.
*              lv_abap_cds_data_type = 'dec'.
*              lv_abap_ddic_data_type = 'p'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length }, { lv_decimals } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_p_length } DECIMALS { lv_decimals } , | .
*            WHEN  'FLTP'.
*              lv_abap_cds_data_type = 'fltp'.
*              lv_abap_ddic_data_type = 'f'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'INT1'.
*              lv_abap_cds_data_type = 'int1'.
*              lv_abap_ddic_data_type = 'int1'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'INT2'.
*              lv_abap_cds_data_type = 'int2'.
*              lv_abap_ddic_data_type = 's'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'INT4'.
*              lv_abap_cds_data_type = 'int4'.
*              lv_abap_ddic_data_type = 'i'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'INT8'.
*              lv_abap_cds_data_type = 'int8'.
*              lv_abap_ddic_data_type = 'int8'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'NUMC'.
*              lv_abap_cds_data_type = 'numc'.
*              lv_abap_ddic_data_type = 'n'.
*              lv_ddl_source_code_line = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_length }, | .
*            WHEN  'QUAN'.
*              SELECT SINGLE reffield INTO lv_reffield_abap FROM dd03l WHERE tabname = lv_rfc_input_structure AND fieldname = ls_comp_table-name.
*              IF lv_reffield_abap IS NOT INITIAL.
*                lv_refproperty = to_mixed( val = lv_reffield_abap sep = '_' ).
*              ELSE.
*                lv_refproperty = '<enter property name>'.
*              ENDIF.
*              lv_ddl_source_code_line = |@Semantics.quantity.unitOfMeasure: '{ lv_refproperty }' |.
*              APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*              lv_abap_cds_data_type = 'quan'.
*              lv_abap_ddic_data_type = 'p'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length }, { lv_decimals } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_p_length } DECIMALS { lv_decimals }, | .
*            WHEN  'STRG'.
*              lv_abap_cds_data_type = 'string'.
*              lv_abap_ddic_data_type = 'string'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'DATS' .
*              lv_abap_cds_data_type = 'dats'.
*              lv_abap_ddic_data_type = 'd'.
*              lv_ddl_source_code_line = |{ lv_property } : timestampl; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN 'TIMS'.
*              lv_abap_cds_data_type = 'tims'.
*              lv_abap_ddic_data_type = 't'.
*              lv_ddl_source_code_line = |{ lv_property } : abap.{ lv_abap_cds_data_type } ; | .
*              lv_abap_source_code_line = |{ lv_property }   TYPE { lv_abap_ddic_data_type } , | .
*            WHEN  'UNIT'.
*              lv_ddl_source_code_line = '@Semantics.unitOfMeasure: true'.
*              APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*              lv_abap_cds_data_type = 'unit'.
*              lv_abap_ddic_data_type = 'c'.
*              lv_ddl_source_code_line  = |{ lv_property } : abap.{ lv_abap_cds_data_type }( { lv_length } ) ; | .
*              lv_abap_source_code_line = |{ lv_property }  TYPE { lv_abap_ddic_data_type } LENGTH { lv_length }, | .
*            WHEN OTHERS.
*              lv_ddl_source_code_line  = |// { ls_comp_table-name } could not be mapped to a standard data element.|.
*              lv_abap_source_code_line = |" { ls_comp_table-name } could not be mapped to a standard data element.|.
*
*          ENDCASE.
*
*      ENDCASE.
*
*      APPEND lv_ddl_source_code_line TO lt_ddl_source_code.
*      APPEND lv_abap_source_code_line TO lt_abap_source_code.
*
*    ENDLOOP.
*
*    "last line of TYPES statement
*    lv_abap_source_code_line = |end OF ty_{ lv_rfc_input_structure }. | .
*    APPEND lv_abap_source_code_line TO lt_abap_source_code.
*
*    out->write( |//######################### DDL source code ################################| ).
*
*    LOOP AT lt_ddl_source_code INTO lv_ddl_source_code_line.
*      out->write( lv_ddl_source_code_line ).
*    ENDLOOP.
*
*    out->write( |"######################### ABAP source code ################################| ).
*
*    LOOP AT lt_abap_source_code INTO lv_abap_source_code_line.
*      out->write( lv_abap_source_code_line ).
*    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
