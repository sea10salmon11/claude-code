// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DaySchedule _$DayScheduleFromJson(Map<String, dynamic> json) => DaySchedule(
      weekDay: $enumDecodeNullable(_$WeekDayEnumMap, json['weekDay'],
              unknownValue: WeekDay.monday) ??
          WeekDay.monday,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DayScheduleToJson(DaySchedule instance) =>
    <String, dynamic>{
      'weekDay': _$WeekDayEnumMap[instance.weekDay]!,
      'lessons': instance.lessons,
    };

const _$WeekDayEnumMap = {
  WeekDay.monday: 'monday',
  WeekDay.tuesday: 'tuesday',
  WeekDay.wednesday: 'wednesday',
  WeekDay.thursday: 'thursday',
  WeekDay.friday: 'friday',
  WeekDay.saturday: 'saturday',
  WeekDay.sunday: 'sunday',
};

T? $enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return $enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

T $enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  final value = enumValues.entries
      .singleWhere(
        (e) => e.value == source,
        orElse: () {
          if (unknownValue == null) {
            throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}',
            );
          }
          return MapEntry(unknownValue, null);
        },
      )
      .key;

  return value;
}
