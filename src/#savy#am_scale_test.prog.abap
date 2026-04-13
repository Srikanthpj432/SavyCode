*&---------------------------------------------------------------------*
*& Report /SAVY/AM_SCALE_TEST
*& Scalability & Sizing Test for User Access Management
*& Package: /SAVY/AM
*&
*& Mode A: Volume scalability - measures CDS views at increasing
*&         row counts (1K, 5K, 10K, 50K, 100K)
*& Mode B: Role complexity scaling - measures role-related views
*&         with varying role density (roles x entries per role)
*&
*& Uses SELECT * into RTTS dynamic table for accurate memory measurement
*& Metrics: time (ms), memory (KB), ms/1K rec, KB/1K rec, rec/sec
*&---------------------------------------------------------------------*
REPORT /savy/am_scale_test.

TYPES: BEGIN OF ty_scale_result,
         icon            TYPE icon_d,
         view_name       TYPE string,
         service_name    TYPE string,
         tier_label      TYPE string,
         requested_rows  TYPE i,
         record_count    TYPE i,
         exec_time_ms    TYPE p DECIMALS 3,
         memory_kb       TYPE p DECIMALS 2,
         ms_per_1k_rec   TYPE p DECIMALS 3,
         kb_per_1k_rec   TYPE p DECIMALS 2,
         records_per_sec TYPE p DECIMALS 0,
         status          TYPE string,
       END OF ty_scale_result.

DATA: gt_results    TYPE TABLE OF ty_scale_result,
      gs_result     TYPE ty_scale_result,
      gv_time_start TYPE i,
      gv_time_end   TYPE i.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_mode_a RADIOBUTTON GROUP mode DEFAULT 'X',
              p_mode_b RADIOBUTTON GROUP mode.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_t1 TYPE i DEFAULT 1000,
              p_t2 TYPE i DEFAULT 5000,
              p_t3 TYPE i DEFAULT 10000,
              p_t4 TYPE i DEFAULT 50000,
              p_t5 TYPE i DEFAULT 100000.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_busers TYPE i DEFAULT 10000,
              p_r1     TYPE i DEFAULT 5,
              p_r2     TYPE i DEFAULT 10,
              p_r3     TYPE i DEFAULT 50,
              p_r4     TYPE i DEFAULT 100,
              p_r5     TYPE i DEFAULT 500,
              p_r6     TYPE i DEFAULT 1000.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.
  PARAMETERS: p_uget  AS CHECKBOX DEFAULT 'X',
              p_udelt AS CHECKBOX DEFAULT 'X',
              p_urole AS CHECKBOX DEFAULT 'X',
              p_rget  AS CHECKBOX DEFAULT 'X',
              p_pget  AS CHECKBOX DEFAULT 'X',
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-005.
  PARAMETERS: p_maxr TYPE i DEFAULT 500000.
SELECTION-SCREEN END OF BLOCK b5.

*----------------------------------------------------------------------*
* Main Processing
*----------------------------------------------------------------------*
START-OF-SELECTION.

  IF p_mode_a = abap_true.
    WRITE: / 'Mode A: Volume Scalability Test (/SAVY/AM)'.
    WRITE: / '============================================='.
    PERFORM run_volume_test.

  DATA: lt_tiers TYPE TABLE OF i,
        lv_tier  TYPE i,
        lv_label TYPE string.

  IF p_t1 > 0. APPEND p_t1 TO lt_tiers. ENDIF.
  IF p_t2 > 0. APPEND p_t2 TO lt_tiers. ENDIF.
  IF p_t3 > 0. APPEND p_t3 TO lt_tiers. ENDIF.
  IF p_t4 > 0. APPEND p_t4 TO lt_tiers. ENDIF.
  IF p_t5 > 0. APPEND p_t5 TO lt_tiers. ENDIF.

  LOOP AT lt_tiers INTO lv_tier.
    IF lv_tier >= 1000.
      lv_label = |{ lv_tier / 1000 }K Users|.
    ELSE.
      lv_label = |{ lv_tier } Users|.
    ENDIF.

    SKIP.
    WRITE: / '--- Tier:', lv_label, '---'.

*   SD_USER_GET (14 views)
    IF p_uget = abap_true.
      PERFORM measure USING '/SAVY/I_USER_GET'         'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ADDRESS'     'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_DEFAULTS'    'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_SNC'         'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_REFERENCE'   'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_GROUPS'      'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_LOGON'       'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ADMINDATA'   'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_UCLASSYS'    'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_COMPANY'     'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_PROFILES'    'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ACTROLES'    'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_PARAMETERS'  'SD_USER_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_CHANGE_LOG'  'SD_USER_GET' lv_tier lv_label.
    ENDIF.

*   SD_USER_GET_DELTA (14 views)
    IF p_udelt = abap_true.
      PERFORM measure USING '/SAVY/I_USER_GET_DELTA'         'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_CHANGE_AUDITITEM'  'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ADDRESS_DELTA'     'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_DEFAULTS_DELTA'    'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_SNC_DELTA'         'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_REFERENCE_DELTA'   'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_GROUP_DELTA'       'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_LOGON_DELTA'       'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ADMINDATA_DELTA'   'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_UCLASSSYS_DELTA'   'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_COMPANY_DELTA'     'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_PROFILES_DELTA'    'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_ROLES_DELTA'       'SD_USER_GET_DELTA' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_USER_PARAMETERS_DELTA'  'SD_USER_GET_DELTA' lv_tier lv_label.
    ENDIF.

*   SD_USER_ROLE_GET (1 view)
    IF p_urole = abap_true.
      PERFORM measure USING '/SAVY/I_USER_ROLE_GET' 'SD_USER_ROLE_GET' lv_tier lv_label.
    ENDIF.

*   SD_ROLE_GET (3 views)
    IF p_rget = abap_true.
      PERFORM measure USING '/SAVY/I_ROLE_GET'   'SD_ROLE_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_ROLE_TCODE' 'SD_ROLE_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_ROLE_TEXT'   'SD_ROLE_GET' lv_tier lv_label.
    ENDIF.

*   SD_PROFILES_GET (3 views)
    IF p_pget = abap_true.
      PERFORM measure USING '/SAVY/I_PROFILES_GET'  'SD_PROFILES_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_PROFILE_TCODE' 'SD_PROFILES_GET' lv_tier lv_label.
      PERFORM measure USING '/SAVY/I_PROFILE_TEXT'   'SD_PROFILES_GET' lv_tier lv_label.
    ENDIF.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form RUN_ROLE_SCALE_TEST
*& Mode B: Test role-related views with increasing complexity
*& Simulates: N roles x M entries per role = total expected rows
*& Tests views that scale with role assignments and auth objects
*&---------------------------------------------------------------------*
FORM run_role_scale_test.

  DATA: lt_roles TYPE TABLE OF i,
        lv_roles TYPE i,
        lv_rows  TYPE i,
        lv_label TYPE string.

  IF p_r1 > 0. APPEND p_r1 TO lt_roles. ENDIF.
  IF p_r2 > 0. APPEND p_r2 TO lt_roles. ENDIF.
  IF p_r3 > 0. APPEND p_r3 TO lt_roles. ENDIF.
  IF p_r4 > 0. APPEND p_r4 TO lt_roles. ENDIF.
  IF p_r5 > 0. APPEND p_r5 TO lt_roles. ENDIF.
  IF p_r6 > 0. APPEND p_r6 TO lt_roles. ENDIF.

  LOOP AT lt_roles INTO lv_roles.
    lv_rows  = p_busers * lv_roles.
    lv_label = |{ lv_roles } Roles x { p_busers } Users|.

    SKIP.
    WRITE: / '--- Tier:', lv_label, '(', lv_rows, 'expected rows ) ---'.

*   Role/profile assignment views that scale with role count per user
    PERFORM measure USING '/SAVY/I_USER_ACTROLES'      'SD_USER_GET'       lv_rows lv_label.
    PERFORM measure USING '/SAVY/I_USER_ROLE_GET'       'SD_USER_ROLE_GET'  lv_rows lv_label.
    PERFORM measure USING '/SAVY/I_USER_ROLES_DELTA'    'SD_USER_GET_DELTA' lv_rows lv_label.
    PERFORM measure USING '/SAVY/I_USER_PROFILES'       'SD_USER_GET'       lv_rows lv_label.
    PERFORM measure USING '/SAVY/I_USER_PROFILES_DELTA' 'SD_USER_GET_DELTA' lv_rows lv_label.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form MEASURE
