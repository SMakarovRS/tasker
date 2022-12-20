﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
// Процедура вставляет текст, передаваемый в качестве параметра в поле 
// табличного документа.
//
Процедура ВставитьТекстВФормулу(Показатель)
	
	ТекстФормулы = ТекстФормулы + " [" + СокрЛП(Показатель) + "] ";
			
КонецПроцедуры // ВставитьТекстВФормулу()

&НаСервереБезКонтекста
// Функция получает идентификатор показателя.
//
Функция ПолучитьИдентификаторПоказателя(СтруктураДанных)
	
	Возврат СокрЛП(СтруктураДанных.ВыбраннаяСтрока.Идентификатор);

КонецФункции // ПолучитьИдентификаторПоказателя()

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТекстФормулы") Тогда
		
		ТекстФормулы = Параметры.ТекстФормулы;
		
	КонецЕсли;	
	
КонецПроцедуры // ПриСозданииНаСервере()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ (КНОПКИ)

&НаКлиенте
// Процедура - обработчик нажатия кнопки ОК
//
Процедура КомандаОК(Команда)
	
	Закрыть(ТекстФормулы);
	
КонецПроцедуры // КомандаОКВыполнить()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА ПАРАМЕТРЫ РАСЧЕТОВ

&НаКлиенте
// Процедура - обработчик события Выбор динамического списка ПараметрыТоваров.
//
Процедура ПараметрыРасчетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураДанных = Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока);
	
	ТекстВФормулу = ПолучитьИдентификаторПоказателя(СтруктураДанных);
    ВставитьТекстВФормулу(ТекстВФормулу);
	
КонецПроцедуры // ПараметрыРасчетовВыбор()

