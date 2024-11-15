CLASS lhc_student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION .

  PRIVATE SECTION .
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR student RESULT result.
    METHODS :

      "set admitted action for status
      set_admitted FOR MODIFY
        IMPORTING keys FOR ACTION student~setAdmitted RESULT result ,

      "set action set_admit disable when admitted
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR student RESULT result,

      "toggel admitted
      toggeladmitted FOR MODIFY
        IMPORTING keys FOR ACTION student~ToggelAdmitted RESULT result ,


      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR student RESULT result,

      "validate age
      validateage FOR VALIDATE ON SAVE
        IMPORTING keys FOR student~validateAge,

      updatecoursedurationmodify FOR DETERMINE ON MODIFY
        IMPORTING keys FOR student~updatecoursedurationmodify ,

      updatecoursedurationsave FOR DETERMINE ON SAVE
        IMPORTING keys FOR student~updateCourseDurationSave ,

      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR student RESULT result ,

      update_is_allow
         RETURNING VALUE(rv_allow) TYPE abap_boolean

      .

ENDCLASS.

CLASS lhc_student IMPLEMENTATION.

  METHOD set_admitted.
    MODIFY ENTITIES OF zi_student_500 IN LOCAL MODE
      ENTITY student
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'X' )    ) .

    READ ENTITIES OF zi_student_500 IN LOCAL MODE
      ENTITY student
      ALL FIELDS WITH VALUE
      #( FOR key IN keys ( %tky = key-%tky ) )
      RESULT DATA(lv_result)  .

    READ TABLE lv_result ASSIGNING FIELD-SYMBOL(<lfs_result>) INDEX 1 .

    IF sy-subrc = 0 .

    ENDIF  .
    result = VALUE #(
      FOR student IN lv_result
      ( %tky = student-%tky %param = student  ) ).
  ENDMETHOD.


  METHOD validateAge.


    READ ENTITIES OF zi_student_500 IN LOCAL MODE
          ENTITY student
          FIELDS ( Age ) WITH CORRESPONDING #( keys )
          RESULT DATA(studentsAge) .
    LOOP AT studentsAge ASSIGNING FIELD-SYMBOL(<lfs_studentAge>) .

      IF <lfs_studentAge>-Age  < 21 .
        APPEND VALUE #( %tky = <lfs_studentage>-%tky ) TO failed-student .

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'error in age '
                               )
                        ) TO reported-student .
      ENDIF  .
    ENDLOOP .
*    reported-student[ 1 ]-%element-age = '04'.
  ENDMETHOD.



  METHOD get_instance_features.
    "get functionality
    "read entity
    READ ENTITIES OF zi_student_500 IN LOCAL MODE
        ENTITY student
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result)
        FAILED failed .

    result = VALUE #(

     FOR lv_result IN lt_result

      LET a  = COND #(  WHEN lv_result-Status = abap_true
                         THEN if_abap_behv=>fc-o-disabled
                        ELSE if_abap_behv=>fc-o-enabled )
                  IN ( %tky = lv_result-%tky
                       %action-setAdmitted = a ) ) .
  ENDMETHOD.

  METHOD ToggelAdmitted.

    READ ENTITIES OF zi_student_500 IN LOCAL MODE
          ENTITY student
          ALL FIELDS WITH VALUE
          #( FOR key IN keys ( %tky = key-%tky ) )
          RESULT DATA(lt_result)  .

    MODIFY ENTITIES OF zi_student_500 IN LOCAL MODE
           ENTITY student
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR wa IN lt_result
                        ( %tky-Id = wa-id
                          Status = COND #( WHEN wa-Status = 'X' THEN ''
                                           WHEN wa-Status = ''  THEN 'X' ) ) ) .

*    READ ENTITIES OF zi_student_500 IN LOCAL MODE
*      ENTITY student
*      ALL FIELDS WITH VALUE
*      #( FOR key IN keys ( %tky = key-%tky ) )
*      RESULT DATA(lt_result1)  .

