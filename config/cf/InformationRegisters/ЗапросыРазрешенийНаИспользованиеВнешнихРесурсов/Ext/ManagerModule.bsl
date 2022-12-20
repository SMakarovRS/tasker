﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Создает запрос администрирования профилей безопасности.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка, ссылка, описывающая программный модуль, для подключения которого
//    предназначен профиль безопасности,
//  Операция - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности.
//
// Возвращаемое значение - УникальныйИдентификатор - идентификатор созданного запроса.
//
Функция ЗапросАдминистрированияРазрешений(Знач ПрограммныйМодуль, Знач Операция) Экспорт
	
	Если Не ТребуетсяЗапросРазрешенийНаИспользованиеВнешнихРесурсов() Тогда
		Возврат Новый УникальныйИдентификатор();
	КонецЕсли;
	
	Если Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Создание Тогда
		ИмяПрофиляБезопасности = НовоеИмяПрофиляБезопасности(ПрограммныйМодуль);
	Иначе
		ИмяПрофиляБезопасности = ИмяПрофиляБезопасности(ПрограммныйМодуль);
	КонецЕсли;
	
	Менеджер = СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторЗапроса = Новый УникальныйИдентификатор();
	
	Если РаботаВБезопасномРежиме.УстановленБезопасныйРежим() Тогда
		Менеджер.БезопасныйРежим = БезопасныйРежим();
	Иначе
		Менеджер.БезопасныйРежим = Ложь;
	КонецЕсли;
	
	Менеджер.Операция = Операция;
	Менеджер.ЗапросАдминистрирования = Истина;
	Менеджер.Имя = ИмяПрофиляБезопасности;
	
	СвойстваПрограммногоМодуля = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(ПрограммныйМодуль);
	Менеджер.ТипПрограммногоМодуля = СвойстваПрограммногоМодуля.Тип;
	Менеджер.ИдентификаторПрограммногоМодуля = СвойстваПрограммногоМодуля.Идентификатор;
	
	Менеджер.Записать();
	
	КлючЗаписи = СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Менеджер.ИдентификаторЗапроса));
	ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
	
	Возврат Менеджер.ИдентификаторЗапроса;
	
КонецФункции

