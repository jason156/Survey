(function(){

function lookup(orderNo)
{
    AppConnector.request({
        module  : 'Survey',
        action  : 'Lookup',
        orderno : orderNo
    }).then(function(a){
        if (!(a.result instanceof Array)
            || (a.result[0].salesorder_no.search(orderNo) == -1)
        ) {
            return Vtiger_Helper_Js.showPnotify({text:'Заказ с таким номером не найден', type:'info'});
        };

        var content = '<h3>Найден:</h3>' + render(a.result[0]);
        var dismiss = '<button class="btn btn-info pull-right" data-dismiss="modal">Ok</button>';
        app.showModalWindow({
            data: content + dismiss,
            css: {'padding':'20px','min-width':'400px','max-width':'600px'},
            classes: 'ext'
        });
    });
}

//Lookup
var tid = false;
$('.locate').on('keyup','#orderno',function(e){
    var searchStr = $('#orderno').val();
    if (e.which != 13
        || (searchStr.length < 4)
        || (searchStr.replace(/\d/g,'') != '')
    ){
        return;
    }
    /*
    if (tid !== false) {
        clearTimeout(tid);
    }
    tid = setTimeout(function(){
    */
        lookup(searchStr);
    //}, 1000);
});

$('.delivered tr').each(function(i,x){
    var $node = $(x);
    $node.on('click', function(){
        lookup($node.data('rid'));
    })
})
//Sub options
$('.step2').on('click','input',function(){
    var $late = $('.step21.toolate');
    var $delay = $('.delay');
    var $done  = $('#done');
    if ( ($delay.find('#a222').is(':checked')
        || $delay.find('#a223').is(':checked')
        || $delay.find('#a224').is(':checked'))
        && !$('#a21').is(':checked')
        && !$('#a221').is(':checked')
    ){
        $late.show();
        $done.data('itms', 5);
    } else {
        $late.hide();
        $('.step21 input').prop('checked', false);
        $done.data('itms', 4);
    }
});

$('#done').on('click',function(){
    if ($('input:checked').length != $('#done').data('itms')) {
        return Vtiger_Helper_Js.showPnotify({text:'Отметьте все опции', type:'info'});
    }
    var ok = parseInt(Math.random()*2);
    //TODO consider critical
    ok = ($('input:checked + .pos').length == 3)
        && ($('input:checked + .neg').length == 0);
    var content = (ok)?$('div.fin.pass').html():$('div.fin.sorrow').html();
    var dismiss = '<button class="btn btn-info pull-right" data-dismiss="modal">Ok</button>';
    AppConnector.request({
        module : 'Survey',
        action : 'Store'
    }).done(function(){
        app.showModalWindow({
            data: content + dismiss,
            css: {'padding':'20px','max-width':'600px','box-shadow': '0 5px 10px #555'},
            overlayCss: {'background':'rgba(255,255,255,.9)'}
        });
    }).fail(function(){
        Vtiger_Helper_Js.showPnotify({
            text:'Попытка пропущена.Следующая - через 2 часа.',
            type:'info'
        });
    })
});

$('#skip').on('click',function(){
    AppConnector.request({
        module : 'Survey',
        action : 'Skip'
    }).then(function(){
        Vtiger_Helper_Js.showPnotify({
            text:'Попытка пропущена.Следующая - через 2 часа.',
            type:'info'
        });
    })
});

$('#ignore').on('click',function(){
    AppConnector.request({
        module : 'Survey',
        action : 'Ignore'
    }).then(function(){
        Vtiger_Helper_Js.showPnotify({
            text:'Опрос помечен как "Пропустить"',
            type:'info'
        });
    })
});

function render(data){
    var lbl = {
        'salesorder_no' : 'Номер',
        'src'           : 'Источник',
        'brand'         : 'Брэнд',
        'subject'       : 'Тема',
        'toperson'      : 'Кому',
        'toPerson'      : 'Кому',
        'ship_street'   : 'Куда',
        'fio'           : 'ФИО',
        'mobile'        : 'Моб.',
        'goods'         : 'Товар'
    };
    var k = Object.keys(data);
    var so = k.shift();
    return '<table class="table ext">'
        + k.map(function(x){
            var value = (x=='salesorder_no')?
                '<a href="index.php?module=SalesOrder&view=Detail&record='
                +data[so]+'">'+data[x]+'</a>' : data[x];
            return (value)?
                '<tr><td>' + lbl[x] + '</td><td>' + value + '</td></tr>'
                :'';
        }).join("\n")
        + '</table>';
}
})()
