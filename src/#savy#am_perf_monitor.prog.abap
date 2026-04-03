*&---------------------------------------------------------------------*
*& Report /SAVY/AM_PERF_MONITOR
*& Performance & Memory Monitor for SavyAuth User Access Management
*& Package: /SAVY/AM
*&---------------------------------------------------------------------*
REPORT /savy/am_perf_monitor.

TYPES: BEGIN OF ty_perf_result,
         view_name    TYPE string,
         service_name TYPE string,
         exec_time_ms TYPE p DECIMALS 3,
         memory_kb    TYPE p DECIMALS 2,
         record_count TYPE i,
         status       TYPE string,
         icon         TYPE icon_d,
       END OF ty_perf_result.

DATA: gt_results TYPE TABLE OF ty_perf_result,
      gs_result  TYPE ty_perf_result.

DATA: gv_time_start  TYPE i,
      gv_time_end    TYPE i.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_max TYPE i DEFAULT 1000 OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_uget  AS CHECKBOX DEFAULT 'X',  " SD_USER_GET
              p_udelt AS CHECKBOX DEFAULT 'X',  " SD_USER_GET_DELTA
              p_urole AS CHECKBOX DEFAULT 'X',  " SD_USER_ROLE_GET
              p_rget  AS CHECKBOX DEFAULT 'X',  " SD_ROLE_GET
              p_pget  AS CHECKBOX DEFAULT 'X'.  " SD_PROFILES_GET
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_extra AS CHECKBOX DEFAULT 'X'.  " Non-service views
SELECTION-SCREEN END OF BLOCK b3.

*----------------------------------------------------------------------*
* Main Processing
*----------------------------------------------------------------------*
START-OF-SELECTION.

  WRITE: / 'Starting SavyAuth AM Performance Analysis...'.
  WRITE: / '============================================='.
  SKIP.

* SD_USER_GET — Full User Data (14 views)
  IF p_uget = abap_true.
    PERFORM measure_view USING '/SAVY/I_USER_GET'          'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_ADDRESS'      'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_DEFAULTS'     'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_SNC'          'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_REFERENCE'    'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_GROUPS'       'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_LOGON'        'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_ADMINDATA'    'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_UCLASSYS'     'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_COMPANY'      'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_PROFILES'     'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_ACTROLES'     'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_PARAMETERS'   'SD_USER_GET'.
    PERFORM measure_view USING '/SAVY/I_USER_CHANGE_LOG'   'SD_USER_GET'.
  ENDIF.

* SD_USER_GET_DELTA — Delta/Change Detection (14 views)
  IF p_udelt = abap_true.
    PERFORM measure_view USING '/SAVY/I_USER_GET_DELTA'         'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_CHANGE_AUDITITEM'  'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_ADDRESS_DELTA'     'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_DEFAULTS_DELTA'    'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_SNC_DELTA'         'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_REFERENCE_DELTA'   'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_GROUP_DELTA'       'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_LOGON_DELTA'       'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_ADMINDATA_DELTA'   'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_UCLASSSYS_DELTA'   'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_COMPANY_DELTA'     'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_PROFILES_DELTA'    'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_ROLES_DELTA'       'SD_USER_GET_DELTA'.
    PERFORM measure_view USING '/SAVY/I_USER_PARAMETERS_DELTA'  'SD_USER_GET_DELTA'.
  ENDIF.

* SD_USER_ROLE_GET — User-Role Mapping (1 view)
  IF p_urole = abap_true.
    PERFORM measure_view USING '/SAVY/I_USER_ROLE_GET'  'SD_USER_ROLE_GET'.
  ENDIF.

* SD_ROLE_GET — Role Summary (3 views)
  IF p_rget = abap_true.
    PERFORM measure_view USING '/SAVY/I_ROLE_GET'    'SD_ROLE_GET'.
    PERFORM measure_view USING '/SAVY/I_ROLE_TCODE'  'SD_ROLE_GET'.
    PERFORM measure_view USING '/SAVY/I_ROLE_TEXT'    'SD_ROLE_GET'.
  ENDIF.

* SD_PROFILES_GET — Profile Summary (3 views)
  IF p_pget = abap_true.
    PERFORM measure_view USING '/SAVY/I_PROFILES_GET'   'SD_PROFILES_GET'.
    PERFORM measure_view USING '/SAVY/I_PROFILE_TCODE'  'SD_PROFILES_GET'.
    PERFORM measure_view USING '/SAVY/I_PROFILE_TEXT'    'SD_PROFILES_GET'.
  ENDIF.

* Non-service views (Change Audit, Change Events, Consumption view)
  IF p_extra = abap_true.
    PERFORM measure_view USING '/SAVY/I_USER_CHANGE_AUDIT'   'INTERNAL'.
    PERFORM measure_view USING '/SAVY/I_USER_CHANGE_EVENTS'  'INTERNAL'.
    PERFORM measure_view USING '/SAVY/C_USER_ROLE_GET'       'INTERNAL'.
  ENDIF.

