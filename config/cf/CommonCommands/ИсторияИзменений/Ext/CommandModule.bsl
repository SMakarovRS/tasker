﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		СсылкаНаОбъект = ПараметрКоманды[0];
	Иначе
		СсылкаНаОбъект = ПараметрКоманды;
	КонецЕсли;
	
	ВерсионированиеОбъектовКлиент.ПоказатьИсториюИзменений(СсылкаНаОбъект, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти
