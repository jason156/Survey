<?php

class Survey_Module_Model extends Vtiger_Module_Model {

    public function getDefaultViewName() {
        return 'Main';
    }

    public function getLastDelivered($soNo = false)
    {
        $where = '';
        $limit = 10;
        //subject, sostatus,
        $sqlTpl = "SELECT
            salesorderid,salesorder_no,
            CASE WHEN vcd.firstname = vcd.lastname
            THEN vcd.firstname
            ELSE
            IF(vcd.lastname != '-',concat(vcd.firstname,' ',vcd.lastname), vcd.firstname)
            END fio,
            vcd.mobile,
            cf_706 src, cf_707 brand,
            cf_657 toPerson, vsa.ship_street
            %GOODS%
            FROM vtiger_salesorder vs
            LEFT JOIN vtiger_salesordercf vscf USING (salesorderid)
            LEFT JOIN vtiger_soshipads vsa ON soshipaddressid = salesorderid
            LEFT JOIN vtiger_crmentity vcs ON crmid = salesorderid
            LEFT JOIN vtiger_contactdetails vcd ON vcd.contactid = vs.contactid
            %JOINS%
            WHERE vs.accountid != '861809'
                AND deleted = 0
                AND sostatus = 'Delivered'
            %WHERE%
            ORDER BY salesorderid DESC
            LIMIT %LMT%";
        $db = PearDatabase::getInstance();
        $db->database->SetFetchMode(2); //ADODB_FETCH_ASSOC

        if ($soNo){
            $goodsField = ",subject,group_concat(productname) goods";
            $goods = "LEFT JOIN vtiger_inventoryproductrel ON id = salesorderid
                LEFT JOIN vtiger_products USING (productid)";
            $where = "AND salesorder_no LIKE ? ";
            $sql = str_replace('%GOODS%', $goodsField, $sqlTpl);
            $sql = str_replace('%JOINS%', $goods, $sql);
            $sql = str_replace('%WHERE%', $where, $sql);
            $sql = str_replace('%LMT%', 1, $sql);
        w($sql);
            $result = $db->pquery($sql, ["%{$soNo}%"]);
            $nr = $db->num_rows($result);
            if ($nr > 0) {
                $orderData = $db->fetch_array($result);
                if (strpos($soNo, $orderData['salesorder_no']) > -1){
                    return [$orderData];
                }
            }
            /*
            */
        }

        $sql = str_replace(['%WHERE%','%JOINS%','%GOODS%'], '', $sqlTpl);
        $sql = str_replace('%LMT%', $limit, $sql);
        return $db->database->GetAll($sql);
    }

    /*
     * @return int
     *      -1: usual user
     *       0: survey operator
     *       1: admin user
     */
    public function checkUser($uid = false) 
    {
        if (!$uid){
            global $current_user;
            $uid = $current_user->id;
        }
        $acl = -1;
        $admins = [1,8,53];
        $list = array_map(
            function($x){return $x['id'];},
            $this->listOperators()
        );
        //DEV $list[] = 8; 
        if (in_array($uid, $list)) $acl = 0;
        if (in_array($uid, $admins)) $acl = 1;

        return $acl;
    }

    public function getList($uid = false)
    {
        $where = '';
        $args = [];
        if ($uid){
            $where = ' WHERE assignedid = ? ';
            $args[] = $uid;
        }
        $db = PearDatabase::getInstance();
        $db->database->SetFetchMode(2);
        $sql = "SELECT
            ps.*,
            vs.subject, vs.salesorder_no,
            concat(vu.first_name,' ',vu.last_name) fio
            FROM pin_survey ps
                LEFT JOIN vtiger_salesorder vs USING (salesorderid)
                LEFT JOIN vtiger_users vu ON id = assignedid
            LIMIT 30";
        $surveyResult = $db->pquery($sql, [$args]);
        if ($db->num_rows($surveyResult) == 0) return [];
        $surveys = [];
        while ($row = $db->fetch_array($surveyResult)){
            $surveyData = $row;
            $results = $surveyData['results'];
            if (!(empty($results) || $results == '{}')){
                $decodeJSON = json_decode(html_entity_decode($results),1);
                if (json_last_error() == JSON_ERROR_NONE){
                    $surveyData['data'] = $decodeJSON;
                }
            }
            $surveys[] = $surveyData;
        }

        return $surveys;
    }

    public function listOperators()
    {
        $db = PearDatabase::getInstance();
        $db->database->SetFetchMode(2);
        $sql = "SELECT id, concat(first_name,' ',last_name) fio
            FROM pin_survey_operators
            LEFT JOIN vtiger_users USING (id)";
        $opsResult = $db->query($sql);
        if ($db->num_rows($opsResult) == 0) return [];

        while ($row = $db->fetch_array($opsResult)){
            $opList[] = $row;
        }

        return $opList;
    }
}
