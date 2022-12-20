﻿
#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда     
		Возврат;
	КонецЕсли;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(Перечисления.СтатусыСервисов.ВРаботе);
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список.Отбор, "Статус", СписокСтатусов);
	
	Если Параметры.Свойство("Проект") Тогда
		Проект = Параметры.Проект;
		Если Проект.Сервисы.Количество() > 0 Тогда
			Список.Параметры.УстановитьЗначениеПараметра("Проект", Проект); 					
		КонецЕсли;	
	КонецЕсли;
	
	Если Параметры.Свойство("ОтображаемыеСервисы") Тогда
		
		Если Параметры.ОтображаемыеСервисы.Количество() > 0 Тогда
			РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список.Отбор, "Ссылка", Параметры.ОтображаемыеСервисы);
		КонецЕсли;		
		
	КонецЕсли;
		
	Если Параметры.Свойство("ТипСервиса") Тогда 
		ТипСервиса = Параметры.ТипСервиса;
		Если ЗначениеЗаполнено(ТипСервиса) Тогда 
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ТипСервиса");
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.Использование    = Истина;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементОтбора.ПравоеЗначение   = ТипСервиса;	
		КонецЕсли	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти