﻿
#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СЛС.ПриСозданииНаСервере(Объект, Отказ, СтандартнаяОбработка, Параметры, ЭтаФорма);	
	
	ПоказатьРегистры(Объект.ТаблицаРегистров);
	
	ВалютаУчета = Константы.НациональнаяВалюта.Получить();
	
	Если Объект.Ссылка.Пустая() Тогда
		// Документ создается из обработки "РабочийСтол".
		Если Параметры.Свойство("РабочийСтолЗначенияЗаполнения") Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.РабочийСтолЗначенияЗаполнения);
		КонецЕсли;

	КонецЕсли;
	
	#Область БСП_ПриСозданииНаСервере
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	#КонецОбласти
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Подключаемый обработчик события "ПриНачалеРедактирования" таблицы формы.
//
&НаКлиенте
Процедура Подключаемый_ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока
		И Элемент.ТекущиеДанные.Свойство("Валюта") Тогда
		
		Элемент.ТекущиеДанные.Валюта = ВалютаУчета;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СЛС.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	СЛС.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
       ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
        ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, 
			"ДокументКорректировкаРегистров (проведение)");	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура вызывается при нажатии кнопки "Настройка состава регистров" 
// командной панели формы.
//
Процедура НастройкаСоставаРегистров(Команда)
	
	СписокИспользуемыхРегистров = Новый СписокЗначений;

	Для Каждого Строка Из Объект.ТаблицаРегистров Цикл
		СписокИспользуемыхРегистров.Добавить(Строка.Имя);
	КонецЦикла;

	Результат = Неопределено;


	ОткрытьФорму("Документ.КорректировкаРегистров.Форма.ФормаВыбораРегистра",
				Новый Структура("СписокИспользуемыхРегистров", СписокИспользуемыхРегистров),,,,, Новый ОписаниеОповещения("НастройкаСоставаРегистровЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСоставаРегистровЗавершение(Результат1, ДополнительныеПараметры) Экспорт
    
    Результат = Результат1;
    
    Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
        
        ОбработатьИзменениеРегистров(Результат);
        
    КонецЕсли;

КонецПроцедуры // НастройкаСоставаРегистров()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БСП

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

#КонецОбласти

&НаСервере
// Функция создает страницу на форме.
//
Функция СоздатьСтраницу(ИмяСтраницы, Заголовок, Родитель, ВидГруппыФормы)

	НовыйЭлемент = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Родитель);
	НовыйЭлемент.Вид                      = ВидГруппыФормы;
	НовыйЭлемент.Заголовок                = Заголовок;
	НовыйЭлемент.РастягиватьПоВертикали   = Истина;
	НовыйЭлемент.РастягиватьПоГоризонтали = Истина;

	Возврат НовыйЭлемент;

КонецФункции // СоздатьСтраницу()

&НаСервере
// Функция создает имя страницы регистра.
//
Функция ПолучитьИмяСтраницыРегистра(ИмяРегистра)

	Возврат "Страница" + ИмяРегистра;

КонецФункции // ПолучитьИмяСтраницыРегистра()

&НаСервере
// Процедура удаляет страницу на форме, соответствующую регистру.
//
Процедура УдалитьСтраницуРегистра(ИмяРегистра)

	Элементы.Удалить(Элементы.Найти(ПолучитьИмяСтраницыРегистра(ИмяРегистра)));

КонецПроцедуры // УдалитьСтраницуРегистра()

&НаСервере
// Процедура создает на форме таблицу для регистра.
//
Процедура СоздатьТаблицуРегистра(ИмяРегистра, Колонки, Родитель)

	ТаблицаФормы = Элементы.Добавить("ТаблицаДвижений" + ИмяРегистра, Тип("ТаблицаФормы"), Родитель);
	ТаблицаФормы.ПутьКДанным      = "Объект.Движения." + ИмяРегистра;
	Родитель.ПутьКДаннымЗаголовка = ТаблицаФормы.ПутьКДанным + ".КоличествоСтрок";

	Для Каждого Колонка Из Колонки Цикл

		Если Колонка.Значение <> Неопределено Тогда
			
			ПолеФормы = Элементы.Добавить(ТаблицаФормы.Имя + Колонка.Ключ, Тип("ПолеФормы"), ТаблицаФормы);
			ПолеФормы.ПутьКДанным = ТаблицаФормы.ПутьКДанным + "." + Колонка.Ключ;
			ПолеФормы.Заголовок   = Колонка.Значение;
			ПолеФормы.Вид         = ВидПоляФормы.ПолеВвода;
			
		КонецЕсли;
	
	КонецЦикла;

	ТаблицаФормы.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаПриНачалеРедактирования");
	
КонецПроцедуры // СоздатьТаблицуРегистра()

&НаСервере
// Процедура показывает таблицу регистра на странице формы.
//
Процедура ПоказатьТаблицуРегистраНаСтранице(Знач СтрокаТЧ)

	Если Метаданные.РегистрыНакопления.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда
		
		СтраницаРегистра = Элементы.НастройкаРегистровНакопления;
		ПредставлениеРегистра = Метаданные.РегистрыНакопления[СтрокаТЧ.Имя].Синоним;
		
		Регистр = Метаданные.РегистрыНакопления[СтрокаТЧ.Имя];
		
	ИначеЕсли Метаданные.РегистрыСведений.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда
		
		СтраницаРегистра = Элементы.НастройкаРегистровСведений;
		ПредставлениеРегистра = Метаданные.РегистрыСведений[СтрокаТЧ.Имя].Синоним;
		
		Регистр = Метаданные.РегистрыСведений[СтрокаТЧ.Имя];
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураРегистра = Новый Структура;
	СтруктураРегистра.Вставить("Период");
	СтруктураРегистра.Вставить("НомерСтроки");
	СтруктураРегистра.Вставить("Активность");
	СтруктураРегистра.Вставить("ВидДвижения");
	
	Для Каждого СтандартныйРеквизит Из Регистр.СтандартныеРеквизиты Цикл
		Если СтруктураРегистра.Свойство(СтандартныйРеквизит.Имя) Тогда
			СтруктураРегистра[СтандартныйРеквизит.Имя] = СтандартныйРеквизит.Синоним;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Измерение Из Регистр.Измерения Цикл
		
		СтруктураРегистра.Вставить(Измерение.Имя, Измерение.Синоним);
		
	КонецЦикла;
	
	Для Каждого Ресурс Из Регистр.Ресурсы Цикл
		
		СтруктураРегистра.Вставить(Ресурс.Имя, Ресурс.Синоним);
		
	КонецЦикла;
	
	Для Каждого Реквизит Из Регистр.Реквизиты Цикл
		
		СтруктураРегистра.Вставить(Реквизит.Имя, Реквизит.Синоним);
		
	КонецЦикла;
	
	СтраницаДляРегистра = СоздатьСтраницу(ПолучитьИмяСтраницыРегистра(СтрокаТЧ.Имя), ПредставлениеРегистра, СтраницаРегистра, 
										  ВидГруппыФормы.Страница);
	
	СоздатьТаблицуРегистра(СтрокаТЧ.Имя, СтруктураРегистра, СтраницаДляРегистра);
	
КонецПроцедуры // ПоказатьТаблицуРегистраНаСтранице()

&НаСервере
// Процедура показывает регистры на форме.
//
Процедура ПоказатьРегистры(ТаблицаРегистров)

	Для Каждого Строка Из ТаблицаРегистров Цикл

		ПоказатьТаблицуРегистраНаСтранице(Строка);

	КонецЦикла;

КонецПроцедуры // ПоказатьРегистры()

&НаСервере
// Процедура служит для включения/исключение регистров из списка редактируемых.
//
Процедура ОбработатьИзменениеРегистров(СписокРегистров)

	Для Каждого Элемент Из СписокРегистров Цикл

		// Нужно добавить новый регистр.
		Если Элемент.Пометка Тогда

			СтрокаТЧ = Объект.ТаблицаРегистров.Добавить();
			СтрокаТЧ.Имя           = Элемент.Значение;

			ПоказатьТаблицуРегистраНаСтранице(СтрокаТЧ);

		Иначе

			Для Каждого Строка Из Объект.ТаблицаРегистров.НайтиСтроки(Новый Структура("Имя", Элемент.Значение)) Цикл
				Объект.ТаблицаРегистров.Удалить(Строка);
			КонецЦикла;

			Объект.Движения[Элемент.Значение].Очистить();
			УдалитьСтраницуРегистра(Элемент.Значение);

		КонецЕсли;

	КонецЦикла;

	Модифицированность = Истина;

КонецПроцедуры // ОбработатьИзменениеРегистров()

#КонецОбласти

