﻿
&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеСведения.Объект КАК Объект,
		|	ДополнительныеСведения.Свойство КАК Свойство,
		|	ДополнительныеСведения.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|ГДЕ
		|	ДополнительныеСведения.Свойство = &Свойство ИЛИ &Свойство = НЕОПРЕДЕЛЕНО";
	
	Запрос.УстановитьПараметр("Свойство", ?(ЗначениеЗаполнено(Свойство), Свойство, Неопределено));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДополнительныеСведения.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	ОбновитьСписокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСписокНаСервере()
КонецПроцедуры

&НаСервере
Процедура ДополнительныеСведенияПриИзмененииНаСервере()
	
	ТекущаяСтрока = ДополнительныеСведения.НайтиПоИдентификатору(Элементы.ДополнительныеСведения.ТекущаяСтрока);
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.Объект) 
		ИЛИ Не ЗначениеЗаполнено(ТекущаяСтрока.Свойство)
		ИЛИ Не ЗначениеЗаполнено(ТекущаяСтрока.Значение) Тогда
		Возврат;
	КонецЕсли;
	
	МЗ = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	МЗ.Объект = ТекущаяСтрока.Объект;
	МЗ.Свойство = ТекущаяСтрока.Свойство;
	МЗ.Значение = ТекущаяСтрока.Значение;
	МЗ.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСведенияПриИзменении(Элемент)
	ДополнительныеСведенияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДополнительныеСведенияПередУдалениемНаСервере(СтруктураСтроки)
	
	МЗ = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	МЗ.Объект = СтруктураСтроки.Объект;
	МЗ.Свойство = СтруктураСтроки.Свойство;
	МЗ.Значение = СтруктураСтроки.Значение;
	МЗ.Удалить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСведенияПередУдалением(Элемент, Отказ)
	
	ТекущаяСтрока = ДополнительныеСведения.НайтиПоИдентификатору(Элементы.ДополнительныеСведения.ТекущаяСтрока);
	
	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Объект",ТекущаяСтрока.Объект);
	СтруктураСтроки.Вставить("Свойство",ТекущаяСтрока.Свойство);
	СтруктураСтроки.Вставить("Значение",ТекущаяСтрока.Значение);
	
	ДополнительныеСведенияПередУдалениемНаСервере(СтруктураСтроки);
КонецПроцедуры

&НаКлиенте
Процедура СвойствоПриИзменении(Элемент)
	ОбновитьСписокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСведенияСвойствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	
	
КонецПроцедуры
