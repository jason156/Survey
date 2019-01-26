<style>
{literal}
.contentsDiv{box-sizing:border-box;padding:25px;}
.surveys th{text-align: center; vertical-align:middle}
#settings {position:absolute;top:0;right:0; margin: 30px}
{/literal}
</style>

<h1>Control Room 1</h1>
<div id="settings">Настройки <i class="fa fa-gear"></i></div>
<h1>Список опросов</h1>
<table class="table surveys">
    <tr>
        <th>Ответственный</th>
        <th>Попытка</th>
        <th>Статус</th>
        <th>Результаты<br>
            <table>
                <tr>
                    <td>№1</td>
                    <td>№2</td>
                    <td>№3</td>
                    <td>Оценка</td>
                </tr>
            </table>
        </th>
        <th>№</th>
        <th style="width: 350px;">Тема</th>
    </tr>
    {foreach item=SURVEY from=$RECORDS}
    <tr>
        <td>{$SURVEY['fio']}</td>
        <td>{$SURVEY['attempt']}</td>
        <td>{$SURVEY['status']}</td>
        <td>
        {$SURVEY['err']}
        {if array_key_exists('data', $SURVEY)}
        <table>
            <tr>
            {foreach key=K item=V from=$SURVEY['data']}
                {if $K neq 'q4'}
                    <td>{$ANSWERS[(int)$V]}<td>
                {else}
                    <td>{$V}<td>
                {/if}
            {/foreach}
            </tr>
        </table>
        {else}
            {$SURVEY['results']}
        {/if}
        </td>
        <td>{$SURVEY['salesorder_no']}</td>
        <td>{$SURVEY['subject']}</td>
    </tr>
    {/foreach}
</table>
