CLASS zcl_caculate_sonnc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_caculate_sonnc IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA : lt_caculate TYPE STANDARD TABLE OF zc_student_500_sonnc .
    lt_caculate =  CORRESPONDING #( it_original_data ) .

    LOOP AT lt_caculate ASSIGNING FIELD-SYMBOL(<lfs_caculate>) .
      CASE <lfs_caculate>-Course .
        WHEN 'E' .
          <lfs_caculate>-BonusAmount = 100 .
        WHEN OTHERS .
          <lfs_caculate>-BonusAmount = 1000 .
      ENDCASE.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_caculate ) .
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    DATA : lv_a TYPE i .
    lv_a = 1 .
    "  it_requested_calc_elements
    "  iv_entity
    "  et_requested_orig_elements

  ENDMETHOD.

ENDCLASS.
