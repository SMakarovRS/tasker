﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Объект") Тогда 		
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Владелец", Параметры.Объект, Истина, 
			ВидСравненияКомпоновкиДанных.Равно);		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") ИЛИ Параметры.Свойство("Объект") Тогда 
		Элементы.Владелец.Видимость = Ложь;		
	КонецЕсли;
	
	ВыводДереваВладельцев = НЕ (Параметры.Отбор.Свойство("Владелец") ИЛИ Параметры.Свойство("Объект"));
	
	Если Параметры.Свойство("Группировка") Тогда 
		ГруппировкаСписка   		= Список.Группировка.Элементы;  
		ЭлементГруппировки   		= ГруппировкаСписка.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));  
		ЭлементГруппировки.Поле  	= Новый ПолеКомпоновкиДанных("Владелец");
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Владелец") Тогда
		ЗаполнитьПанельВладельцев();
	КонецЕсли;
	ОбновитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные.Владелец <> Неопределено Тогда
		Если Элементы.Список.ТекущиеДанные.Свойство("ГруппировкаСтроки") Тогда
			Элементы.ФормаЗапустить.Видимость = Ложь;
		Иначе
			Если ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.ТипПодключения) Тогда 
				Название = ПредставлениеПеречисления(Элементы.Список.ТекущиеДанные.ТипПодключения);
				Элементы.ФормаЗапустить.Картинка = БиблиотекаКартинок[Название];
				Элементы.ФормаЗапустить.Видимость = Истина;
			Иначе
				Элементы.ФормаЗапустить.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Запустить(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Элементы.Список.ТекущиеДанные.Владелец) Тогда
		Возврат;
	КонецЕсли;
	
	Настройка = Новый Структура();
	Настройка.Вставить("Объект", УдаленноеУправлениеВызовСервера.НастройкаУдаленногоУправления(Элементы.Список.ТекущиеДанные.Ссылка));
	
	ПараметрыЗапуска = Новый Структура;
	ОписаниеОповоещения = Новый ОписаниеОповещения("ВыполнитьПослеЗапуска", ЭтотОбъект, ПараметрыЗапуска);
	УдаленноеУправлениеКлиент.ЗапуститьУдаленноеУправление(ОписаниеОповоещения, Настройка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗапуска(П1, П2) Экспорт
	
	// ТУТ НИЧЕГО.
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВладельцы

&НаКлиенте
Процедура ВладельцыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиПанелиНавигации", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьОтображениеПанелиНавигации(Команда)
	
	ПанельНавигацииСкрыта = Не ПанельНавигацииСкрыта;
	ОбновитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПредставлениеПеречисления(Знач ТипПеречисления)
	
	Возврат Метаданные.Перечисления.ТипыПодключений.ЗначенияПеречисления.Получить(
		Перечисления.ТипыПодключений.Индекс(ТипПеречисления)).Имя;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПанельВладельцев()
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УдаленноеУправление.Владелец КАК Владелец,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(УдаленноеУправление.Владелец) КАК Представление,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.Контрагенты)
		|			ТОГДА &СтрокаКонтрагенты
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.Сотрудники)
		|			ТОГДА &СтрокаСотрудники
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.КонтактныеЛица)
		|			ТОГДА &СтрокаКонтактныеЛица
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.МестаХранения)
		|			ТОГДА ""Места хранения""
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.Организации)
		|			ТОГДА &СтрокаОрганизации
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.Подразделения)
		|			ТОГДА &СтрокаПодразделения
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.Пользователи)
		|			ТОГДА &СтрокаПользователи
		|		КОГДА ТИПЗНАЧЕНИЯ(УдаленноеУправление.Владелец) = ТИП(Справочник.ФизическиеЛица)
		|			ТОГДА &СтрокаФизическиеЛица
		|		ИНАЧЕ &СтрокаВладелецНеВыбран
		|	КОНЕЦ КАК Группа
		|ИЗ
		|	Справочник.УдаленноеУправление КАК УдаленноеУправление
		|
		|УПОРЯДОЧИТЬ ПО
		|	Группа,
		|	Владелец
		|ИТОГИ ПО
		|	ОБЩИЕ,
		|	Группа,
		|	Владелец,
		|	Представление
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	СтрокаВладелецНеВыбран = НСтр("ru = 'Владелец не выбран'");
	
	Запрос.УстановитьПараметр("СтрокаФизическиеЛица",		НСтр("ru = 'Физические лица'"));
	Запрос.УстановитьПараметр("СтрокаПользователи",   		НСтр("ru = 'Пользователи'"));
	Запрос.УстановитьПараметр("СтрокаКонтрагенты", 	  		НСтр("ru = 'Контрагенты'"));
	Запрос.УстановитьПараметр("СтрокаКонтактныеЛица", 		НСтр("ru = 'Контактные лица'"));
	Запрос.УстановитьПараметр("СтрокаПодразделения",  		НСтр("ru = 'Подразделения'"));
	Запрос.УстановитьПараметр("СтрокаСотрудники",  			НСтр("ru = 'Сотрудники'"));
	Запрос.УстановитьПараметр("СтрокаПотенциальныеКлиенты",	НСтр("ru = 'Потенциальные клиенты'"));
	Запрос.УстановитьПараметр("СтрокаОрганизации",			НСтр("ru = 'Организации'"));
	Запрос.УстановитьПараметр("СтрокаВладелецНеВыбран",		СтрокаВладелецНеВыбран);
	
	ДЗ = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Владельцы.ПолучитьЭлементы().Очистить();
	
	Для Каждого Строка Из ДЗ.Строки Цикл
	
		СтрокиПервыйУровень					= Владельцы.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(СтрокиПервыйУровень, Строка);
		СтрокиПервыйУровень.Представление	= НСтр("ru = 'Владельцы'");
		СтрокиПервыйУровень.ИндексКартинки	= 1;
		СтрокиПервыйУровень.ЭтоГруппа 		= Истина;
		СтрокиПервыйУровень 				= СтрокиПервыйУровень.ПолучитьЭлементы();
		
		Для Каждого Строка2 Из Строка.Строки Цикл
			НоваяСтрока					= СтрокиПервыйУровень.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка2);
			НоваяСтрока.Представление	= Строка(Строка2.Группа);
			НоваяСтрока.ИндексКартинки	= 1;
			
			Если СтрокаВладелецНеВыбран <> Строка2.Группа Тогда
				
				НоваяСтрока.ЭтоГруппа = Истина;
			
				Для Каждого Подстрока Из Строка2.Строки Цикл
					
					НоваяПодСтрока					= НоваяСтрока.ПолучитьЭлементы().Добавить();
					ЗаполнитьЗначенияСвойств(НоваяПодСтрока, Подстрока);
					НоваяПодСтрока.Представление	= ?(ЗначениеЗаполнено(Подстрока.Владелец), 
						Подстрока.Представление, НСтр("ru = '<Не выбран>'"));
					НоваяПодСтрока.ИндексКартинки	= 2;
					НоваяПодСтрока.ЭтоГруппа 		= Ложь;
					
				КонецЦикла;
				
			Иначе
				
				НоваяСтрока.ЭтоГруппа = Ложь;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимость()

	Если ВыводДереваВладельцев Тогда
	
		Элементы.ГруппаПанельНавигации.Видимость				= НЕ ПанельНавигацииСкрыта;
		КомандаИзменитьОтображениеПанелиНавигации = Команды.Найти("ИзменитьОтображениеПанелиНавигации");
		
		Если ПанельНавигацииСкрыта Тогда
			Элементы.ИзменитьОтображениеПанелиНавигации.Картинка = БиблиотекаКартинок.СтрелкаВправо;
			КомандаИзменитьОтображениеПанелиНавигации.Подсказка = НСтр("ru = 'Показать панель навигации'");
			КомандаИзменитьОтображениеПанелиНавигации.Заголовок = НСтр("ru = 'Показать панель навигации'");			
		Иначе
			Элементы.ИзменитьОтображениеПанелиНавигации.Картинка = БиблиотекаКартинок.СтрелкаВлево;
			КомандаИзменитьОтображениеПанелиНавигации.Подсказка = НСтр("ru = 'Скрыть панель навигации'");
			КомандаИзменитьОтображениеПанелиНавигации.Заголовок = НСтр("ru = 'Скрыть панель навигации'");			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаПанельНавигации.Видимость = Ложь;
		Элементы.ИзменитьОтображениеПанелиНавигации.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиПанелиНавигации()
	
	Если ПанельНавигацииСкрыта Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Владельцы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТекущиеДанные.ЭтоГруппа Тогда
		СЗ = Новый СписокЗначений;
		ПолучитьДочерниеЭлементы(ТекущиеДанные, СЗ);
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, 
			"Владелец", СЗ, , ВидСравненияКомпоновкиДанных.ВСписке);
	Иначе
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, 
			"Владелец", ТекущиеДанные.Владелец);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДочерниеЭлементы(Знач ТекущаяСтрока, СЗ)
	
	Для Каждого Стр Из ТекущаяСтрока.ПолучитьЭлементы() Цикл
		Если НЕ Стр.ЭтоГруппа Тогда
			СЗ.Добавить(Стр.Владелец);
		Иначе
			ПолучитьДочерниеЭлементы(Стр, СЗ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти