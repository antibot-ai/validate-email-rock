-- test/validation.lua
local luatest = require('luatest')
local g = luatest.group('validation')

-- Функция валидации
local validateEmail = require('lua.validate-email.init')

-- Тесты
g.test_valid_email = function()
  local validEmails = {
    'админ@сайт.рф',
    'админ.сайта@сайт.рф',
    'admin@сайт.рф',
    'appdurov@domainPart.co.tk',
    'other.email-with-hyphen@example.com',
    'x@example.com',
    'example-indeed@strange-example.com',
    'test/test@test.com',
    'disposable.style.email.with+symbol@example.com',
    'very.common@example.com',
    '\"Hello World!\"@gmail.com',
    '\" \"@example.org',
    '\"john..doe\"@example.org',
    'mailhost!username@example.org',
    'user%example.com@example.or',
    'user-@example.org',
    'simple@[127.0.0.255]',
    'Москва@[127.0.0.1]',
    'postmaster@[IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334]',
    'Москва@[IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334]'
  }

  for i = 1, #validEmails do
    -- Ожидаем, что адрес электронной почты будет валидным
    local valid = validateEmail(validEmails[i])
    luatest.assert_eval_to_true(valid, validEmails[i])
  end
end

g.test_invalid_email = function()
  local invalidEmails = {
    '.',
    '123.123..',
    '123.123.123.123',
    '123',
    'blablabla',
    '   John@gmail.com ',
    '.John.Doe@example.com',
    'John.Doe.@example.com',
    'Abc.example.com',
    'A@b@c@example.com',
    'a\"b(c)d,e:f;g<h>i[j\\k]l@example.com',
    'just\"not\"right@example.com',
    'this is\"not\allowed@example.com',
    'this\\ still\\\"not\\allowed@example.com',
    '1234567890123456789012345678901234567890123456789012345678901234+x@example.com',
    'i_like_underscore@but_its_not_allowed_in_this_part.example.com',
    'QA[icon]CHOCOLATE[icon]@test.com',
    '[]!@#$%^&@gmail.com',
    'postmaster(coment)@domainPart.lol',
    'postmaster@(comment)domainPart.lol',
    'админ.сайта@сайт.-рф',
    'админ.сайта@сайт.123',
    'а@дмин@сайт.рф',
    'postmaster@[IPv4:2001:0db8:85a3:0000:0000]',
    'postmaster@[IPv4:123.123.123.123]',
    'postmaster@[IPv6:2001:0db8:85a3:0000:0000]',
    'simple@[256.256.256.256]',
    'simple@[256.256.256.-1]',
    'simple@[foo.123.123.123]',
    'foo@[bar]'
  }

  for i = 1, #invalidEmails do
    -- Ожидаем, что адрес электронной почты будет невалидным
    local valid = validateEmail(invalidEmails[i])
    luatest.assert_eval_to_false(valid, invalidEmails[i])
  end
end

g.test_empty_email = function()
    -- Ожидаем, что пустой адрес электронной почты будет невалидным
    local email = ''
    local valid = validateEmail(email)
    luatest.assert_eval_to_false(valid)
end
