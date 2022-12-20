﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СписокЗаданий, "Задания");
	Вариант.Описание = НСтр("ru = 'Информация о заданиях'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СписокЗаданий, "ПоПодразделениям");
	Вариант.Описание = НСтр("ru = 'Информация о заданиях (в разрезе подразделений)'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СписокЗаданий, "ПоИнициаторам");
	Вариант.Описание = НСтр("ru = 'Информация о заданиях (в разрезе инициаторов)'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СписокЗаданий, "ПоСпринтам");
	Вариант.Описание = НСтр("ru = 'Информация о заданиях (в разрезе спринтов)'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СписокЗаданий, "Планирование");
	Вариант.Описание = НСтр("ru = 'Информация о заданиях (для планирования выполнения)'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли