﻿////////////////////////////////////////////////////////////////////////////////
// Работа с трудозатратами.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает количество записей в регистре трудозатрат по объекту.
//
// Параметры:
//	Объект - Любая ссылка - Владелец трудозатрат.
//	Исполнитель - СправочникСсылка.Пользователи - если передан, то устанавливает доп.
//		отбор по исполнителю (чтобы видеть только свои записи).
//
// Возвращаемое значение: 
//	Число - количество записей в регистре по отборам.
//
Функция КоличествоЗаписейТрудозатратОбъекта(Знач Объект, Знач Исполнитель = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(СУММА(1), 0) КАК КоличествоЗаписей
		|ИЗ
		|	РегистрСведений.Трудозатраты КАК Трудозатраты
		|ГДЕ
		|	Трудозатраты.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Если Исполнитель <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + " Трудозатраты.Исполнитель = &Исполнитель ";
		Запрос.УстановитьПараметр("Исполнитель", Исполнитель);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.КоличествоЗаписей;
		
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции //КоличествоЗаписейТрудозатрат

// Возвращает последнюю дату окончания.
//
// Параметры:
//	Объект - Любая ссылка - Владелец трудозатрат.
//
// Возвращаемое значение: 
//	Дата - последняя дата окончания из трудозатрат.
//
Функция ПоследняяДатаОкончанияТрудозатратОбъекта(Знач Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	Трудозатраты.ДатаОкончания КАК ДатаОкончания
		|ИЗ
		|	РегистрСведений.Трудозатраты КАК Трудозатраты
		|ГДЕ
		|	Трудозатраты.Объект = &Объект
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала УБЫВ";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.ДатаОкончания;
		
	КонецЕсли;
	
	Возврат Дата(1, 1, 1);
	
КонецФункции //КоличествоЗаписейТрудозатрат

// Проверяет пересечение интервалов трудозатрат для записи и объекта.
//
// Параметры:
//	Запись - РегистрСведенийЗапись.Трудозатраты - исходная запись.
//
// Возвращаемое значение:
//	Булево - есть ли пересечение интервалов дат.
//
Функция ПроверитьПересечениеИнтервалаДатТрудозатрат(Знач Запись) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Запись.Объект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
        |   Трудозатраты.ДатаНачала КАК ДатаНачала,
        |   Трудозатраты.ДатаОкончания КАК ДатаОкончания
        |ИЗ
        |   РегистрСведений.Трудозатраты КАК Трудозатраты
        |ГДЕ
        |   Трудозатраты.Объект = &Объект
        |   И (&ДН < Трудозатраты.ДатаНачала
        |               И Трудозатраты.ДатаНачала < &ДК
        |           ИЛИ &ДН < Трудозатраты.ДатаОкончания
        |               И Трудозатраты.ДатаОкончания < &ДК)
        |   И Трудозатраты.КлючУникальности <> &КлючУникальности";
	
	Запрос.УстановитьПараметр("Объект", Запись.Объект);
	Запрос.УстановитьПараметр("ДН", Запись.ДатаНачала);
	Запрос.УстановитьПараметр("ДК", ?(Запись.ДатаОкончания = Дата(1, 1, 1), Дата(2199, 1, 1), Запись.ДатаОкончания));
    Запрос.УстановитьПараметр("КлючУникальности", Запись.КлючУникальности);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат НЕ РезультатЗапроса.Пустой();	
	
КонецФункции

// Очищает все трудозатраты по объекту.
//
// Параметры:
//	ОбъектСсылка - ОпределяемыйТип.ТрудозатратыОбъект - владелец трудозатрат.
//
Процедура ОчиститьТрудоазтратыОбъекта(Знач ОбъектСсылка) Экспорт
	
	НаборЗаписей = РегистрыСведений.Трудозатраты.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ОбъектСсылка);
    НаборЗаписей.Записать(); 
	
КонецПроцедуры

// Возвращает массив строк времени по умолчанию.
//
// Возвращаемое значение:
//	Массив - массив строк с временем.
//
Функция ДлительностьВремениПоУмолчанию() Экспорт
	
	Массив = Новый Массив();
	Массив.Очистить();
	Массив.Добавить("00:00");
	Массив.Добавить("00:05");
	Массив.Добавить("00:10");
	Массив.Добавить("00:15");
	Массив.Добавить("00:20");
	Массив.Добавить("00:30");
	Массив.Добавить("00:45");
	Массив.Добавить("01:00");
	Массив.Добавить("01:30");
	Массив.Добавить("02:00");
	Массив.Добавить("02:30");
	Массив.Добавить("03:00");
	Массив.Добавить("04:00");
	Массив.Добавить("05:00");
	Массив.Добавить("06:00");
	Массив.Добавить("08:00");
	
	Возврат Массив;	
	
КонецФункции

// Возвращает представление периода в ежедневном отчете.
//
// Параметры:
//	ЕжедневныйОтчетОбъект - ДокументОьъект.ЕжедневныйОтчет - исходный документ.
//
// Возвращаемое значение:
// 	Строка - представление периода в отчете.
//	
Функция ПредставлениеПериодаЕжедневногоОтчета(Знач ЕжедневныйОтчетОбъект) Экспорт
	
	Результат = "";
	
	Даты = ЕжедневныйОтчетОбъект.Работы.Выгрузить(, "ДатаРаботы, ВремяНачала, ВремяОкончания");
	Даты.Сортировать("ДатаРаботы, ВремяНачала, ВремяОкончания");
	
	Если Даты.Количество() > 0 Тогда
		Если ЕжедневныйОтчетОбъект.ПоложениеДаты = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
					
			Если Даты.Количество() > 0 Тогда
				Если НачалоДня(Даты[0].ДатаРаботы) = НачалоДня(Даты[Даты.Количество() - 1].ДатаРаботы) Тогда
					// Все работы в один день.
					Результат = СтрШаблон(НСтр("ru = '%1 (%2) с %3 до %4'"), 
						Формат(Даты[0].ДатаРаботы, "ДФ=dd.MM.yy;"), 
						Формат(Даты[0].ДатаРаботы, "ДФ=ддд;"), 
						Формат(Даты[0].ВремяНачала, "ДФ=HH:mm:ss;"), 
						Формат(Даты[Даты.Количество() - 1].ВремяОкончания, "ДФ=HH:mm:ss;"));
				Иначе
					// Все работы длятся несколько дней.
					Результат =  СтрШаблон(НСтр("ru = 'с %1 (%2) по %3 (%4)'"), 
						Формат(Даты[0].ВремяНачала, "ДФ='dd.MM.yy HH:mm:ss';"), 
						Формат(Даты[0].ДатаРаботы, "ДФ=ддд;"),
						Формат(Даты[Даты.Количество() - 1].ВремяОкончания, "ДФ='dd.MM.yy HH:mm:ss';"), 
						Формат(Даты[Даты.Количество() - 1].ДатаРаботы, "ДФ=ддд;"));
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Результат = СтрШаблон(НСтр("ru = '%1 (%2) с %3 до %4'"), 
				Формат(Даты[0].ДатаРаботы, "ДФ=dd.MM.yy;"), 
				Формат(Даты[0].ДатаРаботы, "ДФ=ддд;"), 
				Формат(Даты[0].ВремяНачала, "ДФ=HH:mm:ss;"), 
				Формат(Даты[Даты.Количество() - 1].ВремяОкончания, "ДФ=HH:mm:ss;"));
				
		КонецЕсли;
	Иначе
		Результат = НСтр("ru = '<Добавьте строки в работы>'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти