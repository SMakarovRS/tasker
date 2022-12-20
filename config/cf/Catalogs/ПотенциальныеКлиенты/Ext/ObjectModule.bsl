﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка.Пустая() И Не ЭтоГруппа Тогда
		Если НЕ ЗначениеЗаполнено(ДатаРегистрации) Тогда
			ДатаРегистрации = ТекущаяДатаСеанса();
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
			Ответственный = Пользователи.АвторизованныйПользователь();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТелефонныйЗвонок") Тогда
		
		СтруктураНомера	= сфпСофтФонПроСервер.сфпЗаполнитьСтруктуруПолейПоПредставлениюТелефон(ДанныеЗаполнения.АбонентКакСвязаться);
		Телефон = сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(ДанныеЗаполнения.АбонентКакСвязаться);		
		Наименование = ДанныеЗаполнения.АбонентПредставление;
		НоваяКИ = КонтактнаяИнформация.Добавить();
		НоваяКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон");
		СтруктураНомера = сфпСофтФонПроСервер.сфпЗаполнитьСтруктуруПолейПоПредставлениюТелефон(Телефон);
		НоваяКИ.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.МобильныйТелефонПотенциальногоКлиента");
		НоваяКИ.НомерТелефонаБезКодов	= СтруктураНомера.НомерТелефона;		
		Если ЗначениеЗаполнено(СтруктураНомера.КодГорода) Тогда
			НоваяКИ.Представление	= ?(ЗначениеЗаполнено(СтруктураНомера.КодСтраны),СтруктураНомера.КодСтраны 
				+ " (", "(") + СтруктураНомера.КодГорода + ") " + СтруктураНомера.НомерТелефона;
		Иначе	
			НоваяКИ.Представление	= Телефон;
		КонецЕсли;	
		НоваяКИ.НомерТелефона = Телефон;
		ЗначенияПолей	= Новый СписокЗначений;
		ЗначенияПолей.Добавить(СтруктураНомера.КодСтраны,		"КодСтраны");
		ЗначенияПолей.Добавить(СтруктураНомера.КодГорода,		"КодГорода");
		ЗначенияПолей.Добавить(СтруктураНомера.НомерТелефона,	"НомерТелефона");
		НоваяКИ.ЗначенияПолей	= ЗначенияПолей;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Телефон") Тогда
		
		СтруктураНомера	= сфпСофтФонПроСервер.сфпЗаполнитьСтруктуруПолейПоПредставлениюТелефон(ДанныеЗаполнения.Телефон);
		Телефон = сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(ДанныеЗаполнения.Телефон);		
		НоваяКИ = КонтактнаяИнформация.Добавить();
		НоваяКИ.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон");
		СтруктураНомера = сфпСофтФонПроСервер.сфпЗаполнитьСтруктуруПолейПоПредставлениюТелефон(Телефон);
		НоваяКИ.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.МобильныйТелефонПотенциальногоКлиента");
		НоваяКИ.НомерТелефонаБезКодов	= СтруктураНомера.НомерТелефона;		
		Если ЗначениеЗаполнено(СтруктураНомера.КодГорода) Тогда
			НоваяКИ.Представление	= ?(ЗначениеЗаполнено(СтруктураНомера.КодСтраны),СтруктураНомера.КодСтраны 
				+ " (", "(") + СтруктураНомера.КодГорода + ") " + СтруктураНомера.НомерТелефона;
		Иначе	
			НоваяКИ.Представление	= Телефон;
		КонецЕсли;	
		НоваяКИ.НомерТелефона = Телефон;
		ЗначенияПолей	= Новый СписокЗначений;
		ЗначенияПолей.Добавить(СтруктураНомера.КодСтраны,		"КодСтраны");
		ЗначенияПолей.Добавить(СтруктураНомера.КодГорода,		"КодГорода");
		ЗначенияПолей.Добавить(СтруктураНомера.НомерТелефона,	"НомерТелефона");
		НоваяКИ.ЗначенияПолей	= ЗначенияПолей;
		
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли