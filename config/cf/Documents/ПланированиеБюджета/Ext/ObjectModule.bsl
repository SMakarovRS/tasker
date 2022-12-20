﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Бюджеты Цикл
			СтрокаТабличнойЧасти.СтатьяДоходовРасходов = СтатьяДоходовРасходов;
		КонецЦикла;
	КонецЕсли;	
	
	Если ПоложениеПодразделения = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Бюджеты Цикл
			СтрокаТабличнойЧасти.Подразделение = Подразделение;
		КонецЦикла;
	КонецЕсли;	
	
	Если ПоложениеПериодаБюджета = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Бюджеты Цикл
			СтрокаТабличнойЧасти.ПериодБюджета = ПериодБюджета;
		КонецЦикла;
	КонецЕсли;	
	
	СуммаДокумента = Бюджеты.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	СЛС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);	
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	СЛС.ОтразитьДвиженияВРазделахУчета(Ссылка, ДополнительныеСвойства, Движения, Отказ);	
	
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
		
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Основание = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ПоложениеПериодаБюджета			= Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
		ПоложениеСтатьиДоходовРасходов			= ДанныеЗаполнения.ПоложениеСтатьиДоходовРасходов;
		СтатьяДоходовРасходов					= ДанныеЗаполнения.СтатьяДоходовРасходов;
		ПоложениеПодразделения			= ДанныеЗаполнения.ПоложениеПодразделения;
		Подразделение					= ДанныеЗаполнения.Подразделение;
		БезУчетаКоличества				= Ложь;
		Комментарий						= СтрШаблон(НСтр("ru = 'Планирование на основании заказа №%1 от %2'"), ДанныеЗаполнения.Номер, Формат(ДанныеЗаполнения.Дата, "ДФ=dd.MM.yyyy"));
		ПланируемыйБюджет				= ДанныеЗаполнения.Бюджет;
		ВалютаДокумента					= ДанныеЗаполнения.ВалютаДокумента;
		СуммаВключаетНДС				= ДанныеЗаполнения.СуммаВключаетНДС;
		
		Для Каждого Строки Из ДанныеЗаполнения.Номенклатура Цикл
			НоваяСтрока					= Бюджеты.Добавить();
			НоваяСтрока.ПериодБюджета 	= ДанныеЗаполнения.ПериодБюджета;
			НоваяСтрока.Подразделение 	= Строки.Подразделение;
			НоваяСтрока.ДатаОплаты	  	= ДанныеЗаполнения.Дата;
			НоваяСтрока.Количество		= Строки.Количество;
			НоваяСтрока.Цена			= ?(Строки.Количество = 0, 0, Строки.Всего / Строки.Количество);
			НоваяСтрока.СтатьяДоходовРасходов	= Строки.СтатьяДоходовРасходов;
			НоваяСтрока.Описание		= Строка(Строки.Номенклатура);
			НоваяСтрока.Сумма			= Строки.Сумма;
			НоваяСтрока.СтавкаНДС		= Строки.СтавкаНДС;
			НоваяСтрока.СуммаНДС		= Строки.СуммаНДС;
			НоваяСтрока.Всего 			= Строки.Всего;
		КонецЦикла;				
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задание") Тогда
		
		ПоложениеПериодаБюджета			= Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
		ПоложениеПодразделения			= Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		Подразделение					= ДанныеЗаполнения.Подразделение;
		БезУчетаКоличества				= Ложь;
		Комментарий						= СтрШаблон(НСтр("ru = 'Планирование на основании задания №%1 от %2'"), ДанныеЗаполнения.Номер, Формат(ДанныеЗаполнения.Дата, "ДФ=dd.MM.yyyy"));
		ПланируемыйБюджет				= УправлениеITОтделом8УФ.НайтиБюджетНаДату(ДанныеЗаполнения.Дата, ДанныеЗаполнения.Организация);
		
		НоваяСтрока						= Бюджеты.Добавить();
		НоваяСтрока.ПериодБюджета 		= УправлениеITОтделом8УФ.НайтиПериодБюджета(ДанныеЗаполнения.Дата, ПланируемыйБюджет);
		НоваяСтрока.Подразделение 		= Подразделение;
		НоваяСтрока.ДатаОплаты	  		= ДанныеЗаполнения.Дата;
		НоваяСтрока.Количество			= 1;
		НоваяСтрока.Описание			= ДанныеЗаполнения.Тема;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти	

#Область СлужебныеПроцедурыИФункции

// Проверка объекта на обязательные реквизиты перед проведением.
Процедура ПроверитьДокументПередПроведением(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ПланируемыйБюджет) Тогда
		УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указан планируемый бюджет'"), , , "ПланируемыйБюджет", Отказ);
	КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(ПоложениеСтатьиДоходовРасходов) Тогда
		УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указано положение статьи доходов и расходов (в шапке/в таблице)'"), , , "ПоложениеСтатьиДоходовРасходов", Отказ);
	КонецЕсли;
		
	Если ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Если НЕ ЗначениеЗаполнено(СтатьяДоходовРасходов) Тогда
			УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указана статья доходов и расходов'"), , , "СтатьяДоходовРасходов", Отказ);
		КонецЕсли;
	Иначе
		Для каждого СтрокаТабличнойЧасти Из Бюджеты Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтатьяДоходовРасходов) Тогда
				УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указана статья доходов и расходов'"), "Бюджеты", СтрокаТабличнойЧасти.НомерСтроки, "СтатьяДоходовРасходов", Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ПоложениеПериодаБюджета = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Если НЕ ЗначениеЗаполнено(ПериодБюджета) Тогда
			УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указан период бюджета'"), , , "ПериодБюджета", Отказ);
		КонецЕсли;
	Иначе
		Для каждого СтрокаТабличнойЧасти Из Бюджеты Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтатьяДоходовРасходов) Тогда
				УправлениеITОтделом8УФ.СообщитьОбОшибке(ЭтотОбъект, НСтр("ru = 'Не указан период бюджета'"), "Бюджеты", СтрокаТабличнойЧасти.НомерСтроки, "ПериодБюджета", Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли