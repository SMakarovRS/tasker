﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Индивидуальный = Видимость.Количество() = 0;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли