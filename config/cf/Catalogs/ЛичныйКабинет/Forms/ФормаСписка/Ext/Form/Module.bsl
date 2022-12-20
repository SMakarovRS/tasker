﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	ПрочитатьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСтраницыЛичногоКабинета" Тогда
		ЭтаФорма.ОбновитьОтображениеДанных(Элементы.Список);
		Элементы.Список.Обновить();
		ПрочитатьНастройки();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	
	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;

	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Все файлы (*.*)|*.*'");
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			Для Каждого ВыбранноеИмя Из ДиалогОткрытияФайла.ВыбранныеФайлы Цикл
				Файл = Новый Файл(ВыбранноеИмя);
				ОписаниеФайла = СтрШаблон(НСтр("ru = 'Исходный файл: %1'"));
				Родитель = Элементы.Список.ТекущийРодитель;
				АдресВременногоХранилища = "";
				
				ОбработкаОкончанияПомещения = Новый ОписаниеОповещения("ЗагрузитьФайлЗавершение", ЭтотОбъект,
					Новый Структура("АдресВременногоХранилища,ОписаниеФайла,ИмяФайла,ПолноеИмя,Путь,Родитель,ЭтоФайл",
						АдресВременногоХранилища, ОписаниеФайла, Файл.Имя, Файл.ПолноеИмя, Файл.Путь, Родитель, 
						Истина));
						
				НачатьПомещениеФайла(ОбработкаОкончанияПомещения, АдресВременногоХранилища, ВыбранноеИмя, Ложь, );
					
			КонецЦикла;
		КонецЕсли;
	Иначе		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Данная возможность недоступна, так как не подключено расширение работы с файлами.'", "ru"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлЗавершение(Результат, Адрес, ВыбранноеИмя, ДополнительныеПараметры) Экспорт
    
    Если Результат И Адрес <> Неопределено И Адрес <> "" Тогда
        ПоместитьФайлОбъекта(Адрес, ДополнительныеПараметры);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка при загрузке файла в хранилище...'"));
	КонецЕсли;
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЛичныйКабинет"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПапку(Команда)

	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;

	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.Каталог = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда			
			МассивНайденныхФайлов = НайтиФайлы(ДиалогОткрытияФайла.Каталог, "*", Истина);			
			Для Каждого Файл Из МассивНайденныхФайлов Цикл
				ВыбранноеИмя = Файл.ПолноеИмя;
				Файл = Новый Файл(ВыбранноеИмя);
				Родитель = Элементы.Список.ТекущийРодитель;
				АдресВременногоХранилища = "";                       
				Если Файл.ЭтоФайл() Тогда
					ОписаниеФайла = СтрШаблон(НСтр("ru = 'Исходный файл: %1'"), Файл.Имя);
					НачатьПомещениеФайла(Новый ОписаниеОповещения("ЗагрузитьФайлЗавершение", ЭтотОбъект, 
						Новый Структура("АдресВременногоХранилища,ОписаниеФайла,ИмяФайла,ПолноеИмя,Путь,Родитель,
							|ЭтоФайл",
							АдресВременногоХранилища, ОписаниеФайла, Файл.Имя, Файл.ПолноеИмя, Файл.Путь, Родитель, 
							Истина)),
						АдресВременногоХранилища, ВыбранноеИмя, Ложь,);
					
				Иначе
					ОписаниеФайла = СтрШаблон(НСтр("ru = 'Исходная папка: %1'"), Файл.Имя);
					
					ПоместитьФайлОбъекта(АдресВременногоХранилища, 
						Новый Структура("АдресВременногоХранилища,ОписаниеФайла,ИмяФайла,ПолноеИмя,Путь,Родитель,
							|ЭтоФайл",
							АдресВременногоХранилища, ОписаниеФайла, Файл.Имя, Файл.ПолноеИмя, 
							ДиалогОткрытияФайла.Каталог, Родитель, Ложь));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Данная возможность недоступна, так как не подключено расширение работы с файлами.'", "ru"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкиКлиент(Команда)
	
	ЗаписатьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортЭкспорт(Команда)
	
	ОткрытьФорму("Справочник.ЛичныйКабинет.Форма.ФормаИмпортаЭкспорта",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредопределенные(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаЗаполнитьПредопределенные", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, 
		НСтр("ru = 'Будет выполнено заполнение элементов личного кабинета настройками по-умолчанию.
              |Это может занять некоторое время. Продолжить?'"), РежимДиалогаВопрос.ДаНет);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаЗаполнитьПредопределенные(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда		
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ЗаполнитьПредопределенныеЛичногоКабинетаНаСервере();
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания       = Истина;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ТекстСообщения       		 = 
			НСтр("ru = 'Идет заполнение элементов личного кабинета. Это может занять некоторое время'");
		ПараметрыОжидания.Интервал             		 = 2;
		ОповещениеОЗавершении 						 = 
			Новый ОписаниеОповещения("ПослеЗавершенияВыполненияСервернойКомандыВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПредопределенныеЛичногоКабинетаНаСервере()
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "ЗаполнитьПредопределенныеЛичногоКабинетаФоновымЗаданием";
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;		
	ПараметрыЗадания 								= Новый Структура;	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"Справочники.ЛичныйКабинет.ЗаполнитьСтраницыЛичногоКабинетаПриПервоначальномЗаполнении",
		ПараметрыЗадания, ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияВыполненияСервернойКомандыВФоне(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось заполнить элементы справочника по причине:
				|%1.'"), Результат.КраткоеПредставлениеОшибки);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Заполнение элементов справочника завершено.'"));
		Оповестить("ОбновитьСтраницыЛичногоКабинета");	
	КонецЕсли;		
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьФайлОбъекта(АдресВременногоХранилища, ДополнительныеПараметры)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПолноеИмяПути = Сред(ДополнительныеПараметры.ПолноеИмя, СтрДлина(ДополнительныеПараметры.Путь) + 1);
	ПолноеИмя = Лев(ПолноеИмяПути, СтрДлина(ПолноеИмяПути) - СтрДлина(ДополнительныеПараметры.ИмяФайла));
	
	НайденныйРодитель = ДополнительныеПараметры.Родитель;
	Если СтрДлина(ПолноеИмя) > 1 Тогда
		Массив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмя, ПолучитьРазделительПути(), 
			Истина); 
		Для Каждого Элемент Из Массив Цикл
			Структура 			= Новый Структура("АдресВременногоХранилища,ОписаниеФайла,ИмяФайла,
				|ПолноеИмя,Путь,Родитель,ЭтоФайл,Группы");
			ЗаполнитьЗначенияСвойств(Структура, ДополнительныеПараметры);
			Структура.ЭтоФайл 	= Ложь;
			Структура.Родитель 	= НайденныйРодитель;
			Структура.ПолноеИмя = ПолноеИмяПути;
			Структура.ИмяФайла 	= Элемент;
			Структура.Путь 		= ДополнительныеПараметры.Путь + ПолучитьРазделительПути() + Элемент;
			НайденныйРодитель 	= ПоместитьФайлОбъекта("", Структура);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЛичныйКабинет.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЛичныйКабинет КАК ЛичныйКабинет
		|ГДЕ
		|	ЛичныйКабинет.ЭтоГруппа = &ЭтоГруппа
		|	И ЛичныйКабинет.Родитель = &Родитель
		|	И ЛичныйКабинет.Наименование = &Наименование";
		
	Запрос.УстановитьПараметр("ЭтоГруппа", 		НЕ ДополнительныеПараметры.ЭтоФайл);
	Запрос.УстановитьПараметр("Родитель", 		НайденныйРодитель);
	Запрос.УстановитьПараметр("Наименование", 	ДополнительныеПараметры.ИмяФайла);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Если ДополнительныеПараметры.ЭтоФайл Тогда
			НоваяСтраница = Справочники.ЛичныйКабинет.СоздатьЭлемент();
		Иначе
			НоваяСтраница = Справочники.ЛичныйКабинет.СоздатьГруппу();
		КонецЕсли;
	Иначе
		// Группа уже создана, вернем ее.
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	НоваяСтраница.Родитель 		= НайденныйРодитель;
	Если ДополнительныеПараметры.ЭтоФайл Тогда
		НоваяСтраница.ТипФайла 		= РаботаСHTML.ТипФайла(ДополнительныеПараметры.ИмяФайла);
		ДвоичныеДанные 				= ПолучитьИзВременногоХранилища(АдресВременногоХранилища);		
		НоваяСтраница.ХранилищеФайла= Новый ХранилищеЗначения(ДвоичныеДанные, 
			Новый СжатиеДанных(?(СтрНайти(НоваяСтраница.ТипФайла, "text/") > 0, 9, 0)));
		УдалитьИзВременногоХранилища(АдресВременногоХранилища);
		НоваяСтраница.ОписаниеФайла = ДополнительныеПараметры.ОписаниеФайла;
		НоваяСтраница.Расширение 	= ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(
			ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ДополнительныеПараметры.ИмяФайла));
	КонецЕсли;
	НоваяСтраница.Наименование = ДополнительныеПараметры.ИмяФайла;
	НоваяСтраница.ДополнительныеСвойства.Вставить("НеВыполнятьПравилаСобытий", Истина);
	НоваяСтраница.ОбменДанными.Загрузка = Истина;
	НоваяСтраница.Записать();
	
	Если НоваяСтраница.ПометкаУдаления = Истина Тогда
		НоваяСтраница.УстановитьПометкуУдаления(Ложь);
	КонецЕсли;
	
	Возврат НоваяСтраница.Ссылка;
	
КонецФункции

&НаСервере
Процедура ПрочитатьНастройки()
	
	УстановитьПривилегированныйРежим(Истина);
	ХранилищеЗначения 	= Константы.ЛичныйКабинетЛокализация.Получить();
	Локализация 		= ХранилищеЗначения.Получить();
	ИндексСтроки 		= 0;
	ТД = Новый ТекстовыйДокумент;
	Для ИндексСтроки = 1 По СтрЧислоСтрок(Локализация) Цикл
		Стр = СтрПолучитьСтроку(Локализация, ИндексСтроки);
		Если НЕ ПустаяСтрока(Стр) Тогда
			ТД.ДобавитьСтроку(Стр);
		КонецЕсли;
	КонецЦикла;
	ЛичныйКабинетЛокализация					= ТД.ПолучитьТекст();
	ЛичныйКабинетСтраница404 					= Константы.ЛичныйКабинетСтраница404.Получить();
	ЛичныйКабинетСтраницаУстановкиОценокПоЗаданию = Константы.ЛичныйКабинетСтраницаУстановкиОценокПоЗаданию.Получить();
	ЛичныйКабинетСтраницаЗадания 				= Константы.ЛичныйКабинетСтраницаЗадания.Получить();
	ЛичныйКабинетДобавлениеКомментария			= Константы.ЛичныйКабинетДобавлениеКомментария.Получить();
	ЛичныйКабинетСтраницаАвторизации			= Константы.ЛичныйКабинетСтраницаАвторизации.Получить();
	ЛичныйКабинетИспользоватьСобственнуюАвторизацию = 
		Константы.ЛичныйКабинетИспользоватьСобственнуюАвторизацию.Получить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки()
	
	УстановитьПривилегированныйРежим(Истина);
	ХранилищеЗначения = Новый ХранилищеЗначения(ЛичныйКабинетЛокализация, Новый СжатиеДанных(5));
	Константы.ЛичныйКабинетЛокализация.Установить(ХранилищеЗначения);
	Константы.ЛичныйКабинетСтраница404.Установить(ЛичныйКабинетСтраница404);
	Константы.ЛичныйКабинетСтраницаУстановкиОценокПоЗаданию.Установить(ЛичныйКабинетСтраницаУстановкиОценокПоЗаданию);
	Константы.ЛичныйКабинетСтраницаЗадания.Установить(ЛичныйКабинетСтраницаЗадания);
	Константы.ЛичныйКабинетДобавлениеКомментария.Установить(ЛичныйКабинетДобавлениеКомментария);
	Константы.ЛичныйКабинетСтраницаАвторизации.Установить(ЛичныйКабинетСтраницаАвторизации);
	Константы.ЛичныйКабинетИспользоватьСобственнуюАвторизацию.Установить(
		ЛичныйКабинетИспользоватьСобственнуюАвторизацию);
	Модифицированность = Ложь;
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти