﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Код <> "" Тогда
			Объект.Код = Параметры.Код;
		КонецЕсли;
		
		Если Параметры.КоррСчет <> "" Тогда
			Объект.КоррСчет = Параметры.КоррСчет;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
	УстановитьУсловноеОформление();	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.РучноеИзменение = ?(РучноеИзменение = Неопределено, 2, РучноеИзменение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму банковского счета об изменении реквизитов банка
	Оповестить("ЗаписанЭлементБанк", Объект.Ссылка, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СВИФТБИКПриИзменении(Элемент)
	
	Объект.СВИФТБИК = ВРег(СокрЛП(Объект.СВИФТБИК));
	
	Если СтрокаСоответствуетФорматуSWIFT(Объект.СВИФТБИК) Тогда
		
		СтранаБанка = СтранаПоSWIFT(Объект.СВИФТБИК);
		
		Если ЗначениеЗаполнено(СтранаБанка) Тогда
			Объект.Страна = СтранаБанка;
		КонецЕсли;
		
		ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Текст = НСтр("ru = 'Поставляемые данные обновляются автоматически.
		|После ручного изменения автоматическое обновление этого элемента производиться не будет.
		|Продолжить с изменением?'");
	Результат = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("ИзменитьЗавершение", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	ВыполнитьОбновление = Ложь;
	РаботаСБанкамиКлиентПереопределяемый.ОбновитьЭлементИзКлассификатора(ЭтаФорма, ВыполнитьОбновление);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	// Код банка.
	ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Код");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Страна", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СтраныМира.Россия);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРеквизитыЗависимыеОтСтраны(Форма)
	
	ЯвляетсяБанкомРФ = (Форма.Объект.Страна = Форма.СтранаРФ);
	
	Форма.Элементы.ТекстРучногоИзменения.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ОбновитьИзКлассификатора.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Изменить.Видимость = ЯвляетсяБанкомРФ;
	
	Если ЯвляетсяБанкомРФ Тогда
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'БИК'");
	Иначе
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'Национальный код'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Банки);
	РаботаСБанкамиПереопределяемый.СчитатьФлагРучногоИзменения(ЭтаФорма);
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьПрекращена;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		РучноеИзменение    = Истина;
		
		РаботаСБанкамиКлиентПереопределяемый.ОбработатьФлагРучногоИзменения(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	РаботаСБанкамиПереопределяемый.ВосстановитьЭлементИзОбщихДанных(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтранаПоSWIFT(СВИФТБИК)
	
	Возврат Справочники.Банки.СтранаПоSWIFT(СВИФТБИК);
	
КонецФункции

&НаСервереБезКонтекста
Функция СтрокаСоответствуетФорматуSWIFT(СВИФТБИК)
	
	Возврат Справочники.Банки.СтрокаСоответствуетФорматуSWIFT(СВИФТБИК);
	
КонецФункции	

// Добавляет в коллекцию оформляемых полей компоновки данных новое поле
//
// Параметры:
//	КоллекцияОформляемыхПолей 	- коллекция оформляемых полей КД
//	ИмяПоля						- Строка - имя поля
//
// Возвращаемое значение:
//	ОформляемоеПолеКомпоновкиДанных - созданное поле
//
// Пример:
// 	Форма.УсловноеОформление.Элементы[0].Поля
//
&НаСервере
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля) Экспорт
	
	ПолеЭлемента 		= КоллекцияОформляемыхПолей.Элементы.Добавить();
	ПолеЭлемента.Поле 	= Новый ПолеКомпоновкиДанных(ИмяПоля);

	Возврат ПолеЭлемента;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура-обработчик ответа на вопрос о обновлении данных из классификатора
//
Процедура ОпределитьНеобходимостьОбновленияДанныхИзКлассификатора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = КодВозвратаДиалога.Да Тогда
		
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ОбновитьНаСервере();
		ОповеститьОбИзменении(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры // ОпределитьНеобходимостьОбновленияДанныхИзКлассификатора()

#КонецОбласти

#Область ОбработчикиБиблиотек

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

#КонецОбласти

