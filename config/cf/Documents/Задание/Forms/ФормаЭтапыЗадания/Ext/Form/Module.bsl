﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ОбъектСсылка = Параметры.ОбъектСсылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СИсполнителямиНаСервере();
	Элементы.ФормаСИсполнителями.Пометка = Иерархически;
	РазвернутьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СИсполнителями(Команда)
	
	Иерархически = НЕ Иерархически;
	СИсполнителямиНаСервере();
	Элементы.ФормаСИсполнителями.Пометка = Иерархически;
	РазвернутьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СИсполнителямиНаСервере()
	
	ДЗ = СЛС.ДеревоИсполнителейИЭтапов(ОбъектСсылка, "Этапы", Иерархически, 
		УникальныйИдентификатор);
	ЗначениеВРеквизитФормы(ДЗ, "Дерево");	
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	
	КоллекцияЭлементовДерева = Дерево.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл    
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		Элементы.Дерево.Развернуть(ИдентификаторСтроки, Истина);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти