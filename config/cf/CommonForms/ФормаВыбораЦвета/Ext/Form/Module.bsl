﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуЦветов();
	ЗаполнитьОформлениеФормы();
	
	Если Параметры.Свойство("РедактируемыйЦвет") Тогда 
		Если ТипЗнч(Параметры.РедактируемыйЦвет) = Тип("Строка") Тогда
			РедактируемыйЦвет = РаботаСЦветомКлиентСервер.HexВЦвет(Параметры.РедактируемыйЦвет);
		Иначе
			РедактируемыйЦвет = Параметры.РедактируемыйЦвет;
		КонецЕсли;
	Иначе
		РедактируемыйЦвет = Новый Цвет(255, 255, 255);		
	КонецЕсли;
	
	Стр 			= РаботаСЦветомКлиентСервер.ЦветВHex(РедактируемыйЦвет);
	РедактируемыйЦвет = РаботаСЦветомКлиентСервер.HexВЦвет(Стр);
	Красный 		= РедактируемыйЦвет.Красный;
	Зеленый 		= РедактируемыйЦвет.Зеленый;
	Синий   		= РедактируемыйЦвет.Синий;
	HEX 			= Сред(Стр, 2);
	
	НайденныйЦвет = Цвета.НайтиСтроки(Новый Структура("Красный, Зеленый, Синий", Красный, Зеленый, Синий));
	Если НайденныйЦвет.Количество() > 0 Тогда		
		Элементы.Цвета.ТекущаяСтрока = НайденныйЦвет.Получить(0).ПолучитьИдентификатор();
		ВидЦвета = 0;
		ТекущийЭлемент = Элементы.Цвета;
	Иначе
		ВидЦвета = 1;
		ТекущийЭлемент = Элементы.HEX;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриИзмененииСоставляющихЦвета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КрасныйПриИзменении(Элемент)
	
	ПриИзменененииЦвета();
	
КонецПроцедуры // КрасныйПриИзменении()

&НаКлиенте
Процедура ЗеленыйПриИзменении(Элемент)
	
	ПриИзменененииЦвета();
	
КонецПроцедуры // ЗеленыйПриИзменении()

&НаКлиенте
Процедура СинийПриИзменении(Элемент)
	
	ПриИзменененииЦвета();
	
КонецПроцедуры // СинийПриИзменении()

&НаКлиенте
Процедура HEXПриИзменении(Элемент)
	
	Стр		= "#" + ВРег(HEX);
	Красный = РаботаСЦветомКлиентСервер.КрасныйИзHex(Стр);
	Зеленый = РаботаСЦветомКлиентСервер.ЗеленыйИзHex(Стр);
	Синий 	= РаботаСЦветомКлиентСервер.СинийИзHex(Стр);
	
	ПриИзменененииЦвета();
	
КонецПроцедуры // СинийПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыЦвета

&НаКлиенте
Процедура ЦветаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Цвета.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;		
	КонецЕсли;
	
	Если ТекущийЭлемент = Элементы.Цвета Тогда
		ВидЦвета = 0;
	КонецЕсли;
	
	Если ВидЦвета = 0 Тогда
	
		Красный = ТекущиеДанные.Красный;
		Зеленый = ТекущиеДанные.Зеленый;
		Синий 	= ТекущиеДанные.Синий;
		
		ПриИзмененииСоставляющихЦвета();
		
	КонецЕсли;
	
КонецПроцедуры // ЦветаПриАктивизацииСтроки()

&НаКлиенте
Процедура ЦветаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьЦвет();
	