// Создает запрос разрешений на использование внешних ресурсов.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка, ссылка, описывающая программный модуль, для подключения которого
//    предназначен профиль безопасности,
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны запрашиваемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, предоставление разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных,
//  РежимЗамещения - Булево - определяет режим замещения ранее выданных разрешений для данного владельца. При
//    значении параметра равным Истина, помимо предоставления запрошенных разрешений в запрос будет добавлена
//    очистка всех разрешений, ранее запрошенных для этого же владельца.
//  ДобавляемыеРазрешения - Массив Из ОбъектXDTO - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    запрашиваемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//  УдаляемыеРазрешения - Массив Из ОбъектXDTO - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    отменяемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//
// Возвращаемое значение - УникальныйИдентификатор - идентификатор созданного запроса.
//
Функция ЗапросИспользованияРазрешений(Знач ПрограммныйМодуль, Знач Владелец, Знач РежимЗамещения, Знач ДобавляемыеРазрешения, Знач УдаляемыеРазрешения) Экспорт
	
	Если Не ТребуетсяЗапросРазрешенийНаИспользованиеВнешнихРесурсов() Тогда
		Возврат Новый УникальныйИдентификатор();
	КонецЕсли;
	
	Если Владелец = Неопределено Тогда
		Владелец = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	КонецЕсли;
	
	Если ПрограммныйМодуль = Неопределено Тогда
		ПрограммныйМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	КонецЕсли;
	
	Если РаботаВБезопасномРежиме.УстановленБезопасныйРежим() Тогда
		БезопасныйРежим = БезопасныйРежим();
	Иначе
		БезопасныйРежим = Ложь;
	КонецЕсли;
	
	Менеджер = СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторЗапроса = Новый УникальныйИдентификатор();
	Менеджер.ЗапросАдминистрирования = Ложь;
	Менеджер.БезопасныйРежим = БезопасныйРежим;
	Менеджер.РежимЗамещения = РежимЗамещения;
	Менеджер.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Обновление;
	
	СвойстваВладельца = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(Владелец);
	Менеджер.ТипВладельца = СвойстваВладельца.Тип;
	Менеджер.ИдентификаторВладельца = СвойстваВладельца.Идентификатор;
	
	СвойстваПрограммногоМодуля = РаботаВБезопасномРежимеСлужебный.СвойстваДляРегистраРазрешений(ПрограммныйМодуль);
	Менеджер.ТипПрограммногоМодуля = СвойстваПрограммногоМодуля.Тип;
	Менеджер.ИдентификаторПрограммногоМодуля = СвойстваПрограммногоМодуля.Идентификатор;
	
	Если ДобавляемыеРазрешения <> Неопределено Тогда
		
		МассивРазрешений = Новый Массив();
		Для Каждого НовоеРазрешение Из ДобавляемыеРазрешения Цикл
			МассивРазрешений.Добавить(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(НовоеРазрешение));
		КонецЦикла;
		
		Если МассивРазрешений.Количество() > 0 Тогда
			Менеджер.ДобавляемыеРазрешения = ОбщегоНазначения.ЗначениеВСтрокуXML(МассивРазрешений);
		КонецЕсли;
		
	КонецЕсли;
	
	Если УдаляемыеРазрешения <> Неопределено Тогда
		
		МассивРазрешений = Новый Массив();
		Для Каждого ОтменяемоеРазрешение Из УдаляемыеРазрешения Цикл
			МассивРазрешений.Добавить(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ОтменяемоеРазрешение));
		КонецЦикла;
		
		Если МассивРазрешений.Количество() > 0 Тогда
			Менеджер.УдаляемыеРазрешения = ОбщегоНазначения.ЗначениеВСтрокуXML(МассивРазрешений);
		КонецЕсли;
		
	КонецЕсли;
	
	Менеджер.Записать();
	
	КлючЗаписи = СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Менеджер.ИдентификаторЗапроса));
	ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
	
	Возврат Менеджер.ИдентификаторЗапроса;
	
КонецФункции

// Создает и инициализирует менеджер применения запросов на использование внешних ресурсов.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив Из УникальныйИдентификатор - идентификаторы запросов, для
//   применения которых создается менеджер.
//
// Возвращаемое значение:
//   ОбработкаОбъект.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.
//
Функция МенеджерПримененияРазрешений(Знач ИдентификаторыЗапросов) Экспорт
	
	Менеджер = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Создать();
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ЗапросыРазрешений.ТипПрограммногоМодуля,
		|	ЗапросыРазрешений.ИдентификаторПрограммногоМодуля,
		|	ЗапросыРазрешений.ТипВладельца,
		|	ЗапросыРазрешений.ИдентификаторВладельца,
		|	ЗапросыРазрешений.Операция,
		|	ЗапросыРазрешений.Имя,
		|	ЗапросыРазрешений.РежимЗамещения,
		|	ЗапросыРазрешений.ДобавляемыеРазрешения,
		|	ЗапросыРазрешений.УдаляемыеРазрешения,
		|	ЗапросыРазрешений.ИдентификаторЗапроса
		|ИЗ
		|	РегистрСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсов КАК ЗапросыРазрешений
		|ГДЕ
		|	ЗапросыРазрешений.ИдентификаторЗапроса В(&ИдентификаторыЗапросов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗапросыРазрешений.ЗапросАдминистрирования УБЫВ";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КлючЗаписи = СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Выборка.ИдентификаторЗапроса));
		ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
		
		Если Выборка.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Создание
			ИЛИ Выборка.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Удаление Тогда
			
			Менеджер.ДобавитьИдентификаторЗапроса(Выборка.ИдентификаторЗапроса);
			
			Менеджер.ДобавитьОперациюАдминистрирования(
				Выборка.ТипПрограммногоМодуля,
				Выборка.ИдентификаторПрограммногоМодуля,
				Выборка.Операция,
				Выборка.Имя);
			
		КонецЕсли;
		
		ДобавляемыеРазрешения = Новый Массив();
		Если ЗначениеЗаполнено(Выборка.ДобавляемыеРазрешения) Тогда
			
			Массив = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.ДобавляемыеРазрешения);
			
			Для Каждого ЭлементМассива Из Массив Цикл
				ДобавляемыеРазрешения.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
			
		КонецЕсли;
		
		УдаляемыеРазрешения = Новый Массив();
		Если ЗначениеЗаполнено(Выборка.УдаляемыеРазрешения) Тогда
			
			Массив = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.УдаляемыеРазрешения);
			
			Для Каждого ЭлементМассива Из Массив Цикл
				УдаляемыеРазрешения.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
			
		КонецЕсли;
		
		Менеджер.ДобавитьИдентификаторЗапроса(Выборка.ИдентификаторЗапроса);
		
		Менеджер.ДобавитьЗапросРазрешенийНаИспользованиеВнешнихРесурсов(
			Выборка.ТипПрограммногоМодуля,
			Выборка.ИдентификаторПрограммногоМодуля,
			Выборка.ТипВладельца,
			Выборка.ИдентификаторВладельца,
			Выборка.РежимЗамещения,
			ДобавляемыеРазрешения,
			УдаляемыеРазрешения);
		
	КонецЦикла;
	
	Менеджер.РассчитатьПрименениеЗапросов();
	
	Возврат Менеджер;
	
КонецФункции

// Проверяет необходимость интерактивного запроса разрешений на использование внешних ресурсов.
//
// Возвращаемое значение:
//   Булево - 
//
Функция ТребуетсяЗапросРазрешенийНаИспользованиеВнешнихРесурсов()
	
	Если Не ВозможенЗапросРазрешенийНаИспользованиеВнешнихРесурсов() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Константы.ИспользуютсяПрофилиБезопасности.Получить() И Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить();
	
КонецФункции

// Проверяет возможность интерактивного запроса разрешений на использование внешних ресурсов.
//
// Возвращаемое значение:
//   Булево - 
//
Функция ВозможенЗапросРазрешенийНаИспользованиеВнешнихРесурсов()
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияИнформационнойБазы()) ИЛИ Не ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
		
		// В файловой ИБ или при выключенных профилях безопасности запись запросов разрешений возможна
		// в привилегированном режиме или при использовании учетной записи пользователя с правами администратора.
		Возврат ПривилегированныйРежим() ИЛИ Пользователи.ЭтоПолноправныйПользователь();
		
	Иначе
		
		// В клиент-серверной ИБ при включенных профилях безопасности запись запросов разрешений доступна только
		// администраторам независимо от установки привилегированного режима.
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
			
			ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для запроса разрешений на использование внешних ресурсов.'");
			
		КонецЕсли;
		
		Возврат Истина;
		
	КонецЕсли; 
	
КонецФункции

// Возвращает имя профиля безопасности для информационной базы или внешнего модуля.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка на элемент справочника, использующийся в
//    качестве внешнего модуля.
//
// Возвращаемое значение: 
//   Строка - имя профиля безопасности.
//
Функция ИмяПрофиляБезопасности(Знач ПрограммныйМодуль)
	
	Если ПрограммныйМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
		
		Возврат Константы.ПрофильБезопасностиИнформационнойБазы.Получить();
		
	Иначе
		
		Возврат РегистрыСведений.РежимыПодключенияВнешнихМодулей.РежимПодключенияВнешнегоМодуля(ПрограммныйМодуль);
		
	КонецЕсли;
	
КонецФункции

// Формирует имя профиля безопасности для информационной базы или внешнего модуля.
//
// Параметры:
//   ВнешнийМодуль - ЛюбаяСсылка - ссылка на элемент справочника, использующийся в
//                                 качестве внешнего модуля.
//
// Возвращаемое значение: 
//   Строка - имя профиля безопасности.
//
Функция НовоеИмяПрофиляБезопасности(Знач ПрограммныйМодуль)
	
	Если ПрограммныйМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
		
		Результат = "Infobase_" + Строка(Новый УникальныйИдентификатор());
		
	Иначе
		
		МенеджерМодуля = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(ПрограммныйМодуль);
		Шаблон = МенеджерМодуля.ШаблонИмениПрофиляБезопасности(ПрограммныйМодуль);
		Возврат СтрЗаменить(Шаблон, "%1", Строка(Новый УникальныйИдентификатор()));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Очищает неактуальные запросы на использование внешних ресурсов.
