# Установка Flutter на Windows для работы с Claude Code

## 1. Установка Flutter SDK

### Шаг 1: Выберите место установки
Рекомендуется: `C:\flutter\` (БЕЗ пробелов в пути!)

**❌ Плохие места:**
- `C:\Program Files\flutter\` (есть пробел)
- `C:\Users\Ваше Имя\flutter\` (есть пробел)

**✅ Хорошие места:**
- `C:\flutter\`
- `C:\src\flutter\`
- `C:\dev\flutter\`

### Шаг 2: Распаковка
1. Распакуйте скачанный архив в выбранное место
2. Должна получиться структура: `C:\flutter\bin\flutter.bat`

### Шаг 3: Добавление в PATH

**Через GUI:**
1. Нажмите Win + R → введите `sysdm.cpl` → Enter
2. Вкладка "Дополнительно" → "Переменные среды"
3. В разделе "Системные переменные" найдите `Path` → "Изменить"
4. Добавьте новую строку: `C:\flutter\bin`
5. ОК → ОК → ОК

**Через PowerShell (от администратора):**
```powershell
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\flutter\bin",
    "Machine"
)
```

### Шаг 4: Перезапустите терминал
Закройте все окна PowerShell/CMD и откройте новое.

### Шаг 5: Проверка
```powershell
flutter doctor
```

## 2. Настройка Android SDK

Если используете Android Studio:
```powershell
# Проверьте что установлено
flutter doctor -v

# Если нужно, укажите путь к SDK
flutter config --android-sdk "C:\Users\ВашеИмя\AppData\Local\Android\Sdk"
```

## 3. Установка Android Studio SDK Manager

В Android Studio:
1. Tools → SDK Manager
2. Установите:
   - ✅ Android SDK Platform (минимум API 21+)
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android SDK Command-line Tools

## 4. Проверка полной установки

```powershell
flutter doctor -v
```

Должно быть:
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 202x.x)
[✓] VS Code (optional)
```

## 5. Создание эмулятора (опционально)

```powershell
# Создать эмулятор
flutter emulators --create --name test_emulator

# Или через Android Studio: Tools → Device Manager → Create Device
```

## 6. Работа с Claude Code

### Структура работы:

**Claude (в контейнере):**
- Создает/редактирует код
- Файлы синхронизируются с вашим Windows

**Вы (в PowerShell на Windows):**
```powershell
# Перейти в папку проекта
cd C:\путь\к\claude-code\ваш_проект

# Установить зависимости (после того как Claude добавил в pubspec.yaml)
flutter pub get

# Запустить на эмуляторе/устройстве
flutter run

# Или собрать APK
flutter build apk --debug
```

## 7. Настройка VS Code (рекомендуется)

1. Установите VS Code
2. Установите расширения:
   - Flutter
   - Dart
3. Откройте папку проекта
4. F5 для запуска с отладкой

## Troubleshooting

### Flutter не найден после добавления в PATH
- Перезагрузите компьютер
- Или перезапустите все окна терминала

### "cmdlet flutter" not recognized
- Проверьте PATH: `$env:Path -split ';'`
- Должен быть `C:\flutter\bin`

### Android SDK не найден
```powershell
flutter config --android-sdk "C:\Users\ВашеИмя\AppData\Local\Android\Sdk"
```

### Git не установлен
Скачайте с: https://git-scm.com/download/win

## Команды для быстрого старта

```powershell
# Узнать где находится проект Claude Code
# (обычно показывается в интерфейсе claude.ai/code)

# Перейти в проект
cd C:\путь\к\проекту

# Первый запуск Flutter проекта
flutter pub get
flutter run

# Горячая перезагрузка (когда приложение запущено)
# Нажмите 'r' в терминале где работает flutter run
```
