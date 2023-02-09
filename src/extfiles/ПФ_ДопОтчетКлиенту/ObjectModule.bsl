﻿Функция СведенияОВнешнейОбработке() Экспорт
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.РС_ОтчетКлиенту");
	
	ПараметрыРегистрации = Новый Структура;
	
	//Имя = ЭтотОбъект.Метаданные().Имя;
	//Представление = ЭтотОбъект.Метаданные().Синоним;
	
	//ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке(СтандартныеПодсистемыСервер.ВерсияБиблиотеки());
	//ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	//ПараметрыРегистрации.БезопасныйРежим = Ложь;
	//ПараметрыРегистрации.Версия = "0.1";
	//ПараметрыРегистрации.Наименование = Представление;
	//ПараметрыРегистрации.Назначение = МассивНазначений;
	//ПараметрыРегистрации.Информация = "Разработчик: И.Горохов 18.05.2021";
	
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма"); 
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Приложение№1КОтчетуКлиентуРС");	
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ИСТИНА);
	ПараметрыРегистрации.Вставить("Версия", "1.1"); 
	ПараметрыРегистрации.Вставить("Информация", "Внешняя печатная форма приложения №1 к отету клиенту");
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, "Приложение № 1", "ДопОтчетКлиенту", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
		
	Возврат ПараметрыРегистрации; 
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка")); 
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение, Модификатор)
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление; 
	НоваяКоманда.Идентификатор = Идентификатор;
	
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ДопОтчетКлиенту", "Приложение № 1 к отчету клиенту РС", СформироватьТабДок(МассивОбъектов[0], ОбъектыПечати ));
	
КонецПроцедуры

&НаСервере
Функция СформироватьТабДок(СсылкаНаОбъект, ОбъектыПечати)
	ТабДок = Новый ТабличныйДокумент;
	//ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабДок.ИспользуемоеИмяФайла = "Отчет заказчику: "+СсылкаНаОбъект.Клиент.НаименованиеПолное+?(ЗначениеЗаполнено(СсылкаНаОбъект.Проект)," по проекту "+СсылкаНаОбъект.Проект.Наименование,"") + " по работам, принятым до " +Формат(СсылкаНаОбъект.Период,"ДФ=dd.MM.yyyy");
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;

	Макет = ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Ссылка КАК ЗанятостьСсылка,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Исполнитель КАК ЗанятостьИсполнитель,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.ВидРаботы КАК ЗанятостьВидРаботы,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Описание КАК ЗанятостьОписание,
	|	ВЫБОР
	|		КОГДА РС_ОтчетКлиентуСписокЗанятостей.КОплате > РС_ОтчетКлиентуСписокЗанятостей.ФактическоеВремя
	|			ТОГДА РС_ОтчетКлиентуСписокЗанятостей.КОплате
	|		ИНАЧЕ РС_ОтчетКлиентуСписокЗанятостей.ФактическоеВремя
	|	КОНЕЦ КАК Факт,
	|	РС_ОтчетКлиентуСписокЗанятостей.ВремяКлиента КАК ВремяКлиента,
	|	РС_ОтчетКлиентуСписокЗанятостей.КОплате КАК КОплате,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание.Ссылка КАК Задание,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание.Тема КАК ЗаданиеОписание,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание.ТекущийЭтап КАК ЗаданиеСтатус,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание.Проект КАК Проект,
	|	РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание.Инициатор КАК ЗаданиеКонтактноеЛицо,
	|	КОНЕЦПЕРИОДА(РС_ОтчетКлиентуСписокЗанятостей.Занятость.ДатаНачала, МЕСЯЦ) КАК ЗанятостьДата,
	|	ВЫБОР
	|		КОГДА РС_ОтчетКлиентуСписокЗанятостей.КОплате > РС_ОтчетКлиентуСписокЗанятостей.ФактическоеВремя
	|			ТОГДА 0
	|		ИНАЧЕ РС_ОтчетКлиентуСписокЗанятостей.ФактическоеВремя - РС_ОтчетКлиентуСписокЗанятостей.КОплате
	|	КОНЕЦ КАК ВремяБесплатно
	|ИЗ
	|	Документ.РС_ОтчетКлиенту.СписокЗанятостейЗакрытые КАК РС_ОтчетКлиентуСписокЗанятостей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РС_ОтчетКлиенту КАК РС_ОтчетКлиенту
	|		ПО РС_ОтчетКлиентуСписокЗанятостей.Ссылка = РС_ОтчетКлиенту.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Задание КАК Задание
	|		ПО РС_ОтчетКлиентуСписокЗанятостей.Занятость.Задание = Задание.Ссылка
	|			И (Задание.ТекущийЭтап.СостояниеЭтапа = ЗНАЧЕНИЕ(Перечисление.СостоянияЭтаповПроцесса.Закрыт))
	|			И (Задание.ДатаВыполнения <= КОНЕЦПЕРИОДА(&Дата, ДЕНЬ))
	|ГДЕ
	|	РС_ОтчетКлиенту.Ссылка = &Документ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Задание.Дата
	|ИТОГИ
	|	СУММА(Факт),
	|	СУММА(КОплате),
	|	СУММА(ВремяБесплатно)
	|ПО
	|	ОБЩИЕ,
	|	Проект,
	|	Задание,
	|	ЗанятостьСсылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"{ПоМесяцам}","");
	Запрос.УстановитьПараметр("Документ",СсылкаНаОбъект);
	Запрос.УстановитьПараметр("Дата",СсылкаНаОбъект.Период);
	Запрос.УстановитьПараметр("ВыводитьОписание", ИСТИНА);
	Результат = Запрос.Выполнить();
	ИтогФ=0;
	ИтогБ=0;
	ИтогП=0;

		Проекты = Результат.Выгрузить();
		Проекты.Свернуть("Проект");
		Проекты = Проекты.ВыгрузитьКолонку("Проект");
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.НаименованиеПолное = СсылкаНаОбъект.Клиент.НаименованиеПолное;
		ОбластьЗаголовок.Параметры.Инн = СсылкаНаОбъект.Клиент.ИНН;
		ОбластьЗаголовок.Параметры.НомерОтчета = УбратьЛидирующиеНули(СсылкаНаОбъект.Номер);
		
		Если ЗначениеЗаполнено(СсылкаНаОбъект.НомерАкта) и ЗначениеЗаполнено(СсылкаНаОбъект.ДатаАкта) тогда
			ОбластьЗаголовок.Параметры.НомерАкта = СсылкаНаОбъект.НомерАкта;
			ОбластьЗаголовок.Параметры.ДатаАкта = Формат(СсылкаНаОбъект.ДатаАкта, "ДЛФ=Д");
		Иначе
			ОбластьЗаголовок.Параметры.НомерАкта = "________";
			ОбластьЗаголовок.Параметры.ДатаАкта = "___.___._____";
		КонецЕсли;
		
		//Для Каждого Проект из Проекты Цикл
		//	Если ОбластьЗаголовок.Параметры.ПроектСтрока <> "" Тогда ОбластьЗаголовок.Параметры.ПроектСтрока = ОбластьЗаголовок.Параметры.ПроектСтрока + ", " КонецЕсли;
		//	ОбластьЗаголовок.Параметры.ПроектСтрока = ОбластьЗаголовок.Параметры.ПроектСтрока + Проект;
		//КонецЦикла;
		ТабДок.Вывести(ОбластьЗаголовок);
		
		Шапка = Макет.ПолучитьОбласть("ШапкаОснова");
		ТабДок.Вывести(Шапка);
		Н1=1;		
		ВыборкаОбщие=Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОбщие.Следующий() Цикл
			ВыборкаПроект=ВыборкаОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПроект.Следующий() Цикл
				
				О_Проект = Макет.ПолучитьОбласть("ПроектОснова");
				О_Проект.Параметры.Номер = Н1;
				О_Проект.Параметры.Проект = ВыборкаПроект.Проект;
				О_Проект.Параметры.КОплате = ВыборкаПроект.КОплате;
				ТабДок.Вывести(О_Проект);
				//ТабДок.НачатьГруппуСтрок();//Группа заданий
				ВыборкаЗадание = ВыборкаПроект.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Н2=1;
				Пока ВыборкаЗадание.Следующий() Цикл
					О_Задание = Макет.ПолучитьОбласть("ЗаданиеОснова");
					О_Задание.Параметры.Номер = ""+Н1+"."+Н2;	
					ЗаполнитьЗначенияСвойств(О_Задание.Параметры,ВыборкаЗадание);
					О_Задание.Параметры.Задание = ВыборкаЗадание.Задание;
					О_Задание.Параметры.ЗаданиеОписание =  " " + Символы.ПС+ ВыборкаЗадание.ЗаданиеОписание + Символы.ПС +" ";
					
					О_Задание.Параметры.КОплате = ВыборкаЗадание.КОплате;
					Поз=СтрНайти(О_Задание.Параметры.Задание,"(");
					Если Поз > 1 Тогда О_Задание.Параметры.Задание=Лев(О_Задание.Параметры.Задание,Поз-1) КонецЕсли;
					ТабДок.Вывести(О_Задание);
					
					//ТабДок.НачатьГруппуСтрок(,ВыводитьЗанятости);//Группа занятостей
					
					Выборка = ВыборкаЗадание.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Н3=1;
					Пока Выборка.Следующий() Цикл
						О_Занятость = Макет.ПолучитьОбласть("ЗанятостьОснова");
						О_Занятость.Параметры.Номер = ""+Н1+"."+Н2+"."+Н3;
						Н3=Н3+1;
						//ЗаполнитьЗначенияСвойств(О_Занятость.Параметры,Выборка);
						О_Занятость.Параметры.ЗанятостьОписание = " " + Символы.ПС+ Выборка.ЗанятостьОписание + Символы.ПС + " ";
						О_Занятость.Параметры.Исполнитель = Выборка.ЗанятостьИсполнитель;
						О_Занятость.Параметры.КОплате = Выборка.КОплате;					
						ТабДок.Вывести(О_Занятость);
						
					КонецЦикла;
					Н2=Н2+1;
					//ТабДок.ЗакончитьГруппуСтрок();//Группа занятостей
				КонецЦикла;
				//Н2=Н2+1;
				Н1=Н1+1;
				//ТабДок.ЗакончитьГруппуСтрок();//Группа заданий
			КонецЦикла;
			Область = Макет.ПолучитьОбласть("ИтогиКОплате");
			Область.Параметры.КОплате = ВыборкаОбщие.КОплате;
			ТабДок.Вывести(Область);
			Подвал = Макет.ПолучитьОбласть("Подвал");
			ТабДок.Вывести(Подвал);

		КонецЦикла; 		
	ТабДок.Автомасштаб=истина;
	ИмяФайла = "Отчет Клиенту "+СсылкаНаОбъект.Клиент+" на "+Формат(СсылкаНаОбъект.Период,"ДФ=dd.MM.yyyy");
	Возврат ТабДок;
КонецФункции

Функция УбратьЛидирующиеНули(Знач НомерДокумента)
	
    Пока Лев(НомерДокумента, 1) = "0" Цикл
        НомерДокумента = Прав(НомерДокумента, СтрДлина(НомерДокумента) - 1);
	КонецЦикла;
	
    Возврат НомерДокумента;
КонецФункции