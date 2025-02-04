Перем Цифры;

Функция РазобратьСтрокуПараметров(СтрокаПараметров) Экспорт

	Результат = Новый Структура(
		"Аннотации, Параметры",
		Новый Массив,
		Новый Массив
	);

	Этап = "";
	МетаЭтап = "АннотацииМетода";

	РазбираемыеАннотации = Новый Массив;

	Для Индекс = 1 По СтрДлина(СтрокаПараметров) Цикл

		Токен = Сред(СтрокаПараметров, Индекс, 1);

		Если Этап = "" Тогда

			Если Токен = "&" Тогда
				Этап = "Аннотация";
				Аннотация = Новый Структура("Имя, Параметры", "", Новый Массив);
				Продолжить;
			КонецЕсли;

			Если Токен = "(" И МетаЭтап = "АннотацииМетода" Тогда
				Этап = "";
				МетаЭтап = "ПараметрыМетода";
				Результат.Аннотации = РазбираемыеАннотации;
				РазбираемыеАннотации = Новый Массив;
				Продолжить;
			КонецЕсли;

			Если Не ПустаяСтрока(Токен) Тогда

				Этап = "ПараметрМетода";
				МетаЭтап = "ПараметрыМетода";

				ПараметрМетода = Новый Структура("Имя, Аннотации", "");
				ПараметрМетода.Аннотации = РазбираемыеАннотации;
				РазбираемыеАннотации = Новый Массив;

			КонецЕсли;

		КонецЕсли;

		Если Этап = "Аннотация" Тогда

			Если Токен = "(" Тогда
				Этап = "ПараметрАннотации";
				ЭтапПараметрАннотации = "Имя";
				ПараметрАннотации = Новый Структура("Имя, Значение", "", "");
				Продолжить;
			КонецЕсли;

			Если Токен = " " Или Токен = Символы.ПС Тогда
				Этап = "";
				РазбираемыеАннотации.Добавить(Аннотация);
				Продолжить;
			КонецЕсли;

			Аннотация.Имя = Аннотация.Имя + Токен;

		КонецЕсли;

		Если Этап = "ПараметрАннотации" Тогда

			Если Токен = ")" Тогда
				Этап = "Аннотация";
				ДобавитьПараметрАннотации(Аннотация.Параметры, ПараметрАннотации);
				Продолжить;
			КонецЕсли;

			Если Токен = "," Тогда
				ДобавитьПараметрАннотации(Аннотация.Параметры, ПараметрАннотации);
				ЭтапПараметрАннотации = "Имя";
				ПараметрАннотации = Новый Структура("Имя, Значение", "", "");
				Продолжить;
			КонецЕсли;

			Если Токен = """"
				Или Токен = "'"
				Или ЭтоЦифра(Токен) Тогда
				ЭтапПараметрАннотации = "ЗначениеНачало";
			КонецЕсли;

			Если Токен = "=" Тогда
				ЭтапПараметрАннотации = "Значение";
				Продолжить;
			КонецЕсли;

			Если Не ПустаяСтрока(Токен) И ЭтапПараметрАннотации = "Значение" Тогда
				ЭтапПараметрАннотации = "ЗначениеНачало";
			КонецЕсли;

			Если ЭтапПараметрАннотации = "Имя" Тогда

				Если ПустаяСтрока(Токен) Тогда
					Продолжить;
				КонецЕсли;

				ПараметрАннотации.Имя = ПараметрАннотации.Имя + Токен;
			ИначеЕсли  ЭтапПараметрАннотации = "ЗначениеНачало" Тогда
				ПараметрАннотации.Значение = ПараметрАннотации.Значение + Токен;
			КонецЕсли;

		КонецЕсли;

		Если Этап = "ПараметрМетода" Тогда

			Если Токен = ")" Или Токен = "," Или Индекс = СтрДлина(СтрокаПараметров) Тогда
				Этап = "";
				Если ЗначениеЗаполнено(ПараметрМетода.Имя) Тогда
					Результат.Параметры.Добавить(ПараметрМетода);
				КонецЕсли;
				ПараметрМетода = Новый Структура("Имя, Аннотации", "");
				Продолжить;
			КонецЕсли;

			ПараметрМетода.Имя = ПараметрМетода.Имя + Токен;

		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ЭтоЦифра(Символ)
	Возврат Цифры.Найти(Символ) <> Неопределено;
КонецФункции

Процедура ДобавитьПараметрАннотации(Параметры, ПараметрАннотации)

	ПараметрАннотации.Значение = СтрЗаменить(ПараметрАннотации.Значение, """", "");

	Если ЭтоЦифра(Лев(ПараметрАннотации.Значение, 1)) Тогда
		ПараметрАннотации.Значение = Число(ПараметрАннотации.Значение);
	ИначеЕсли СтрНачинаетсяС(ПараметрАннотации.Значение, "'") Тогда
		ПараметрАннотации.Значение = Дата(СтрЗаменить(ПараметрАннотации.Значение, "'", ""));
	ИначеЕсли ПараметрАннотации.Значение = "Ложь" Или ПараметрАннотации.Значение = "False"
		Или ПараметрАннотации.Значение = "Истина" Или ПараметрАннотации.Значение = "True" Тогда
		ПараметрАннотации.Значение = Булево(ПараметрАннотации.Значение);
	КонецЕсли;

	Параметры.Добавить(ПараметрАннотации);

КонецПроцедуры

Цифры = Новый Массив;
Цифры.Добавить("0");
Цифры.Добавить("1");
Цифры.Добавить("2");
Цифры.Добавить("3");
Цифры.Добавить("4");
Цифры.Добавить("5");
Цифры.Добавить("6");
Цифры.Добавить("7");
Цифры.Добавить("8");
Цифры.Добавить("9");
