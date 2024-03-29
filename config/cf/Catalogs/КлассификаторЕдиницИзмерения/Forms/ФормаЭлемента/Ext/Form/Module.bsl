﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// При вызове из классификатора.
	Если Параметры.Свойство("Код") Тогда
		Объект.Код = Параметры.Код;
	КонецЕсли;	
	
	Если Параметры.Свойство("Наименование") Тогда
		Объект.Наименование = Параметры.Наименование;
	КонецЕсли;
	
	Если Параметры.Свойство("МеждународноеСокращение") Тогда
		Объект.МеждународноеСокращение = Параметры.МеждународноеСокращение;
	КонецЕсли;
	
	Если Параметры.Свойство("НаименованиеПолное") Тогда
		Объект.НаименованиеПолное = Параметры.НаименованиеПолное;
	КонецЕсли;	
	
КонецПроцедуры // ПриСозданииНаСервере()
