﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДополнительныеДанные = Неопределено;
	
	ОбменДаннымиСервер.ФормаНастройкиЗначенийПоУмолчаниюБазыКорреспондентаПриСозданииНаСервере(
		ЭтотОбъект,
		Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Имя,
		ДополнительныеДанные);
		
	Элементы.СтавкаНДСПоУмолчанию.Видимость = Ложь;
	Элементы.СтавкаНДС.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ОбменДаннымиСервер.ОпределитьПроверяемыеРеквизитыСУчетомНастроекВидимостиПолейФормы(ПроверяемыеРеквизиты, Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОбменДаннымиКлиент.ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
