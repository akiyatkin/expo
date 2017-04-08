{root:}
ФИО: {name}
E-mail: {email}
Мобильный телефон: {phone_mobile}
Городской телефон: {phone_town}

Цена: {cost=:Опт?:Оптовая?:Розница}

{pos::order}

Всего: {all_count} шт, {~cost(all_sum,~true)} руб.

==Реквизиты. {legal?:legal?:individual}
 
==Доставка==
Транспортная компания: {type_delivery.Наименование}{type_delivery.notr??:compdelivery}

Время: {~date(:j F Y H:i,time)}
IP: {ip}
Браузер: {browser}
{compdelivery:}
{type_delivery.other?:delother}
Доставка до дверей: {to_house?:Да?:Нет}
Дополнительная упаковка: {boxing?:Да?:Нет}
Адрес доставки: {address_delivery}
{positions:}
{Наименование} 
	{count} по {~cost(cost,~true)} руб. = {~cost(sum,~true)} руб.

{delother:}Другая транспортная компания: {name_transport}
{individual:}Физическое лицо==
Паспорт: {passport_serial}
Серия и номер: {passport_num}
Когда выдан: {when_issued}
Адрес проживания с индексом: {address}

{legal:}Юридическое лицо==
Компания: {company}
Юридический адрес: {legal_adress}
ИНН: {inn}
КПП: {kpp}

{noresult:}
{order:}
==Заявка {~key}== {::positions}