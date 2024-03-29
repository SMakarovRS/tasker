﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИмяАрхива;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьОписаниеВариантаОтчета();
	ПрочитатьПользовательскиеНастройки();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИмяАрхива = "ReportOptions.zip";
	
	Обработчик = Новый ОписаниеОповещения("ПослеУстановкиРасширенияРаботыСФайлами", ЭтотОбъект);
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Обработчик, ТекстПредложения());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ИмяФайла)
		И Не СтрЗаканчиваетсяНа(ИмяФайла, ".zip") Тогда 
		
		ИмяФайла = ИмяФайла + ".zip";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФайловаяСистемаКлиент.ВыбратьКаталог(Новый ОписаниеОповещения("ИмяФайлаПослеВыбораКаталога", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользовательскиеНастройки

&НаКлиенте
Процедура ПользовательскиеНастройкиПриИзменении(Элемент)
	
	ТекущиеПользовательскиеНастройки = ПользовательскиеНастройки.НайтиПоЗначению(КлючТекущихПользовательскихНастроек);
	Если ТекущиеПользовательскиеНастройки <> Неопределено Тогда 
		ТекущиеПользовательскиеНастройки.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	УпаковатьНастройкиВариантаОтчета();
	
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда 
		ИмяФайла = ИмяАрхива;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УпаковатьНастройкиВариантаОтчетаЗавершение", ЭтотОбъект);
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.ТекстПредложения = ТекстПредложения();
	ПараметрыСохранения.Диалог.Фильтр = НСтр("ru = 'Архив (*.zip)|*.zip'");
	ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Укажите файл'");
	ПараметрыСохранения.Диалог.ПолноеИмяФайла = ИмяФайла;
	
	ФайловаяСистемаКлиент.СохранитьФайл(Обработчик, АдресХранилищаАрхива, ИмяФайла, ПараметрыСохранения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользовательскиеНастройкиЗначение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользовательскиеНастройки.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
	ОтборЭлемента.ПравоеЗначение = "[ЭтоТекущиеНастройки]";
	
	ШрифтВажнойНадписи = Метаданные.ЭлементыСтиля.ВажнаяНадписьШрифт;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтВажнойНадписи.Значение);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ПредставлениеТекущихПользовательскихНастроек);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПользовательскиеНастройкиПометка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПользовательскиеНастройки.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит;
	ОтборЭлемента.ПравоеЗначение = "[ЭтоТекущиеНастройки]";
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписаниеВариантаОтчета()
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ВариантыОтчетовКлиентСервер.СвойстваСохраненияВариантаОтчета());
	
	Если ЗначениеЗаполнено(ИмяОтчета) Тогда 
		Возврат;
	КонецЕсли;
	
	ОписаниеВариантаОтчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ВариантОтчета, "Отчет, КлючВарианта, Представление, Настройки, ТипОтчета");
	
	Если ОписаниеВариантаОтчета.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный
		И Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда 
		
		Возврат;
	КонецЕсли;
	
	Если ОписаниеВариантаОтчета.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда 
		
		ИмяОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"ВнешнийОтчет.%1", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОписаниеВариантаОтчета.Отчет, "ИмяОбъекта"));
	Иначе
		МетаданныеОтчета = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ОписаниеВариантаОтчета.Отчет);
		ИмяОтчета = МетаданныеОтчета.ПолноеИмя();
	КонецЕсли;
	
	КлючТекущегоВарианта = ОписаниеВариантаОтчета.КлючВарианта;
	ПредставлениеТекущегоВарианта = ОписаниеВариантаОтчета.Представление;
	
	// Поиск текущих пользовательских настроек.
	Отбор = Новый Структура();
	Отбор.Вставить("КлючОбъекта", ИмяОтчета + "/" + КлючТекущегоВарианта + "/" + "КлючТекущихПользовательскихНастроек");
	Отбор.Вставить("Пользователь", ИмяПользователя());
	
	Выборка = ХранилищеСистемныхНастроек.Выбрать(Отбор);
	Если Выборка.Следующий() Тогда 
		КлючТекущихПользовательскихНастроек = Выборка.Настройки;
	КонецЕсли;
	
	НастройкиВариантаОтчета = ОписаниеВариантаОтчета.Настройки.Получить();
	Если НастройкиВариантаОтчета <> Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ОписаниеВариантаОтчета.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда 
		
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		Отчет = МодульДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(ОписаниеВариантаОтчета.Отчет);
	Иначе
		Отчет = ОтчетыСервер.ОтчетОбъект(ИмяОтчета);
	КонецЕсли;
	
	НастройкиВариантаОтчета = Отчет.СхемаКомпоновкиДанных.ВариантыНастроек[КлючТекущегоВарианта].Настройки;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПользовательскиеНастройки()
	
	Отбор = Новый Структура();
	Отбор.Вставить("КлючОбъекта", ИмяОтчета + "/" + КлючТекущегоВарианта);
	Отбор.Вставить("Пользователь", ИмяПользователя());
	
	Выборка = ХранилищеПользовательскихНастроекОтчетов.Выбрать(Отбор);
	Пока Выборка.Следующий() Цикл 
		
		ПользовательскиеНастройки.Добавить(Выборка.КлючНастроек, Выборка.Представление);
		ЗаполнитьЗначенияСвойств(ХранилищеПользовательскихНастроек.Добавить(), Выборка);
		
	КонецЦикла;
	
	ТекущиеПользовательскиеНастройки = ПользовательскиеНастройки.НайтиПоЗначению(КлючТекущихПользовательскихНастроек);
	Если ТекущиеПользовательскиеНастройки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредставлениеТекущихПользовательскихНастроек) Тогда 
		ПредставлениеТекущихПользовательскихНастроек = ТекущиеПользовательскиеНастройки.Представление;
	КонецЕсли;
	
	ТекущиеПользовательскиеНастройки.Пометка = Истина;
	ТекущиеПользовательскиеНастройки.Представление = ТекущиеПользовательскиеНастройки.Представление + " [ЭтоТекущиеНастройки]";
	
	Индекс = ПользовательскиеНастройки.Индекс(ТекущиеПользовательскиеНастройки);
	Если Индекс > 0 Тогда 
		ПользовательскиеНастройки.Сдвинуть(ТекущиеПользовательскиеНастройки, -Индекс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаПослеВыбораКаталога(Каталог, ДополнительныеПараметры) Экспорт 
	
	Если ЗначениеЗаполнено(Каталог) Тогда 
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог) + ИмяАрхива;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УпаковатьНастройкиВариантаОтчета()
	
	ИмяКаталога = ФайловаяСистема.СоздатьВременныйКаталог();
	
	Если Не ЗначениеЗаполнено(ИмяКаталога) Тогда 
		Возврат;
	КонецЕсли;
	
	ИмяКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталога);
	ИмяФайлаАрхива = ПолучитьИмяВременногоФайла("zip");
	
	Архив = Новый ЗаписьZipФайла(ИмяФайлаАрхива);
	
	ДобавитьНастройкиВАрхив(Архив, НастройкиВариантаОтчета, ИмяКаталога, "Settings");
	
	Счетчик = 0;
	Поиск = Новый Структура("КлючНастроек");
	
	Для Каждого ЭлементСписка Из ПользовательскиеНастройки Цикл 
		
		Если Не ЭлементСписка.Пометка Тогда 
			Продолжить;
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
		Поиск.КлючНастроек = ЭлементСписка.Значение;
		
		НайденныеНастройки = ХранилищеПользовательскихНастроек.НайтиСтроки(Поиск);
		ДобавитьНастройкиВАрхив(Архив, НайденныеНастройки[0].Настройки, ИмяКаталога, "UserSettings", Счетчик);
		
	КонецЦикла;
	
	ДобавитьОписаниеНастроекВАрхив(Архив, ИмяКаталога);
	
	Архив.Записать();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаАрхива);
	АдресХранилищаАрхива = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	
	ФайловаяСистема.УдалитьВременныйКаталог(ИмяКаталога);
	ФайловаяСистема.УдалитьВременныйФайл(ИмяФайлаАрхива);
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковатьНастройкиВариантаОтчетаЗавершение(Файлы, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(Файлы) = Тип("Массив")
		И Файлы.Количество() > 0 Тогда 
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вариант отчета сохранен в файл'"),, ИмяФайла);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНастройкиВАрхив(Архив, Настройки, ИмяКаталога, ТипНастроек, Суффикс = Неопределено)
	
	ИмяФайлаНастроек = ИмяКаталога + ТипНастроек + ?(Суффикс = Неопределено, "", Суффикс) + ".xml";
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайлаНастроек);
	
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Настройки, НазначениеТипаXML.Явное);
	
	ЗаписьXML.Закрыть();
	
	Архив.Добавить(ИмяФайлаНастроек);
	
