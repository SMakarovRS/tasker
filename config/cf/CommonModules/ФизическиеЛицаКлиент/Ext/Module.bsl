﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция определяет пол физлица по его отчеству
// Параметр:
// 		ОтчествоРаботника - отчество работника
//
Функция ОпределитьПолПоОтчеству(ОтчествоРаботника) Экспорт
	
	Если Прав(ОтчествоРаботника, 2) = "ич" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской");
	ИначеЕсли Прав(ОтчествоРаботника, 2) = "на" Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский");
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ОпределитьПолПоОтчеству()
