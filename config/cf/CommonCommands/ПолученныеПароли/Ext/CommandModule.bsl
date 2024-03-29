﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВидимостьПаролей = ПолучитьДоступКПаролям();
	Если ВидимостьПаролей = Истина Тогда 
		Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
			ТабДок = ПечатьПолученныеПароли(ПараметрКоманды);
			Коллекция = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Макет");
			СтруктураКоллекции = Коллекция.Получить(0);
			СтруктураКоллекции.ТабличныйДокумент = ТабДок;
			СтруктураКоллекции.ИмяФайлаПечатнойФормы = Строка(ПараметрКоманды);
			СтруктураКоллекции.СинонимМакета = Строка(ПараметрКоманды);
			Структура = Новый Структура;
			Структура.Вставить("ЗаголовокФормы", Строка(ПараметрКоманды));
			Структура.Вставить("ВладелецФормы", ПараметрКоманды); 
			УправлениеПечатьюКлиент.ПечатьДокументов(Коллекция, ПараметрКоманды, Структура);
		КонецЕсли;
	КонецЕсли;
				
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПечатьПолученныеПароли(ПараметрКоманды)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПолученныеПароли";
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ПолученныеПароли");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникЛогиныИПароли.ТипПароля КАК ТипПароля,
		|	СправочникЛогиныИПароли.Объект КАК Объект,
		|	СправочникЛогиныИПароли.Программа КАК Программа,
		|	ЛогиныИПаролиСрезПоследних.Логин КАК Логин,
		|	ЛогиныИПаролиСрезПоследних.Пароль КАК Пароль
		|ИЗ
		|	РегистрСведений.ЛогиныИПаролиХранилище.СрезПоследних КАК ЛогиныИПаролиСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЛогиныИПароли КАК СправочникЛогиныИПароли
		|		ПО ЛогиныИПаролиСрезПоследних.Владелец = СправочникЛогиныИПароли.Ссылка
		|ГДЕ
		|	СправочникЛогиныИПароли.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", ПараметрКоманды);
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда 
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Новый Структура("Объект", ПараметрКоманды));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	НомерСтроки = 1;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ВыборкаДетальныеЗаписи);		
		ОбластьМакета.Параметры.Заполнить(Новый Структура("НомерСтроки", НомерСтроки));
		ОбластьМакета.Параметры.Заполнить(Новый Структура("Пароль",  ВыборкаДетальныеЗаписи.Пароль.Получить()));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда 
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Новый Структура("ДатаИВремяПечати", ТекущаяДатаСеанса()));
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	ТабличныйДокумент.АвтоМасштаб = Истина; 
    ТабличныйДокумент.ТолькоПросмотр = Истина;
    ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
    ТабличныйДокумент.ОтображатьСетку = Ложь;
    ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабличныйДокумент;
				
КонецФункции

&НаСервере
Функция ПолучитьДоступКПаролям()
	
	Возврат УправлениеITОтделом8УФПовтИсп.Право("ПолныеПрава") 
		ИЛИ УправлениеITОтделом8УФПовтИсп.Право("ДобавлениеИзменениеПаролей") 
		ИЛИ УправлениеITОтделом8УФПовтИсп.Право("ЧтениеПаролей");
	
КонецФункции

#КонецОбласти
