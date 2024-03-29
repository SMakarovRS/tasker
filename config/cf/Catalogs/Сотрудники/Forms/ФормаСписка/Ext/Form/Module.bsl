﻿#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СОХРАНЕНИЯ НАСТРОЕК

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПоказыватьАктуальных = Истина;
	ОбновитьВидимостьДоступность();
			
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьТолькоАктуальныхСотрудников(Команда)
	
	ПоказыватьАктуальных = НЕ ПоказыватьАктуальных;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	Элементы.ФормаПоказыватьТолькоАктуальныхСотрудников.Пометка = ПоказыватьАктуальных;
	
	Если ПоказыватьАктуальных Тогда
		// Только актуальные.
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Актуальность", Истина);
	Иначе				
		// Всех подряд
		РаботаСОтборамиКлиентСервер.УдалитьЭлементОтбораСписка(Список, "Актуальность");
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти