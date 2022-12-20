﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаТарифов = КонецДня(ТекущаяДата());
	ОбновитьОтборы();
	ОбновитьЗаголовки();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаданияСервер.УстановитьШагКорректировкиВеса(ШагКорректировкиВеса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Документ.УстановкаЦенУслуг" Тогда
		ОбновитьЗаголовки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ВесРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если ШагКорректировкиВеса > 1 Тогда		
		
		СтандартнаяОбработка = Ложь;
		Если Направление = 1 Тогда
			Объект.Вес = Объект.Вес + ШагКорректировкиВеса;
		Иначе
			Объект.Вес = Объект.Вес - ШагКорректировкиВеса;
		КонецЕсли;	
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТарифы

&НаКлиенте
Процедура ТарифыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.Тарифы.ТекущиеДанные.Регистратор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОтборы()
	
	Тарифы.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", ?(ДатаТарифов = Дата(1, 1, 1), 
		Новый Граница(КонецДня(ТекущаяДатаСеанса()), ВидГраницы.Включая), 
		Новый Граница(КонецДня(ДатаТарифов), ВидГраницы.Включая)));
		
	Тарифы.Параметры.УстановитьЗначениеПараметра("Услуга", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовки()
	
	КоличествоТарифов 		= 0;
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ЦеныУслугСрезПоследних.Регистратор) КАК КоличествоЦенТарифов
		|ИЗ
		|	РегистрСведений.ЦеныУслуг.СрезПоследних(&ДатаАктуальности, Услуга = &Услуга) КАК ЦеныУслугСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаАктуальности", 	ДатаТарифов);
	Запрос.УстановитьПараметр("Услуга", 			Объект.Ссылка);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Тарифы
	ВыборкаТарифы = МассивРезультатов[0].Выбрать();
	Если ВыборкаТарифы.Следующий() Тогда
		КоличествоТарифов = ВыборкаТарифы.КоличествоЦенТарифов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти