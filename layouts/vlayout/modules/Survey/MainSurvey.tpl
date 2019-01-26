{literal}
<style>
    .contentsDiv {padding: 20px; display: flex}
    .contentsDiv div.delivered{max-width: 300px;padding:0}
    div.delivered tr{cursor:pointer}
    table.ext td:nth-child(1){
        min-width: 120px;
        text-align: right;
        font-weight: bold;
    }
    td.Cvetovik,
    td.Fantasy{
        position: relative
    }
    td.Cvetovik:after,
    td.Fantasy:after {
        font: bold 18px/1 sans-serif;
        bottom:0;
        right:0;
        margin: 10px;
        position: absolute;
        opacity: .5;
    }
    td.Cvetovik:after {
        content: "C";
        color: #080;
    }
    td.Fantasy:after {
        content: "F";
        color: #f3c;
    }
    .wrap{
        margin: 0 auto 150px;
        max-width: 800px;
    }
    .wrap > * {margin-bottom: 20px}
    .locate input:focus {
        border-color: #777;
    }
    .locate input {
        margin: 0;
        line-height: 2;
        margin-right: 10px;
        padding: 10px;
        border: 0;
        border-bottom: 3px solid #ddd;
        outline: 0;
        box-shadow: none;
    }
    .locate button {
        line-height: 2.7;
        padding: 0 30px;
    }
    .survey h4 {
        margin: 20px 15px;
        font-style: italic;
        font-weight: normal;
        font-family: serif;
        font-size: 20px;
    }
    ol > li {
        margin-bottom: 30px;
        border-bottom: 1px solid #ddd;
    }
    #warned {display: block}
    .opts {
        display: flex;
        /*align-items: baseline;*/
    }
    div.fin,
    .toolate,
    #other,
    .opts input[type=radio] {
        display: none;
    }
    .opts input:checked + label.pos {
        background: rgba(200,250,220,.8);
    }
    .opts input:checked + label.neg {
        background: rgba(250,150,130,.8);
    }
    .opts input:checked + label.indif {
        background: rgba(200,200,200,.7);
    }
    .opts > label {
        padding: 25px 50px;
        min-width: 150px;
        text-align: center;
        box-sizing: border-box;
        transition: all .3s;
    }
    .opts > label:hover {
        background: rgba(0,0,0,.1);
    }
    .opts label.delay{
        display: flex;
        align-items: baseline;
        padding:0 20px;
    }
    .delay input:checked + label {
        font-weight: bold;
        color: #311;
    }
    .delay label {
        padding: 0 20px;
        color: #888;
        line-height: 5;
        margin: 0;
    }
    .delay label.neg:hover {
        background: rgba(200,100,100,.8);
        color: #fff;
    }
    #other {margin-left: 10px;}
    #a33:checked ~ #other {
        display: block;
    }
    .stars input:checked + .star {
        color: red !important;
        font-weight: bold;
        font-size: 20px;
    }
    .stars .star{
        color: red;
    }
    .stars .star:hover {
        color: black;
    }
    .stars input:checked ~ .star{
        color: grey;
    }
    /*
    .star:before {
        content: "\f005";
        font: normal 20px/1 FontAwesome;
    }
    .stars input:checked + .star:before {
        content: "\f005" !important;
        color: red !important;
    }
    .stars input:checked ~ .star:before{
        content: "\f006";
    }
    */
    #submit-ctls{
        position: fixed;
        bottom: 0;
        right: 0;
        margin: 30px;
        box-shadow: 0 5px 7px #444;
        display: flex;
    }
    #submit-ctls .btn{
        padding: 20px 30px;
    }
</style>
{/literal}
{strip}
<div class="delivered">
    <h4>Список обзвона:</h4>
    <div class="locate">
        <input id="orderno" placeholder="Поиск по номеру Заказа"/>
    </div>
    {*
                <th>Источник</th>
                <td>{$ORDER['src']}</td>
        <table class="table">
            <tr>
                <th>Номер</th>
                <th>ФИО</th>
                <th>Мобильный</th>
                <th>Брэнд</th>
                <th>Куда</th>
                <th>Кому</th>
            </tr>
        {foreach item=ORDER from=$ORDERS}
            <tr>
                <td>{$ORDER['salesorder_no']}</td>
                <td>{$ORDER['fio']}</td>
                <td>{$ORDER['mobile']}</td>
                <td>{$ORDER['brand']}</td>
                <td>{$ORDER['ship_street']}</td>
                <td>{$ORDER['toPerson']}</td>
            </tr>
        {/foreach}
        </table>
    *}
    <table class="table">
        <tr>
            <th>Номер</th>
            <th>Заказ</th>
        </tr>
    {foreach item=ORDER from=$ORDERS}
        <tr data-rid="{$ORDER['salesorder_no']}">
            <td>
                <a href="index.php?module=SalesOrder&view=Detail&record={$ORDER['salesorderid']}">
                    {$ORDER['salesorder_no']}
                </a>
            </td>
            <td class="{$ORDER['brand']}">
                <div>{$ORDER['ship_street']}</div>
                <span>{$ORDER['mobile']}</span>
                {$ORDER['sostatus']}
            </td>
        </tr>
    {/foreach}
    </table>
</div>
<div class="wrap">
<h3>Опрос по доставленным Заказам</h3>
<div class="survey">
    <p class="disclaimer">
    {$FIO    = $ORDERS[0]['fio']}
    {$BRAND  = $ORDERS[0]['brand']}
    Добрый день, {$FIO}, компания {$BRAND}, меня зовут {$OPNAME}.<br/>
    Недавно Вы делали у нас заказ цветов, удобно ли Вам будет ответить на несколько вопросов по качеству обслуживания?<br/>
    Это займет 2 минуты Вашего времени.
    </p>
    <ol>
        <li class="step1">
            <h4>Устроило ли Вас обслуживание оператором при оформлении заказа?</h4>
            <div class="opts">
                <input type="radio" id="a11" name="happy"/>
                <label for="a11" class="pos">Да</label>
                <input type="radio" id="a12" name="happy"/>
                <label for="a12" class="neg">Нет</label>
                <input type="radio" id="a13" name="happy"/>
                <label for="a13" class="indif">Не общались</label>
            </div>
        </li>
        <li class="step2">
            <h4>Доставка состоялась в выбранный Вами при оформлении интервал?</h4>
            {*
            <select id="warned" name="warned">
                <option value="0">Да</option>
                <option value="1">Опоздание до 10 минут</option>
                <option value="2">Опоздание 10-30 минут</option>
                <option value="3">Опоздание более 30 минут</option>
                <option value="4">Опоздание более часа</option>
            </select>
            *}
            <div class="opts">
                <input type="radio" id="a21" name="late"/>
                <label for="a21" class="pos">Да</label>
                <label for="a22" class="delay">Опоздание:
                    <input type="radio" id="a221" name="late"/>
                    <label for="a221" class="neg">до 10 минут</label>
                    <input type="radio" id="a222" name="late"/>
                    <label for="a222" class="neg">10-30 минут</label>
                    <input type="radio" id="a223" name="late"/>
                    <label for="a223" class="neg critical">более 30 минут</label>
                    <input type="radio" id="a224" name="late"/>
                    <label for="a224" class="neg critical">более часа</label>
                </label>
            </div>
            <div class="step21 toolate">
                <h4>Предупредили ли Вас об опоздании?</h4>
                <div class="opts">
                    <input type="radio" id="a231" name="warn"/>
                    <label for="a231" class="pos">Да</label>
                    <input type="radio" id="a232" name="warn"/>
                    <label for="a232" class="neg">Нет</label>
                    <input type="radio" id="a233" name="warn"/>
                    <label for="a233" class="indif">Не помню</label>
                </div>
            </div>
        </li>
        <li class="step3">
            <h4>Устроило ли Вас качество цветов и оформление?</h4>
            <div class="opts">
                <input type="radio" id="a31" name="quality"/>
                <label for="a31" class="pos">Да</label>
                <input type="radio" id="a32" name="quality"/>
                <label for="a32" class="neg">Нет</label>
                <input type="radio" id="a33" name="quality"/>
                <label for="a33" class="indif">Иное</label>
                <div id="other">
                    <span>Укажите причину:</span>
                    <textarea></textarea>
                </div>
            </div>
        </li>
        <li class="step4">
            <h4>Насколько вероятно, что Вы порекомендуете нашу компанию друзьям\знакомым?</h4>
            Оцените от 1 до 5. где 1 - это точно не порекомендую, 5 - порекомендую.
            <div class="opts stars">
                <input type="radio" name="rate" id="s1" value="1"/>
                <label class="star" for="s1">1</label>
                <input type="radio" name="rate" id="s2" value="2"/>
                <label class="star" for="s2">2</label>
                <input type="radio" name="rate" id="s3" value="3"/>
                <label class="star" for="s3">3</label>
                <input type="radio" name="rate" id="s4" value="4"/>
                <label class="star" for="s4">4</label>
                <input type="radio" name="rate" id="s5" value="5"/>
                <label class="star" for="s5">5</label>
            </div>
        </li>
    </ol>
</div>
</div>
<div id="submit-ctls">
    <button id="ignore" class="btn btn-danger">Не звонить</button>
    <button id="skip" class="btn btn-warning">Пропустить</button>
    <button id="done" class="btn btn-info">Завершить!</button>
</div>
<div class="fin pass">
    <h4>Благодарим Вас за участие в опросе!</h4>
    Обратите внимание, что в нашем магазине проходит акция - За каждый опубликованный отзыв на площадке Яндекс Маркет, предоставляется скидка на следующую покупку.<br/>
    Будем рады Вашим новым заказам!
    <hr/>
</div>
<div class="fin sorrow">
    <h4>Приносим Вам извинения за доставленные неудобства.</h4>
    Я обязательно передам Ваше обращение специалисту для проведения проверки.</br>
    Ожидайте, пожалуйста, звонка от нашего менеджера.
    <hr/>
</div>
{/strip}
<script src="/layouts/vlayout/modules/Survey/js/Survey.js"></script>
{*
*}