*& Core measurement: SELECT * into RTTS dynamic table
*& Captures: elapsed time, heap memory delta, record count
*& Calculates: per-1K metrics and throughput for sizing extrapolation
*&---------------------------------------------------------------------*
FORM measure USING pv_view    TYPE string
                   pv_service TYPE string
                   pv_rows    TYPE i
                   pv_label   TYPE string.

  DATA: lv_mem_before TYPE abap_msize,
        lv_mem_after  TYPE abap_msize,
        lv_max_rows   TYPE i,
        lr_data       TYPE REF TO data.

  FIELD-SYMBOLS: <lt_data> TYPE STANDARD TABLE.

  CLEAR gs_result.
  gs_result-view_name      = pv_view.
  gs_result-service_name   = pv_service.
  gs_result-tier_label     = pv_label.
  gs_result-requested_rows = pv_rows.

* Safety check
  IF pv_rows > p_maxr.
    gs_result-status = |SKIPPED (> { p_maxr } max)|.
    gs_result-icon   = icon_led_inactive.
    APPEND gs_result TO gt_results.
    WRITE: / pv_view, ': SKIPPED -', pv_rows, '>', p_maxr.
    RETURN.
  ENDIF.

  lv_max_rows = pv_rows.

  TRY.
*     Create dynamic internal table via RTTS
      DATA(lo_struct) = CAST cl_abap_structdescr(
        cl_abap_typedescr=>describe_by_name( pv_view ) ).
      DATA(lo_table) = cl_abap_tabledescr=>create( lo_struct ).
      CREATE DATA lr_data TYPE HANDLE lo_table.
      ASSIGN lr_data->* TO <lt_data>.

*     Garbage collection for clean baseline
      cl_abap_memory_utilities=>do_garbage_collection( ).

*     Memory before
      cl_abap_memory_utilities=>get_total_used_size(
        IMPORTING size = lv_mem_before ).

*     Time start (microseconds)
      GET RUN TIME FIELD gv_time_start.

*     SELECT * for real data transfer + memory measurement
      SELECT * FROM (pv_view) INTO TABLE <lt_data>
        UP TO lv_max_rows ROWS.

*     Time end
      GET RUN TIME FIELD gv_time_end.

*     Memory after
      cl_abap_memory_utilities=>get_total_used_size(
        IMPORTING size = lv_mem_after ).

*     Base metrics
      gs_result-record_count = lines( <lt_data> ).
      gs_result-exec_time_ms = ( gv_time_end - gv_time_start ) / 1000.
      gs_result-memory_kb    = ( lv_mem_after - lv_mem_before ) / 1024.
      IF gs_result-memory_kb < 0.
        gs_result-memory_kb = 0.
      ENDIF.

*     Free table immediately
      FREE <lt_data>.

*     Per-1K record metrics (for sizing)
      IF gs_result-record_count > 0.
        gs_result-ms_per_1k_rec = gs_result-exec_time_ms
          / gs_result-record_count * 1000.
        gs_result-kb_per_1k_rec = gs_result-memory_kb
          / gs_result-record_count * 1000.
      ENDIF.

*     Throughput
      IF gs_result-exec_time_ms > 0.
        gs_result-records_per_sec = gs_result-record_count
          / ( gs_result-exec_time_ms / 1000 ).
      ENDIF.

*     Status thresholds
      IF gs_result-exec_time_ms < 500.
        gs_result-status = 'GOOD'.
        gs_result-icon   = icon_green_light.
      ELSEIF gs_result-exec_time_ms < 2000.
        gs_result-status = 'WARNING'.
        gs_result-icon   = icon_yellow_light.
      ELSE.
        gs_result-status = 'CRITICAL'.
        gs_result-icon   = icon_red_light.
      ENDIF.

    CATCH cx_root INTO DATA(lx_error).
      gs_result-exec_time_ms  = 0.
      gs_result-memory_kb     = 0.
      gs_result-record_count  = 0.
      gs_result-status        = lx_error->get_text( ).
      gs_result-icon          = icon_red_light.
  ENDTRY.

  APPEND gs_result TO gt_results.

  WRITE: / pv_view, '(', pv_label, '):',
           gs_result-exec_time_ms, 'ms |',
           gs_result-memory_kb, 'KB |',
           gs_result-record_count, 'rec |',
           gs_result-records_per_sec, 'rec/s'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM display_alv.

  DATA: lo_alv       TYPE REF TO cl_salv_table,
        lo_columns   TYPE REF TO cl_salv_columns_table,
        lo_column    TYPE REF TO cl_salv_column,
        lo_functions TYPE REF TO cl_salv_functions_list,
        lo_display   TYPE REF TO cl_salv_display_settings,
        lo_sorts     TYPE REF TO cl_salv_sorts,
        lo_agg       TYPE REF TO cl_salv_aggregations.

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_results ).

      lo_functions = lo_alv->get_functions( ).
      lo_functions->set_all( abap_true ).

      lo_display = lo_alv->get_display_settings( ).
      lo_display->set_striped_pattern( abap_true ).
      IF p_mode_a = abap_true.
        lo_display->set_list_header( 'AM Scalability - Mode A: Volume by User Count' ).
      ELSE.
        lo_display->set_list_header( |AM Scalability - Mode B: Role Density ({ p_busers } Roles)| ).
      ENDIF.

      lo_columns = lo_alv->get_columns( ).
      lo_columns->set_optimize( abap_true ).

      TRY.
          lo_column = lo_columns->get_column( 'ICON' ).
          lo_column->set_short_text( 'Status' ).
          lo_column->set_medium_text( 'Status' ).
          lo_column->set_long_text( 'Performance Status' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'VIEW_NAME' ).
          lo_column->set_short_text( 'CDS View' ).
          lo_column->set_medium_text( 'CDS View Name' ).
          lo_column->set_long_text( 'CDS View Entity Name' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'SERVICE_NAME' ).
          lo_column->set_short_text( 'Service' ).
          lo_column->set_medium_text( 'OData Service' ).
          lo_column->set_long_text( 'OData Service Name' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'TIER_LABEL' ).
          lo_column->set_short_text( 'Tier' ).
          lo_column->set_medium_text( 'Test Tier' ).
          lo_column->set_long_text( 'Scalability Test Tier' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'REQUESTED_ROWS' ).
          lo_column->set_short_text( 'Requested' ).
          lo_column->set_medium_text( 'Requested Rows' ).
          lo_column->set_long_text( 'Number of Rows Requested' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'RECORD_COUNT' ).
          lo_column->set_short_text( 'Actual' ).
          lo_column->set_medium_text( 'Actual Records' ).
          lo_column->set_long_text( 'Actual Records Retrieved' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'EXEC_TIME_MS' ).
          lo_column->set_short_text( 'Time(ms)' ).
          lo_column->set_medium_text( 'Exec Time (ms)' ).
          lo_column->set_long_text( 'Execution Time in Milliseconds' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'MEMORY_KB' ).
          lo_column->set_short_text( 'Mem(KB)' ).
          lo_column->set_medium_text( 'Memory (KB)' ).
          lo_column->set_long_text( 'Heap Memory in Kilobytes' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'MS_PER_1K_REC' ).
          lo_column->set_short_text( 'ms/1K' ).
          lo_column->set_medium_text( 'ms per 1K Rec' ).
          lo_column->set_long_text( 'Milliseconds per 1000 Records (Sizing)' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'KB_PER_1K_REC' ).
          lo_column->set_short_text( 'KB/1K' ).
          lo_column->set_medium_text( 'KB per 1K Rec' ).
          lo_column->set_long_text( 'Kilobytes per 1000 Records (Sizing)' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'RECORDS_PER_SEC' ).
          lo_column->set_short_text( 'Rec/sec' ).
          lo_column->set_medium_text( 'Records/sec' ).
          lo_column->set_long_text( 'Throughput - Records per Second' ).
        CATCH cx_salv_not_found.
      ENDTRY.

      TRY.
          lo_column = lo_columns->get_column( 'STATUS' ).
          lo_column->set_short_text( 'Result' ).
          lo_column->set_medium_text( 'Status' ).
          lo_column->set_long_text( 'Performance Status' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Sort: view name then tier ascending (scalability curve)
      lo_sorts = lo_alv->get_sorts( ).
      TRY.
          lo_sorts->add_sort(
            columnname = 'VIEW_NAME'
            sequence   = if_salv_c_sort=>sort_up
            subtotal   = abap_true ).
          lo_sorts->add_sort(
            columnname = 'REQUESTED_ROWS'
            sequence   = if_salv_c_sort=>sort_up ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      lo_agg = lo_alv->get_aggregations( ).
      TRY.
          lo_agg->add_aggregation(
            columnname  = 'EXEC_TIME_MS'
            aggregation = if_salv_c_aggregation=>total ).
          lo_agg->add_aggregation(
            columnname  = 'MEMORY_KB'
            aggregation = if_salv_c_aggregation=>total ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

      lo_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.
