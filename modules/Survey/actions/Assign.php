<?php

class Survey_Assign_Action extends Vtiger_Action_Controller {

    function checkPermission(Vtiger_Request $request)
    {
        return true;
    }

    public function process(Vtiger_Request $request)
    {
        $selectedOps    = $request->get('oplist');
        $selectedOrders = $request->get('orders');

        if (empty($selectedOrders) || empty($selectedOps)){
            $this->emit('Need data');
            return;
        }

        $orderList = array_map(trim, explode(',', $selectedOrders));
        $opCount = count($selectedOps);
        $soCount = count($orderList);
        $collect = [];
        $c = 0;
        foreach ($orderList as $x){
            $collect[$selectedOps[$c]][] = $x;
            $c = ($c >= ($opCount-1))? 0 : $c+1;
        };
        $this->emit($collect);
        
        foreach ($collect as $uid=>$orders){
            $this->addSurvey($uid, $orders);
        }
        return;
        /*
        $chunk = (int)($soCount / $opCount);
        $rest = $soCount % $opCount;
        if ($rest > 0){
            for ($i = 0; $i<$rest; $i++){
                $collect['rest'][] = array_pop($orderList);
            }
        }
        $current = [];
        $c = 0;
        foreach ($orderList as $x){
            $current[] = $x;
            $c++;
            if ($c > $chunk-1){
                $key = array_shift($selectedOps);
                $collect[$key] = $current;
                $c = 0;
                $current = [];
            };
        };
        $surveyMod = Vtiger_Module_Model::getInstance('Survey');
        $records = $surveyMod->getLastDelivered($searchValue);
         */
    }

    private function addSurvey($uid, $orders)
    {
        $db = PearDatabase::getInstance();
        $sql = 'INSERT INTO pin_survey (assignedid, salesorderid, status) VALUES ';
        $recs = [];
        $args = [];
        foreach($orders as $x){
            $recs[] = "(?,?,'Не звонили')";
            $args[] = $uid;
            $args[] = $x;
        }

        $sql .= implode(',',$recs);
        $db->pquery($sql, $args);

        return $db->database->ErrorMsg();
    }

    public function emit($data)
    {
        $res = new Vtiger_Response();
        $res->setResult($data);
        $res->emit();
    }
}
