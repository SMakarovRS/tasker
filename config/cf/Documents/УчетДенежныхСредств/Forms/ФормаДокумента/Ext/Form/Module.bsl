﻿
#Область ОписаниеПеременных

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт; //Проверка контрагентов

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт; // Длительная операция
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СЛС.ПриСозданииНаСервере(Объект, Отказ, СтандартнаяОбработка, Параметры, ЭтаФорма);	
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ПоложениеСтатьиДоходовРасходов) Тогда
			Объект.ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ПоложениеПодразделения) Тогда
			Объект.ПоложениеПодразделения = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидДвижения) Тогда
			Объект.ВидДвижения = Перечисления.ВидыДоходовРасходов.Расход;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидДенежныхСредств) Тогда
			Объект.ВидДенежныхСредств = Справочники.ВидыДенежныхСредств.Банк;
		КонецЕсли;
				
		// Документ создается из обработки "РабочийСтол".
		Если Параметры.Свойство("РабочийСтолЗначенияЗаполнения") Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.РабочийСтолЗначенияЗаполнения);
		КонецЕсли;
		
	КонецЕсли;	
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Основание) И Объект.БюджетыПоОплачиваемымДокументам = Истина Тогда
		Объект.Бюджет 		 = Объект.Основание.Бюджет;
		Объект.ПериодБюджета = Объект.Основание.ПериодБюджета;
	КонецЕсли;
	
	#Область БСП_ПриСозданииНаСервере

	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.Взаимодействия
	Взаимодействия.ПодготовитьОповещения(ЭтотОбъект,Параметры);
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	

	// ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ВерсионированиеОбъектов
	
	#КонецОбласти
	
	ТекущийЭлемент = Элементы.Оплата;
	
	// Учет остатков контрагентов.
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Организация");
	УправлениеITОтделом8УФ.УстановитьОграничениеТипаДляЭлементовФормы(ЭтаФорма, МассивЭлементов); 
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Корректировки документа
	УправлениеITОтделом8УФКлиент.ОбновитьНадписьАвтор(Объект, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
       ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Корректировки документа
	УправлениеITОтделом8УФКлиент.ОбновитьНадписьАвтор(Объект, ЭтаФорма);
	Оповестить("Запись_УчетДенежныхСредств", Объект.Ссылка);
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
        ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, 
			"ДокументУчетДенежныхСредств (проведение)");	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СЛС.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	// СтандартныеПодсистемы.УправлениеДоступом
    УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДатаСоздания = Дата(1, 1, 1) Тогда
		ТекущийОбъект.ДатаСоздания = ТекущаяДатаСеанса();
	Иначе
		ТекущийОбъект.ДатаКорректировки = ТекущаяДатаСеанса();
	КонецЕсли; 
	
	Если ТекущийОбъект.Автор = Справочники.Пользователи.ПустаяСсылка() Тогда
		ТекущийОбъект.Автор = Пользователи.ТекущийПользователь();
	Иначе
		ТекущийОбъект.АвторКорректировки = Пользователи.ТекущийПользователь();
	КонецЕсли; 
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СЛС.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма);
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма") 
		И ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаВыбораОрганизацииКонтрагента"
		И ИсточникВыбора.ВладелецФормы = ЭтаФорма Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбораФормы(ЭтаФорма, 
		 	"Организация",
			Объект.Организация,
			ВыбранноеЗначение,
			Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект));
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатаОплачиваемыйДокументОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Оплата.ТекущиеДанные;
		
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Тип") Тогда
			Если ЭтоТипНачислениеЗаработнойПлаты(ВыбранноеЗначение) Тогда
				Если Объект.ВидДокумента = 
					ПредопределенноеЗначение("Перечисление.ВидДокументаУчетДенежныхСредств.ЗаработнаяПлата") Тогда
					СтандартнаяОбработка = Ложь;
					ЗначениеОтбора = Новый Структура("Организация", Объект.Организация);
					ПараметрыФормы = Новый Структура("Отбор", ЗначениеОтбора);
					ДопПараметры = Новый Структура;			
					ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНачисленияЗаработнойПлаты", ЭтотОбъект, ДопПараметры);
					ОткрытьФорму("Документ.НачислениеЗаработнойПлаты.Форма.ФормаВыбора", 
					ПараметрыФормы, ЭтотОбъект, , , ,ОписаниеОповещения);
				Иначе
					СтандартнаяОбработка = Ложь;
					ПоказатьПредупреждение(, 
						СтрШаблон(НСтр("ru = 'Для данного типа документа необходимо 
                                        |указать вид движения д/с: ""Расход"", вид операции: ""Заработная плата""'")));
				КонецЕсли;
			Иначе
				Если Объект.ВидДокумента = 
					ПредопределенноеЗначение("Перечисление.ВидДокументаУчетДенежныхСредств.ЗаработнаяПлата") Тогда 
					СтандартнаяОбработка = Ложь;
					ПоказатьПредупреждение(, 
						СтрШаблон(НСтр("ru = 'Нельзя выбрать данный тип документа для вида операции ""Заработная плата""'")));
				КонецЕсли;				
			КонецЕсли;
		ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.НачислениеЗаработнойПлаты") Тогда 
			Если ТекущиеДанные <> Неопределено Тогда 
				УдалитьВзаимосвязанныеОбъектыТЧ(ТекущиеДанные.ОплачиваемыйДокумент);				
			КонецЕсли;
			ДопПараметры = Новый Структура;
			ПослеВыбораНачисленияЗаработнойПлаты(ВыбранноеЗначение, ДопПараметры);
		КонецЕсли;
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер			= "";                   
		КонецЕсли;
		ОбновитьРеквизитыБюджетов();
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	ОбновитьРеквизитыБюджетов();
	ПриИзмененииВидаОперацииНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ПриИзмененииВидаОперацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРасходаДенежныхСредствПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДвиженияДенежныхСредствПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВидДвижения) Тогда		
		Если Объект.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидыДоходовРасходов.Доход") Тогда
			Объект.ВидДокумента = 
				ПредопределенноеЗначение("Перечисление.ВидДокументаУчетДенежныхСредств.ОплатаПокупателя");
		ИначеЕсли Объект.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидыДоходовРасходов.Расход") Тогда
			Объект.ВидДокумента = 
				ПредопределенноеЗначение("Перечисление.ВидДокументаУчетДенежныхСредств.ОплатаПоставщику");			
		Иначе
			Объект.ВидДокумента = 
				ПредопределенноеЗначение("Перечисление.ВидДокументаУчетДенежныхСредств.ПустаяСсылка");
	    КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗаполнитьВидОперации();	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступность();	
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаОперацииНаСервере()
	
	МассивЗаказ = Новый Массив();
	МассивОплачиваемыйДокумент = Новый Массив();
	
	Если Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ВозвратПокупателю Тогда
		
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивЗаказ, , );
		Элементы.ОплатаЗаказ.ОграничениеТипа = ДопустимыеТипы;
		
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Продажа"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;
		
	ИначеЕсли Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ВозвратПоставщика Тогда
		
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивЗаказ, , );
		Элементы.ОплатаЗаказ.ОграничениеТипа = ДопустимыеТипы;
		
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Поступление"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;		
		
	ИначеЕсли Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ЗаработнаяПлата Тогда
				
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НачислениеЗаработнойПлаты"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;
		
	ИначеЕсли Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ОплатаПоставщику Тогда
		
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивЗаказ, , );
		Элементы.ОплатаЗаказ.ОграничениеТипа = ДопустимыеТипы;		
		
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ЛистУчетаРабочегоВремени"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НарядНаРаботы"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НачалоОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ОкончаниеОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Поступление"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;
		
	ИначеЕсли Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ОплатаПокупателя Тогда
		
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивЗаказ, , );
		Элементы.ОплатаЗаказ.ОграничениеТипа = ДопустимыеТипы;
		
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ЛистУчетаРабочегоВремени"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НарядНаРаботы"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НачалоОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ОкончаниеОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Продажа"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;
		
	Иначе
		
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
		МассивЗаказ.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивЗаказ, , );
		Элементы.ОплатаЗаказ.ОграничениеТипа = ДопустимыеТипы;

		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ЛистУчетаРабочегоВремени"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НарядНаРаботы"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.НачалоОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.ОкончаниеОбслуживания"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Поступление"));
		МассивОплачиваемыйДокумент.Добавить(Тип("ДокументСсылка.Продажа"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивОплачиваемыйДокумент, , );
		Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа = ДопустимыеТипы;		
		
	КонецЕсли;
	
	// Очищаем типы, которые не соответствуют отбору/операции.
	Для Каждого Строки Из Объект.Оплата Цикл
		                              
		Если ЗначениеЗаполнено(Строки.Заказ)
			И НЕ Элементы.ОплатаЗаказ.ОграничениеТипа.СодержитТип(ТипЗнч(Строки.Заказ)) Тогда
			
			Строки.Заказ = Неопределено;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строки.ОплачиваемыйДокумент)
			И НЕ Элементы.ОплатаОплачиваемыйДокумент.ОграничениеТипа.СодержитТип(ТипЗнч(Строки.ОплачиваемыйДокумент)) Тогда
			
			Строки.ОплачиваемыйДокумент = Неопределено;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОплата

&НаКлиенте
Процедура ОплатаПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОплачиваемыйДокумент = Элемент.ТекущиеДанные.ОплачиваемыйДокумент;
	
	Если ТипЗнч(ОплачиваемыйДокумент) = Тип("ДокументСсылка.НачислениеЗаработнойПлаты") Тогда 
		УдалитьВзаимосвязанныеОбъектыТЧ(ОплачиваемыйДокумент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НадписьАвторНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Спк = УправлениеITОтделом8УФКлиент.ПолучитьСписокНадписьАвтор(Объект);	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("НадписьАвторНажатиеЗавершение", ЭтотОбъект),
		Спк, Элементы.НадписьАвтор);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьАвторНажатиеЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт    

КонецПроцедуры

// Процедура - обработчик команды НастройкаДокумента.
//
&НаКлиенте
Процедура НастройкаДокумента(Команда)
	
	// 1. Формируем структуру параметров для заполнения формы "Настройка документа".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПоложениеСтатьиДоходовРасходов", 	Объект.ПоложениеСтатьиДоходовРасходов);
	СтруктураПараметров.Вставить("ПоложениеПодразделения", 	Объект.ПоложениеПодразделения);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения", 	Ложь);
	
	СтруктураНастройкаДокумента = Неопределено;
	
	// 2. Открываем форму настроек.
	ОткрытьФорму("ОбщаяФорма.НастройкаДокумента", СтруктураПараметров,,,,, 
		Новый ОписаниеОповещения("НастройкаДокументаЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
        
    СтруктураНастройкаДокумента = Результат;
    
    // 3. Применяем изменения, сделанные в форме "Настройка документа".
	Если ТипЗнч(СтруктураНастройкаДокумента) = Тип("Структура") 
		И СтруктураНастройкаДокумента.БылиВнесеныИзменения Тогда
        
        Объект.ПоложениеСтатьиДоходовРасходов = СтруктураНастройкаДокумента.ПоложениеСтатьиДоходовРасходов;
        Объект.ПоложениеПодразделения = СтруктураНастройкаДокумента.ПоложениеПодразделения;
        
        ПредВидимостьДатыПоступления = Элементы.СтатьяДоходовРасходов.Видимость;
        
        УстановитьВидимостьИДоступность();
        
        Если ПредВидимостьДатыПоступления = Ложь // Было в ТЧ.
            И Элементы.СтатьяДоходовРасходов.Видимость = Истина Тогда // Стало в шапке.
            
            Если Объект.Оплата.Количество() > 0 Тогда
                Объект.СтатьяДоходовРасходов = Объект.Оплата[0].СтатьяДоходовРасходов;	
            КонецЕсли;
            
        КонецЕсли;
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЗаказуПоставщику(Команда)

	// Записываем документ
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Документ не записан. Для продолжения необходима его запись.'"));
		Возврат;
	КонецЕсли;
		
	Записать();
	
	// Добавляем в документ, что заказ поставщику в дереве.
	Объект.ПоложениеСтатьиДоходовРасходов = ПредопределенноеЗначение(
		"Перечисление.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти");
	
	УстановитьВидимостьИДоступность();
	
	Структура = Новый Структура();
	Структура.Вставить("ОтборКонтрагент"	, Объект.Контрагент);
	Структура.Вставить("ОтборДоговор"		, Объект.Договор);
	Структура.Вставить("ЗакрыватьПриВыборе"	, Истина);
	
	ОткрытьФорму("Документ.ЗаказПоставщику.ФормаВыбора", Структура, ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ДобавитьПоЗаказуПоставщикуЗавершение", ЭтотОбъект), 
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоЗаказуПоставщикуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    // Добавляем строки заявки в документ
    Если Результат <> Неопределено Тогда
        ДобавитьПоЗаказуПоставщикуНаСервере(Результат);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДобавитьПоЗаказуПоставщикуНаСервере(ЗаказПоставщику)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗаказПоставщикуНоменклатура.Номенклатура) КАК НоменклатураПредставление,
		|	ЗаказПоставщикуНоменклатура.Сумма,
		|	ЗаказПоставщикуНоменклатура.СтатьяДоходовРасходов
		|ИЗ
		|	Документ.ЗаказПоставщику.Номенклатура КАК ЗаказПоставщикуНоменклатура
		|ГДЕ
		|	ЗаказПоставщикуНоменклатура.Ссылка = &ЗаказПоставщику";

	Запрос.УстановитьПараметр("ЗаказПоставщику", ЗаказПоставщику);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока 						= Объект.Оплата.Добавить();
		
		НоваяСтрока.Заказ					= ЗаказПоставщику;
		НоваяСтрока.Описание 				= ВыборкаДетальныеЗаписи.НоменклатураПредставление;
		НоваяСтрока.СтатьяДоходовРасходов	= ВыборкаДетальныеЗаписи.СтатьяДоходовРасходов;
		НоваяСтрока.Сумма					= ВыборкаДетальныеЗаписи.Сумма;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БСП

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами

#КонецОбласти

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", 
		УправлениеITОтделом8УФ.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура устанавливает видимость элементов формы.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьВидимостьИДоступность()	
	
	Если (Объект.ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке) 
		ИЛИ (НЕ ЗначениеЗаполнено(Объект.ПоложениеСтатьиДоходовРасходов)) Тогда
		
		Элементы.СтатьяДоходовРасходов.Видимость				= Истина;
		Элементы.ЗаработнаяПлатаСтатьяДоходовРасходов.Видимость	= Ложь;	
		Элементы.ОплатаСтатьяДоходовРасходов.Видимость			= Ложь;	
	Иначе
		Элементы.СтатьяДоходовРасходов.Видимость				= Ложь;
		Элементы.ЗаработнаяПлатаСтатьяДоходовРасходов.Видимость	= Истина;	
		Элементы.ОплатаСтатьяДоходовРасходов.Видимость			= Истина;
	КонецЕсли;	
	
	Если (Объект.ПоложениеПодразделения = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке) 
		ИЛИ (НЕ ЗначениеЗаполнено(Объект.ПоложениеПодразделения)) Тогда
		
		Элементы.Подразделение.Видимость				= Истина;
		Элементы.ОплатаПодразделение.Видимость			= Ложь;
		Элементы.ЗаработнаяПлатаПодразделение.Видимость	= Ложь;
	Иначе
		Элементы.Подразделение.Видимость				= Ложь;
		Элементы.ОплатаПодразделение.Видимость			= Истина;
		Элементы.ЗаработнаяПлатаПодразделение.Видимость	= Истина;
	КонецЕсли;	
	
	Элементы.БанковскийСчет.Видимость = Объект.ВидДенежныхСредств = Справочники.ВидыДенежныхСредств.Банк;
	
	Если Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ЗаработнаяПлата Тогда 
		Элементы.Контрагент.Видимость		= Ложь;
		Элементы.Договор.Видимость			= Ложь;
		Элементы.ЗаработнаяПлата.Видимость	= Истина;
		Элементы.СтраховыеВзносы.Видимость	= Истина;
		Элементы.ОплатаЗаказ.Видимость		= Ложь;
		Элементы.ОплатаГруппаЗаказДокумент.Видимость = Ложь;
	Иначе 
		Элементы.Контрагент.Видимость		= Истина;
		Элементы.Договор.Видимость			= Истина;
		Элементы.ЗаработнаяПлата.Видимость	= Ложь;
		Элементы.СтраховыеВзносы.Видимость	= Ложь;
		Элементы.ОплатаЗаказ.Видимость		= Истина;
		Элементы.ОплатаГруппаЗаказДокумент.Видимость = Истина;
	КонецЕсли;
	
	// Заголовок группы заказ документ.
	Если Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ВозвратПокупателю
		ИЛИ Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ВозвратПоставщика Тогда
		Элементы.ОплатаГруппаЗаказДокумент.Заголовок = НСтр("ru = 'Заказ / Документ возврата'");
	ИначеЕсли Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ЗаработнаяПлата Тогда 
		Элементы.ОплатаГруппаЗаказДокумент.Заголовок = НСтр("ru = 'Оплачиваемый документ'");
	Иначе
		Элементы.ОплатаГруппаЗаказДокумент.Заголовок = НСтр("ru = 'Заказ / Оплачиваемый документ'");
	КонецЕсли;
	
	// Прочий доход, расход.
	Если Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ПрочийДоход
		ИЛИ Объект.ВидДокумента = Перечисления.ВидДокументаУчетДенежныхСредств.ПрочийРасход Тогда
		
		Элементы.ОплатаЗаказ.Видимость					= Ложь;
		Элементы.ОплатаГруппаЗаказДокумент.Видимость 	= Ложь;
		
	КонецЕсли;
	
	ПриИзмененииВидаОперацииНаСервере();	
	
КонецПроцедуры // УстановитьВидимостьОтПользовательскихНастроек()

&НаСервере
Процедура ОбновитьРеквизитыБюджетов()
	
	Объект.Бюджет			= УправлениеITОтделом8УФ.НайтиБюджетНаДату(Объект.Дата, Объект.Организация);
	Объект.ПериодБюджета	= УправлениеITОтделом8УФ.НайтиПериодБюджета(Объект.Дата, Объект.Бюджет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидОперации()
	
	Элементы.ВидОперации.СписокВыбора.Очистить();
		
	мПараметрыВыбора= Новый Структура;	
	мОтбор			= Новый Структура;	
	мОтбор.Вставить("ВидДвиженияДенежныхСредств", Объект.ВидДвижения); 
	мПараметрыВыбора.Вставить("Отбор", мОтбор);
	
	ВидОперации = Перечисления.ВидДокументаУчетДенежныхСредств.ПолучитьДанныеВыбора(мПараметрыВыбора);
	Элементы.ВидОперации.СписокВыбора.ЗагрузитьЗначения(ВидОперации.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличныеЧастиДокумента(ВыбранноеЗначение)
	
	Для Каждого Строки Из ВыбранноеЗначение.НачисленияУдержания Цикл
		НоваяСтрока								= Объект.ЗаработнаяПлата.Добавить();
		НоваяСтрока.Сотрудник					= Строки.Сотрудник;
		НоваяСтрока.Подразделение				= ВыбранноеЗначение.Подразделение;
		НоваяСтрока.СтатьяДоходовРасходов		= ВыбранноеЗначение.СтатьяДоходовРасходов;
		НоваяСтрока.МесяцНачисления				= ВыбранноеЗначение.МесяцНачисления;
		НоваяСтрока.ВидНачисленияУдержания		= Строки.ВидНачисленияУдержания;
		НоваяСтрока.Сумма						= Строки.Сумма;
		НоваяСтрока.Регистратор					= ВыбранноеЗначение.Ссылка;
	КонецЦикла;
	
	Для Каждого Строки Из ВыбранноеЗначение.НалогиНаДоходы Цикл
		НоваяСтрока								= Объект.ЗаработнаяПлата.Добавить();
		НоваяСтрока.Сотрудник					= Строки.Сотрудник;
		НоваяСтрока.Подразделение				= ВыбранноеЗначение.Подразделение;
		НоваяСтрока.СтатьяДоходовРасходов		= ВыбранноеЗначение.СтатьяДоходовРасходов;
		НоваяСтрока.МесяцНачисления				= ВыбранноеЗначение.МесяцНачисления;
		НоваяСтрока.ВидНачисленияУдержания		= Строки.ВидНачисленияУдержания;
		НоваяСтрока.Сумма						= Строки.Сумма;
		НоваяСтрока.Регистратор					= ВыбранноеЗначение;
	КонецЦикла;
	
	Для Каждого Строки Из ВыбранноеЗначение.СтраховыеВзносы Цикл
		НоваяСтрока								= Объект.СтраховыеВзносы.Добавить();
		НоваяСтрока.Сотрудник					= Строки.Сотрудник;
		НоваяСтрока.МесяцНачисления				= ВыбранноеЗначение.МесяцНачисления;
		НоваяСтрока.ВидНачисленияУдержания		= Строки.ВидНачисленияУдержания;
		НоваяСтрока.Сумма						= Строки.Сумма;
		НоваяСтрока.Регистратор					= ВыбранноеЗначение.Ссылка;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ЭтоТипНачислениеЗаработнойПлаты(Знач Значение)	
	
	Возврат Метаданные.НайтиПоТипу(Значение).Имя = "НачислениеЗаработнойПлаты";
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораНачисленияЗаработнойПлаты(Результат, ДопПараметры) Экспорт 
		
	ТекущиеДанные = Элементы.Оплата.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Результат) Тогда
		
		СтруктураДляПоиска	= Новый Структура("ОплачиваемыйДокумент", Результат); 
		ТабличнаяЧастьДок	= Объект.Оплата; 
		МассивСтрок = ТабличнаяЧастьДок.НайтиСтроки(СтруктураДляПоиска);
		
		Если МассивСтрок.Количество() > 0 Тогда 
			ПоказатьПредупреждение(, СтрШаблон(НСтр("ru = 'Документ %1 выбран ранее.'"), Результат));
		Иначе 
			ДанныеЗаполнения = ПолучитьДанныеЗаполнения(Результат);
			ТекущиеДанные.ОплачиваемыйДокумент	= Результат;
			ТекущиеДанные.СтатьяДоходовРасходов	= ДанныеЗаполнения.СтатьяДоходовРасходов;
			ТекущиеДанные.Сумма					= ДанныеЗаполнения.СуммаДокумента;
			ЗаполнитьТабличныеЧастиДокумента(Результат);
		КонецЕсли;		
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеЗаполнения(ИсточникВыбора)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("СтатьяДоходовРасходов", ИсточникВыбора.СтатьяДоходовРасходов);
	ДанныеЗаполнения.Вставить("СуммаДокумента", ИсточникВыбора.СуммаДокумента);
	Возврат ДанныеЗаполнения;
	
КонецФункции

#Область УчетОстатковКонтрагентов

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
			
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикНачалоВыбора(ЭтаФорма, Объект.Организация, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, 
	Ожидание, СтандартнаяОбработка)
		
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикАвтоПодбор(ЭтаФорма, 
				"Организация",
				Текст, 
				ДанныеВыбора,
				Ожидание,
				СтандартнаяОбработка);
				
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Очистка(Элемент, СтандартнаяОбработка)	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)	
		
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбора(ЭтаФорма, 
				"Организация", 
				Объект.Организация,
				Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект),
				ВыбранноеЗначение,
				СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	ОрганизацияПриИзменении(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВзаимосвязанныеОбъектыТЧ(ОплачиваемыйДокумент)
	
	СтруктураДляПоиска = Новый Структура("Регистратор", ОплачиваемыйДокумент); 
	ТабличнаяЧастьДок = Объект.ЗаработнаяПлата; 
	МассивСтрок = ТабличнаяЧастьДок.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивСтрок Цикл 
		ТабличнаяЧастьДок.Удалить(Строка); 
	КонецЦикла; 
	ТабличнаяЧастьДок = Объект.СтраховыеВзносы; 
	МассивСтрок = ТабличнаяЧастьДок.НайтиСтроки(СтруктураДляПоиска); 
	Для Каждого Строка Из МассивСтрок Цикл 
		ТабличнаяЧастьДок.Удалить(Строка); 
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
