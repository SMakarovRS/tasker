﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает имена и синонимы ролей.
//
Функция ВсеРоли() Экспорт
	
	Массив = Новый Массив;
	Соответствие = Новый Соответствие;
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;
		
		Массив.Добавить(ИмяРоли);
		Соответствие.Вставить(ИмяРоли, Роль.Синоним);
		Таблица.Добавить().Имя = ИмяРоли;
	КонецЦикла;
	
	ВсеРоли = Новый Структура;
	ВсеРоли.Вставить("Массив",       Новый ФиксированныйМассив(Массив));
	ВсеРоли.Вставить("Соответствие", Новый ФиксированноеСоответствие(Соответствие));
	ВсеРоли.Вставить("Таблица",      Новый ХранилищеЗначения(Таблица));
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеРоли, Ложь);
	
КонецФункции

// Возвращает роли, недоступные для указанного назначения (с учетом или без учета модели сервиса).
//
// Параметры:
//  Назначение - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                        "СовместноДляПользователейИВнешнихПользователей".
//     
//  Сервис     - Неопределено - определить текущий режим автоматически.
//             - Булево       - Ложь   - для локального режима (недоступные роли только для назначения),
//                              Истина - для модели сервиса (включая роли неразделенных пользователей).
//
// Возвращаемое значение:
//  Соответствие - со свойствами:
//   * Ключ     - Строка - имя роли.
//   * Значение - Булево - Истина.
//
Функция НедоступныеРоли(Назначение = "ДляПользователей", Сервис = Неопределено) Экспорт
	
	ПроверитьНазначение(Назначение,
		НСтр("ru = 'Ошибка в функции НедоступныеРоли общего модуля ПользователиСлужебныйПовтИсп.'"));
	
	Если Сервис = Неопределено Тогда
		Сервис = ОбщегоНазначения.РазделениеВключено();
	КонецЕсли;
	
	НазначениеРолей = ПользователиСлужебныйПовтИсп.НазначениеРолей();
	НедоступныеРоли = Новый Соответствие;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если (Назначение <> "ДляАдминистраторов" Или Сервис)
		   И НазначениеРолей.ТолькоДляАдминистраторовСистемы.Получить(Роль.Имя) <> Неопределено
		 // Для внешних пользователей.
		 Или Назначение = "ДляВнешнихПользователей"
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		   И НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		 // Для пользователей.
		 Или (Назначение = "ДляПользователей" Или Назначение = "ДляАдминистраторов")
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // Совместно для пользователей и внешних пользователей.
		 Или Назначение = "СовместноДляПользователейИВнешнихПользователей"
		   И Не НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // С учетом модели сервиса.
		 Или Сервис
		   И НазначениеРолей.ТолькоДляПользователейСистемы.Получить(Роль.Имя) <> Неопределено Тогда
			
			НедоступныеРоли.Вставить(Роль.Имя, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(НедоступныеРоли);
	
КонецФункции

// Возвращает недоступные роли для разделенных пользователей или внешних пользователей
// с учетом прав текущего пользователя и режима работы (локальный или модель сервиса).
//
// Параметры:
//  ДляВнешнихПользователей - Булево - если истина, значит для внешних пользователей.
//
// Возвращаемое значение:
//  Соответствие - со свойствами:
//   * Ключ     - Строка - имя роли.
//   * Значение - Булево - Истина.
//
Функция НедоступныеРолиПоТипуПользователя(ДляВнешнихПользователей) Экспорт
	
	Если ДляВнешнихПользователей Тогда
		НазначениеРолейПользователя = "ДляВнешнихПользователей";
		
	ИначеЕсли Не ОбщегоНазначения.РазделениеВключено()
	        И Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		
		// Пользователь с ролью АдминистраторСистемы в локальном режиме работы
		// может выдавать административные права.
		НазначениеРолейПользователя = "ДляАдминистраторов";
	Иначе
		НазначениеРолейПользователя = "ДляПользователей";
	КонецЕсли;
	
	Возврат ПользователиСлужебныйПовтИсп.НедоступныеРоли(НазначениеРолейПользователя);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает назначение ролей, определенное разработчиком.
// См. комментарий к процедуре ПриОпределенииНазначенияРолей общего модуля ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * ТолькоДляПользователейСистемы - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * ТолькоДляВнешнихПользователей - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * СовместноДляПользователейИВнешнихПользователей - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//
Функция НазначениеРолей() Экспорт
	
	НазначениеРолей = Пользователи.НазначениеРолей();
	
	Назначение = Новый Структура;
	Для Каждого ОписаниеНазначенияРолей Из НазначениеРолей Цикл
		Имена = Новый Соответствие;
		Для Каждого Имя Из ОписаниеНазначенияРолей.Значение Цикл
			Имена.Вставить(Имя, Истина);
		КонецЦикла;
		Назначение.Вставить(ОписаниеНазначенияРолей.Ключ, Новый ФиксированноеСоответствие(Имена));
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(Назначение);
	
КонецФункции

// См. Пользователи.ЭтоСеансВнешнегоПользователя.
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
	   И СеансЗапущенБезРазделителей Тогда
		// Неразделенные пользователи не могут быть внешними.
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторПользователяИБ);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	
	// Пользователь, который не найден в справочнике ВнешниеПользователи не может быть внешним.
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Настройки работы подсистемы Пользователи.
// См. также описание процедуры ПриОпределенииНастроек в общем модуле ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//   * ОбщиеНастройкиВхода - Булево - если Ложь,
//          тогда в панели администрирования "Настройки прав и пользователей" возможность
//          открытия формы настроек входа будет скрыта, как и поле СрокДействия в карточках
//          пользователя и внешнего пользователя.
//
//   * РедактированиеРолей - Булево - если Ложь, тогда
//          интерфейс изменения ролей в карточках пользователя, внешнего пользователя и
//          группы внешних пользователей будет скрыт (в том числе для администратора).
//
//   * ВнешниеПользователи - Структура - со свойствами, как у свойства Пользователи (см. далее).
//   * Пользователи - Структура - со свойствами:
//
//     * ПарольДолженОтвечатьТребованиямСложности   - Булево - проверять сложность нового пароля.
//     * МинимальнаяДлинаПароля                     - Число - проверять длину нового пароля.
//
//     * МаксимальныйСрокДействияПароля             - Число - дней после первого входа с новым паролем, после
//                                                            которого пользователю потребуется сменить пароль.
//     * МинимальныйСрокДействияПароля              - Число - дней после первого входа с новым паролем, в течение
//                                                            которого пользователь не сможет сменить пароль.
//     * ЗапретитьПовторениеПароляСредиПоследних    - Число - паролей, хеши которых будут храниться для проверки.
//
//     * ПросрочкаРаботыВПрограммеДоЗапрещенияВхода - Число - дней относительно последней активности пользователя,
//                                                            после которых вход в программу будет запрещен.
//     * ПросрочкаРаботыВПрограммеДатаВключения     - Дата  - момент записи ненулевого количества дней
//                                                            просрочки вместо нулевого.
//
Функция Настройки() Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОбщиеНастройкиВхода", Истина);
	Настройки.Вставить("РедактированиеРолей", Истина);
	
	ИнтеграцияПодсистемБСП.ПриОпределенииНастроек(Настройки);
	ПользователиПереопределяемый.ПриОпределенииНастроек(Настройки);
	
	Если ОбщегоНазначения.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		
		Настройки.Вставить("ОбщиеНастройкиВхода", Ложь);
	КонецЕсли;
	
	ВсеНастройки = ПользователиСлужебный.НастройкиВхода();
	ВсеНастройки.Вставить("ОбщиеНастройкиВхода", Настройки.ОбщиеНастройкиВхода);
	ВсеНастройки.Вставить("РедактированиеРолей", Настройки.РедактированиеРолей);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеНастройки);
	
