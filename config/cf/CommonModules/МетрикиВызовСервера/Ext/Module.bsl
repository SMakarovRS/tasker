﻿
#Область ПрограммныйИнтерфейс

// Возвращает представление по переданному полному имени метаданных
//
// Параметры:
//	Имя - Строка - полное имя.
//
// Возвращаемое значение:
//	Строка - представление.
//
Функция СинонимПоПолномуИмениМетаданных(Знач Имя) Экспорт
	
	Мета = Метаданные.НайтиПоПолномуИмени(Имя);
	Возврат Мета.Представление();
	
КонецФункции

// Возвращает ограничение типа по переданному полному имени метаданных.
//
// Параметры:
//	Имя - Строка - Полное имя метаданных.
//
// Возвращаемое значение:
//	ОписаниеТипов - типы которыми ограничено.
//
Функция ПолучитьОграничениеТипаПоПолномуИмени(Знач ИмяТипа) Экспорт
	
	МассивИмен = СтрРазделить(ИмяТипа, ";", Ложь);
	
	Массив = Новый Массив;
	Для Каждого Имя Из МассивИмен Цикл
		Если НЕ ПустаяСтрока(Имя) Тогда
			Если СтрНайти(Имя, "Документ.") > 0 Тогда
				Имя = "ДокументСсылка." + Сред(Имя, СтрНайти(Имя, "Документ.") + СтрДлина("Документ."));
			ИначеЕсли СтрНайти(Имя, "Справочник.") > 0 Тогда
				Имя = "СправочникСсылка." + Сред(Имя, СтрНайти(Имя, "Справочник.") + СтрДлина("Справочник."));
			ИначеЕсли СтрНайти(Имя, "Перечисление.") > 0 Тогда
				Имя = "ПеречислениеСсылка." + Сред(Имя, СтрНайти(Имя, "Перечисление.") + СтрДлина("Перечисление."));
			ИначеЕсли СтрНайти(Имя, "Строка") > 0 Тогда
				КС = Новый КвалификаторыСтроки(100);
				Массив.Добавить(Тип("Строка"));
				ОписаниеСтроки = Новый ОписаниеТипов(Массив, , КС);
				Возврат ОписаниеСтроки;
				
			ИначеЕсли СтрНайти(Имя, "Число") > 0 Тогда	
				КЧ = Новый КвалификаторыЧисла(15, 3);
				Массив.Добавить(Тип("Число"));
				ОписаниеЧисла = Новый ОписаниеТипов(Массив, , , КЧ);
				Возврат ОписаниеЧисла;
				
			ИначеЕсли СтрНайти(Имя, "Дата") > 0 Тогда
				КД = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
				ОписаниеДаты = Новый ОписаниеТипов("Дата", , , КД);
				Возврат ОписаниеДаты;
				
			ИначеЕсли СтрНайти(Имя, "Булево") > 0 Тогда
				ОписаниеБулево = Новый ОписаниеТипов("Булево");
				Возврат ОписаниеБулево;
				
			КонецЕсли;
			Массив.Добавить(Тип(Имя));
		КонецЕсли;
	КонецЦикла;
	Описание = Новый ОписаниеТипов(Массив);	
	
	Возврат Описание;
	
КонецФункции

// Возвращает значения измерений по умолчанию для метрики.
//
// Параметры:
//	Метрика - СправочникСсылка.Метрики - сама метрика.
//
// Возвращаемое значение:
//	Массив структур - результат заполнения.
//
Функция ЗначенияИзмеренийПоУмолчаниюДляМетрики(Знач Метрика) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МетрикиИзмерения.НомерСтроки КАК НомерСтроки,
		|	МетрикиИзмерения.ТипИзмерения КАК ТипИзмерения,
		|	МетрикиИзмерения.ПоУмолчанию КАК ПоУмолчанию,
		|	МетрикиИзмерения.Обязательное КАК Обязательное,
		|	МетрикиИзмерения.Представление КАК Представление,
		|	МетрикиИзмерения.Назначение КАК Назначение,
		|	МетрикиИзмерения.Подсказка КАК Подсказка,		
		|	МетрикиИзмерения.Ссылка.ЗначениеПоУмолчанию КАК ПланФактПоУмолчанию
		|ИЗ
		|	Справочник.Метрики.Измерения КАК МетрикиИзмерения
		|ГДЕ
		|	МетрикиИзмерения.Ссылка = &Метрика
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Метрика", Метрика);
	
	Массив = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Структура =
			Новый Структура("НомерСтроки, ТипИзмерения, ПоУмолчанию, Обязательное, Представление, Назначение, Подсказка");
		ЗаполнитьЗначенияСвойств(Структура, Выборка);
		Массив.Добавить(Структура);
		
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

