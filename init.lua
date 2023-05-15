--- Валидация адреса электронной почты
--
local utf8 = require('utf8')

local RU_LETTERS = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'

--- Проверяет адрес электронной почты на корректность
--
-- @param  email Строка адреса электройнной почты
-- @return valid Корректен ли переданный адрес
local function validateEmail(email)
  -- Захват локальной и доменной части
  --
  local localPart, domainPart = utf8.lower(email)
    :match('^(['..RU_LETTERS..'a-z0-9%.!#%$%%&\'%*%+%-/=%?%^_`{|}~ "]+)@(['..RU_LETTERS..'a-z0-9%-%.:%[%]]+)$')

  if not localPart or not domainPart then
    return false
  end

  if localPart:len() > 64 or domainPart:len() > 255 then
    return false
  end

  -- Захват и проверка локальной части в кавычках
  --
  local localPartInQuotes = localPart:match('^"(.+)"$')

  if localPartInQuotes then
    if localPartInQuotes:match('[^'..RU_LETTERS..'a-z0-9!#%$%%&\'%*%+%-/=?^_ `{|}~%.]') then
      return false
    end
  else
    if localPart:find('"') then
      return false
    end
  end

  -- Начало и конец локальной части не должны содержать точку
  if localPart:sub(1, 1) == '.' or localPart:sub(-1) == '.' then
    return false
  end

  -- Проверка доменной части
  --
  local hostname = domainPart:match('^(['..RU_LETTERS..'%d%a%-%.]+)$')

  if hostname then
    -- Проверяем домен верхнего уровня на недопустимые символы
    if not hostname:match('%.([a-z'..RU_LETTERS..']+)$') then
      return false
    end

    -- Доменная часть не должна начинаться и заканчиваться с точки,
    -- а так же не должно быть две и более точек подряд
    if domainPart:sub(0, 1) == '.' or 
      domainPart:sub(-1) == '.' or
      domainPart:find('%.%.')
    then
      return false
    end
  end

  -- Если доменная часть это адрес ipv4
  --
  local ipv4 = domainPart:match('^%[.+%]$')

  if ipv4 then
    local a, b, c, d = domainPart:match('%[(%d+)%.(%d+)%.(%d+)%.(%d+)%]')

    if a and b and c and d then
      if not ((tonumber(a) < 256) and
        (tonumber(b) < 256) and
        (tonumber(c) < 256) and
        (tonumber(d) < 256))
      then
        return false
      end
    end
  end

  -- Если доменная часть это адрес ipv6
  --
  local ipv6 = domainPart:match('^%[ipv6:(.+)%]$')

  if ipv6 then
    if not ipv6:find(('([a-f0-9]+):'):rep(7)..'([a-f0-9]+)') then
      return false
    end
  end

  return true
end

--- validateEmail
-- @table export
return validateEmail