КонецФункции

// Возвращает дерево ролей с подсистемами или без них.
// Если роль не принадлежит ни одной подсистеме она добавляется "в корень".
// 
// Параметры:
//  ПоПодсистемам - Булево - если Ложь, все роли добавляются в "корень".
//  Назначение    - Строка - "ДляАдминистраторов", "ДляПользователей", "ДляВнешнихПользователей",
//                           "СовместноДляПользователейИВнешнихПользователей".
// 
// Возвращаемое значение:
//  ДеревоЗначений - где:
//    * ЭтоРоль - Булево - 
//    * Имя     - Строка - имя     роли или подсистемы.
//    * Синоним - Строка - синоним роли или подсистемы.
//
Функция ДеревоРолей(ПоПодсистемам = Истина, Назначение = "ДляПользователей") Экспорт
	
	ПроверитьНазначение(Назначение,
		НСтр("ru = 'Ошибка в функции ДеревоРолей общего модуля ПользователиСлужебныйПовтИсп.'"));
	
	НедоступныеРоли = ПользователиСлужебныйПовтИсп.НедоступныеРоли(Назначение);
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));
	
	Если ПоПодсистемам Тогда
		ЗаполнитьПодсистемыИРоли(Дерево.Строки, Неопределено, НедоступныеРоли);
	КонецЕсли;
	
	// Добавление ненайденных ролей.
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
		 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя);
		Если Дерево.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль       = Истина;
			СтрокаДерева.Имя           = Роль.Имя;
			СтрокаДерева.Синоним       = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);
	
	Возврат Новый ХранилищеЗначения(Дерево);
	