*   result = VALUE #(
*      FOR student IN lt_result
*      ( %tky = student-%tky
**      %param = CORRESPONDING #( student  MAPPING Status = cond #(  )  )
*      %param-Status  =  cond #( when student-Status = 'X' THEN ''
*                               WHEN student-Status = '' THEN 'X' )  )
    result = VALUE #(
      FOR student IN lt_result
      ( %tky = student-%tky %param = CORRESPONDING #( student  ) ) ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.
*    DATA : update_request_flag TYPE c LENGTH 1  .
*
*    READ ENTITIES OF zi_student_500 IN LOCAL MODE
*        ENTITY student
*        ALL FIELDS WITH VALUE
*        #( FOR key IN keys ( %tky = key-%tky ) )
*        RESULT DATA(lt_result)  .
*    CHECK lt_result IS NOT INITIAL .
*
*    update_request_flag = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
*                                       requested_authorizations-%action-ToggelAdmitted = if_abap_behv=>mk-on
*                                  THEN abap_true ELSE abap_false  ) .
*
*    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_result>) .
*      IF <lfs_result>-Status = '' .
*        IF update_request_flag = abap_true .
*          DATA(update_granted) = update_is_allow( )  .
*          IF update_granted = abap_false  .
*            APPEND VALUE #( %tky = <lfs_result>-%tky ) TO failed-student .
*            APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                            %msg  = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text     = 'No AUTHORIATION to use toggle status!!!!'
*                                    ) ) TO reported-student .
*
*
*
*          ENDIF .
*        ENDIF .
*
*      ENDIF .
*
*
*    ENDLOOP.
  ENDMETHOD.

  METHOD updateCourseDurationModify.
*    READ ENTITIES OF zi_student_500 IN LOCAL MODE
*         ENTITY student
*         FIELDS ( Course  ) WITH CORRESPONDING #( keys  )
*         RESULT DATA(StudentsCourse)  .
*    LOOP AT studentscourse ASSIGNING FIELD-SYMBOL(<lfs_course>) .
*      MODIFY ENTITIES OF zi_student_500 IN LOCAL MODE
*             ENTITY student
*             UPDATE
*             FIELDS ( Courseduration ) WITH VALUE #(
*
*                    ( %tky = <lfs_course>-%tky Courseduration =  40 ) ) .
*    ENDLOOP.
  ENDMETHOD.

  METHOD updateCourseDurationSave.
*
*   "READ ENTITY STUDENT
    READ ENTITIES OF zi_student_500 IN LOCAL MODE
         ENTITY student
         FIELDS ( Course  ) WITH CORRESPONDING #( keys  )
         RESULT DATA(StudentsCourse)  .
    LOOP AT studentscourse ASSIGNING FIELD-SYMBOL(<lfs_course>) .

      IF <lfs_course>-Course = 'C' .
        MODIFY ENTITIES OF zi_student_500 IN LOCAL MODE
             ENTITY student
             UPDATE
             FIELDS ( Courseduration ) WITH VALUE #(
                    ( %tky = <lfs_course>-%tky Courseduration =  2
                      Status = COND #( WHEN <lfs_course>-Status IS NOT INITIAL THEN ''
                                       ELSE 'X'  ) ) ).

      ELSE .
        MODIFY ENTITIES OF zi_student_500 IN LOCAL MODE
             ENTITY student
             UPDATE
             FIELDS ( Courseduration ) WITH VALUE #(
                    ( %tky = <lfs_course>-%tky Courseduration =  60
                    Status = COND #( WHEN <lfs_course>-Status IS NOT INITIAL THEN ''
                                       ELSE 'X'  )  )  ) .
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%update = if_abap_behv=>mk-on
     OR requested_authorizations-%action-ToggelAdmitted = if_abap_behv=>mk-on   .
      result-%update = COND #( WHEN update_is_allow( ) = 'X' THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized )  .
      result-%action-ToggelAdmitted  = COND #( WHEN update_is_allow( ) = 'X' THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized )  .
    ENDIF  .

  ENDMETHOD.

  METHOD update_is_allow.
    "ABAP_TRUE IS ALLOW
    rv_allow = abap_FALSE .
  ENDMETHOD.







ENDCLASS.
