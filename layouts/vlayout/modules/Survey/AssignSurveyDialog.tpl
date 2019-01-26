<h1>Назначить обзвоны:</h1>
<hr/>
<label>Операторы:</label>
{literal}
<style>
    .select2-container{width:100%}
    #globalmodal{max-width:400px}
</style>
{/literal}
<select class="select2" multiple id="opsSelector" name="operators">
    <option value="10">Юлия Изотова</option>
    <option value="12">Жанна Шевченко</option>
    <option value="32">Наталья Правдюк</option>
    <option value="45">Наталья Григорьева</option>
    <option value="49">Елизавета Емельянова</option>
    <option value="103">Мария Головченко</option>
    <option value="112">Хангома Анварова</option>
    <option value="114">Анна Рубцова</option>
    <option value="116">Екатерина Быкова</option>
</select>
<label>Заказы:</label>
<div id="orders"></div>
<button class="btn btn-info pull-right" id="assign">Ok</button>
<button class="btn btn-warning pull-right" data-dismiss="modal">Cancel</button>
