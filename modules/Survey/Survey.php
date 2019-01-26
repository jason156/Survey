<?php
/*+**********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 ************************************************************************************/
require_once('data/CRMEntity.php');
require_once('data/Tracker.php');
include_once('vtlib/Vtiger/Event.php');

class Survey extends CRMEntity {

    public $tableName = 'pin_survey';
    public $tableIndex = 'surveyid';

    var $tab_name = [
        'vtiger_crmentity',
        'pin_survey'
    ];

    var $tab_name_index = [
        'vtiger_crmentity'  => 'crmid',
        'pin_survey'   => 'surveyid'
    ];
    var $list_fields = [
        'LBL_ASSIGNED'  => ['survey', 'assignedid'],
        'LBL_ORDER'     => ['survey', 'surveyid'],
        'LBL_STATUS'    => ['survey', 'surveystatus'],
        'LBL_RESULTS'   => ['survey', 'results'],
        'LBL_OWNER'     => ['crmentity','smownerid']
    ];

    var $list_fields_name = [
        'LBL_ASSIGNED'  => 'assignedid',
        'LBL_ORDER'     => 'surveyid',
        'LBL_STATUS'    => 'surveystatus',
        'LBL_RESULTS'   => 'results',
        'LBL_OWNER'     => 'smownerid'
    ];

    var $list_link_field = 'surveyid';
    var $search_fields = [];
    var $search_fields_name = [];

    var $popup_fields = ['salesorderid', 'surveystatus'];

    var $mandatory_fields = ['salesorderid', 'assignedid'];

    var $default_order_by = 'surveyid';
    var $default_sort_order='ASC';
/*
 */
    function Survey() {
        $this->db  = PearDatabase::getInstance();
        $this->column_fields = getColumnFields($this->modName);
    }

	/**
	* Invoked when special actions are performed on the module.
	* @param String Module name
	* @param String Event Type
	*/
	function vtlib_handler($moduleName, $eventType) {
 		if($eventType == 'module.postinstall') {
		} else if($eventType == 'module.enabled') {
		} else if($eventType == 'module.disabled') {
		} else if($eventType == 'module.preuninstall') {
		} else if($eventType == 'module.preupdate') {
		} else if($eventType == 'module.postupdate') {
		}
 	}
}
