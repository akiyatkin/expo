<?php
	use infrajs\cache\Cache;
	use infrajs\load\Load;
	use infrajs\ans\Ans;
	use infrajs\path\Path;
	use infrajs\mail\Mail;
	use infrajs\excel\Xlsx;
	use infrajs\config\Config;
	use infrajs\template\Template;

	$ans = array();
	$post = $_POST;

	if (empty($_POST['json'])) return Ans::err($ans,'Некорректные данные');
	if (empty($_POST['cost'])) return Ans::err($ans, 'Ошибка, некорректные данные. Нет информации о расчётной цене.');
	if (empty($_POST['type_delivery'])) return Ans::err($ans,'Некорректные данные');
	if (empty($_POST['pos'])) return Ans::err($ans,'Некорректные данные');
	if (empty($_POST['cost'])) return Ans::err($ans,'Некорректные данные');

	$json = $_POST['json'];
	$data = Load::loadJSON($json);
	
	
	

	
	
	
	if (!$post['cost']) $post['cost'] = 'Цена';
	

	
	if ($post['type_delivery'] == 'other') {
		$tr = array('Наименование' => 'Другая компания', 'other' => true);
		$tr['other'] = true;
	} else if ($post['type_delivery'] == 'notr') {
		$tr = array('Наименование' => 'Самовывоз', 'notr' => true);
	} else {
		$tr = array('Наименование' => $post['type_delivery']);
	}
	
	$post['type_delivery'] = $tr;

	
	
	$poss = array();
	
	$all_sum=0;
	$all_sum_opt = 0;
	$all_sum_roz = 0;
	$all_count=0;

	foreach ($data['list'] as $group) {
		Xlsx::runPoss($group, function &(&$pos) use ($group, &$post, &$poss, &$all_sum, &$all_count, &$all_sum_opt, &$all_sum_roz){
			$r = null;
			if (empty($post['pos'][$group['title']])) return $r;
			if (empty($post['pos'][$group['title']][$pos['Артикул']])) return $r;

			$pos['count'] = (int) $post['pos'][$group['title']][$pos['Артикул']];

			if (!empty($pos[$post['cost']])) {
				$pos['cost'] = $pos[$post['cost']];
			} else {
				$pos['cost'] = $pos['Цена'];
			}
			
			$pos['sum'] = $pos['count'] * $pos['cost'];
			
			$sum_opt = $pos['count'] * $pos['Опт'];
			$sum_roz = $pos['count'] * $pos['Цена'];

			$all_sum_opt += $sum_opt;
			$all_sum_roz += $sum_roz;

			$all_count += $pos['count'];
			$all_sum += $pos['sum'];
			if (!isset($poss[$group['title']])) $poss[$group['title']] = array();
			$poss[$group['title']][] = &$pos;
			return $r;
		});
	}


	$post['time'] = time();
	$post['ip'] = isset($_SERVER['REMOTE_ADDR'])?$_SERVER['REMOTE_ADDR']:'';
	$post['host'] = isset($_SERVER['REMOTE_HOST'])?$_SERVER['REMOTE_HOST']:'';
	$post['browser'] = $_SERVER['HTTP_USER_AGENT'];

	$post['pos'] = $poss;
	$post['all_sum'] = $all_sum;
	$post['all_count'] = $all_count;

	$msg = Template::parse('-expo/bid/mail.tpl', $post);
	$ans['msg'] = '<pre>'.$msg.'</pre>';
	$ans['post'] = $post;

	
	


	if (empty($post['email'])) return Ans::err($ans, 'Ошибка, нужно указать Email.');
	if (empty($post['name'])) return Ans::err($ans, 'Ошибка, необходимо указать ФИО.');
	if (empty($post['phone_town']) && empty($post['phone_mobile'])) return Ans::err($ans, 'Укажите хотя бы один телефон.');
	
	if (empty($post['all_count'])) return Ans::err($ans, 'Ошибка, нет выбранных товаров.');
	/*if ($post['legal']){
		if (!$post['company']) return Ans::err($ans, 'Укажите название компании.');
		if (!$post['legal_adress']) return Ans::err($ans, 'Укажите юридический адрес компании.');
		if (!$post['inn']) return Ans::err($ans, 'Укажите ИНН.');
		if (!$post['kpp']) return Ans::err($ans, 'Укажите КПП.');
	}else{*/
		if (empty($post['passport_serial'])) return Ans::err($ans, 'Укажите серию паспорта.');
		if (empty($post['passport_num'])) return Ans::err($ans, 'Укажите номер паспорта.');
		if (empty($post['when_issued'])) return Ans::err($ans, 'Укажите когда выдан паспорт.');
		if (empty($post['address'])) return Ans::err($ans, 'Укажите адрес проживания с индексом.');
	//}
	/*Доставка.*/
	if (!empty($post['type_delivery']['other']) && empty($post['name_transport'])) return Ans::err($ans, 'Введите имя транспортной компании.');
	if (!$post['type_delivery']['Наименование']) return Ans::err($ans, 'Выберите транспортною компанию.');
	if ($post['type_delivery']['Наименование'] !=='Самовывоз' && !empty($post['to_house']) && empty($post['address_delivery'])) return Ans::err($ans, 'Укажите адрес доставки.');
	
	$param = $data['param'];
	$step = $param['Опт'];
	if ($post['cost']=='Опт') {
		if ($all_sum < $step) {
			if (empty($post['yep'])) return Ans::err($ans, 'Указана оптовая цена при стоимости заказа меньше <b>'.$param['Опт'].' руб.</b><br><input autosave="0" name="yep" type="checkbox"> &mdash; всё правильно, я постоянный клиент.<br>Для уточнения вашего статуса звоните по телефонам в <a href="/contacts">контактах.</a>');
		}
	}
	if($post['cost']=='Цена') {
		if ($all_sum_opt > $step) {
			if (empty($post['yep'])) return Ans::err($ans, 'Указана розничная цена при оптовой стоимости заказа больше '.$param['Опт'].' руб. <br><input autosave="0" name="yep" type="checkbox"> &mdash; всё правильно');
		}
		if ($all_sum_opt == $step) {
			if (empty($post['yep'])) return Ans::err($ans, 'Указана розничная цена при оптовой стоимости заказа '.$param['Опт'].' руб. <br><input autosave="0" name="yep" type="checkbox"> &mdash; всё правильно');
		}
	}
	

	$dir = Path::theme('~auto/.Заявки с сайта/');
	$title = $_SERVER['HTTP_HOST'].' заявка '.$post['name'];
	$ans['title'] = $title;
	$file = date('Y.m.d H-i-s', $post['time']);
	$file .= ' '.$title.'.txt';
	$ans['file'] = $file;
	$file = Path::tofs($file);
	
	file_put_contents($dir.$file,$msg);

	$r = Mail::toAdmin($title,$post['email'],$msg);

	if (!$r) return Ans::err($ans, 'Неудалось отправить заявку из-за ошибки на сервере, воспользуйтесь телефоном, заявка сохранена на сайте');
	return Ans::ret($ans);
?>