КонецПроцедуры // ЦветаВыбор()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	ВыбратьЦвет();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЦветов()
	
	ДобавитьСтроку("Белые", "Белый", НСтр("ru = 'Белый'"), "FFFFFF", 255, 255, 255);
	ДобавитьСтроку("Белые", "Снежный", НСтр("ru = 'Снежный'"), "FFFAFA", 255, 250, 250);
	ДобавитьСтроку("Белые", "МедоваяРоса", НСтр("ru = 'Медовая Роса'"), "F0FFF0", 240, 255, 240);
	ДобавитьСтроку("Белые", "МятныйКрем", НСтр("ru = 'Мятный Крем'"), "F5FFFA", 245, 255, 250);
	ДобавитьСтроку("Белые", "Лазурный", НСтр("ru = 'Лазурный'"), "F0FFFF", 240, 255, 255);
	ДобавитьСтроку("Белые", "БледноГолубой", НСтр("ru = 'Бледно-Голубой'"), "F0F8FF", 240, 248, 255);
	ДобавитьСтроку("Белые", "ПризрачноБелый", НСтр("ru = 'Призрачно-Белый'"), "F8F8FF", 248, 248, 255);
	ДобавитьСтроку("Белые", "БелыйДым", НСтр("ru = 'Белый Дым'"), "F5F5F5", 245, 245, 245);
	ДобавитьСтроку("Белые", "Перламутровый", НСтр("ru = 'Перламутровый'"), "FFF5EE", 255, 245, 238);
	ДобавитьСтроку("Белые", "Бежевый", НСтр("ru = 'Бежевый'"), "F5F5DC", 245, 245, 220);
	ДобавитьСтроку("Белые", "Кружевной", НСтр("ru = 'Кружевной'"), "FDF5E6", 253, 245, 230);
	ДобавитьСтроку("Белые", "Цветочный", НСтр("ru = 'Цветочный'"), "FFFAF0", 255, 250, 240);
	ДобавитьСтроку("Белые", "СлоноваяКость", НСтр("ru = 'Слоновая Кость'"), "FFFFF0", 255, 255, 240);
	ДобавитьСтроку("Белые", "БелыйАнтик", НСтр("ru = 'Белый Антик'"), "FAEBD7", 250, 235, 215);
	ДобавитьСтроку("Белые", "Льняной", НСтр("ru = 'Льняной'"), "FAF0E6", 250, 240, 230);
	ДобавитьСтроку("Белые", "РозоваяЛаванда", НСтр("ru = 'Розовая Лаванда'"), "FFF0F5", 255, 240, 245);
	ДобавитьСтроку("Белые", "ТусклоРозовый", НСтр("ru = 'Тускло-Розовый'"), "FFE4E1", 255, 228, 225);
	ДобавитьСтроку("Серые", "Гейнсборо", НСтр("ru = 'Гейнсборо'"), "DCDCDC", 220, 220, 220);
	ДобавитьСтроку("Серые", "СветлоСерый", НСтр("ru = 'Светло-Серый'"), "D3D3D3", 211, 211, 211);
	ДобавитьСтроку("Серые", "Серебрянный", НСтр("ru = 'Серебрянный'"), "C0C0C0", 192, 192, 192);
	ДобавитьСтроку("Серые", "ТемноСерый", НСтр("ru = 'Темно-Серый'"), "A9A9A9", 169, 169, 169);
	ДобавитьСтроку("Серые", "Серый", НСтр("ru = 'Серый'"), "808080", 128, 128, 128);
	ДобавитьСтроку("Серые", "ТусклоСерый", НСтр("ru = 'Тускло-Серый'"), "696969", 105, 105, 105);
	ДобавитьСтроку("Серые", "СветлоГрифельный", НСтр("ru = 'Светло-Грифельный'"), "778899", 119, 136, 153);
	ДобавитьСтроку("Серые", "Грифельный", НСтр("ru = 'Грифельный'"), "708090", 112, 128, 144);
	ДобавитьСтроку("Серые", "ТемноГрифельный", НСтр("ru = 'Темно-Грифельный'"), "2F4F4F", 47, 79, 79);
	ДобавитьСтроку("Серые", "Черный", НСтр("ru = 'Черный'"), "000000", 0, 0, 0);
	ДобавитьСтроку("Красные", "Киноварь", НСтр("ru = 'Киноварь'"), "CD5C5C", 205, 92, 92);
	ДобавитьСтроку("Красные", "СветлоКоралловый", НСтр("ru = 'Светло-Коралловый'"), "F08080", 240, 128, 128);
	ДобавитьСтроку("Красные", "Лосось", НСтр("ru = 'Лосось'"), "FA8072", 250, 128, 114);
	ДобавитьСтроку("Красные", "ТемныйЛосось", НСтр("ru = 'Темный Лосось'"), "E9967A", 233, 150, 122);
	ДобавитьСтроку("Красные", "СветлыйЛосось", НСтр("ru = 'Светлый Лосось'"), "FFA07A", 255, 160, 122);
	ДобавитьСтроку("Красные", "Малиновый", НСтр("ru = 'Малиновый'"), "DC143C", 220, 20, 60);
	ДобавитьСтроку("Красные", "Красный", НСтр("ru = 'Красный'"), "FF0000", 255, 0, 0);
	ДобавитьСтроку("Красные", "Кирпичный", НСтр("ru = 'Кирпичный'"), "B22222", 178, 34, 34);
	ДобавитьСтроку("Красные", "ТемноКрасный", НСтр("ru = 'Темно-Красный'"), "8B0000", 139, 0, 0);
	ДобавитьСтроку("Розовые", "Розовый", НСтр("ru = 'Розовый'"), "FFC0CB", 255, 192, 203);
	ДобавитьСтроку("Розовые", "СветлоРозовый", НСтр("ru = 'Светло-Розовый'"), "FFB6C1", 255, 182, 193);
	ДобавитьСтроку("Розовые", "ЯркоРозовый", НСтр("ru = 'Ярко-Розовый'"), "FF69B4", 255, 105, 180);
	ДобавитьСтроку("Розовые", "ТемноРозовый", НСтр("ru = 'Темно-Розовый'"), "FF1493", 255, 20, 147);
	ДобавитьСтроку("Розовые", "НейтральноФиолетовоКрасный", НСтр("ru = 'Нейтрально-Фиолетово-Красный'"), 
		"C71585", 199, 21, 133);
	ДобавитьСтроку("Розовые", "БледноФиолетовоКрасный", НСтр("ru = 'Бледно-Фиолетово-Красный'"), "DB7093", 219, 112, 147);
	ДобавитьСтроку("Оранжевые", "Коралловый", НСтр("ru = 'Коралловый'"), "FF7F50", 255, 127, 80);
	ДобавитьСтроку("Оранжевые", "Томатный", НСтр("ru = 'Томатный'"), "FF6347", 255, 99, 71);
	ДобавитьСтроку("Оранжевые", "ОранжевоКрасный", НСтр("ru = 'Оранжево-Красный'"), "FF4500", 255, 69, 0);
	ДобавитьСтроку("Оранжевые", "ТемноОранжевый", НСтр("ru = 'Темно-Оранжевый'"), "FF8C00", 255, 140, 0);
	ДобавитьСтроку("Оранжевые", "Оранжевый", НСтр("ru = 'Оранжевый'"), "FFA500", 255, 165, 0);
	ДобавитьСтроку("Желтые", "Золотой", НСтр("ru = 'Золотой'"), "FFD700", 255, 215, 0);
	ДобавитьСтроку("Желтые", "Желтый", НСтр("ru = 'Желтый'"), "FFFF00", 255, 255, 0);
	ДобавитьСтроку("Желтые", "СветлоЖелтый", НСтр("ru = 'Светло-Желтый'"), "FFFFE0", 255, 255, 224);
	ДобавитьСтроку("Желтые", "ЛимонныйШифон", НСтр("ru = 'Лимонный Шифон'"), "FFFACD", 255, 250, 205);
	ДобавитьСтроку("Желтые", "СветлоЗолотистыйЖелтый", НСтр("ru = 'Светло-Золотистый Желтый'"), "FAFAD2", 250, 250, 210);
	ДобавитьСтроку("Желтые", "ТопленноеМолоко", НСтр("ru = 'Топленное Молоко'"), "FFEFD5", 255, 239, 213);
	ДобавитьСтроку("Желтые", "СветлаяЗамша", НСтр("ru = 'Светлая Замша'"), "FFE4B5", 255, 228, 181);
	ДобавитьСтроку("Желтые", "Персиковый", НСтр("ru = 'Персиковый'"), "FFDAB9", 255, 218, 185);
	ДобавитьСтроку("Желтые", "БледноЗолотистый", НСтр("ru = 'Бледно-Золотистый'"), "EEE8AA", 238, 232, 170);
	ДобавитьСтроку("Желтые", "Хаки", НСтр("ru = 'Хаки'"), "F0E68C", 240, 230, 140);
	ДобавитьСтроку("Желтые", "ТемныйХаки", НСтр("ru = 'Темный Хаки'"), "BDB76B", 189, 183, 107);
	ДобавитьСтроку("Коричневые", "Шелковый", НСтр("ru = 'Шелковый'"), "FFF8DC", 255, 248, 220);
	ДобавитьСтроку("Коричневые", "Миндальный", НСтр("ru = 'Миндальный'"), "FFEBCD", 255, 235, 205);
	ДобавитьСтроку("Коричневые", "Бисквитный", НСтр("ru = 'Бисквитный'"), "FFE4C4", 255, 228, 196);
	ДобавитьСтроку("Коричневые", "БелыйНавахо", НСтр("ru = 'Белый Навахо'"), "FFDEAD", 255, 222, 173);
	ДобавитьСтроку("Коричневые", "Пшеничный", НСтр("ru = 'Пшеничный'"), "F5DEB3", 245, 222, 179);
	ДобавитьСтроку("Коричневые", "Древесный", НСтр("ru = 'Древесный'"), "DEB887", 222, 184, 135);
	ДобавитьСтроку("Коричневые", "РыжеватоКоричневый", НСтр("ru = 'Рыжевато-Коричневый'"), "D2B48C", 210, 180, 140);
	ДобавитьСтроку("Коричневые", "РозовоКоричневый", НСтр("ru = 'Розово-Коричневый'"), "BC8F8F", 188, 143, 143);
	ДобавитьСтроку("Коричневые", "Песочный", НСтр("ru = 'Песочный'"), "F4A460", 244, 164, 96);
	ДобавитьСтроку("Коричневые", "Золотистый", НСтр("ru = 'Золотистый'"), "DAA520", 218, 165, 32);
	ДобавитьСтроку("Коричневые", "ТемноЗолотистый", НСтр("ru = 'Темно-Золотистый'"), "B8860B", 184, 134, 11);
	ДобавитьСтроку("Коричневые", "НейтральноКоричневый", НСтр("ru = 'Нейтрально-Коричневый'"), "CD853F", 205, 133, 63);
	ДобавитьСтроку("Коричневые", "Шоколадный", НСтр("ru = 'Шоколадный'"), "D2691E", 210, 105, 30);
	ДобавитьСтроку("Коричневые", "КожанноКоричневый", НСтр("ru = 'Кожанно-Коричневый'"), "8B4513", 139, 69, 19);
	ДобавитьСтроку("Коричневые", "Охра", НСтр("ru = 'Охра'"), "A0522D", 160, 82, 45);
	ДобавитьСтроку("Коричневые", "Коричневый", НСтр("ru = 'Коричневый'"), "A52A2A", 165, 42, 42);
	ДобавитьСтроку("Коричневые", "ТемноБордовый", НСтр("ru = 'Темно-Бордовый'"), "800000", 128, 0, 0);
	ДобавитьСтроку("Зеленые", "Зеленожелтый", НСтр("ru = 'Зелено-желтый'"), "ADFF2F", 173, 255, 47);
	ДобавитьСтроку("Зеленые", "Шартрез", НСтр("ru = 'Шартрез'"), "7FFF00", 127, 255, 0);
	ДобавитьСтроку("Зеленые", "ЗеленыйГазон", НСтр("ru = 'Зеленый Газон'"), "7CFC00", 124, 252, 0);
	ДобавитьСтроку("Зеленые", "Лайм", НСтр("ru = 'Лайм'"), "00FF00", 0, 255, 0);
	ДобавитьСтроку("Зеленые", "ЛимонноЗеленый", НСтр("ru = 'Лимонно-Зеленый'"), "32CD32", 50, 205, 50);
	ДобавитьСтроку("Зеленые", "БледноЗеленый", НСтр("ru = 'Бледно-Зеленый'"), "98FB98", 152, 251, 152);
	ДобавитьСтроку("Зеленые", "СветлоЗеленый", НСтр("ru = 'Светло-Зеленый'"), "90EE90", 144, 238, 144);
	ДобавитьСтроку("Зеленые", "НейтральноЗеленаяВесна", НСтр("ru = 'Нейтрально-Зеленая Весна'"), "00FA9A", 0, 250, 154);
	ДобавитьСтроку("Зеленые", "ЗеленаяВесна", НСтр("ru = 'Зеленая Весна'"), "00FF7F", 0, 255, 127);
	ДобавитьСтроку("Зеленые", "НейтральнаяМорскаяВолна", НСтр("ru = 'Нейтральная Морская Волна'"), 
		"3CB371", 60, 179, 113);
	ДобавитьСтроку("Зеленые", "МорскаяВолна", НСтр("ru = 'Морская Волна'"), "2E8B57", 46, 139, 87);
	ДобавитьСтроку("Зеленые", "ТемноЗеленый", НСтр("ru = 'Темно-Зеленый'"), "228B22", 34, 139, 34);
	ДобавитьСтроку("Зеленые", "Зеленый", НСтр("ru = 'Зеленый'"), "008000", 0, 128, 0);
	ДобавитьСтроку("Зеленые", "ТемноЗеленый", НСтр("ru = 'Темно-Зеленый'"), "006400", 0, 100, 0);
	ДобавитьСтроку("Зеленые", "ЖелтоЗеленый", НСтр("ru = 'Желто-Зеленый'"), "9ACD32", 154, 205, 50);
	ДобавитьСтроку("Зеленые", "БледноОливковый", НСтр("ru = 'Бледно-Оливковый'"), "6B8E23", 107, 142, 35);
	ДобавитьСтроку("Зеленые", "Оливковый", НСтр("ru = 'Оливковый'"), "808000", 128, 128, 0);
	ДобавитьСтроку("Зеленые", "ТемноОливковый", НСтр("ru = 'Темно-Оливковый'"), "556B2F", 85, 107, 47);
	ДобавитьСтроку("Зеленые", "НейтральныйАквамарин", НСтр("ru = 'Нейтральный Аквамарин'"), "66CDAA", 102, 205, 170);
	ДобавитьСтроку("Зеленые", "ТемнаяМорскаяВолна", НСтр("ru = 'Темная Морская Волна'"), "8FBC8F", 143, 188, 143);
	ДобавитьСтроку("Зеленые", "СветлаяМорскаяВолна", НСтр("ru = 'Светлая Морская Волна'"), "20B2AA", 32, 178, 170);
	ДобавитьСтроку("Зеленые", "ТемныйЦиан", НСтр("ru = 'Темный Циан'"), "008B8B", 0, 139, 139);
	ДобавитьСтроку("Зеленые", "НейтральныйЦиан", НСтр("ru = 'Нейтральный Циан'"), "008080", 0, 128, 128);
	ДобавитьСтроку("Синие", "Циан", НСтр("ru = 'Циан'"), "00FFFF", 0, 255, 255);
	ДобавитьСтроку("Синие", "СветлоГолубой", НСтр("ru = 'Светло-Голубой'"), "E0FFFF", 224, 255, 255);
	ДобавитьСтроку("Синие", "БледноБирюзовый", НСтр("ru = 'Бледно-Бирюзовый'"), "AFEEEE", 175, 238, 238);
	ДобавитьСтроку("Синие", "Аквамарин", НСтр("ru = 'Аквамарин'"), "7FFFD4", 127, 255, 212);
	ДобавитьСтроку("Синие", "Бирюзовый", НСтр("ru = 'Бирюзовый'"), "40E0D0", 64, 224, 208);
	ДобавитьСтроку("Синие", "НейтральноБирюзовый", НСтр("ru = 'Нейтрально-Бирюзовый'"), "48D1CC", 72, 209, 204);
	ДобавитьСтроку("Синие", "ТемноБирюзовый", НСтр("ru = 'Темно-Бирюзовый'"), "00CED1", 0, 206, 209);
	ДобавитьСтроку("Синие", "СероСиний", НСтр("ru = 'Серо-Синий'"), "5F9EA0", 95, 158, 160);
	ДобавитьСтроку("Синие", "СтальнойСиний", НСтр("ru = 'Стальной Синий'"), "4682B4", 70, 130, 180);
	ДобавитьСтроку("Синие", "СветлоСтальнойСиний", НСтр("ru = 'Светло-Стальной Синий'"), "B0C4DE", 176, 196, 222);
	ДобавитьСтроку("Синие", "Кобальт", НСтр("ru = 'Кобальт'"), "B0E0E6", 176, 224, 230);
	ДобавитьСтроку("Синие", "СветлоГолубой", НСтр("ru = 'Светло-Голубой'"), "ADD8E6", 173, 216, 230);
	ДобавитьСтроку("Синие", "НебесноГолубой", НСтр("ru = 'Небесно-Голубой'"), "87CEEB", 135, 206, 235);
	ДобавитьСтроку("Синие", "СветлоНебесноГолубой", НСтр("ru = 'Светло-Небесно-Голубой'"), "87CEFA", 135, 206, 250);
	ДобавитьСтроку("Синие", "ТемноНебесноГолубой", НСтр("ru = 'Темно-Небесно-Голубой'"), "00BFFF", 0, 191, 255);
	ДобавитьСтроку("Синие", "СинийПлут", НСтр("ru = 'Синий Плут'"), "1E90FF", 30, 144, 255);
	ДобавитьСтроку("Синие", "Васильковый", НСтр("ru = 'Васильковый'"), "6495ED", 100, 149, 237);
	ДобавитьСтроку("Синие", "НейтральноСиневатоСерый", НСтр("ru = 'Нейтрально-Синевато-Серый'"), "7B68EE", 123, 104, 238);
	ДобавитьСтроку("Синие", "КоролевскийСиний", НСтр("ru = 'Королевский Синий'"), "4169E1", 65, 105, 225);
	ДобавитьСтроку("Синие", "Синий", НСтр("ru = 'Синий'"), "0000FF", 0, 0, 255);
	ДобавитьСтроку("Синие", "СветлоСиний", НСтр("ru = 'Светло-Синий'"), "0000CD", 0, 0, 205);
	ДобавитьСтроку("Синие", "ТемноСиний", НСтр("ru = 'Темно-Синий'"), "00008B", 0, 0, 139);
	ДобавитьСтроку("Синие", "Ультрамарин", НСтр("ru = 'Ультрамарин'"), "000080", 0, 0, 128);
	ДобавитьСтроку("Синие", "СиняяПолночь", НСтр("ru = 'Синяя Полночь'"), "191970", 25, 25, 112);
	ДобавитьСтроку("Фиолетовые", "Лаванда", НСтр("ru = 'Лаванда'"), "E6E6FA", 230, 230, 250);
	ДобавитьСтроку("Фиолетовые", "Чертополох", НСтр("ru = 'Чертополох'"), "D8BFD8", 216, 191, 216);
	ДобавитьСтроку("Фиолетовые", "Слива", НСтр("ru = 'Слива'"), "DDA0DD", 221, 160, 221);
	ДобавитьСтроку("Фиолетовые", "Фиолетовый", НСтр("ru = 'Фиолетовый'"), "EE82EE", 238, 130, 238);
	ДобавитьСтроку("Фиолетовые", "Орхидея", НСтр("ru = 'Орхидея'"), "DA70D6", 218, 112, 214);
	ДобавитьСтроку("Фиолетовые", "Фуксия", НСтр("ru = 'Фуксия'"), "FF00FF", 255, 0, 255);
	ДобавитьСтроку("Фиолетовые", "НейтральнаяОрхидея", НСтр("ru = 'Нейтральная Орхидея'"), "BA55D3", 186, 85, 211);
	ДобавитьСтроку("Фиолетовые", "НейтральноФиолетовый", НСтр("ru = 'Нейтрально-Фиолетовый'"), "9370DB", 147, 112, 219);
	ДобавитьСтроку("Фиолетовые", "СинеФиолетовый", НСтр("ru = 'Сине-Фиолетовый'"), "8A2BE2", 138, 43, 226);
	ДобавитьСтроку("Фиолетовые", "ТемноФиолетовый", НСтр("ru = 'Темно-Фиолетовый'"), "9400D3", 148, 0, 211);
	ДобавитьСтроку("Фиолетовые", "ТемнаяОрхидея", НСтр("ru = 'Темная Орхидея'"), "9932CC", 153, 50, 204);
	ДобавитьСтроку("Фиолетовые", "ТемноПурпурный", НСтр("ru = 'Темно-Пурпурный'"), "8B008B", 139, 0, 139);
	ДобавитьСтроку("Фиолетовые", "Фиолетовый", НСтр("ru = 'Фиолетовый'"), "800080", 128, 0, 128);
	ДобавитьСтроку("Фиолетовые", "Серый", НСтр("ru = 'Серый'"), "4B0082", 75, 0, 130);
	ДобавитьСтроку("Фиолетовые", "ГрифельноСиний", НСтр("ru = 'Грифельно-Синий'"), "6A5ACD", 106, 90, 205);
	ДобавитьСтроку("Фиолетовые", "ТемноГрифельноСиний", НСтр("ru = 'Темно-Грифельно-Синий'"), "483D8B", 72, 61, 139);
	
