﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗаписью;

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда     
		Возврат;
	КонецЕсли;

	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();

	#Если Не ВебКлиент Тогда
	Объект.ИмяКомпьютера = ИмяКомпьютера();
	#КонецЕсли
	
	Элементы.Оборудование.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПустаяСтрока(Объект.Код) Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		Объект.Код = ВРег(СистемнаяИнформация.ИдентификаторКлиента);
	КонецЕсли;
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Место = ТекущийОбъект.Ссылка;
	
	СписокУстройств = МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам( , , Место);
	Для Каждого Элемент Из СписокУстройств Цикл
		Если Элемент.РабочееМесто = Место Тогда
			ЛокальноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
		КонецЕсли;
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверкаУникальностиПоИдентификаторуКлиента()Тогда
		Отказ = Истина;
		Текст = НСтр("ru='Ошибка сохранение рабочего места.
					|Рабочее место с таким идентификатором клиента уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		Возврат;
	КонецЕсли;
	
	Если Не ПроверкаУникальностиПоНаименованию()Тогда
		Если ОтветПередЗаписью <> Истина Тогда
			Отказ = Истина;
			Текст = НСтр("ru='Указано неуникальное наименование рабочего места.
						|Возможно в дальнейшем это затруднит идентификацию и выбор рабочего места.
						|Рекомендуется указывать уникальное наименование рабочих мест.
						|Продолжить сохранение с указанным наименованием?'");
			Оповещение = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		Записать();
	КонецЕсли;  
	
КонецПроцедуры 
   
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	
	Если Объект.Код = ВРег(СистемнаяИнформация.ИдентификаторКлиента) Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	МенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверкаУникальностиПоНаименованию()
	
	Результат = Истина;
	
	Если Не ПустаяСтрока(Объект.Наименование) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.РабочиеМеста КАК РабочиеМеста
		|ГДЕ
		|    РабочиеМеста.Наименование = &Наименование
		|    И РабочиеМеста.Ссылка <> &Ссылка
		|");
		Запрос.УстановитьПараметр("Наименование", Объект.Наименование);
		Запрос.УстановитьПараметр("Ссылка"      , Объект.Ссылка);
		Результат = Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПроверкаУникальностиПоИдентификаторуКлиента()
	
	Результат = Истина;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = ВРег(СистемнаяИнформация.ИдентификаторКлиента);
	
	Если Не ПустаяСтрока(Объект.Код) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.РабочиеМеста КАК РабочиеМеста
		|ГДЕ
		|    РабочиеМеста.Код = &Код
		|    И РабочиеМеста.Ссылка <> &Ссылка
		|");
		Запрос.УстановитьПараметр("Код"    , ИдентификаторКлиента);
		Запрос.УстановитьПараметр("Ссылка" , Объект.Ссылка);
		Результат = Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьКартинку(ТипОборудования, Размер)
	
	Попытка // Может прийти пустая ссылка или неопределено, может не быть картинки.
		МетаОбъект  = ТипОборудования.Метаданные();
		Индекс      = Перечисления.ТипыПодключаемогоОборудования.Индекс(ТипОборудования);
		ИмяКартинки = МетаОбъект.ЗначенияПеречисления[Индекс].Имя;
		ИмяКартинки = "ПодключаемоеОборудование" + ИмяКартинки + Размер;
		Картинка = БиблиотекаКартинок[ИмяКартинки]
	Исключение
		Картинка = Неопределено;
	КонецПопытки;
	
	Возврат Картинка;
	
КонецФункции

#КонецОбласти