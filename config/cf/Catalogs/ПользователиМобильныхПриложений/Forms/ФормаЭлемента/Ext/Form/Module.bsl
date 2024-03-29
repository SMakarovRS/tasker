﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда		
		Возврат;		
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ФорматыПередаваемыхФайлов) Тогда 
		Объект.ФорматыПередаваемыхФайлов = СписокФорматовФайловПередаваемыхНаМобильныйКлиент();
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ОграничениеПередаваемыхФайловПоРазмеру	= Истина;
		Объект.МаксимальныйРазмерФайлов 				= 1;
		Объект.ОграничениеФорматовПередаваемыхФайлов	= Ложь;		
		Объект.СрокУстареванияДанных					= 14;
		Объект.ПодробныйЖурналРаботы					= Ложь;
	КонецЕсли;	
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Пользователь) Тогда
		Элементы.Пользователь.КнопкаВыпадающегоСписка = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОписаниеОшибки = ПроверитьПользователяНаСервере(Объект.Пользователь);
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(, ОписаниеОшибки);			
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = ПроверитьПользователяНаСервере(Объект.Пользователь);
	
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(, ОписаниеОшибки);
		Объект.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		Возврат;
	КонецЕсли;	
	
	Объект.Наименование = Строка(Объект.Пользователь);			
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПользователяНаСервере(Знач ПользовательПрограммы)
	
	Возврат ОбменМобильноеПриложениеСервер.ТекстОшибкиПроверкиПользователя(ПользовательПрограммы);
	
КонецФункции	

&НаКлиенте
Процедура ИспользоватьФильтрыПриИзменении(Элемент)	
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничитьПередаваемыеФайлыПоРазмеруПриИзменении(Элемент)
	
	Элементы.МаксимальныйРазмерПередаваемогоФайла.Доступность = Объект.ОграничениеПередаваемыхФайловПоРазмеру;
	Если НЕ Объект.ОграничениеПередаваемыхФайловПоРазмеру Тогда
		Объект.МаксимальныйРазмерФайлов = 0;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьПередаваемыеНаКлиентФайлыПриИзменении(Элемент)
	
	Элементы.ФорматыПередаваемыхФайлов.Доступность = Объект.ОграничениеФорматовПередаваемыхФайлов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаМобильныхКлиентов(Команда)
	
	Если Объект.Ссылка.Пустая() ИЛИ Модифицированность Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для получения QR - кода необходимо записать настройки пользователя.'"));
	Иначе		
		
		Если ЗначениеЗаполнено(Объект.Пользователь) Тогда
			ОписаниеОшибки = ПроверитьПользователяНаСервере(Объект.Пользователь);
			
			Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
				ПоказатьПредупреждение(, ОписаниеОшибки);			
				Возврат;
			КонецЕсли;
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ПользовательМП", Объект.Пользователь); 
			ОткрытьФорму("ОбщаяФорма.ФормаНастройкиПодключенияМобильныхКлиентов", ПараметрыФормы);
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Элементы.СтраницаОрганизации.ТолькоПросмотр  			  = НЕ Объект.ИспользоватьФильтры;
	Элементы.СтраницаИнициаторы.ТолькоПросмотр  			  = НЕ Объект.ИспользоватьФильтры;	
	Элементы.СтраницаИсполнители.ТолькоПросмотр 			  = НЕ Объект.ИспользоватьФильтры;
	Элементы.МаксимальныйРазмерПередаваемогоФайла.Доступность = Объект.ОграничениеПередаваемыхФайловПоРазмеру; 
	Элементы.ФорматыПередаваемыхФайлов.Доступность			  = Объект.ОграничениеФорматовПередаваемыхФайлов;
	
КонецПроцедуры

&НаСервере
Функция СписокФорматовФайловПередаваемыхНаМобильныйКлиент()

	Массив = Новый Массив();
	Массив.Добавить("txt log ini");
	Массив.Добавить("ico wmf emf");
	Массив.Добавить("htm html url mht mhtml");
	Массив.Добавить("doc docx dot rtf xls xlsx ppt pptx");
	Массив.Добавить("jpg jpeg jp2 jpe bmp dib tif tiff gif png");
	Массив.Добавить("pdf");
	Массив.Добавить("odt odf odp odg ods");

	Возврат ВРег(СтрСоединить(Массив, " "));

КонецФункции

#КонецОбласти
