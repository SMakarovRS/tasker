﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Функция рассчитывает сумму документа.
//
Функция ПолучитьСуммуДокумента() Экспорт

	ТаблицаНачислений = Новый ТаблицаЗначений;
    Массив = Новый Массив;
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("СуммаНачислено",	0);
	СтруктураВозврата.Вставить("СуммаУдержано",		0);
	СтруктураВозврата.Вставить("СуммаДокумента",	0);
	СтруктураВозврата.Вставить("СуммаВзносов",		0);
	
	СтруктураВозврата.СуммаВзносов = СтраховыеВзносы.Итог("Сумма");
	Массив.Добавить(Тип("СправочникСсылка.ВидыНачисленийИУдержаний"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаНачислений.Колонки.Добавить("ВидНачисленияУдержания", ОписаниеТипов);

	Массив.Добавить(Тип("Число"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаНачислений.Колонки.Добавить("Сумма", ОписаниеТипов);
	
	Для каждого СтрокаТЧ Из НачисленияУдержания Цикл
		НоваяСтрока = ТаблицаНачислений.Добавить();
        НоваяСтрока.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
        НоваяСтрока.Сумма = СтрокаТЧ.Сумма;
	КонецЦикла;
	
	Для каждого СтрокаТЧ Из НалогиНаДоходы Цикл
		НоваяСтрока = ТаблицаНачислений.Добавить();
        НоваяСтрока.ВидНачисленияУдержания = СтрокаТЧ.ВидНачисленияУдержания;
        НоваяСтрока.Сумма = СтрокаТЧ.Сумма;
	КонецЦикла;
	
	Запрос = Новый Запрос
		("ВЫБРАТЬ
		|	ТаблицаНачисленияУдержания.ВидНачисленияУдержания,
		|	ТаблицаНачисленияУдержания.Сумма
		|ПОМЕСТИТЬ ТаблицаНачисленияУдержания
		|ИЗ
		|	&ТаблицаНачисленияУдержания КАК ТаблицаНачисленияУдержания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = 
		|				ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
		|					ТОГДА НачислениеЗарплатыНачисленияУдержания.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаНачислено,
		|	СУММА(ВЫБОР
		|			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = 
		|				ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
		|					ТОГДА 0
		|			ИНАЧЕ НачислениеЗарплатыНачисленияУдержания.Сумма
		|		КОНЕЦ) КАК СуммаУдержано,
		|	СУММА(ВЫБОР
		|			КОГДА НачислениеЗарплатыНачисленияУдержания.ВидНачисленияУдержания.Тип = 
		|				ЗНАЧЕНИЕ(Перечисление.ТипыНачисленийИУдержаний.Начисление)
		|					ТОГДА НачислениеЗарплатыНачисленияУдержания.Сумма
		|			ИНАЧЕ -1 * НачислениеЗарплатыНачисленияУдержания.Сумма
		|		КОНЕЦ) КАК СуммаДокумента
		|ИЗ
		|	ТаблицаНачисленияУдержания КАК НачислениеЗарплатыНачисленияУдержания");
						  
	Запрос.УстановитьПараметр("ТаблицаНачисленияУдержания", ТаблицаНачислений);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатЗапроса[1].Пустой() Тогда
		СтруктураВозврата.СуммаДокумента = СтруктураВозврата.СуммаДокумента - СтруктураВозврата.СуммаПогашено;
		Возврат СтруктураВозврата;	
	Иначе
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, РезультатЗапроса[1].Выгрузить()[0]);
		Если ЗначениеЗаполнено(СтруктураВозврата.СуммаДокумента) Тогда
			СтруктураВозврата.СуммаДокумента = СтруктураВозврата.СуммаДокумента;
		КонецЕсли;
		Возврат СтруктураВозврата;	
	КонецЕсли; 

КонецФункции // ПолучитьСуммуДокумента()

#КонецОбласти	
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = ПолучитьСуммуДокумента().СуммаДокумента;
	
КонецПроцедуры
	
// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
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
	
	// Инициализация дополнительных свойств для удаления проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	УправлениеITОтделом8УФ.ОчиститьДатуНомерВходящегоДокумента(ЭтотОбъект);
		 
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи объекта.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	МесяцНачисления = НачалоМесяца(ТекущаяДатаСеанса());
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли