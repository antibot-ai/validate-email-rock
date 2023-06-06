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

  -- Проверка доменной части на ip адрес
  --
  local ip = domainPart:match('^%[(.+)%]$')

  if ip then
    local isIp = false

    -- Если доменная часть это адрес ipv4
    --
    local ipv4 = {ip:match('^(%d+)%.(%d+)%.(%d+)%.(%d+)$')}

    if ipv4[1] and ipv4[2] and ipv4[3] and ipv4[4] then
      local a = tonumber(ipv4[1])
      local b = tonumber(ipv4[2])
      local c = tonumber(ipv4[3])
      local d = tonumber(ipv4[4])

      if not ((a < 256) and (b < 256) and (c < 256) and (d < 256))
      then
        return false
      end

      isIp = true
    end

    -- Если доменная часть это адрес ipv6
    --
    local ipv6 = ip:match('^ipv6:(.+)$')

    if ipv6 then
      local re = '^([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+)$'
      if not ipv6:find(re) then
        return false
      end

      isIp = true
    end

    if not isIp then
      return false
    end
  end

  return true
end

--- validateEmail
-- @table export
return validateEmail
