﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	// Очистка неиспользуемых реквизитов и заполнение служебных.
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	ИначеЕсли ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
	Иначе
		
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	// Обновление кэшируемых данных, зависящих от значений реквизитов данного узла обмена.
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(Ссылка);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьОтборПоОрганизациям = Ложь;
	ДатаНачалаВыгрузкиДокументов  = НачалоГода(ТекущаяДатаСеанса());
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	РежимВыгрузкиДокументов   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	
	ПравилаОтправкиДокументов = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ОпределитьВариантСинхронизацииДокументов(
		РежимВыгрузкиДокументов);
	ПравилаОтправкиСправочников = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ОпределитьВариантСинхронизацииСправочников(
		РежимВыгрузкиСправочников);
	
	СтавкаНДСПоУмолчанию    = Справочники.СтавкиНДС.НайтиПоРеквизиту("Ставка", 20);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
