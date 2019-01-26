<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

class Survey_Main_View extends Vtiger_Index_View {
/*
    public function getHeaderScripts(Vtiger_Request $request)
    {
        $headerScriptInstances = parent::getHeaderScripts($request);
        $jsFileNames = ["modules.Calendar.resources.CalendarView"];
        $jsScriptInstances = $this->checkAndConvertJsScripts($jsFileNames);
        $headerScriptInstances = array_merge($headerScriptInstances, $jsScriptInstances);

        return $headerScriptInstances;
    }
*/
    public function process(Vtiger_Request $request)
    {
        $modName = $request->getModule();
        $currentUserModel = Users_Record_Model::getCurrentUserModel();
        $modSurvey = Vtiger_Module_Model::getInstance($modName);
        $uid = $request->get('uid', false);
        $acl = $modSurvey->checkUser($uid);
        $viewer = $this->getViewer($request);
        switch ($acl){
            case -1: $tpl = 'Index.tpl'; break;
            case  0: 
                $orders = $modSurvey->getLastDelivered();
                //$orders = $modSurvey->getList($uid);
                $viewer->assign([
                    'ORDERS' => $orders,
                    'OPNAME' => $currentUserModel->getDisplayName()
                ]);
                $tpl = 'MainSurvey.tpl';
            break;
            case  1:
                $viewer->assign([
                    'ANSWERS' => ['Нет','Да','-'],
                    'RECORDS' => $modSurvey->getList(),
                    'OPLIST'  => $modSurvey->listOperators()
                ]);
                $tpl = 'Control.tpl';
            break;
        }
        $viewer->view($tpl, $modName);
    }
}
