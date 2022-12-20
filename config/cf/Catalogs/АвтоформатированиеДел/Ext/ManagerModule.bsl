﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет предопределенные автоформатирования для дел по пользователю.
//
// Параметры:
//	Пользователь - СправочникСсылка.Пользователи - пользователь, по которому происходит заполнение.
//
Процедура ЗаполнитьАвтоформатированиеДелУмолчанию(Знач Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
    
    Структура = Новый Структура;
    
    #Область Помеченные
    // Помеченные (Marked).
    ЦветаПомеченнойЗадачи = ЗаданияСервер.ПолучитьЦветаПомеченногоЗадания();
    Структура.Вставить("Наименование",  НСтр("ru='Подсвечено'", "ru"));
    Структура.Вставить("Идентификатор", "Marked");
    Структура.Вставить("ЦветТекста",    ЦветаПомеченнойЗадачи.ЦветТекста);
    Структура.Вставить("ЦветФона",      ЦветаПомеченнойЗадачи.ЦветФона);    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", "МассивУсловий.Добавить(""Дела.Подсвечено = Истина"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область Сегодня
    // Сегодня (Today).
    Структура.Вставить("Наименование",  НСтр("ru='Сегодня'", "ru"));
    Структура.Вставить("Идентификатор", "Today");
    Структура.Вставить("ЦветТекста",    WebЦвета.Белый);
    Структура.Вставить("ЦветФона",      Новый Цвет(198, 108, 19));    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "Срок");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""Дела.Срок МЕЖДУ &ДатаНачСрокаСегодня И &ДатаКонСрокаСегодня"");
        |Запрос.УстановитьПараметр(""ДатаНачСрокаСегодня"", НачалоДня(ТекущаяДатаСеанса()));
        |Запрос.УстановитьПараметр(""ДатаКонСрокаСегодня"", КонецДня(ТекущаяДатаСеанса()));");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область Завтра
    // Завтра (Tomorrow).
    Структура.Вставить("Наименование",  НСтр("ru='Завтра и позднее'", "ru"));
    Структура.Вставить("Идентификатор", "Tomorrow");
    Структура.Вставить("ЦветТекста",    WebЦвета.Белый);
    Структура.Вставить("ЦветФона",      Новый Цвет(34, 112, 242));    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "Срок");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""Дела.Срок >= &ДатаНачЗавтра"");
        |Запрос.УстановитьПараметр(""ДатаНачЗавтра"", КонецДня(ТекущаяДатаСеанса()) + 1);");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область Просрочено
    // Просрочено (expired).
    Структура.Вставить("Наименование",  НСтр("ru='Просрочено'", "ru"));
    Структура.Вставить("Идентификатор", "Expired");
    Структура.Вставить("ЦветТекста",    WebЦвета.Белый);
    Структура.Вставить("ЦветФона",      Новый Цвет(209, 72, 54));    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "Срок");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""(Дела.Срок > ДатаВремя(1, 1, 1, 0, 0, 0) И Дела.Срок < &ДатаНачВчера) ИЛИ (Дела.ИспользоватьВремя = ИСТИНА И Дела.Срок >= &ДатаНачСрокаСегодня И Дела.Срок < &ТекущаяДата)"");
        |Запрос.УстановитьПараметр(""ТекущаяДата"", ТекущаяДатаСеанса());
        |Запрос.УстановитьПараметр(""ДатаНачСрокаСегодня"", НачалоДня(ТекущаяДатаСеанса()));
        |Запрос.УстановитьПараметр(""ДатаНачВчера"", НачалоДня(ТекущаяДатаСеанса()) - 1);");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область ЕстьОписаниеДелоНеВыполнено
    // Есть описание, дело не выполнено (HaveNotes).
    Структура.Вставить("Наименование",  НСтр("ru='Есть описание, дело не выполнено'", "ru"));
    Структура.Вставить("Идентификатор", "HaveNotes");
    Структура.Вставить("ЦветТекста",    "");
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      29);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", "МассивУсловий.Добавить(""Дела.ЕстьОписание = Истина И Дела.Выполнено = Ложь"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область ЕстьОписаниеДелоВыполнено
    // Есть описание, дело выполнено (HaveNotesCompleted).
    Структура.Вставить("Наименование",  НСтр("ru='Есть описание, дело выполнено'", "ru"));
    Структура.Вставить("Идентификатор", "CompletedHaveNotes");
    Структура.Вставить("ЦветТекста",    "");
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      30);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", "МассивУсловий.Добавить(""Дела.ЕстьОписание = Истина И Дела.Выполнено = Истина"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область ЦельНедели
    // Цель недели (WeekGoal).
    Структура.Вставить("Наименование",  НСтр("ru='Недельная цель'", "ru"));
    Структура.Вставить("Идентификатор", "WeekGoal");
    Структура.Вставить("ЦветТекста",    "");
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      27);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""Дела.ВидЦели = Значение(Перечисление.ВидЦелиДела.Неделя) И Дела.Выполнено = Ложь"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область ЦельМесяца
	// Цель месяца (MonthGoal).
    Структура.Вставить("Наименование",  НСтр("ru='Месячная цель'", "ru"));
    Структура.Вставить("Идентификатор", "MonthGoal");
    Структура.Вставить("ЦветТекста",    "");
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      28);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""Дела.ВидЦели = Значение(Перечисление.ВидЦелиДела.Месяц) И Дела.Выполнено = Ложь"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область ЛюбаяЗавершеннаяЦель
	// Любая завершенная цель (CompletedGoal).
    Структура.Вставить("Наименование",  НСтр("ru='Любая завершенная цель'", "ru"));
    Структура.Вставить("Идентификатор", "CompletedGoal");
    Структура.Вставить("ЦветТекста",    "");
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      9);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие", 
        "МассивУсловий.Добавить(""Дела.ВидЦели <> Значение(Перечисление.ВидЦелиДела.Нет) И Дела.Выполнено = Истина"")");    
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область Проекты
    
    // Проекты (Projects).
    Структура.Вставить("Наименование",  НСтр("ru='Проекты'", "ru"));
    Структура.Вставить("Идентификатор", "Projects");
    Структура.Вставить("ЦветТекста",    WebЦвета.Синий);
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие",       "МассивУсловий.Добавить(""Дела.ЭтоПроект = Истина"");");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
    #Область Выполненные
    // Выполненные (Completed).
    Структура.Вставить("Наименование",  НСтр("ru='Выполнено'", "ru"));
    Структура.Вставить("Идентификатор", "Completed");
    Структура.Вставить("ЦветТекста",    WebЦвета.Серый);
    Структура.Вставить("ЦветФона",      "");    
    Структура.Вставить("Стиль",         "");
    Структура.Вставить("Картинка",      -1);    
    Структура.Вставить("Столбец",       "");
    Структура.Вставить("Условие",        "МассивУсловий.Добавить(""Дела.Выполнено = Истина"")");
    ЗаписатьЭлемент(Структура, Пользователь);
    #КонецОбласти
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьЭлемент(Знач Структура, Знач Пользователь)

    НачатьТранзакцию();
    
    Попытка
    
        Запрос = Новый Запрос();
        Запрос.Текст =
            "ВЫБРАТЬ ПЕРВЫЕ 1
            |	АвтоформатированиеДел.Ссылка КАК Ссылка
            |ИЗ
            |	Справочник.АвтоформатированиеДел КАК АвтоформатированиеДел
            |ГДЕ
            |	АвтоформатированиеДел.Идентификатор = &Идентификатор
            |	И АвтоформатированиеДел.Пользователь = &Пользователь";
        
        Запрос.УстановитьПараметр("Идентификатор", Структура.Идентификатор);
        Запрос.УстановитьПараметр("Пользователь", Пользователь);
        Выборка = Запрос.Выполнить().Выбрать();
        Если Выборка.Следующий() Тогда
            Объект                  = Выборка.Ссылка.ПолучитьОбъект();
        Иначе
            Объект                  = Справочники.АвтоформатированиеДел.СоздатьЭлемент();
            Объект.Идентификатор    = Структура.Идентификатор;
            Объект.Пользователь		= Пользователь;
        КонецЕсли;
        
        ЗаполнитьЗначенияСвойств(Объект, Структура,,"ЦветФона,ЦветТекста");
        Объект.ЦветТекста 		    = ?(Структура.ЦветТекста <> "", РаботаСЦветомКлиентСервер.ЦветВHex(Структура.ЦветТекста), "");
        Объект.ЦветФона 		    = ?(Структура.ЦветФона <> "", РаботаСЦветомКлиентСервер.ЦветВHex(Структура.ЦветФона), "");        
        Объект.Использование        = Истина;
        Объект.Записать();
        
        ЗафиксироватьТранзакцию();
        
    Исключение
                    
        ОтменитьТранзакцию();
        
        // Записываем ошибку.
        ЗаписьЖурналаРегистрации(НСтр("ru = 'Дела'"), УровеньЖурналаРегистрации.Ошибка, 
            Метаданные.Справочники.АвтоформатированиеДел,, 
            СтрШаблон(НСтр("ru = 'Ошибка записи элемента ""%1"" (%2)'"), Структура.Наименование, 
                ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));        
        
    КонецПопытки;
        
КонецПроцедуры

#КонецОбласти

#КонецЕсли