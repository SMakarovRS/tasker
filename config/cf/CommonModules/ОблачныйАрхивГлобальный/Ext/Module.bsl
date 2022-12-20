﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивГлобальный.
//
// Все глобальные клиентские процедуры и функции для работы с "Облачным архивом".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ПриНачалеРаботыСистемы

// Процедура проверяет свойства Облачного архива, которые должны регулярно проверяться на клиенте.
// Первый запуск (ОблачныйАрхив_ЗаполнитьПараметрыКлиента_ПервыйЗапуск) осуществляется через 2 минуты после старта (можно переопределить),
//  а затем проверяется каждые 6 часов (ОблачныйАрхив_ЗаполнитьПараметрыКлиента_Регулярно, можно переопределить).
//
Процедура ОблачныйАрхив_ЗаполнитьПараметрыКлиента_ПервыйЗапуск() Экспорт

	ТипЧисло = Тип("Число");

	// Данные по клиенту и из веб-сервисов собираются отдельно и сохраняются в базе.
	// На клиенте необходимо только проверять сохраненные ранее данные с контрольными значениями.

	Если ОблачныйАрхивКлиентПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда

		// Список данных, необходимых на клиенте немедленно:
		// - ПодсистемаНастроена.
		ПараметрыОкруженияСервер = ОблачныйАрхивВызовСервера.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");
		Если ПараметрыОкруженияСервер.ПодсистемаНастроена = 0 Тогда // Не настроена.
			// Подключить оповещение, что надо настроить систему. ////! Реализовать.
		КонецЕсли;

		ОблачныйАрхивКлиент.ЗаполнитьРасписаниеСозданияРезервныхКопий(ОбщегоНазначенияКлиент.ДатаСеанса());

		// Подключить обработчик проверки остальных параметров на клиенте, каждые 6 часов.
		ОтключитьОбработчикОжидания("ОблачныйАрхив_ЗаполнитьПараметрыКлиента_Регулярно");
		ИнтервалСекунд = 6*60*60; // Каждые 6 часов
		ОблачныйАрхивКлиентПереопределяемый.ПереопределитьВремяРегулярногоЗаполненияПараметровКлиента(ИнтервалСекунд);
		Если (ТипЗнч(ИнтервалСекунд) <> ТипЧисло)
				ИЛИ (ИнтервалСекунд <= 0) Тогда
			ИнтервалСекунд = 6*60*60; // Каждые 6 часов
		КонецЕсли;
		ПодключитьОбработчикОжидания("ОблачныйАрхив_ЗаполнитьПараметрыКлиента_Регулярно", ИнтервалСекунд, Ложь);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// Процедура проверяет свойства Облачного архива, которые должны регулярно проверяться на клиенте.
// Первый запуск (ОблачныйАрхив_ЗаполнитьПараметрыКлиента_ПервыйЗапуск) осуществляется через 2 минуты после старта (можно переопределить),
//  а затем проверяется каждые 6 часов (ОблачныйАрхив_ЗаполнитьПараметрыКлиента_Регулярно, можно переопределить).
//
Процедура ОблачныйАрхив_ЗаполнитьПараметрыКлиента_Регулярно() Экспорт

	// Данные по клиенту и из веб-сервисов собираются отдельно и сохраняются в базе.
	// На клиенте необходимо только проверять сохраненные ранее данные с контрольными значениями.

	Если ОблачныйАрхивКлиентПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда

		// Список данных, которые необходимо регулярно обновлять на клиенте:
		// ////? - ИнформацияОКлиенте.
		// - Расписание создания резервных копий.
		ОблачныйАрхивКлиент.ЗаполнитьРасписаниеСозданияРезервныхКопий(ОбщегоНазначенияКлиент.ДатаСеанса());

	КонецЕсли;

КонецПроцедуры

// Процедура проверяет необходимость выхода, чтобы сделать резервную копию в Облачный архив.
//
Процедура ПроверитьНеобходимостьВыходаДляСозданияРезервнойКопииВОблачныйАрхив_Регулярно() Экспорт

	ОблачныйАрхивКлиент.ПроверитьНеобходимостьВыходаДляСозданияРезервнойКопииВОблачныйАрхив(ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

#КонецОбласти

#КонецОбласти