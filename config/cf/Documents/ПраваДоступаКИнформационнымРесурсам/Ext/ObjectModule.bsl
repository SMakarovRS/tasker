﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
		
	Если ПоложениеСотрудника = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		
		Для каждого СтрокаТабличнойЧасти Из Доступ Цикл
			СтрокаТабличнойЧасти.Сотрудник	= Сотрудник;
		КонецЦикла;
		СписокСотрудников = Строка(Сотрудник);
		
	Иначе
		
		СписокСотрудников = "";
		ДоступСотрудники = Доступ.Выгрузить();
		ДоступСотрудники.Свернуть("Сотрудник", );
		ДоступСотрудники.Сортировать("Сотрудник");
		Для каждого СтрокаТабличнойЧасти Из ДоступСотрудники Цикл
			Если НЕ ПустаяСтрока(СписокСотрудников) Тогда
				СписокСотрудников = СписокСотрудников + "; ";
			КонецЕсли;
			СписокСотрудников = СписокСотрудников + Строка(СтрокаТабличнойЧасти.Сотрудник);
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;		
	КонецЕсли;
	
	// Проверка на ошибки
	СписокОшибок = ПроверитьДокументПередПроведением();
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок, Отказ);	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проверка на ошибки.
	// Из-за использования дерева приходится несколько раз делать проверку.
	Если НЕ ОбменДанными.Загрузка Тогда
		СписокОшибок = ПроверитьДокументПередПроведением();
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок, Отказ);	
	КонецЕсли;	
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	СЛС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);	
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	СЛС.ОтразитьДвиженияВРазделахУчета(Ссылка, ДополнительныеСвойства, Движения, Отказ);	
	
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Основание = ДанныеЗаполнения;
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задание") Тогда
		Организация			= ДанныеЗаполнения.Организация;
		ПоложениеСотрудника = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		ПоложениеНоменклатуры = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
		Сотрудник			= ДанныеЗаполнения.Инициатор;
		Комментарий			= ДанныеЗаполнения.Тема;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПраваДоступаКИнформационнымРесурсам") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Проведен,Дата,Номер,Автор,ДатаСоздания,АвторКорректировки,ДатаКорректировки");
		
		Доступ.Загрузить(ДанныеЗаполнения.Доступ.Выгрузить());
		Права.Загрузить(ДанныеЗаполнения.Права.Выгрузить());
		
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти	

#Область СлужебныеПроцедурыИФункции

// Проверяет документ перед проведением, возвращает СписокЗначений с ошибками,
// если пустой, то ошибок нет.
Функция ПроверитьДокументПередПроведением()
	СписокОшибок = Неопределено;
				
	Возврат СписокОшибок;
КонецФункции

#КонецОбласти


#КонецЕсли