// Для метрики и переданной даты начала возвращает дату окончания.
// Использует периодичность.
//
// Параметры:
//	Метрика - СправочникСсылка.Метрики - сама метрика.
//	ДатаНачала - Дата - дата для которой нужно посчитать дату окончания.
//
// Возвращаемое значение:
//	Дата - дата окончания.
//
Функция СледующееЗначениеПериода(Знач Метрика, Знач ДатаНачала) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Метрика) Тогда
		Возврат КонецДня(ДатаНачала);
	КонецЕсли;
	
	Результат = ДатаНачала;	
	
	Возврат Результат;	
	
КонецФункции

// Возвращает используются ли метрики или нет.
//
// Параметры:
//	Нет
//
// Возвращаемое значение:
//	Булево - Истина, если используются.
//
Функция ИспользоватьМетрики() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьМетрики");

КонецФункции // ()

// Рассчет метрик.
//
// Параметры:
//	Нет.
//
Процедура РассчитатьМетрики() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// 1. Проверим, что есть правила для рссчета метрик.		
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПравилаСобытий.Ссылка КАК Ссылка,
		|	ПравилаСобытий.ТипУсловия КАК ТипУсловия,
		|	ПравилаСобытий.ПроверкаРеквизитовОбъектаУсловия КАК ПроверкаРеквизитовОбъектаУсловия,
		|	ПравилаСобытий.ПрименитьОстальныеПравила КАК ПрименитьОстальныеПравила,
		|	ПравилаСобытий.ТипПравила КАК ТипПравила,
		|	ПравилаСобытий.Представление КАК Представление,
		|	ПравилаСобытий.Наименование КАК Наименование,
		|	ПравилаСобытий.Приоритет КАК Приоритет,
		|	ПравилаСобытий.РасчетМетрикИмяОбъекта КАК РасчетМетрикИмяОбъекта,
		|	ПравилаСобытий.ПроверкаИспользуетСКД КАК ПроверкаИспользуетСКД
		|ИЗ
		|	Справочник.ПравилаСобытий КАК ПравилаСобытий
		|ГДЕ
		|	ПравилаСобытий.Использовать = ИСТИНА
		|	И ПравилаСобытий.ТипПравила = ЗНАЧЕНИЕ(Перечисление.ТипыПравилСобытий.РасчетМетрик)
		|	И ПравилаСобытий.ЭтоГруппа = ЛОЖЬ
		|	И ПравилаСобытий.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПравилаСобытий.Приоритет УБЫВ";
			
	ТаблицаПравил = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаПравил.Количество() = 0 Тогда // нет правил для рассчета метрик - выходим.
		Возврат;
	КонецЕсли;
	
	// 2. Получение измененных данных по метаданным.
	УзелОбмена 				= МетрикиПовтИсп.ПолучитьУзелДляРегистрацииДанных();	
	Состав     				= УзелОбмена.Метаданные().Состав;
	ТекстВложенногоЗапроса 	= "";
	Для Каждого ЭлементСоставаПланаОбмена Из Состав Цикл
				
		МетаданныеЭлементаИмя	= ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		
		ШаблонВложенногоЗапроса = 
			" ВЫБРАТЬ
			|	""%1"" КАК ТипСсылки,
			|	ТаблицаИзменения.Ссылка КАК Ссылка
			|ИЗ
			|	%1.Изменения КАК ТаблицаИзменения
			|ГДЕ
			|	ТаблицаИзменения.Узел = &Узел
			|	
			|	ОБЪЕДИНИТЬ ВСЕ";
		
		ТекстВложенногоЗапроса = ТекстВложенногоЗапроса + СтрШаблон(ШаблонВложенногоЗапроса, МетаданныеЭлементаИмя);	
		
	КонецЦикла;
	ТекстВложенногоЗапроса = СокрЛП(Сред(ТекстВложенногоЗапроса, 1, СтрДлина(ТекстВложенногоЗапроса) - 15));
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Спр.ТипСсылки КАК ТипСсылки,
		|	Спр.Ссылка КАК Ссылка
		|ИЗ
		|	(%1) КАК Спр
		|
		|СГРУППИРОВАТЬ ПО
		|	Спр.ТипСсылки,
		|	Спр.Ссылка
		|ИТОГИ ПО
		|	ТипСсылки";
	
	ТекстЗапроса 	= СтрШаблон(ТекстЗапроса, ТекстВложенногоЗапроса);
	Запрос 			= Новый Запрос();
	Запрос.Текст	= ТекстЗапроса;
	Запрос.УстановитьПараметр("Узел", УзелОбмена);
	ВыборкаТипов 	= Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ТипСсылки");
	Если ВыборкаТипов.Количество() > 0 Тогда
		
		Пока ВыборкаТипов.Следующий() Цикл
			
			Выборка = ВыборкаТипов.Выбрать();
			МассивИзмененныхДанных 	= Новый Массив;
			Пока Выборка.Следующий() Цикл
				МассивИзмененныхДанных.Добавить(Выборка.Ссылка);
			КонецЦикла;
			ОтборСтрок   = Новый Структура("РасчетМетрикИмяОбъекта", ВыборкаТипов.ТипСсылки);
			МассивСтрокПравил = ТаблицаПравил.НайтиСтроки(ОтборСтрок);
			Если МассивСтрокПравил.Количество() > 0 Тогда
				РассчитатьМетрикиПоМетаданным(МассивИзмененныхДанных, МассивСтрокПравил);
			Иначе
				// Для зарегистрированных объектов нет правил рассчета метрик - отменяем регистрацию.
				ОтменитьРегистрациюОбъектов(МассивИзмененныхДанных);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#Область РегламентныеЗадания

Процедура МетрикиРасчетМетрик() Экспорт	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМетрики") <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.МетрикиРасчетМетрик);
	
	РассчитатьМетрики();

КонецПроцедуры

#КонецОбласти

#Область ПодпискиНаСобытия

// Обработчик подписки на событие "УправлениеITОтделом8УФПередУдалениемСвязанныхОбъектовМетрик".
//
// Параметры:
//	Источник - ДокументОбъект, СправочникОбъект - источник действия.
// 	Отказ - Булево - предопределенный реквизит.
//
Процедура ПередУдалениемОбъектов(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка
		ИЛИ ТипЗнч(Источник.Ссылка) = Тип("ДокументСсылка.ОтражениеМетрик") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВложенныйЗапрос.Ссылка КАК Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		ОтражениеМетрик.Ссылка КАК Ссылка
		|	ИЗ
		|		Документ.ОтражениеМетрик КАК ОтражениеМетрик
		|	ГДЕ
		|		ОтражениеМетрик.Источник = &Ссылка
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ОтражениеМетрикЗначения.Ссылка
		|	ИЗ
		|		Документ.ОтражениеМетрик.Значения КАК ОтражениеМетрикЗначения
		|	ГДЕ
		|		(ОтражениеМетрикЗначения.Измерение1 = &Ссылка
		|				ИЛИ ОтражениеМетрикЗначения.Измерение2 = &Ссылка
		|				ИЛИ ОтражениеМетрикЗначения.Измерение3 = &Ссылка
		|				ИЛИ ОтражениеМетрикЗначения.Измерение4 = &Ссылка
		|				ИЛИ ОтражениеМетрикЗначения.Измерение5 = &Ссылка)) КАК ВложенныйЗапрос";
	
	Массив = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Если Массив.Количество() > 0 Тогда
		УдалитьОбъекты(Массив);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик подписки на событие "МетрикиПриЗаписиОбъекта".
//
Процедура МетрикиПередЗаписьюОбъекта(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМетрики") <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка ИЛИ Источник.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления <> Источник.Ссылка.ПометкаУдаления Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ОтражениеМетрик.Ссылка КАК Ссылка,
			|	ОтражениеМетрик.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	Документ.ОтражениеМетрик КАК ОтражениеМетрик
			|ГДЕ
			|	ОтражениеМетрик.Источник = &Источник
			|	И ТИПЗНАЧЕНИЯ(ОтражениеМетрик.Источник) = &Тип";
		
		Запрос.УстановитьПараметр("Тип", ТипЗнч(Источник.Ссылка));
		Запрос.УстановитьПараметр("Источник", Источник.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ОбъектОтражения = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектОтражения.УстановитьПометкуУдаления(Источник.ПометкаУдаления);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьМетрикиПоМетаданным(Знач МассивИзмененныхДанных, Знач МассивСтрокПравил)
		
	ТаблицаОбъектов = Новый ТаблицаЗначений;
	ТаблицаОбъектов.Колонки.Добавить("Объект");
	ТаблицаОбъектов.Колонки.Добавить("МассивПравил");
	ТаблицаОбъектов.Индексы.Добавить("Объект");
	
	Для Каждого СтрокаПравило Из МассивСтрокПравил Цикл		
		
		// Не выполняем проверку по СКД, если строит настройка.		
		Если СтрокаПравило.ПроверкаИспользуетСКД = Истина Тогда
			
			// Проверяем СКД
			НастройкиСКД = СтрокаПравило.ПроверкаРеквизитовОбъектаУсловия.Получить();
			Если НастройкиСКД <> Неопределено Тогда
				
				СКД = Справочники.ПравилаСобытий.ПолучитьПравилаОтбораСобытий(СтрокаПравило.РасчетМетрикИмяОбъекта);
							
				ЗапросВР = СКД.НаборыДанных[0].Запрос;
				ЗапросВР = СтрЗаменить(ЗапросВР, "= &Основание", "В (&Основание)");
				СКД.НаборыДанных[0].Запрос = ЗапросВР;			
				
				КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
				КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
				КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиСКД);
				КомпоновщикНастроек.Восстановить();
				КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Основание", МассивИзмененныхДанных);
				
				КомпоновщикМакета 	= Новый КомпоновщикМакетаКомпоновкиДанных;
				МакетКомпоновки 	= КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроек.ПолучитьНастройки(),,,
					Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
				
				ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Ложь);
				
				РезультатСКД 		= Новый ТаблицаЗначений;
				ПроцессорВывода 	= Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
				ПроцессорВывода.УстановитьОбъект(РезультатСКД);
				ПроцессорВывода.Вывести(ПроцессорКомпоновки);
				
				Если РезультатСКД.Количество() = 0 Тогда
					// По отбору правила нет подходящих объектов.
					Продолжить;
				КонецЕсли;
				
				МассивОбъектов = РезультатСКД.ВыгрузитьКолонку("Ссылка");
				Для Каждого ОбъектСсылка Из МассивОбъектов Цикл
					ПараметрыОтбора	= Новый Структура("Объект", ОбъектСсылка);
					МассивСтрок		= ТаблицаОбъектов.НайтиСтроки(ПараметрыОтбора);
					Если МассивСтрок.Количество() > 0 Тогда
						МассивСтрок[0].МассивПравил.Добавить(СтрокаПравило.Ссылка);
					Иначе
						НоваяСтрока 		= ТаблицаОбъектов.Добавить();
						НоваяСтрока.Объект 	= ОбъектСсылка;
						МассивПравилТ 	   	= Новый Массив;
						МассивПравилТ.Добавить(СтрокаПравило.Ссылка);
						НоваяСтрока.МассивПравил = МассивПравилТ;
					КонецЕсли;	
				КонецЦикла;
				
				// Прерываем правило, если стоит флаг.
				Если СтрокаПравило.ПрименитьОстальныеПравила = Ложь Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаОбъектов.Количество() > 0 Тогда 
		ВыполнитьДействияПравила(ТаблицаОбъектов);
	Иначе
		ОтменитьРегистрациюОбъектов(МассивИзмененныхДанных);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВыполнитьДействияПравила(Знач ТаблицаОбъектов)
	
	УзелОбмена   		= МетрикиПовтИсп.ПолучитьУзелДляРегистрацииДанных();
	ИсточникЭтоДокумент = Ложь;
	Регистратор			= Неопределено;
	МассивПравил 		= Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаОбъектов Цикл		
		Для Каждого ЭлМассива Из СтрокаТаблицы.МассивПравил Цикл
			Если МассивПравил.Найти(ЭлМассива) = Неопределено Тогда 
				МассивПравил.Добавить(ЭлМассива);
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла; 	
	
	Запрос = Новый Запрос();
	Запрос.Текст =		
		"ВЫБРАТЬ
		|	МетрикиИзмерения.Ссылка КАК Метрика,
		|	МетрикиИзмерения.НомерСтроки КАК НомерИзмерения
		|ПОМЕСТИТЬ ВТ_НазначениеПользователь
		|ИЗ
		|	Справочник.Метрики.Измерения КАК МетрикиИзмерения
		|ГДЕ
		|	МетрикиИзмерения.Назначение = ЗНАЧЕНИЕ(Перечисление.ТипыНазначенияМетрик.Пользователь)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МетрикиИзмерения.Ссылка КАК Метрика,
		|	МетрикиИзмерения.НомерСтроки КАК НомерИзмерения
		|ПОМЕСТИТЬ ВТ_НазначениеПроект
		|ИЗ
		|	Справочник.Метрики.Измерения КАК МетрикиИзмерения
		|ГДЕ
		|	МетрикиИзмерения.Назначение = ЗНАЧЕНИЕ(Перечисление.ТипыНазначенияМетрик.Проект)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДействияПравилСобытийРасчетМетрик.Ссылка КАК ДействиеПравила,
		|	ДействияПравилСобытийРасчетМетрик.НомерСтроки КАК НомерСтроки,
		|	ДействияПравилСобытийРасчетМетрик.Метрика КАК Метрика,
		|	ДействияПравилСобытийРасчетМетрик.ПериодРегистрации КАК ПериодРегистрации,
		|	ДействияПравилСобытийРасчетМетрик.Измерение1 КАК Измерение1,
		|	ДействияПравилСобытийРасчетМетрик.Измерение2 КАК Измерение2,
		|	ДействияПравилСобытийРасчетМетрик.Измерение3 КАК Измерение3,
		|	ДействияПравилСобытийРасчетМетрик.Измерение4 КАК Измерение4,
		|	ДействияПравилСобытийРасчетМетрик.Измерение5 КАК Измерение5,
		|	ДействияПравилСобытийРасчетМетрик.ПланФакт КАК ПланФакт,
		|	ДействияПравилСобытийРасчетМетрик.Формула КАК Формула,
		|	ДействияПравилСобытийРасчетМетрик.Метрика.КоличествоИзмерений КАК КоличествоИзмерений,
		|	ЕСТЬNULL(ВТ_НазначениеПользователь.НомерИзмерения, 0) КАК НомерИзмеренияПользователь,
		|	ЕСТЬNULL(ВТ_НазначениеПроект.НомерИзмерения, 0) КАК НомерИзмеренияПроект
		|ИЗ
		|	Справочник.ДействияПравилСобытий.РасчетМетрик КАК ДействияПравилСобытийРасчетМетрик
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НазначениеПользователь КАК ВТ_НазначениеПользователь
		|		ПО ДействияПравилСобытийРасчетМетрик.Метрика = ВТ_НазначениеПользователь.Метрика
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НазначениеПроект КАК ВТ_НазначениеПроект
		|		ПО ДействияПравилСобытийРасчетМетрик.Метрика = ВТ_НазначениеПроект.Метрика
		|ГДЕ
		|	ДействияПравилСобытийРасчетМетрик.Ссылка В
		|			(ВЫБРАТЬ
		|				ПравилаСобытийДействия.Действие КАК Действие
		|			ИЗ
		|				Справочник.ПравилаСобытий.Действия КАК ПравилаСобытийДействия
		|			ГДЕ
		|				ПравилаСобытийДействия.Ссылка В (&МассивПравилКВыполнению))";
	
	Запрос.УстановитьПараметр("МассивПравилКВыполнению", МассивПравил);	
	РасчетыМетрикТаблица 		= Запрос.Выполнить().Выгрузить();
	мПеречисленияПланФактФакт 	= Перечисления.ПланФакт.Факт;
	
	Если РасчетыМетрикТаблица.Количество() = 0 Тогда // нет действий в правилах - отменяем регистрацию и на выход.
		Для Каждого СтрокаТаблицы Из ТаблицаОбъектов Цикл
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, СтрокаТаблицы.Объект);
		КонецЦикла;	
		Возврат;
	КонецЕсли;	
	
	Для Каждого СтрокаТаблицы Из ТаблицаОбъектов Цикл
		
		Источник = СтрокаТаблицы.Объект;
		Если Источник <> Неопределено Тогда
			
			Если Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Источник)) Тогда
				Регистратор 		= Источник;
				ИсточникЭтоДокумент = Истина;
				
			ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(Источник)) Тогда
				Регистратор 		= Источник;
				ИсточникЭтоДокумент = Ложь;
				
			Иначе	
				Регистратор			= Неопределено;
				ИсточникЭтоДокумент = Ложь;
				
			КонецЕсли;		
			
			Если Регистратор <> Неопределено Тогда					
				// Выбираем документы с отражениями, которые были введены ранее.
				Запрос = Новый Запрос();
				Запрос.Текст =
					"ВЫБРАТЬ ПЕРВЫЕ 1
					|	ОтражениеМетрик.Ссылка КАК Ссылка
					|ИЗ
					|	Документ.ОтражениеМетрик КАК ОтражениеМетрик
					|ГДЕ
					|	ОтражениеМетрик.Источник = &Регистратор
					|	И ОтражениеМетрик.ПометкаУдаления = ЛОЖЬ";
				
				Запрос.УстановитьПараметр("Регистратор", Регистратор);
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Количество() = 0 Тогда
					Отражение 		   	= Документы.ОтражениеМетрик.СоздатьДокумент();
					Отражение.Дата 	   	= ?(ИсточникЭтоДокумент, Регистратор.Дата, ТекущаяДатаСеанса());
					Отражение.Источник 	= Регистратор;
				Иначе
					Выборка.Следующий();
					Отражение 			= Выборка.Ссылка.ПолучитьОбъект();
					Отражение.Значения.Очистить();
					Отражение.Метрики.Очистить();
				КонецЕсли;
			Иначе
				Отражение.Дата 	   = ТекущаяДатаСеанса();
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого СтрокаРасчета Из РасчетыМетрикТаблица Цикл	
			
			Попытка
				Результат = 0;
				Выполнить(СтрокаРасчета.Формула);		
			Исключение			
				Результат = 0;			
			КонецПопытки;
			
			Если Результат <> 0 Тогда
				
				НоваяСтрока 				= Отражение.Значения.Добавить();
				НоваяСтрока.Метрика 		= СтрокаРасчета.Метрика;
				НоваяСтрокаМетрики			= Отражение.Метрики.Добавить();
				НоваяСтрокаМетрики.Метрика  = СтрокаРасчета.Метрика;
				
				// План/Факт.
				Если СтрокаРасчета.ПланФакт = мПеречисленияПланФактФакт Тогда
					НоваяСтрока.ЗначениеФакт = Результат;
				Иначе
					НоваяСтрока.ЗначениеПлан = Результат;
				КонецЕсли;
				
				// Период регистрации.
				Попытка                                  
					Результат = Неопределено;
					Выполнить(СтрокаРасчета.ПериодРегистрации)					
				Исключение
					Результат = ТекущаяДатаСеанса();
				КонецПопытки;
				НоваяСтрока.ПериодРегистрации = Результат;
												
				// Заполняем измерения.
				Для Индекс = 1 По СтрокаРасчета.КоличествоИзмерений Цикл
					
					Попытка                                  
						Результат = Неопределено;
						Выполнить(СтрокаРасчета["Измерение" + Строка(Индекс)])					
					Исключение
						Результат = Неопределено;
					КонецПопытки;
					
					Если Результат <> Неопределено Тогда
						НоваяСтрока["Измерение" + Строка(Индекс)] = Результат;
					КонецЕсли;
					
				КонецЦикла;
				
				// Заполнение Пользователь.
				Если СтрокаРасчета.НомерИзмеренияПользователь <> 0 Тогда
					Пользователь 				= НоваяСтрока["Измерение" + Строка(СтрокаРасчета.НомерИзмеренияПользователь)];
					Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
						НоваяСтрока.Пользователь 	= Пользователь;
					КонецЕсли;
				КонецЕсли;
				
				// Заполнение Проект.
				Если СтрокаРасчета.НомерИзмеренияПроект <> 0 Тогда
					Проект 				= НоваяСтрока["Измерение" + Строка(СтрокаРасчета.НомерИзмеренияПроект)];
					Если ТипЗнч(Проект) = Тип("СправочникСсылка.Проекты") Тогда
						НоваяСтрока.Проект 	= Проект;
					КонецЕсли;
				КонецЕсли;
				
				Отражение.ИтогоПлан = Отражение.Значения.Итог("ЗначениеПлан");
				Отражение.ИтогоФакт = Отражение.Значения.Итог("ЗначениеФакт");
				
			КонецЕсли;
			
		КонецЦикла;	
		
		Если Отражение.ИтогоПлан <> 0 ИЛИ Отражение.ИтогоФакт <> 0 Тогда				
			Попытка
				Отражение.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				Отражение.Записать(РежимЗаписиДокумента.Запись);
			КонецПопытки;	
			
		КонецЕсли;

		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, СтрокаТаблицы.Объект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтменитьРегистрациюОбъектов(Знач МассивИзмененныхДанных)
	
	УзелОбмена 				= МетрикиПовтИсп.ПолучитьУзелДляРегистрацииДанных();	
	Для Каждого ЭлементДанных Из МассивИзмененныхДанных Цикл 
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, ЭлементДанных);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти
