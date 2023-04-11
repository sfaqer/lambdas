Перем ЭтоЛямбдаВыражение;      // Кеш регулярного выражения лямбда выражения
Перем СодержитВозвратЗначения; // Кеш регулярного выражения содержит возврат значения

Функция РегулярноеВыражениеЭтоЛямбдаВыражение() Экспорт
	
	Если ЭтоЛямбдаВыражение = Неопределено Тогда

		ЭтоЛямбдаВыражение = Новый РегулярноеВыражение(
			"\(?\s*([^)]*)\s*\)?\s*->\s*\{?([^\}]+)\}?"
		);

	КонецЕсли;

	Возврат ЭтоЛямбдаВыражение;

КонецФункции

Функция РегулярноеВыражениеСодержитВозвратЗначения() Экспорт
	
	Если СодержитВозвратЗначения = Неопределено Тогда
		СодержитВозвратЗначения = Новый РегулярноеВыражение("(?>[^\S]+|^)(Возврат)\s+[^;\s]+\s*;?");
	КонецЕсли;

	Возврат СодержитВозвратЗначения;

КонецФункции
