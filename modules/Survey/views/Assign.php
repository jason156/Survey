
<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

class Survey_Assign_View extends Vtiger_PopupAjax_View {
    
    public function process(Vtiger_Request $request) {
        if (!$request->isAjax()) return;

        $viewer = $this->getViewer($request);
        $moduleName = $request->getModule();
        $viewer->assign('MODULE', $moduleName);
        echo $viewer->view('AssignSurveyDialog.tpl', $moduleName, true);
    }
}

