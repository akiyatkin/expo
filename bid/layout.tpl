{root:}
	<ol class="breadcrumb">
		<li><a href="/">Главная</a></li>
		<li><a href="/{config.crumb}">{config.title}</a></li>
		<li class="active">Заявка</li>
	</ol>
	<div class="bid">
		<span class="clear pull-right btn btn-default">Очистить</span>
		<h1>Заявка на {config.title}</h1>
		{config.ans.result?:ready?:showform}
	</div>
{ready:}<h3>Благодарим за заказ!</h3>
	<a class="a" href="/form" onclick="delete Controller.ids[{id}].config.ans">Корректировать заявку</a><br>
	{config.ans:ans.msg}
	<script>
		domready( function () {
			if (window.Ya && Ya._metrika.counter) {
				var ya = Ya._metrika.counter;
				ya.reachGoal('expo');
			}
			if (window.ga) {
				ga('send', 'event', 'Оформить заявку', 'Отправить');//depricated
				ga('send', 'event', 'expo');
			}
		});
	</script>
{ans::}-ans/ans.tpl
{tabs:}
	<li role="presentation" class="{~first()?:active}"><a href="#tab{id}" data-crumb="false" aria-controls="tab{id}" role="tab" data-toggle="tab">{title}</a></li>
{tabscontent:}
	<div role="tabpanel" class="tab-pane fade {~first()?:active in}" id="tab{id}">
		<h3>{title}</h3>
		{data::position}
	</div>
{showform:}
	<style>
		.bid label .red {
			color:red;
		}
		.bid .select {
			font-weight: bold;
		}
	</style>
	<form class="container-fluid form-horizontal" action="/-expo/bid/submit.php" method="POST">
		<input name="json" type="hidden" value="{json}">
		<div class="form-group">
			<label for="inputName{id}" class="col-sm-5 control-label">ФИО{:ast}</label>
			<div class="col-sm-7">
				<input name="name" type="text" class="form-control" id="inputName{id}" placeholder="Иван Иванович Иванов">
			</div>
		</div>
		<div class="form-group">
			<label for="input_email{id}" class="col-sm-5 control-label">Email{:ast}</label>
			<div class="col-sm-7">
				<input name="email" type="email" class="form-control" id="input_email{id}" placeholder="i.ivanov@mail.ru">
			</div>
		</div>
		<div class="form-group">
			<label for="input_phone_mobile{id}" class="col-sm-5 control-label">Мобильный телефон{:ast}</label>
			<div class="col-sm-7">
				<input name="phone_mobile" type="tel" class="form-control" id="input_phone_mobile{id}" placeholder="+71234567890">
			</div>
		</div>
		<div class="form-group">
			<label for="input_phone_town{id}" class="col-sm-5 control-label">Городской телефон</label>
			<div class="col-sm-7">
				<input name="phone_town" type="tel" class="form-control" id="input_phone_town{id}" placeholder="+7 1234 56-78-90">
			</div>
		</div>
		<!--<div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
				<div class="checkbox">
					<label>
						<input type="checkbox"> Remember me
					</label>
				</div>
			</div>
		</div>-->
		<h2>Спецификация <div class="btn-group" data-toggle="buttons">
				<label class="btn btn-default">
					<input type="radio" name="cost" value="Опт">ОПТОВАЯ
				</label>
				<label class="btn btn-default">
					<input type="radio" name="cost" value="Цена" checked>РОЗНИЦА
				</label>
				<label class="btn btn-default">
					<input type="radio" name="cost" value="Акция">АКЦИЯ
				</label>
			</div> <b class="all_sum">0</b>&nbsp;руб.</h2>
		<div class="well">
			{data.param.descr}
		</div>
		
		<div class="specification">
			<style scoped>
				.specification .control-label {
					text-align:left;
				}
				.specification .spec-name {
					text-align:right;
				}
			</style>
			<!-- Nav tabs -->

			<ul class="nav nav-tabs" role="tablist">
				{data.list::tabs}
			</ul>

			<!-- Tab panes -->
			<div class="tab-content">
				{data.list::tabscontent}
			</div>
			
			<div class="form-group text-right" style="font-size:150%; padding-top:5px; padding-bottom:5px;">
				<div>Итого <span style="font-size:180%"><b class="all_sum">0</b>&nbsp;руб.</span></div>
			</div>
		</div>
		

		<h2>Реквизиты
			<!--<div class="btn-group" data-toggle="buttons">
				<label class="btn btn-default">
					<input type="radio" name="legal" value="">Физическое лицо
				</label>
				<label class="btn btn-default">
					<input type="radio" name="legal" value="yes" checked>Юридическое лицо
				</label>
			</div>-->
		</h2>
		<div id='bid_individual'>
			<div class="form-group">
				<label for="input_passport_serial{id}" class="col-sm-5 control-label">Серия паспорта{:ast}</label>
				<div class="col-sm-7">
					<input name="passport_serial" type="text" class="form-control" id="input_passport_serial{id}" placeholder="1234">
				</div>
			</div>
			<div class="form-group">
				<label for="input_passport_num{id}" class="col-sm-5 control-label">Номер паспорта{:ast}</label>
				<div class="col-sm-7">
					<input name="passport_num" type="text" class="form-control" id="input_passport_num{id}" placeholder="123456">
				</div>
			</div>
			<div class="form-group">
				<label for="input_when_issued{id}" class="col-sm-5 control-label">Дата выдачи{:ast}</label>
				<div class="col-sm-7">
					<input name="when_issued" type="text" class="form-control" id="input_when_issued{id}" placeholder="12.12.2012">
				</div>
			</div>
			<div class="form-group">
				<label for="input_address{id}" class="col-sm-5 control-label">Адрес проживания{:ast}</label>
				<div class="col-sm-7">
					<input name="address" type="text" class="form-control" id="input_address{id}" placeholder="443456, Самарская обл., г. Тольятти, ул. Ивана Грозного 13, кв 123">
				</div>
			</div>
		</div>
		
		<div id='bid_legal' style='display:none'>
			<div class="form-group">
				<label for="input_company{id}" class="col-sm-5 control-label">Компания{:ast}</label>
				<div class="col-sm-7">
					<input name="company" type="text" class="form-control" id="input_company{id}" placeholder="ИП Иванов И.И.">
				</div>
			</div>
			<div class="form-group">
				<label for="input_kpp{id}" class="col-sm-5 control-label">КПП{:ast}</label>
				<div class="col-sm-7">
					<input name="kpp" type="text" class="form-control" id="input_kpp{id}" placeholder="123456789">
				</div>
			</div>
			<div class="form-group">
				<label for="input_inn{id}" class="col-sm-5 control-label">ИНН{:ast}</label>
				<div class="col-sm-7">
					<input name="inn" type="text" class="form-control" id="input_inn{id}" placeholder="123456789012">
				</div>
			</div>
			<div class="form-group">
				<label for="input_legal_adress{id}" class="col-sm-5 control-label">Юридический адрес{:ast}</label>
				<div class="col-sm-7">
					<input name="legal_adress" type="text" class="form-control" id="input_legal_adress{id}" placeholder="443456, Самарская обл., г. Тольятти, ул. Ивана Грозного 13, офис 12">
				</div>
			</div>
		</div>
		<div class="well">
			На email будет отправлен счёт для оплаты.
		</div>
		
		<div class='bid_delivery'>
			<h3>Доставка</h3>
			<p>{data.param.transport:recomend}</p>
			<div class="form-group">
				<label for="type_delivery{id}" class="col-sm-5 control-label">Транспортная&nbsp;компания{:ast}</label>
				<div class="col-sm-7">
					<select id="type_delivery" name="type_delivery" class="form-control">
						{data.param.transport:transport}
						<option value="other">Другая компания</option>
						<option value="notr">Самовывоз</option>
					</select>
					<span id='transport_site'>Тарифы и условия на доставку груза опубликованы на сайте <a href='http://{Сайт}' target="_blank">{Сайт}</a>.</span>
				</div>
			</div>
			<div class="form-group" id="name_transport">
				<label for="input_name_transport{id}" class="col-sm-5 control-label">Название{:ast}</label>
				<div class="col-sm-7">
					<input type="text" id="input_name_transport" name="name_transport" class="form-control">
				</div>
			</div>
			<div class="form-group" id="to_house">
				<label for="input_to_house{id}" class="col-sm-5 control-label">Доставка до дверей{:ast}</label>
				<div class="col-sm-7">
					<div class="checkbox">
				        <input style="margin-left:0" type="checkbox" id="input_to_house" name="to_house">
					</div>
				</div>
			</div>
			<div class="form-group" id="address_delivery" style="display:none">
				<label for="input_address_delivery{id}" class="col-sm-5 control-label">Адрес доставки</label>
				<div class="col-sm-7">
					<input type="text" id="input_address_delivery" placeholder="443456, Самарская обл., г. Тольятти, ул. Ивана Грозного 13, офис 12" name="address_delivery" class="form-control">
				</div>
			</div>
			<div class="form-group" id="boxing">
				<label for="input_to_house{id}" class="col-sm-5 control-label">Доп. упаковка</label>
				<div class="col-sm-7">
					<div class="checkbox">
				        <input style="margin-left:0" type="checkbox" name="boxing"> <span style="margin-left:20px">производится транспортной компанией<b class="freeinp">, {data.ТРАНСПОРТ.data.0.Бесплатная упаковка?:бесплатно?:платно}</b></span>
					</div>
				</div>
			</div>
			
			<div class="well">
				<p>ВНИМАНИЕ! Все товары, заказанные Вами, становятся Вашей собственностью после того, как мы погрузили их в автомобиль транспортной компании. Транспортная компания ответственна за полную и безопасную поставку Ваших товаров.</p>
			</div>
		</div>
		{config.ans:ans.msg}



		
		<button type="submit" class="btn btn-danger submit">Отправить</button>
		
		
	</form>
	<script>
		domready(function(){
			Event.one('Controller.onshow', function () {
				bid.init(Controller.ids[{id}]);
			});
		});
	</script>
{ast:}&nbsp;<span class="red">*</span>
{recomend:}
	<i>Транспортная компания <b>{name}</b> дополнительную упаковку для наших клиентов производит бесплатно.</i>
{position:}
	<div class="form-group block" data-Опт="{Опт}" data-Акция="{Акция|Цена}" data-Цена="{Цена}">
		<a href="/{config.crumb}/{...title}/{Артикул}" style="text-align:left" for="input_cell{~key}{id}" class="col-sm-5 control-label spec-name">{Артикул}</a>
		<label for="input_cell{~key}{id}" class="col-sm-2 control-label"><b><span class="cost">{~cost(Цена)}</span>&nbsp;руб.</b></label>
		<div class="col-sm-2 counter">
			<input data-name="{Артикул}" data-group="{...title}" name="pos[{...title}][{Артикул}]" name="fax" type="number" class="form-control input-number" id="input_cell{~key}{id}" placeholder="шт" value="0" min="0" max="9999">
		</div>
		<label for="input_cell{~key}{id}" class="col-sm-3 control-label">
			<div class="pos_sum" style="padding:2px 5px">{sum|:0}&nbsp;руб.</div>
		</label>
	</div>
{transport:}
<option value='{name}'>{name}</option>
