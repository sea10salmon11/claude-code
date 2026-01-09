import 'package:flutter/material.dart';

/// Константы приложения
class AppConstants {
  // Цвета для уроков
  static const List<Color> lessonColors = [
    Color(0xFFE57373), // Красный
    Color(0xFF64B5F6), // Синий
    Color(0xFF81C784), // Зеленый
    Color(0xFFFFD54F), // Желтый
    Color(0xFFBA68C8), // Фиолетовый
    Color(0xFFFF8A65), // Оранжевый
    Color(0xFF4DB6AC), // Бирюзовый
    Color(0xFFA1887F), // Коричневый
    Color(0xFF90A4AE), // Серый
  ];

  // Стандартные времена начала уроков
  static const List<String> standardStartTimes = [
    '08:00',
    '08:55',
    '09:50',
    '10:55',
    '12:00',
    '13:05',
    '14:10',
    '15:15',
  ];

  // Стандартные времена окончания уроков
  static const List<String> standardEndTimes = [
    '08:45',
    '09:40',
    '10:35',
    '11:40',
    '12:45',
    '13:50',
    '14:55',
    '16:00',
  ];

  // Продолжительность урока по умолчанию (минуты)
  static const int defaultLessonDuration = 45;

  // Названия предметов для автодополнения
  static const List<String> commonSubjects = [
    'Математика',
    'Русский язык',
    'Литература',
    'Английский язык',
    'Физика',
    'Химия',
    'Биология',
    'География',
    'История',
    'Обществознание',
    'Информатика',
    'Физкультура',
    'ОБЖ',
    'Музыка',
    'ИЗО',
    'Технология',
  ];
}

/// Преобразование hex строки в Color
Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

/// Преобразование Color в hex строку
String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}