//
Процедура ОчиститьНеактуальныеЗапросы() Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Выборка = Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Попытка
				
				Ключ = СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Выборка.ИдентификаторЗапроса));
				ЗаблокироватьДанныеДляРедактирования(Ключ);
				
			Исключение
				
				// Обработка исключения не требуется.
				// Ожидаемое исключение - попытка удалить ту же запись регистра из другого сеанса.
				Продолжить;
				
			КонецПопытки;
			
			Менеджер = СоздатьМенеджерЗаписи();
			Менеджер.ИдентификаторЗапроса = Выборка.ИдентификаторЗапроса;
			Менеджер.Удалить();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Создает "пустые" запросы замещения для всех ранее предоставленных разрешений.
//
// Возвращаемое значение:
//   Массив Из УникальныйИдентификатор - идентификаторы запросов для замещения всех ранее
//   предоставленных разрешений.
//
Функция ЗапросыЗамещенияДляВсехПредоставленныхРазрешений() Экспорт
	
	Результат = Новый Массив();
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаРазрешений.ТипПрограммногоМодуля,
		|	ТаблицаРазрешений.ИдентификаторПрограммногоМодуля,
		|	ТаблицаРазрешений.ТипВладельца,
		|	ТаблицаРазрешений.ИдентификаторВладельца
		|ИЗ
		|	РегистрСведений.РазрешенияНаИспользованиеВнешнихРесурсов КАК ТаблицаРазрешений";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПрограммныйМодуль = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Выборка.ТипПрограммногоМодуля,
			Выборка.ИдентификаторПрограммногоМодуля);
		
		Владелец = РаботаВБезопасномРежимеСлужебный.СсылкаИзРегистраРазрешений(
			Выборка.ТипВладельца,
			Выборка.ИдентификаторВладельца);
		
		ЗапросЗамещения = РаботаВБезопасномРежимеСлужебный.ЗапросИзмененияРазрешений(
			Владелец, Истина, Новый Массив(), , ПрограммныйМодуль);
		
		Результат.Добавить(ЗапросЗамещения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сериализует запросы на использование внешних ресурсов.
//
// Параметры:
//  Идентификаторы - Массив Из УникальныйИдентификатор - идентификаторы сериализуемых
//   запросов.
//
// Возвращаемое значение - Строка.
//
Функция ЗаписатьЗапросыВСтрокуXML(Знач Идентификаторы) Экспорт
	
	Результат = Новый Массив();
	
	Для Каждого Идентификатор Из Идентификаторы Цикл
		
		Набор = СоздатьНаборЗаписей();
		Набор.Отбор.ИдентификаторЗапроса.Установить(Идентификатор);
		Набор.Прочитать();
		
		Результат.Добавить(Набор);
		
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Результат);
	
КонецФункции

// Десериализует запросы на использование внешних ресурсов.
//
// Параметры:
//  СтрокаXML - Строка - результат функции ЗаписатьЗапросыВСтрокуXML().
//
Процедура ПрочитатьЗапросыИзСтрокиXML(Знач СтрокаXML) Экспорт
	
	Запросы = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого Запрос Из Запросы Цикл
			Запрос.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Удаляет запросы на использование внешних ресурсов.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив Из УникальныйИдентификатор - идентификаторы удаляемых запросов.
//
Процедура УдалитьЗапросы(Знач ИдентификаторыЗапросов) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого ИдентификаторЗапроса Из ИдентификаторыЗапросов Цикл
			
			Менеджер = СоздатьМенеджерЗаписи();
			Менеджер.ИдентификаторЗапроса = ИдентификаторЗапроса;
			Менеджер.Удалить();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
