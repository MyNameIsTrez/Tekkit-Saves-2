Entity_test = {
  new = function(self)
          local starting_values = {
                  id = math.random()
          }
          setmetatable(starting_values, {__index = self})
          return starting_values
  end,
  setVar = function(self, var)
          self.var = var
  end,
  printVar = function(self)
          print(self.var)
  end,
  printID = function(self)
          print(self.id)
  end
}

entities_test = {}
for i = 1, 2 do
 entities_test[#entities_test+1] = Entity_test:new()
end

entities_test[1]:setVar("a")
entities_test[2]:setVar("b")
entities_test[1]:printVar()
entities_test[2]:printVar()
entities_test[1]:printID()
entities_test[2]:printID()
