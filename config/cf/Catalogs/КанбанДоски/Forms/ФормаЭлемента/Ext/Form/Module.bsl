﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БазовыеЦвета = ЗначениеИзСтрокиВнутр(ПолучитьОбщийМакет("БазовыеЦвета").ПолучитьТекст());
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ТипФона = Перечисления.ТипФонаКанбанДоски.ЦветФона;
		Объект.ЦветФона = "#FAFAFA";
	КонецЕсли;
	
	Попытка
		РедактируемыйЦветФона = РаботаСЦветомКлиентСервер.HexВЦвет(Объект.ЦветФона);
	Исключение
		РедактируемыйЦветФона = РаботаСЦветомКлиентСервер.HexВЦвет("#FAFAFA");
	КонецПопытки;
	
	ОбновитьИзображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    
    Оповестить("Запись_ИсточникКанбанДоски");
    
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ЦветФона  = РаботаСЦветомКлиентСервер.ЦветВHex(РедактируемыйЦветФона);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Результат = Неопределено;

	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("РедактируемыйЦветНачалоВыбораЗавершение2", ЭтотОбъект), БазовыеЦвета,
		Элемент, БазовыеЦвета.НайтиПоЗначению(РедактируемыйЦветФона));
	
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбораЗавершение2(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Результат = ВыбранныйЭлемент;
    Если Результат <> Неопределено Тогда
        
        Если ТипЗнч(Результат.Значение) = Тип("Строка") Тогда
            ПараметрыФормы = Новый Структура("РедактируемыйЦвет", РедактируемыйЦветФона);
            ОткрытьФорму("ОбщаяФорма.ФормаВыбораЦвета", ПараметрыФормы, Элементы.РедактируемыйЦветФона,,,,
				Новый ОписаниеОповещения("РедактируемыйЦветНачалоВыбораЗавершение", ЭтотОбъект,
					Новый Структура("Результат", Результат)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
            Возврат;
        Иначе
            РедактируемыйЦветФона = Результат.Значение;
        КонецЕсли;
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбораЗавершение(Результат1, ДополнительныеПараметры) Экспорт

    Результат = ДополнительныеПараметры.Результат;

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Цвет") Тогда
		РедактируемыйЦветФона = ВыбранноеЗначение;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьИзФайла(Команда)
	
	ВыбратьКартинкуИзФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение2(Подключено, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = ДополнительныеПараметры.АдресВременногоХранилища;
	
	
	Если Подключено Тогда
		Режим = РежимДиалогаВыбораФайла.Открытие;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = УправлениеITОтделом8УФКлиентСервер.ПолучитьФильтрИзображений();
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите изображение'");
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение1", ЭтотОбъект,
			Новый Структура("АдресВременногоХранилища, ДиалогОткрытияФайла", АдресВременногоХранилища, ДиалогОткрытияФайла)));
	Иначе		
		ПоказатьПредупреждение(,НСтр("ru = 'Данная возможность недоступна, так как не подключено расширение работы с файлами.'", "ru"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение1(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = ДополнительныеПараметры.АдресВременногоХранилища;
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ВыбранноеИмя = ДиалогОткрытияФайла.ПолноеИмяФайла;
		НачатьПомещениеФайла(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение", ЭтотОбъект, 
			Новый Структура("АдресВременногоХранилища", АдресВременногоХранилища)), 
			АдресВременногоХранилища, ВыбранноеИмя, Ложь,);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение(Результат, Адрес, ВыбранноеИмя, ДополнительныеПараметры) Экспорт
    
    Если Результат Тогда
        ПоместитьФайлОбъекта(Адрес);
        Элементы.АдресИзображения.Обновить();			
		ОбновитьИзображение();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	ОчиститьИзображениеНаСервере();	
	ОбновитьИзображение();
	Элементы.АдресИзображения.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппы

&НаКлиенте
Процедура ГруппыГруппаПриИзменении(Элемент)
    
    ТекущиеДанные = Элементы.Группы.ТекущиеДанные;
    Если ТекущиеДанные = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(ТекущиеДанные.Сортировка) Тогда
        ТекущиеДанные.Сортировка = ПредопределенноеЗначение("Перечисление.СортировкаКанбанДоски.Авто");
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьКартинкуИзФайла()
	
	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;

	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение2", ЭтотОбъект, 
		Новый Структура("АдресВременногоХранилища", АдресВременногоХранилища)));
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьИзображениеНаСервере()
	
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ЭлементСправочника.Изображение = Неопределено;
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИзображение()
	
	АдресИзображения = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Изображение")
	
КонецПроцедуры

// Процедура извлекает данные объекта из временного хранилища, 
// производит модификацию элемента справочника и записывает его.
// 
// Параметры: 
//  АдресВременногоХранилища - Строка - адрес временного хранилища. 
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура ПоместитьФайлОбъекта(АдресВременногоХранилища)
	
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементСправочника.Изображение = Новый ХранилищеЗначения(ДвоичныеДанные);
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");
	
КонецПроцедуры

#КонецОбласти
