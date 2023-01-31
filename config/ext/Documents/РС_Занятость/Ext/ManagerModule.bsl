﻿#Область ПравилаСобытий

// Функция - Все условия правил событий для объекта.
// 
// Возвращаемое значение:
//  Соответствие - соответствие с условиями.
//
Функция УсловияПравилаСобытий() Экспорт
	
	СоответствиеИзменениеОбъекта = Новый Соответствие;
	
	СоответствиеИзменениеОбъекта.Вставить("ЗанятостьИзменениеОбъектаПревышениеЛимита",		  	  	  
	НСтр("ru = 'Превышение лимита'"));
	
	
	СоответствиеПериодическоеСобытие = Новый Соответствие;	
	
	СоответствиеРасчетМетрик = Новый Соответствие;
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	Соответствие.Вставить("СоответствиеРасчетМетрик", 		  СоответствиеРасчетМетрик);
	
	Возврат Соответствие;
	
КонецФункции

// Функция - Проверка условия правила события.
//
// Параметры:
//  ПравилоСобытия	 - СправчоникСсылка.ПравилаСобытий	 - правило проверки.
//  ИмяСобытия		 - Строка	 - имя проверки.
//  Структура		 - Структура	 - источник события и другая информация.
// 
// Возвращаемое значение:
//   - 
//
Функция ПроверкаУсловияПравилаСобытия(Знач ПравилоСобытия, Знач Структура = Неопределено,
	Знач Источник = Неопределено) Экспорт
	
	ИмяСобытия = ПравилоСобытия.ПроверкаРеквизитовОбъектаИмяУсловия;
	
	Если ПравилоСобытия.ТипПравила = Перечисления.ТипыПравилСобытий.ИзменениеОбъекта Тогда 
		
		Если ИмяСобытия = "ЗанятостьИзменениеОбъектаПревышениеЛимита" Тогда
			
			Рез = ЗанятостьПревышениеЛимита(Источник); 
			Возврат Рез;	
			
		КонецЕсли;
		
		Возврат Ложь;
		
	ИначеЕсли ПравилоСобытия.ТипПравила = Перечисления.ТипыПравилСобытий.ПериодическоеСобытие Тогда 
		
		ДатаНачалаПроверки   = Структура.ДатаНачалаПроверки;
		ДатаОкончанияПроверки= Структура.ДатаОкончанияПроверки;			
		Запрос 		 		 = Новый Запрос;			
		
	КонецЕсли;
	
КонецФункции

Функция ЗанятостьПревышениеЛимита(Знач Источник)
	
	Задание = Источник.Задание;
	ПлановаяДлительность = Задание.ПлановаяДлительность;
	СогласованоЧасов = Задание.СогласованоЧасов;
	Лимит = ?(ПлановаяДлительность>0, ПлановаяДлительность, ?(СогласованоЧасов>0,СогласованоЧасов,5));
	ЭтоНовый = ПроверитьДвижения(Источник);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РС_Занятость.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_Занятости
	|ИЗ
	|	Документ.РС_Занятость КАК РС_Занятость
	|ГДЕ
	|	РС_Занятость.Задание = &Ссылка
	| 	И РС_Занятость.ПометкаУдаления = ЛОЖЬ 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(РС_РаботыОбороты.ФактическоеВремяОборот), 0) КАК ФактическоеВремяОборот,
	|	ЕСТЬNULL(СУММА(РС_РаботыОбороты.ВремяКлиентаОборот), 0) КАК ВремяКлиентаОборот
	|ИЗ
	|	РегистрНакопления.РС_Работы.Обороты КАК РС_РаботыОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Занятости КАК ВТ_Занятости
	|		ПО РС_РаботыОбороты.Занятость = ВТ_Занятости.Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Задание.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЧасыФакт = ВыборкаДетальныеЗаписи.ФактическоеВремяОборот;
	КонецЦикла;
	
	Результат = Ложь;
	
	Если НЕ ЗначениеЗаполнено(ЧасыФакт) И Источник.ФактическаяТрудоемкость > Лимит тогда
		Результат = Истина;
	ИначеЕсли ЗначениеЗаполнено(ЧасыФакт) Тогда
		Если ЧасыФакт + ?(ЭтоНовый, Источник.ФактическаяТрудоемкость, 0)  > Лимит тогда
			Результат = Истина;
		Иначе
			Результат = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
Возврат Результат;

КонецФункции

Функция ПроверитьДвижения(Занятость)
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	|	РС_Работы.Занятость КАК Занятость
	|ИЗ
	|	РегистрНакопления.РС_Работы КАК РС_Работы
	|ГДЕ
	|	РС_Работы.Регистратор = &Регистратор";
	
	Запрос.Параметры.Вставить("Регистратор", Занятость.Ссылка);
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции


#КонецОбласти