КонецПроцедуры

// Добавляет в zip-архив xml-файл описания настроек варианта отчета, со следующей спецификацией:
//  <SettingsDescription ReportName="Отчет._ДемоФайлы">
//  	<Settings Key="50a4127a-7646-49b3-9d09-51681e6e16b9" Presentation="Демо: Версии файлов"/>
//  	<UserSettings Key="a61e745b-ac46-46d3-92a6-5bba4969b7d2" Presentation="Файлы > 100 Кб" isCurrent="true"/>
//  	<UserSettings Key="6895ac09-f02d-4b17-82b6-79dd76c7b2a3" Presentation="Файлы > 10 Мб" isCurrent="false"/>
//  </SettingsDescription>
//
// Параметры:
//  Архив - ЗаписьZipФайла - архив, в который упаковываются настройки варианта отчета и их описание.
//  ИмяКаталога - Строка - имя временного каталога, содержащего xml-файлы настроек варианта отчета и их описание.
//
&НаСервере
Процедура ДобавитьОписаниеНастроекВАрхив(Архив, ИмяКаталога)
	
	ИмяФайлаОписанияНастроек = ИмяКаталога + "SettingsDescription.xml";
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайлаОписанияНастроек);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("SettingsDescription");
	
		ЗаписьXML.ЗаписатьАтрибут("ReportName", ИмяОтчета);
	
		ЗаписьXML.ЗаписатьНачалоЭлемента("Settings");
		
			ЗаписьXML.ЗаписатьАтрибут("Key", КлючТекущегоВарианта);
			ЗаписьXML.ЗаписатьАтрибут("Presentation", ПредставлениеТекущегоВарианта);
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // <Settings>
	
		Для Каждого ЭлементСписка Из ПользовательскиеНастройки Цикл 
			
			Если Не ЭлементСписка.Пометка Тогда 
				Продолжить;
			КонецЕсли;
			
			ПредставлениеНастройки = СокрЛП(СтрЗаменить(ЭлементСписка.Представление, "[ЭтоТекущиеНастройки]", ""));
			ЭтоТекущиеНастройки = ПредставлениеНастройки = ПредставлениеТекущихПользовательскихНастроек;
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("UserSettings");
			
			ЗаписьXML.ЗаписатьАтрибут("Key", ЭлементСписка.Значение);
			ЗаписьXML.ЗаписатьАтрибут("Presentation", ПредставлениеНастройки);
			ЗаписьXML.ЗаписатьАтрибут("isCurrent", XMLСтрока(ЭтоТекущиеНастройки));
			
			ЗаписьXML.ЗаписатьКонецЭлемента(); // <UserSettings>
			
		КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); // <SettingsDescription>
	ЗаписьXML.Закрыть();
	
	Архив.Добавить(ИмяФайлаОписанияНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиРасширенияРаботыСФайлами(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено = Истина Тогда 
		
		Обработчик = Новый ОписаниеОповещения("ПослеПолученияКаталогаДокументов", ЭтотОбъект);
		НачатьПолучениеКаталогаДокументов(Обработчик);
		
	ИначеЕсли Не ЗначениеЗаполнено(ИмяФайла) Тогда 
		
		ИмяФайла = ИмяАрхива;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияКаталогаДокументов(ИмяКаталогаДокументов, ДополнительныеПараметры) Экспорт 
	
	Если ЗначениеЗаполнено(ИмяКаталогаДокументов) Тогда 
		ИмяФайла = ИмяКаталогаДокументов + ИмяАрхива;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ТекстПредложения()
	
	Возврат НСтр("ru = 'Для сохранения варианта отчета в файл рекомендуется
		|установить расширение для работы с файлами.'");
	
КонецФункции

#КонецОбласти