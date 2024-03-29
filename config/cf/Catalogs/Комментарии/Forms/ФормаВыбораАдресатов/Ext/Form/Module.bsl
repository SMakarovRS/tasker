﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВладелецКомментария", ВладелецКомментария);
	МассивАдресатов = Новый Массив;
	Параметры.Свойство("МассивАдресатов", МассивАдресатов);
	
	Если МассивАдресатов.Количество() > 0 Тогда
		Для Каждого Адресат Из МассивАдресатов Цикл
			Если ЗначениеЗаполнено(Адресат) Тогда
				Адресаты.Добавить(Адресат);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	ОтобразитьДерево();
	
	СвернутьРазвернуть 							= Ложь;
	Элементы.ДеревоРазвернутьДерево.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСвернутьДерево(Команда)
	
	СвернутьДерево(Дерево);
	Элементы.ДеревоСвернутьДерево.Доступность 	= Ложь;
	Элементы.ДеревоРазвернутьДерево.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРазвернутьДерево(Команда)
	
	РазвернутьДерево(Дерево, 2);
	Элементы.ДеревоРазвернутьДерево.Доступность = Ложь;
	Элементы.ДеревоСвернутьДерево.Доступность 	= Истина;

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	МассивАдресатов = МассивАдресатовНаСервере();
	
	Закрыть(МассивАдресатов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	КоллекцияЭлементовДерева = Дерево.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл
		УстановитьДочерниеФлаги(Строка, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	КоллекцияЭлементовДерева = Дерево.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл
		УстановитьДочерниеФлаги(Строка, Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    Если Поле.Имя = "ДеревоАдресат" Тогда
        Возврат;
    КонецЕсли;
    
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Флаг = Не ТекущиеДанные.Флаг;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СвернутьДерево(Дерево)
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();		
		СвернутьДерево(Строка);		
		Элементы.Дерево.Свернуть(ИдентификаторСтроки);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте 
Процедура РазвернутьДерево(Дерево, Знач Уровень)
	
	Уровень = Уровень - 1;
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		
		Если Уровень >= 0 Тогда
			ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
			Элементы.Дерево.Развернуть(ИдентификаторСтроки);
			РазвернутьДерево(Строка,Уровень); 
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДерево()
	
	Если ТипЗнч(ВладелецКомментария) = Тип("ДокументСсылка.Задание") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВладелецКомментария, 
			"Автор, Инициатор, Клиент, ТекущийИсполнитель, Наблюдатели");
		
		тДерево = РеквизитФормыВЗначение("Дерево");
		тДерево.Строки.Очистить();
		
		ПользовательПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
		
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.Автор) Тогда
			АвторЗадания 		 = ЗначенияРеквизитов.Автор;
			СтрокаДерева 		 = тДерево.Строки.Добавить();
			СтрокаДерева.Адресат = АвторЗадания;
			СтрокаДерева.Роль	 = НСтр("ru = 'Автор'");
			СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(АвторЗадания) <> Неопределено;
            Если СтрокаДерева.Флаг Тогда
                Адресаты.НайтиПоЗначению(АвторЗадания).Пометка = Истина;
            КонецЕсли;
			СтрокаДерева.Группа	 = НСтр("ru = 'Автор'");
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.Инициатор) Тогда
			ИнициаторЗадания = ЗначенияРеквизитов.Инициатор;
			НайденнаяСтрока  = тДерево.Строки.Найти(ИнициаторЗадания, "Адресат", Истина);
			Если НайденнаяСтрока = Неопределено Тогда
				СтрокаДерева 		 = тДерево.Строки.Добавить();
				СтрокаДерева.Адресат = ИнициаторЗадания;
				СтрокаДерева.Роль	 = НСтр("ru = 'Инициатор'");
				СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(ИнициаторЗадания) <> Неопределено;
                Если СтрокаДерева.Флаг Тогда
                    Адресаты.НайтиПоЗначению(ИнициаторЗадания).Пометка = Истина;
                КонецЕсли;
				СтрокаДерева.Группа	 = НСтр("ru = 'Инициатор'");
			Иначе
				НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Инициатор'");
			КонецЕсли;	
			
			Если ЗначениеЗаполнено(ЗначенияРеквизитов.Клиент) Тогда
				КлиентЗадания = ЗначенияРеквизитов.Клиент;
				НайденнаяСтрока  = тДерево.Строки.Найти(КлиентЗадания, "Адресат", Истина);
				Если НайденнаяСтрока = Неопределено Тогда
					СтрокаДерева 		 = тДерево.Строки.Добавить();
					СтрокаДерева.Адресат = КлиентЗадания;
					СтрокаДерева.Роль	 = НСтр("ru = 'Клиент'");
					СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(КлиентЗадания) <> Неопределено;
                    Если СтрокаДерева.Флаг Тогда
                        Адресаты.НайтиПоЗначению(КлиентЗадания).Пометка = Истина;
                    КонецЕсли;
				Иначе
					НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Клиент'");
				КонецЕсли;			
			КонецЕсли;	
		КонецЕсли;		
				
		СтрокаИсполнителя  = Неопределено;		
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.ТекущийИсполнитель) Тогда
			
			ИсполнительЗадания = ЗначенияРеквизитов.ТекущийИсполнитель;
			НайденнаяСтрока    = тДерево.Строки.Найти(ИсполнительЗадания, "Адресат", Истина);
			Если НайденнаяСтрока = Неопределено Тогда
				СтрокаДерева 		 = тДерево.Строки.Добавить();
				СтрокаДерева.Адресат = ИсполнительЗадания;
				СтрокаДерева.Роль	 = НСтр("ru = 'Текущий исполнитель'");
				СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(ИсполнительЗадания) <> Неопределено;
				СтрокаДерева.Группа	 = НСтр("ru = 'Исполнитель'");
                Если СтрокаДерева.Флаг Тогда
                    Адресаты.НайтиПоЗначению(ИсполнительЗадания).Пометка = Истина;
                КонецЕсли;
				СтрокаИсполнителя	 = СтрокаДерева;	
			Иначе
				НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Текущий исполнитель'");
			КонецЕсли;
			
			Если ТипЗнч(ИсполнительЗадания) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				СоставГруппы = ИсполнительЗадания.Состав;
				Если СоставГруппы.Количество() > 0 Тогда
					Для Каждого СтрокаСостава Из СоставГруппы Цикл
						НайденнаяСтрока = тДерево.Строки.Найти(СтрокаСостава.Пользователь, "Адресат", Истина);						
						Если НайденнаяСтрока = Неопределено Тогда
							Если СтрокаИсполнителя <> Неопределено Тогда
								СтрокаДерева 		 = СтрокаИсполнителя.Строки.Добавить();
							Иначе
								СтрокаДерева 		 = тДерево.Строки.Добавить();
							КонецЕсли;	
							СтрокаДерева.Адресат = СтрокаСостава.Пользователь;
							СтрокаДерева.Роль	 = НСтр("ru = 'Участник группы исполнителей'");
							СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(СтрокаСостава.Пользователь) <> Неопределено;
							СтрокаДерева.Группа	 = НСтр("ru = 'Исполнитель'");
                            Если СтрокаДерева.Флаг Тогда
                                Адресаты.НайтиПоЗначению(СтрокаСостава.Пользователь).Пометка = Истина;
                            КонецЕсли;
						Иначе
							НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Участник группы исполнителей'");
						КонецЕсли;
					КонецЦикла;	
				КонецЕсли;	
			КонецЕсли;				
		КонецЕсли;
				
		Наблюдатели = ЗначенияРеквизитов.Наблюдатели.Выгрузить(); 
		Если Наблюдатели.Количество() > 0 Тогда			
			Для Каждого СтрокаНаблюдатель Из Наблюдатели Цикл
				СтрокаДереваНаблюдатель = Неопределено;
				ТекущийНаблюдатель 		= СтрокаНаблюдатель.Адресат;
				НайденнаяСтрока  		= тДерево.Строки.Найти(ТекущийНаблюдатель, "Адресат", Истина);
				Если НайденнаяСтрока = Неопределено Тогда
					СтрокаДерева 		 = тДерево.Строки.Добавить();
					СтрокаДерева.Адресат = ТекущийНаблюдатель;
					СтрокаДерева.Роль	 = НСтр("ru = 'Наблюдатель'");
					СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(ТекущийНаблюдатель) <> Неопределено;
					СтрокаДерева.Группа	 = НСтр("ru = 'Наблюдатель'");
                    Если СтрокаДерева.Флаг Тогда
                        Адресаты.НайтиПоЗначению(ТекущийНаблюдатель).Пометка = Истина;
                    КонецЕсли;
					СтрокаДереваНаблюдатель	 = СтрокаДерева;	
				Иначе
					НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Наблюдатель'");
				КонецЕсли;
				
				Если ТипЗнч(ТекущийНаблюдатель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
					СоставГруппы = ТекущийНаблюдатель.Состав;
					Если СоставГруппы.Количество() > 0 Тогда
						Для Каждого СтрокаСостава Из СоставГруппы Цикл
							НайденнаяСтрока = тДерево.Строки.Найти(СтрокаСостава.Пользователь, "Адресат", Истина);						
							Если НайденнаяСтрока = Неопределено Тогда
								Если СтрокаДереваНаблюдатель <> Неопределено Тогда
									СтрокаДерева 		 = СтрокаДереваНаблюдатель.Строки.Добавить();
								Иначе
									СтрокаДерева 		 = тДерево.Строки.Добавить();
								КонецЕсли;	
								СтрокаДерева.Адресат = СтрокаСостава.Пользователь;
								СтрокаДерева.Роль	 = НСтр("ru = 'Участник группы наблюдателей'");
								СтрокаДерева.Флаг	 = Адресаты.НайтиПоЗначению(СтрокаСостава.Пользователь) <> Неопределено;
								СтрокаДерева.Группа	 = НСтр("ru = 'Наблюдатель'");
                                Если СтрокаДерева.Флаг Тогда
                                    Адресаты.НайтиПоЗначению(СтрокаСостава.Пользователь).Пометка = Истина;
                                КонецЕсли;
							Иначе
								НайденнаяСтрока.Роль = НайденнаяСтрока.Роль + НСтр("ru = ', Участник группы наблюдателей'");
							КонецЕсли;
						КонецЦикла;	
					КонецЕсли;	
				КонецЕсли;
				
			КонецЦикла;
        КонецЕсли;
        
        Для Каждого Элемент ИЗ Адресаты Цикл
            Если Элемент.Пометка = Ложь Тогда
                СтрокаДерева         = тДерево.Строки.Добавить();
                СтрокаДерева.Адресат = Элемент.Значение;
                СтрокаДерева.Флаг    = Истина;
                СтрокаДерева.Роль    = НСтр("ru = 'Консультант'");
            КонецЕсли;
        КонецЦикла;
		
		ЗначениеВРеквизитФормы(тДерево, "Дерево");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция МассивАдресатовНаСервере()
	
	МассивАдресатов = Новый Массив;
	ДЗ = ДанныеФормыВЗначение(Дерево, Тип("ДеревоЗначений"));
	Для Каждого Строки Из ДЗ.Строки Цикл
		Если Строки.Флаг И ЗначениеЗаполнено(Строки.Адресат) Тогда
			Если МассивАдресатов.Найти(Строки.Адресат) = Неопределено Тогда
				МассивАдресатов.Добавить(Строки.Адресат);
			КонецЕсли;				
		КонецЕсли;
		СохранитьПодчиненныеСтрокиДерева(Строки, МассивАдресатов);
	КонецЦикла;
	
	Возврат МассивАдресатов;
	
КонецФункции

&НаСервере
Процедура СохранитьПодчиненныеСтрокиДерева(СтрокаДерева, МассивАдресатов)
	
	Для Каждого Строки Из СтрокаДерева.Строки Цикл
		Если Строки.Флаг Тогда
			Если МассивАдресатов.Найти(Строки.Адресат) = Неопределено Тогда
				МассивАдресатов.Добавить(Строки.Адресат);
			КонецЕсли;
			СохранитьПодчиненныеСтрокиДерева(Строки, МассивАдресатов);
		КонецЕсли;		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДочерниеФлаги(Строки, Флаг)
	
	Строки.Флаг = Флаг;
	
	КоллекцияЭлементовДерева = Строки.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл    
		УстановитьДочерниеФлаги(Строка, Флаг);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    
    Отказ = Истина;
    НоваяСтрока             = ОбработкаТабличныхЧастейКлиент.ДобавитьСтрокуДерева(Дерево, Неопределено);
    НоваяСтрока.Роль        = НСтр("ru = 'Консультант'");
	Элемент.ТекущаяСтрока 	= НоваяСтрока.ПолучитьИдентификатор();
	ТекущийЭлемент          = Элементы.Дерево;
	Элементы.Дерево.ИзменитьСтроку();
    
КонецПроцедуры

#КонецОбласти