КонецПроцедуры // ЗаполнитьТаблицуЦветов() 

&НаСервере
Процедура ДобавитьСтроку(ГруппаЦвета, ИдентификаторЦвета, НаименованиеЦвета, ШестЗначение, Красный, Зеленый, Синий) 
	
	НоваяСтрока                 = Цвета.Добавить();
	НоваяСтрока.Группа          = ГруппаЦвета;
	НоваяСтрока.Идентификатор   = ИдентификаторЦвета;
	НоваяСтрока.Наименование    = НаименованиеЦвета;
	НоваяСтрока.ЩестандцетиричноеЗначение = ШестЗначение;
	НоваяСтрока.Красный         = Красный;
	НоваяСтрока.Зеленый         = Зеленый;
	НоваяСтрока.Синий           = Синий;
	
КонецПроцедуры // ДобавитьСтроку()

&НаСервере
Процедура ЗаполнитьОформлениеФормы()
	
	Для Каждого СтрокаЦвета Из Цвета Цикл
		
		ДобавитьОформление(СтрокаЦвета.Красный, СтрокаЦвета.Зеленый, СтрокаЦвета.Синий);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьОформлениеФормы()

&НаСервере
Процедура ДобавитьОформление(Красный, Зеленый, Синий)

	НовоеОформление = УсловноеОформление.Элементы.Добавить();
	НовоеОформление.Использование = Истина;
	НовоеОформление.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(Красный, Зеленый, Синий));
	
	НовыйОтбор = НовоеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Цвета.Красный");
	НовыйОтбор.ПравоеЗначение = Красный;
	
	НовыйОтбор = НовоеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Цвета.Зеленый");
	НовыйОтбор.ПравоеЗначение = Зеленый;
	
	НовыйОтбор = НовоеОформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Цвета.Синий");
	НовыйОтбор.ПравоеЗначение = Синий;
	
	НовоеПоле = НовоеОформление.Поля.Элементы.Добавить();
	НовоеПоле.Использование = Истина;
	НовоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЦветаПредставлениеЦвета");
	
КонецПроцедуры // ДобавитьОформление()

&НаКлиенте
Процедура ПриИзменененииЦвета()
	
	НайденныйЦвет = Цвета.НайтиСтроки(Новый Структура("Красный, Зеленый, Синий", Красный, Зеленый, Синий));
	Если НайденныйЦвет.Количество() Тогда
		
		ВидЦвета = 0;
		Элементы.Цвета.ТекущаяСтрока = НайденныйЦвет.Получить(0).ПолучитьИдентификатор();
		
	Иначе
		
		ВидЦвета = 1;
		ПриИзмененииСоставляющихЦвета();
		
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПриИзмененииСоставляющихЦвета()
	
	ТекущийЦвет = Новый Цвет(Красный, Зеленый, Синий);
	БелыйЦвет 	= Новый Цвет(255, 255, 255);
	ЧерныйЦвет 	= Новый Цвет(0, 0, 0);
	СуммаСостовляющих = Красный + Зеленый + Синий;
	
	СтрокаПримерТекста = НСтр("ru = 'Пример текста'");
	СтрокаПримерФона 	= НСтр("ru = 'Пример фона'");
	
	СтрокиПримераТекста = Новый Массив;
	СтрокиПримераТекста.Добавить(СтрокаПримерТекста);
	СтрокиПримераТекста.Добавить(Символы.ПС);
	СтрокиПримераТекста.Добавить(СтрокаПримерТекста);
	СтрокиПримераТекста.Добавить(Символы.ПС);
	СтрокиПримераТекста.Добавить(СтрокаПримерТекста);
	
	СтрокиПримераФона = Новый Массив;
	СтрокиПримераФона.Добавить(СтрокаПримерФона); 
	СтрокиПримераФона.Добавить(Символы.ПС);
	СтрокиПримераФона.Добавить(СтрокаПримерФона);
	СтрокиПримераФона.Добавить(Символы.ПС);
	СтрокиПримераФона.Добавить(СтрокаПримерФона);
	
	ПримерТекста 	= Новый ФорматированнаяСтрока(СтрокиПримераТекста, , ТекущийЦвет, 
		ЦветФонаФормы());
	ПримерФона 		= Новый ФорматированнаяСтрока(СтрокиПримераФона, , 
		?(СуммаСостовляющих > 384, ЧерныйЦвет, БелыйЦвет), ТекущийЦвет);
	
	Стр = РаботаСЦветомКлиентСервер.ЦветВHex(ТекущийЦвет);
	HEX = Сред(Стр, 2)
	
КонецПроцедуры // ПриИзмененииСоставляющихЦвета()

&НаКлиенте
Процедура ВыбратьЦвет()
	
	ВыбранныйЦвет = Новый Цвет(Красный, Зеленый, Синий);
	ОповеститьОВыборе(ВыбранныйЦвет);
	
КонецПроцедуры // ВыбратьЦвет()

&НаСервере
Функция ЦветФонаФормы()
	
	Возврат ЦветаСтиля.ЦветФонаФормы;
	
КонецФункции

#КонецОбласти
