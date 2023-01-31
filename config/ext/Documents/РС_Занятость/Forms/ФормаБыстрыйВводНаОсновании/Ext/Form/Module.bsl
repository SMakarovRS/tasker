﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Не Параметры.Свойство("ОписаниеКоманды");
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьДокумент(Параметры.ОписаниеКоманды, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДокумент(СтруктураПараметров, Отказ)
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьНовыйДокумент();
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	Объект.Задание = ПолучитьЗадание(СтруктураПараметров.Представление);
	
	Если Не ЗначениеЗаполнено(Объект.Задание) Тогда
		ОбщегоНазначения.СообщитьПользователю("В текущем месяце ещё не создано задание для заполнения " + СтруктураПараметров.Представление 
		+ Символы.ПС + " обратитесь к управляющему",,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ОписаниеФорматированныйДокумент.Добавить(СтруктураПараметров.Представление);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадание(ИмяЗадания)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Задание.Ссылка КАК Задание
	|ИЗ
	|	Документ.Задание.ДополнительныеРеквизиты КАК ЗаданиеДополнительныеРеквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Задание КАК Задание
	|		ПО ЗаданиеДополнительныеРеквизиты.Ссылка = Задание.Ссылка
	|			И (ЗаданиеДополнительныеРеквизиты.Свойство = &Свойство)
	|			И (ЗаданиеДополнительныеРеквизиты.Значение = &Значение)
	|			И (Задание.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|			И (НЕ Задание.ПометкаУдаления)
	|			И (Задание.Проведен)");
		
	Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "ВидРегламентированнойЗадачи");
	Значение = ИмяЗадания;
	
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ТекущаяДата()) - (86400 * 10));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("Свойство", Свойство);
	Запрос.УстановитьПараметр("Значение", Справочники.ЗначенияСвойствОбъектов.НайтиПоНаименованию(Значение));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда		
		Возврат Документы.Задание.ПустаяСсылка();
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Задание;
	
КонецФункции

&НаКлиенте
Процедура РасчетВремени(Элемент)
	
	Объект.ДатаНачала = НачалоМинуты(Объект.ДатаНачала);
	Объект.ДатаОкончания = НачалоМинуты(Объект.ДатаОкончания);
	ФактВремя = Объект.ДатаОкончания - Объект.ДатаНачала;
	Объект.ФактическаяТрудоемкость = ФактВремя/3600;
	Объект.ВремяКлиента = Объект.ФактическаяТрудоемкость;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОписаниеФорматированныйДокумент = ТекущийОбъект.ФорматированноеОписание.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ФорматированноеОписание = Новый ХранилищеЗначения(ОписаниеФорматированныйДокумент);
	СтруктураВложений = Новый Структура;
	ОписаниеФорматированныйДокумент.ПолучитьHTML(ТекстHTML, СтруктураВложений);		
	Если СтрНайти(НРег(ТекстHTML), "<body>") > 0 Тогда
		ТекстHTML = СтрЗаменить(ТекстHTML, Сред(ТекстHTML, СтрНайти(НРег(ТекстHTML), "<body>"), 6), 
			"<body style=""font-family:Arial;font-size:10pt;"">");
	КонецЕсли;
	ТекстHTML = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстHTML);
	ТекущийОбъект.ТекстHTML = ТекстHTML;
	ТекущийОбъект.Описание = ОписаниеФорматированныйДокумент.ПолучитьТекст();
	
КонецПроцедуры

&НаСервере
Процедура ОКНаСервере()
	
	Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ОКНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСписокВыбораВремени(Элементы.ВремяНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВыбораВремени(ЭлементФормы)

	Если ЭлементФормы = Элементы.ДатаНачала Тогда
		Элементы.ВремяОкончания.СписокВыбора.Очистить();	
		НачалоПериода = 900;	
		КонецПериода = 14400;
		КратноеВремя = Объект.ДатаНачала - ((Минута(Объект.ДатаНачала) % 15) * 60) - Секунда(Объект.ДатаНачала);
		Пока НачалоПериода <= КонецПериода Цикл
			Элементы.ВремяОкончания.СписокВыбора.Добавить((КратноеВремя + НачалоПериода), Формат((КратноеВремя + НачалоПериода), "ДФ = HH:mm"));
			НачалоПериода = НачалоПериода + 900;
		КонецЦикла;
	КонецЕсли;
	Если ЭлементФормы = Элементы.ДатаОкончания Тогда
		Элементы.ВремяОкончания.СписокВыбора.Очистить();	
		НачалоПериода = 0;	
		КонецПериода = 14400;
		Пока НачалоПериода <= КонецПериода Цикл
			Элементы.ВремяОкончания.СписокВыбора.Добавить((НачалоДня(Объект.ДатаОкончания) + НачалоПериода), Формат((НачалоДня(Объект.ДатаОкончания) + НачалоПериода), "ДФ = HH:mm"));
			НачалоПериода = НачалоПериода + 900;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры



