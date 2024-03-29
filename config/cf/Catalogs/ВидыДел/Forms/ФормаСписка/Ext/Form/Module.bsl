﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Список.Порядок.Элементы.Очистить();
	НовыйПорядок = Список.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	    
	// Если необходимо по возрастанию сортировать то меняем на Убыв на Возр.
	НовыйПорядок.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
	НовыйПорядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	    
	// Реквизит сортировки - Дата.
	НовыйПорядок.Поле = Новый ПолеКомпоновкиДанных("РеквизитДопУпорядочивания");
	НовыйПорядок.Использование = Истина;
	
	Список.Параметры.УстановитьЗначениеПараметра("Автор", Пользователи.ТекущийПользователь());

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

&НаКлиенте
Процедура ЗаполнитьПредопределенные(Команда)
	
	ЗаполнитьПредопределенныеНаСервере();
	Оповестить("ИзменениеВидаДел");
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПредопределенныеНаСервере()
	
	Справочники.ВидыДел.ЗаполнитьВидыДелПоУмолчанию(Пользователи.ТекущийПользователь());
	
КонецПроцедуры

#КонецОбласти