КонецФункции

// См. Пользователи.СвойстваПроверяемогоПользователяИБ.
Функция СвойстваТекущегоПользователяИБ() Экспорт
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Свойства = Новый Структура;
	Свойства.Вставить("УказанТекущийПользовательИБ", Истина);
	Свойства.Вставить("УникальныйИдентификатор", ПользовательИБ.УникальныйИдентификатор);
	Свойства.Вставить("Имя",                     ПользовательИБ.Имя);
	
	Свойства.Вставить("ПравоАдминистрирование", ?(ПривилегированныйРежим(),
		ПравоДоступа("Администрирование", Метаданные, ПользовательИБ),
		ПравоДоступа("Администрирование", Метаданные)));
	
	Свойства.Вставить("РольДоступнаАдминистраторСистемы",
		РольДоступна(Метаданные.Роли.АдминистраторСистемы)); // Не заменять на РолиДоступны.
	
	Свойства.Вставить("РольДоступнаПолныеПрава",
		РольДоступна(Метаданные.Роли.ПолныеПрава)); // Не заменять на РолиДоступны.
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает пустые ссылки типов объектов авторизации,
// указанных в определяемом типе ВнешнийПользователь.
//
// Если в определяемом типе указан тип Строка или
// другой нессылочный тип, то он пропускается.
//
// Возвращаемое значение:
//  ФиксированныйМассив - со значениями:
//   * Значение - Ссылка - пустая ссылка типа объекта авторизации.
//
Функция ПустыеСсылкиТиповОбъектовАвторизации() Экспорт
	
	ПустыеСсылки = Новый Массив;
	
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВнешнийПользователь.Тип.Типы() Цикл
		Если Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеТипаСсылки = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Тип));
		ПустыеСсылки.Добавить(ОписаниеТипаСсылки.ПривестиЗначение(Неопределено));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ПустыеСсылки);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы, НедоступныеРоли, ВсеРоли = Неопределено)
	
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;
	
	Если ВсеРоли = Неопределено Тогда
		ВсеРоли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			
			Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено
			 Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			
				Продолжить;
			КонецЕсли;
			ВсеРоли.Вставить(Роль, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Подсистема Из Подсистемы Цикл
		
		ОписаниеПодсистемы = КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя     = Подсистема.Имя;
		ОписаниеПодсистемы.Синоним = ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);
		
		ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, НедоступныеРоли, ВсеРоли);
		
		Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
			Если ВсеРоли[ОбъектМетаданных] = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роль = ОбъектМетаданных;
			ОписаниеРоли = ОписаниеПодсистемы.Строки.Добавить();
			ОписаниеРоли.ЭтоРоль = Истина;
			ОписаниеРоли.Имя     = Роль.Имя;
			ОписаниеРоли.Синоним = ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЦикла;
		
		Отбор = Новый Структура("ЭтоРоль", Истина);
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьНазначение(Назначение, ЗаголовокОшибки)
	
	Если Назначение <> "ДляАдминистраторов"
	   И Назначение <> "ДляПользователей"
	   И Назначение <> "ДляВнешнихПользователей"
	   И Назначение <> "СовместноДляПользователейИВнешнихПользователей" Тогда
		
		ВызватьИсключение ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Параметр Назначение ""%1"" указан некорректно.
			           |
			           |Допустимы только следующие значения:
			           |- ""ДляАдминистраторов"",
			           |- ""ДляПользователей"",
			           |- ""ДляВнешнихПользователей"",
			           |- ""СовместноДляПользователейИВнешнихПользователей"".'"),
			Назначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
