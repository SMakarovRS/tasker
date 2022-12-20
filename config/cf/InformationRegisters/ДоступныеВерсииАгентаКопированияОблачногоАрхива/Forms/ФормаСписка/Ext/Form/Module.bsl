﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РазрешенаРаботаСОблачнымАрхивом = ОблачныйАрхив.РазрешенаРаботаСОблачнымАрхивом();
	Если РазрешенаРаботаСОблачнымАрхивом = Ложь Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗагрузитьЗначенияПоУмолчанию(Команда)

	КомандаЗагрузитьЗначенияПоУмолчаниюНаСервере();
	Элементы.Список.Обновить();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КомандаЗагрузитьЗначенияПоУмолчаниюНаСервере()

	РегистрыСведений.ДоступныеВерсииАгентаКопированияОблачногоАрхива.ЗагрузитьСтандартныеЗначения();

КонецПроцедуры

#КонецОбласти