* Display Results
  PERFORM display_alv.

*&---------------------------------------------------------------------*
*& Form MEASURE_VIEW
*& Measures execution time, memory, and record count for a CDS view
*&---------------------------------------------------------------------*
FORM measure_view USING pv_view_name TYPE string
                        pv_service   TYPE string.

  DATA: lv_count   TYPE i,
        lv_status  TYPE string,
        lv_icon    TYPE icon_d.

  DATA: lv_mem_before TYPE abap_msize,
        lv_mem_after  TYPE abap_msize.

  CLEAR gs_result.
  gs_result-view_name    = pv_view_name.
  gs_result-service_name = pv_service.

  TRY.
*     Capture memory before
      cl_abap_memory_utilities=>get_total_used_size(
        IMPORTING size = lv_mem_before ).

*     Capture start time (microseconds)
      GET RUN TIME FIELD gv_time_start.

*     Dynamic SELECT from CDS view with row limit
      SELECT COUNT(*) FROM (pv_view_name) INTO @lv_count
        UP TO @p_max ROWS.

*     Capture end time
      GET RUN TIME FIELD gv_time_end.

*     Capture memory after
      cl_abap_memory_utilities=>get_total_used_size(
        IMPORTING size = lv_mem_after ).

*     Calculate metrics
      gs_result-exec_time_ms = ( gv_time_end - gv_time_start ) / 1000. " microsec to ms
      gs_result-memory_kb    = ( lv_mem_after - lv_mem_before ) / 1024. " bytes to KB
      gs_result-record_count = lv_count.

*     Set status based on execution time thresholds
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
      gs_result-exec_time_ms = 0.
      gs_result-memory_kb    = 0.
      gs_result-record_count = 0.
      gs_result-status       = lx_error->get_text( ).
      gs_result-icon         = icon_red_light.
  ENDTRY.

  APPEND gs_result TO gt_results.

  WRITE: / gs_result-view_name, ':', gs_result-exec_time_ms, 'ms',
           gs_result-record_count, 'records'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*& Display performance results in ALV grid
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

*     Enable ALV functions (sort, filter, export)
      lo_functions = lo_alv->get_functions( ).
      lo_functions->set_all( abap_true ).

*     Display settings
      lo_display = lo_alv->get_display_settings( ).
      lo_display->set_striped_pattern( abap_true ).
      lo_display->set_list_header( 'SavyAuth AM - User Access Management Performance Monitor' ).

*     Column settings
      lo_columns = lo_alv->get_columns( ).
      lo_columns->set_optimize( abap_true ).

*     Status Icon
      TRY.
          lo_column = lo_columns->get_column( 'ICON' ).
          lo_column->set_short_text( 'Status' ).
          lo_column->set_medium_text( 'Status' ).
          lo_column->set_long_text( 'Performance Status' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     View Name
      TRY.
          lo_column = lo_columns->get_column( 'VIEW_NAME' ).
          lo_column->set_short_text( 'CDS View' ).
          lo_column->set_medium_text( 'CDS View Name' ).
          lo_column->set_long_text( 'CDS View Entity Name' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Service Name
      TRY.
          lo_column = lo_columns->get_column( 'SERVICE_NAME' ).
          lo_column->set_short_text( 'Service' ).
          lo_column->set_medium_text( 'OData Service' ).
          lo_column->set_long_text( 'OData Service Name' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Execution Time
      TRY.
          lo_column = lo_columns->get_column( 'EXEC_TIME_MS' ).
          lo_column->set_short_text( 'Time(ms)' ).
          lo_column->set_medium_text( 'Exec Time (ms)' ).
          lo_column->set_long_text( 'Execution Time in Milliseconds' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Memory
      TRY.
          lo_column = lo_columns->get_column( 'MEMORY_KB' ).
          lo_column->set_short_text( 'Mem(KB)' ).
          lo_column->set_medium_text( 'Memory (KB)' ).
          lo_column->set_long_text( 'Memory Consumption in Kilobytes' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Record Count
      TRY.
          lo_column = lo_columns->get_column( 'RECORD_COUNT' ).
          lo_column->set_short_text( 'Records' ).
          lo_column->set_medium_text( 'Record Count' ).
          lo_column->set_long_text( 'Number of Records Retrieved' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Status Text
      TRY.
          lo_column = lo_columns->get_column( 'STATUS' ).
          lo_column->set_short_text( 'Result' ).
          lo_column->set_medium_text( 'Status' ).
          lo_column->set_long_text( 'Performance Status' ).
        CATCH cx_salv_not_found.
      ENDTRY.

*     Sort by execution time descending (slowest first)
      lo_sorts = lo_alv->get_sorts( ).
      TRY.
          lo_sorts->add_sort(
            columnname = 'EXEC_TIME_MS'
            sequence   = if_salv_c_sort=>sort_down ).
        CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
      ENDTRY.

*     Aggregations - show totals
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

*     Display the ALV
      lo_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.
