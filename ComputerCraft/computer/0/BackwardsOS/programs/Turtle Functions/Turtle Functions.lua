local tt = tf.t:new("explorer", { 1, 2 })

for i = 1, 20 do
  tt:tRight()
  tt:mForward()
  tt:tLeft()
  tt:place()
  tt:print_own_data()
end

for i = 1, 20 do
  tt:dig()
  tt:tLeft()
  tt:mForward()
  tt:tRight()
  tt:print_own_data()
end

-- for key, nickname in pairs(Diva.nicknames) do
--   print(key .. ": " .. nickname)
-- end