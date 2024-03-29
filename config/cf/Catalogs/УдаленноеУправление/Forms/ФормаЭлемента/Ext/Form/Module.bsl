﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		ТипПодключенияПриИзменении(Неопределено);
		Если ЗначениеЗаполнено(Объект.Владелец) Тогда
			ОбъектПриИзменении(Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьИтоговуюСтрокуЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УдаленноеУправление");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
    УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	
	ОбъектПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	Если Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.AnyDesk") Тогда
		Объект.ПараметрыЗапуска = "";
		Объект.Порт = 7070;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.LiteManager") Тогда
		Объект.ПараметрыЗапуска = "/FULLCONTROL";
		Объект.Порт = 5650;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.RAdmin") Тогда
		Объект.ПараметрыЗапуска = "";
		Объект.Порт = 4899;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.DameWareMiniRemoteControl") Тогда
		Объект.ПараметрыЗапуска = "";
		Объект.Порт = 6129;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.UltraVNC") Тогда
		Объект.ПараметрыЗапуска = "-connect";
		Объект.Порт = 5900;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.RemoteManipulatorSystem") Тогда
		Объект.ПараметрыЗапуска = "/fullcontrol";
		Объект.ПолеБулево1 = Ложь;
		Объект.Порт = 5650;
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.AeroAdmin") Тогда
		Объект.ПараметрыЗапуска = "";
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.RDP") Тогда
		Объект.Порт = 3389;
		Объект.ПараметрыЗапуска = "";
	ИначеЕсли Объект.ТипПодключения = ПредопределенноеЗначение("Перечисление.ТипыПодключений.AmmyAdmin") Тогда
		Объект.ПараметрыЗапуска = "";
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	ОбновитьИтоговуюСтрокуЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитПриИзменении(Элемент)
	
	ОбновитьИтоговуюСтрокуЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапускаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФорму("Справочник.ШаблоныПараметровЗапускаУдаленногоУправления.ФормаВыбора",,,,, 
		,Новый ОписаниеОповещения("ПараметрыЗапускаНачалоВыбораЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапускаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено 
		И ТипЗнч(Результат) = Тип("СправочникСсылка.ШаблоныПараметровЗапускаУдаленногоУправления") Тогда
		
		Объект.ПараметрыЗапуска = ПолучитьТекстШаблона(Результат);
		ОбновитьИтоговуюСтрокуЗапуска();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Запустить(Команда)
	
	Настройка = Новый Структура();
	Настройка.Вставить("Объект", Объект);
	
	ПараметрыЗапуска    = Новый Структура;
	ОписаниеОповоещения = Новый ОписаниеОповещения("ВыполнитьПослеЗапуска", ЭтотОбъект, ПараметрыЗапуска);
	УдаленноеУправлениеКлиент.ЗапуститьУдаленноеУправление(ОписаниеОповоещения, Настройка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗапуска(П1, П2) Экспорт
	
	// ТУТ НИЧЕГО.
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипПодключения) Тогда
		
		Элементы.Страницы.Видимость = Ложь;
		Элементы.ФормаЗапустить.Картинка = Неопределено;
		
	Иначе
		
		Элементы.Страницы.Видимость = Истина;
		ТекущаяСтраница = ПредставлениеПеречисления(Объект.ТипПодключения);
		Элементы.Страницы.ТекущаяСтраница = Элементы[ТекущаяСтраница];
		Элементы.ФормаЗапустить.Картинка = БиблиотекаКартинок[ТекущаяСтраница];
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеПеречисления(Знач ТипПеречисления)
	
	Возврат Метаданные.Перечисления.ТипыПодключений.ЗначенияПеречисления.Получить(
		Перечисления.ТипыПодключений.Индекс(ТипПеречисления)).Имя;
	
КонецФункции

&НаСервере
Процедура ОбъектПриИзмененииНаСервере()
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Строка(Объект.Владелец);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИтоговуюСтрокуЗапуска()
	
	Настройка = Новый Структура("ТипПодключения,АдресПодключения,Логин,Пароль,ПараметрыЗапуска,Порт");
	ЗаполнитьЗначенияСвойств(Настройка, Объект);
	Настройка.Вставить("Объект", Объект);
	Настройка.Вставить("СкрыватьПароль", Истина);
	
	ИтоговаяСтрокаЗапуска = УдаленноеУправлениеКлиент.ИтоговаяСтрокаЗапуска(Настройка);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстШаблона(Знач ШаблонСсылка)
	
	Возврат ?(ЗначениеЗаполнено(ШаблонСсылка), ШаблонСсылка.ТекстШаблона, "");
	
КонецФункции

#КонецОбласти