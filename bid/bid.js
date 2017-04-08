(function(){
	window.bid = {
		init: function(layer) {
			var div = $('#'+layer.div);
			bid.checkCost(layer);
			div.find('[name=cost]').change(function(){
				bid.checkCost(layer);
				if(layer.config && layer.config.ans){
					delete layer.config.ans;
					Controller.check(layer);
				}
				
			});


			div.find('.clear').click( function () {
				delete layer.config.ans;
				bid.clear(layer);
				div.find('.clear').attr('disabled','disabled');
			
			});
			div.find('form input').change(function(){
				div.find('.clear').removeAttr('disabled');
			});
			if (bid.get(layer)) {
				div.find('.clear').removeAttr('disabled');
			} else {
				div.find('.clear').attr('disabled','disabled');
			}

			
			/* Обработка кликов */
			div.find('[name="legal"]').change(function(){
				bid.legal_form(layer);
			});
			bid.legal_form(layer);
			

			
			bid.delivery(layer);
			div.find('#to_house input').click(function(){
				bid.delivery(layer);
			});
			$('#type_delivery').change(function(){
				bid.delivery(layer);
			});
			
			
			/* Интерактивное изменение суммы */
			bid.count_all(layer);
			$('.counter input').change(function() {
				bid.count_all(layer);
			});
		},
		checkCost: function(layer) {
			var cost = bid.get(layer,'cost');
			if (!cost) cost='Цена';
			var div = $('#'+layer.div);
			//Установить большую видиму цену. Поменять цену в счётчиках. Всё пересчитать
			div.find('[name="cost"]').parent().removeClass('active');
			div.find('[name="cost"]:checked').parent().addClass('active');


			div.find('.pos_sum').removeClass('bg-success').removeClass('bg-danger').removeClass('bg-info');
			if (cost == 'Опт') {
				//div.find('.all_sum').parents('.alert').removeClass('alert-success').addClass('alert-info');	
				div.find('.pos_sum').addClass('bg-info');
			} else if (cost == 'Акция') {
				//div.find('.all_sum').parents('.alert').removeClass('alert-success').addClass('alert-info');
				div.find('.pos_sum').addClass('bg-danger');
			} else {
				//div.find('.all_sum').parents('.alert').removeClass('alert-info').addClass('alert-success');
				div.find('.pos_sum').addClass('bg-success');
			}

			div.find('.block').each(function(){
				$(this).find('.cost').html($(this).data(cost));
			});

			bid.count_all(layer);
		},
		legal_form:function(layer) {
			var div = $('#'+layer.div);
			div.find('[name=legal]').parent().removeClass('active');
			div.find('[name=legal]:checked').parent().addClass('active');
			//infrajs.autosave.set(layer,'legal',legal);
			var legal = $('[name=legal]:checked').val();
			if(!legal){
				div.find('#bid_individual_button').addClass('select');
				div.find('#bid_legal_button').removeClass('select');
				div.find('#bid_individual').show();
				div.find('#bid_individual input').prop('disabled',false);
				div.find('#bid_legal').hide();
				div.find('#bid_legal input').prop('disabled',true);
			}else{
				div.find('#bid_legal_button').addClass('select');
				div.find('#bid_individual_button').removeClass('select');
				div.find('#bid_legal').show();
				div.find('#bid_legal input').prop('disabled',false);
				div.find('#bid_individual').hide();
				div.find('#bid_individual input').prop('disabled',true);
			}
		},
		delivery: function (layer) {
			var div = $('#'+layer.div);
			var id = $("#type_delivery option:selected").attr('value');
			div.find('#address_delivery').show();
			div.find('#to_house').show();
			
			if (div.find('#to_house input').prop('checked')) {
				div.find('#address_delivery').show();
				div.find('#address_delivery input').prop('disabled',false);
			} else {
				div.find('#address_delivery').hide();
				div.find('#address_delivery input').prop('disabled',true);
			}

			if(!id||id=='other') {
				div.find('.freeinp').hide();
				div.find('#boxing').show();
				div.find('#boxing input').prop('disabled',false);
				div.find('#boxing input').prop('checked',false);
				div.find('#transport_site').hide();
				div.find('#name_transport').show();
				div.find('#name_transport input').prop('disabled',false);
			} else if (id == 'notr') {
				div.find('#address_delivery').hide();
				div.find('#boxing').hide();
				div.find('#to_house').hide();
				div.find('#boxing input').prop('disabled',true);
				div.find('#boxing input').prop('checked',false);
				div.find('#transport_site').hide();
				div.find('#name_transport').hide();
				div.find('#name_transport input').prop('disabled',true);
			} else {
				var data = Load.loadJSON(layer.json);
				
				
				var pos = data.param.transport;
				if (pos['name']==id){
					div.find('.freeinp').html(', бесплатно');
					div.find('#boxing input').prop('disabled',true);
					div.find('#boxing input').prop('checked',true);
					var site = pos['site'];
					div.find('#transport_site a').text(site);
					div.find('#transport_site a').attr('href','http://'+site);
				}
				div.find('#boxing').show();
				div.find('#transport_site').show();
				div.find('#name_transport').hide();
				div.find('#name_transport input').prop('disabled',true);
			}
		},
		/* Получение цены позиции */
		get_pos:function(layer, group, name) {
			var data = Load.loadJSON(layer.json);
			return infra.forr(data.list[group].data, function (pos) {
				if (pos['Артикул'] == name) return pos;
			});
		},
		rebase:function(){
			delete bid.layer.config.ans;
			infrajs.check();
		},
		
		count_all: function (layer) {
			var div = $('#'+layer.div);
			var cost=bid.get(layer, 'cost');
			if (!cost) cost = 'Цена';
			div.find('.counter input').each(function(){
				var name = $(this).data('name');
				var group = $(this).data('group');
				var count = parseInt($(this).val());
				if (!count) count=0;
				/* Назначение суммы и количества в прайс */
				var pos=bid.get_pos(layer, group, name);
				var valcost = pos[cost]?pos[cost]:pos['Цена'];
				var sum=count*valcost;

				pos['sum'] = sum;
				pos['count'] = count;

				var psum=infra.template.scope['~cost'](sum)+' руб.';
				
				if (count) $(this).parents('.block').find('.pos_sum').show().html(psum);
				else $(this).parents('.block').find('.pos_sum').hide().html('');
			});
			var all_sum = 0;
			var data = Load.loadJSON(layer.json);
			for (var i in data.list) {
				Each.exec(data.list[i].data, function (pos) {
					if (pos['sum']) all_sum += pos['sum'];
				});
			}

			div.find('.all_sum').html(infra.template.scope['~cost'](all_sum));			
		},
		clear: function(layer){
			bid.set(layer);
			var div = $('#'+layer.div);
			div.find('form')[0].reset();
			this.count_all(layer);
		},
		set:function(layer, name, value){
			if(!name) var right = [];
			else var right = Sequence.right(name);
			var right = Sequence.right(name);
			return Session.set([layer.autosavename].concat(right), value);
		},
		get: function (layer, name, def) {
			if(!name) var right = [];
			else var right = Sequence.right(name);
			return Session.get([layer.autosavename].concat(right), def);
		}
	}
})();