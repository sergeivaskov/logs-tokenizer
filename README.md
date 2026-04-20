# Smart Paste - Умная вставка сжатых логов

## Описание

Smart Paste - утилита для автоматического сжатия логов при вставке. Вместо вставки сырых логов с тысячами повторяющихся строк, вы получаете компактную версию с сохранением всей важной информации.

## Как использовать

### Запуск

**Вариант 1: Через BAT файл (рекомендуется)**
```cmd
start-smart-paste.bat
```

**Вариант 2: Через PowerShell**
```powershell
powershell -ExecutionPolicy Bypass -File src\smart-paste-logs.ps1
```

### Использование

1. **Копируйте логи обычным способом** (Ctrl+C или правый клик → Copy)
2. **Переключитесь в Cursor** или любое другое приложение
3. **Нажмите Ctrl+Alt+V** вместо обычного Ctrl+V
4. **Вставятся сжатые логи** с автоматическим удалением дубликатов

### Что делает сжатие

- ✅ Удаляет полностью дублирующиеся строки
- ✅ Группирует последовательные повторы (добавляет счётчик "повторялось N раз")
- ✅ Нормализует временные метки для сравнения
- ✅ Убирает повторяющиеся значения метрик (WorkingSet, Peak и т.д.)
- ✅ Нормализует HWND и другие изменяющиеся идентификаторы
- ✅ Показывает процент экономии токенов

### Пример

**До (5000 символов):**
```
2026-04-18T11:43:40.486 [ExclusionService] ✅ App ALLOWED: C:\...\Cursor.exe
2026-04-18T11:43:40.511 [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
2026-04-18T11:43:40.512 [WinFocusMonitor] workerMain: hwnd=00000000016000FE idObject=-4 idChild=0 -> secure=0
2026-04-18T11:43:40.527 [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
2026-04-18T11:43:40.527 [WinFocusMonitor] workerMain: hwnd=00000000003B0640 idObject=-4 idChild=-3681 -> secure=0
2026-04-18T11:43:41.744 [MemDiag] periodic t+9s WorkingSet=364.378906MB Peak=364.378906MB
2026-04-18T11:43:44.759 [MemDiag] periodic t+12s WorkingSet=277.437500MB Peak=368.765625MB
2026-04-18T11:43:47.768 [MemDiag] periodic t+15s WorkingSet=280.527344MB Peak=368.765625MB
2026-04-18T11:43:50.779 [MemDiag] periodic t+18s WorkingSet=280.527344MB Peak=368.765625MB
```

**После (2000 символов, -60%):**
```
[TIMESTAMP] [ExclusionService] ✅ App ALLOWED: C:\...\Cursor.exe
[TIMESTAMP] [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
[TIMESTAMP] [WinFocusMonitor] workerMain: hwnd=[HWND] idObject=-4 idChild=[ID] -> secure=0
    ... (повторялось ещё 1 раз)
[TIMESTAMP] [MemDiag] periodic t+[X]s WorkingSet=[X]MB Peak=[X]MB
    ... (повторялось ещё 3 раз)
```

## Автозапуск при старте Windows

### Через Task Scheduler (рекомендуется)

1. Открыть Task Scheduler (Win+R → `taskschd.msc`)
2. Create Basic Task
3. Name: "Smart Paste AutoStart"
4. Trigger: "At log on"
5. Action: "Start a program"
6. Program: `powershell.exe`
7. Arguments: `-WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\dev\LogsTokenizer\src\smart-paste-logs.ps1"`
8. Finish

### Через Startup папку

Создать ярлык на `start-smart-paste.bat` в:
```
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
```

## Проблемы и решения

### Хоткей не работает

**Проблема:** Ctrl+Alt+V уже используется другим приложением

**Решение:** Закройте другие приложения или измените хоткей в скрипте (строка с `$VK_V`)

### Скрипт не запускается

**Проблема:** PowerShell Execution Policy

**Решение:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Иконка не появляется в трее

**Проблема:** Скрипт запущен, но иконки нет

**Решение:** Проверьте скрытые иконки в трее (стрелка вверх возле часов)

## Технические детали

- **Язык:** PowerShell 5.1+
- **Зависимости:** .NET Framework (встроен в Windows)
- **Хоткей:** Глобальный, работает во всех приложениях
- **Потребление ресурсов:** ~10-20 МБ RAM
- **Латентность:** <100ms от нажатия до вставки

## Структура проекта

```
LogsTokenizer/
├── src/                          # Основные скрипты
│   ├── smart-paste-logs.ps1     # Главный скрипт утилиты
│   └── start-smart-paste.bat    # Launcher для Windows
├── docs/                         # Документация
├── tests/                        # Тестовые скрипты (не в git)
├── examples/                     # Примеры логов (не в git)
├── .gitignore
└── README.md
```

## Лицензия

MIT License
