#Использовать decorator

Перем РазобранноеВыражение; // Структура разобранного лямбда выражения

Перем мВыражение; // Лямбда выражение
Перем мИнтерфейс; // Функциональный интерфейс для лямбда выражения
Перем мКонтекст;  // Структура с контекстом для лямбда выражения
Перем мОбъект;    // Объект который будет захвачен в лямбда выражение

Перем СодержитВозвратЗначения; // Регулярное выражение проверяющее наличие возврата значения
Перем ЭтоЛямбдаВыражение;      // Регулярное выражение проверяющее лямбда выражение

Функция Интерфейс(Интерфейс) Экспорт

	ЭтоФункция       = Интерфейс.ПолучитьКартуИнтерфейса()[0].ЭтоФункция;
	ВозвратыЗначений = СодержитВозвратЗначения.НайтиСовпадения(РазобранноеВыражение.Тело);

	Если ЭтоФункция Тогда

		Если СтрЧислоСтрок(РазобранноеВыражение.Тело) > 1
			И ВозвратыЗначений.Количество() = 0 Тогда

			ВызватьИсключение Новый ИнформацияОбОшибке(
				"Лямбда выражение должно возвращать значение",
				мВыражение
			);

		КонецЕсли;

		Если СтрЧислоСтрок(РазобранноеВыражение.Тело) = 1 
			И ВозвратыЗначений.Количество() = 0 Тогда

			РазобранноеВыражение.Тело = "Возврат " + РазобранноеВыражение.Тело; 

		КонецЕсли;

	ИначеЕсли ВозвратыЗначений.Количество() <> 0 Тогда

		ВызватьИсключение Новый ИнформацияОбОшибке(
			"Лямбда выражение не должно возвращать значение",
			мВыражение
		);

	КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	мИнтерфейс = Интерфейс;

	Возврат ЭтотОбъект;

КонецФункции

Функция Контекст(Контекст) Экспорт

	Если Не ТипЗнч(Контекст) = Тип("Структура") Тогда
		ВызватьИсключение "Контекстом для лямбда выражения может выступать только структура";
	КонецЕсли;

	мКонтекст = Контекст;

	Возврат ЭтотОбъект;

КонецФункции

Функция ЗахватитьОбъект(Объект) Экспорт

	мОбъект = Объект;

	Возврат ЭтотОбъект;

КонецФункции

Функция ВДействие() Экспорт
	
	Объект = ВОбъект();

	Возврат Новый Действие(
		Объект,
		мИнтерфейс.ПолучитьКартуИнтерфейса()[0].Имя
	);

КонецФункции

Функция ВОбъект() Экспорт
	
	Если Не ЗначениеЗаполнено(мИнтерфейс) Тогда
		ОпределитьИнтерфейс();
	КонецЕсли;

	МетодИнтерфейса = мИнтерфейс.ПолучитьКартуИнтерфейса()[0];

	Метод = Новый Метод(МетодИнтерфейса.Имя)
		.Публичный()
		.ТелоМетода(РазобранноеВыражение.Тело);

	Если Не МетодИнтерфейса.ЭтоФункция Тогда
		Метод.ЭтоПроцедура();
	КонецЕсли;

	Для каждого ИмяПараметра Из РазобранноеВыражение.Параметры Цикл
		Метод.Параметр(Новый ПараметрМетода(ИмяПараметра));
	КонецЦикла;

	Построитель = Новый ПостроительДекоратора(мОбъект)
		.Метод(Метод);

	Для каждого ПеременнаяИЗначение Из мКонтекст Цикл
		
		Построитель.Поле(
			Новый Поле(ПеременнаяИЗначение.Ключ)
				.ЗначениеПоУмолчанию(ПеременнаяИЗначение.Значение)
		);

	КонецЦикла;
	
	Объект = Построитель.Построить();

	Рефлектор = Новый РефлекторОбъекта(Объект);

	Рефлектор.РеализуетИнтерфейс(мИнтерфейс, Истина);

	Возврат Объект;

КонецФункции

Процедура РазобратьВыражение(Выражение)
	
	Если Не ЭтоЛямбдаВыражение.Совпадает(Выражение) Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Переданное выражение не является лямбда выражением", Выражение);
	КонецЕсли;

	Совпадения = ЭтоЛямбдаВыражение.НайтиСовпадения(Выражение);
	
	РазобранноеВыражение.Параметры = СтрРазделить(
		Совпадения[0].Группы[1].Значение,
		","
	);

	РазобранноеВыражение.Тело = Совпадения[0].Группы[2].Значение;

КонецПроцедуры

Процедура ОпределитьИнтерфейс()
	
	ЭтоФункция           = СодержитВозвратЗначения.НайтиСовпадения(РазобранноеВыражение.Тело).Количество() <> 0;
	КоличествоПараметров = РазобранноеВыражение.Параметры.Количество();

	Если ЭтоФункция Тогда

		Если КоличествоПараметров = 1 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.УниФункция();
		ИначеЕсли КоличествоПараметров = 2 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.БиФункция();
		ИначеЕсли КоличествоПараметров = 3 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.ТерФункция();
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	Иначе

		Если КоличествоПараметров = 1 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.УниПроцедура();
		ИначеЕсли КоличествоПараметров = 2 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.БиПроцедура();
		ИначеЕсли КоличествоПараметров = 3 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.ТерПроцедура();
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	КонецЕсли;

	Если Не ЗначениеЗаполнено(мИнтерфейс) Тогда

		Параметры = Новый Структура(
			"Выражение, ЭтоФункция, КоличествоПараметров",
			мВыражение,
			ЭтоФункция,
			КоличествоПараметров
		);

		ВызватьИсключение Новый ИнформацияОбОшибке(
			"Невозможно определить функциональный интерфейс для лямбда выражения",
			Параметры
		);

	КонецЕсли;

КонецПроцедуры

Процедура ПриСозданииОбъекта(Выражение)

	РазобранноеВыражение = Новый Структура(
		"Параметры, Тело"
	);

	мВыражение = Выражение;
	мКонтекст  = Новый Структура();

	РазобратьВыражение(Выражение);

КонецПроцедуры

ЭтоЛямбдаВыражение      = ЛямбдыКешируемыеЗначения.РегулярноеВыражениеЭтоЛямбдаВыражение();
СодержитВозвратЗначения = ЛямбдыКешируемыеЗначения.РегулярноеВыражениеСодержитВозвратЗначения();
