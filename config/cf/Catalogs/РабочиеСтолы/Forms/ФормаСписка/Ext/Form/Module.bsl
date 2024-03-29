﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСПодчиненными(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;		
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда		
		ДопПараметры 		= Новый Структура("РабочийСтолСсылка", ТекущиеДанные.Ссылка);		
		ОписаниеОповещения 	= Новый ОписаниеОповещения("ПослеВопросаСкопироватьРабочийСтол", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, 
			СтрШаблон(НСтр("ru = 'Рабочий стол (%1) и все его подчиненные элементы будут скопированы.
			|Это может занять некоторое время. Продолжить?'"), ТекущиеДанные.Ссылка), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРабочийСтол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("РабочийСтолСсылка", ТекущиеДанные.Ссылка);
		ОткрытьФорму("Обработка.РабочийСтол.Форма.ФормаРабочегоСтола", ПараметрыФормы);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортЭкспорт(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ТекущиеДанные	= Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			ПараметрыФормы.Вставить("РабочийСтол", ТекущиеДанные.Ссылка);
		КонецЕсли;	
	КонецЕсли;	
	
	ОткрытьФорму("Справочник.РабочиеСтолы.Форма.ФормаИмпортаЭкспорта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредопределенный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаЗаполнитьПредопределенныйРабочийСтол", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Предопределенный рабочий стол будет заполнен настройками по умолчанию.
										| Это может занять некоторое время. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВопросаЗаполнитьПредопределенныйРабочийСтол(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ЗаполнитьПредопределенныйРабочийСтолНаСервере();
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания       = Истина;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ТекстСообщения 			 = 
						НСтр("ru = 'Идет заполнение рабочего стола по умолчанию. Это может занять некоторое время'");
		ПараметрыОжидания.Интервал             		 = 2;
		ОповещениеОЗавершении 						 = Новый ОписаниеОповещения("ПослеЗавершенияВыполненияСервернойКомандыВФоне", 
																				ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПредопределенныйРабочийСтолНаСервере()
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "ЗаполнитьПредопределенныйРабочийСтолФоновымЗаданием";
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;		
	ПараметрыЗадания 								= Новый Структура;	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
			"Справочники.РабочиеСтолы.ЗаполнитьРабочийСтолПриПервоначальномЗаполнении",
			ПараметрыЗадания, ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияВыполненияСервернойКомандыВФоне(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить элементы справочника по причине:
				|%1.'"), Результат.КраткоеПредставлениеОшибки);
	Иначе
		Элементы.Список.Обновить();
		ПоказатьПредупреждение(, НСтр("ru = 'Заполнение элементов справочника завершено.'"));		
		
	КонецЕсли;		
			
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаСкопироватьРабочийСтол(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	НовыйРабочийСтол = СкопироватьРабочийСтолНаСервере(ДополнительныеПараметры.РабочийСтолСсылка);
	Элементы.Список.Обновить();
	ПоказатьЗначение(, НовыйРабочийСтол);
	
КонецПроцедуры

&НаСервере
Функция СкопироватьРабочийСтолНаСервере(Знач РабочийСтолСсылка)
	
	ОбъектКопирования 		= РабочийСтолСсылка.ПолучитьОбъект();
	НовыйРабочийСтолОбъект 	= ОбъектКопирования.Скопировать();	
	НовыйРабочийСтолОбъект.Записать();
	НовыйРабочийСтол 		= НовыйРабочийСтолОбъект.Ссылка;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Виджеты.Ссылка КАК Ссылка,
		|	Виджеты.Родитель КАК Родитель
		|ИЗ
		|	Справочник.Виджеты КАК Виджеты
		|ГДЕ
		|	НЕ Виджеты.ПометкаУдаления
		|	И Виджеты.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("Владелец", РабочийСтолСсылка);	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат НовыйРабочийСтол;
	КонецЕсли;
	
	СоответствиеЭлементов = Новый Соответствие;	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
			Предок = СоответствиеЭлементов[Выборка.Родитель];
		Иначе
			Предок = Справочники.Виджеты.ПустаяСсылка();
		КонецЕсли;	
		
		ТекСпр = Выборка.Ссылка.ПолучитьОбъект();
		НовыйВиджет 			= ТекСпр.Скопировать();
		НовыйВиджет.Владелец	= НовыйРабочийСтол;
		НовыйВиджет.Родитель 	= Предок;	 
		НовыйВиджет.Записать();
		СоответствиеЭлементов.Вставить(Выборка.Ссылка, НовыйВиджет.Ссылка);				
		
	КонецЦикла;
	
	// Возвращаем реквизит доп.упорядочивания.
	Для Каждого КлючИЗначение Из СоответствиеЭлементов Цикл
		Если КлючИЗначение.Ключ.РеквизитДопУпорядочивания <> КлючИЗначение.Значение.РеквизитДопУпорядочивания Тогда
			ВиджетОбъект = КлючИЗначение.Значение.ПолучитьОбъект();
			ВиджетОбъект.РеквизитДопУпорядочивания 	= КлючИЗначение.Ключ.РеквизитДопУпорядочивания;
			ВиджетОбъект.ОбменДанными.Загрузка 		= Истина;
			ВиджетОбъект.Записать();
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат НовыйРабочийСтол;
	
КонецФункции

#КонецОбласти