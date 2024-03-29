﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Объект, Представление, СтандартнаяОбработка)
	
	Представление 			= СтрШаблон(НСтр("ru = '%1%2'"), Объект.Наименование, ?(ПустаяСтрока(Объект.Организация), "", " (" + Объект.Организация + ")"));
	СтандартнаяОбработка 	= Ложь;	
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Организация");
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

#КонецОбласти

#Область ПравилаСобытий

// Функция - Все условия правил событий для объекта.
// 
// Возвращаемое значение:
//  Соответствие - соответствие с условиями.
//
Функция УсловияПравилаСобытий() Экспорт
	
	СоответствиеИзменениеОбъекта     = Новый Соответствие;	
	СоответствиеПериодическоеСобытие = Новый Соответствие;
	
	СоответствиеРасчетМетрик = Новый Соответствие;
	СоответствиеРасчетМетрик.Вставить("ПотенциальныеКлиентыРасчетМетрикЗаписьЭлемента", НСтр("ru = 'Запись элемента'"));

	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	Соответствие.Вставить("СоответствиеРасчетМетрик", 		  СоответствиеРасчетМетрик);
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли