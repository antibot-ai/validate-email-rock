# Валидация e-mail
Проверяет корректность емейла. Возвращает `true` в случае успешной валидации.

### Параметры
- **email** (строка): Строка для валидации.

# Установка
### tarantool
```bash
tt rocks install --only-server=https://rocks.antibot.ru validate-email
```
### luarocks
```bash
luarocks install --server=https://rocks.antibot.ru validate-email
```

# Использование
```lua
local validateEmail = require('validateEmail')

local valid = validateEmail('admin@antibot.ru')
print(valid) -- true
```

# Генерация ldoc
```bash
ldoc -s '!new' -d ldoc lua
```

# Тестирование
```bash
luatest test/*
```
