Entity_test = {
  new = function(self)
          local new = {}
          setmetatable(new, {__index = self})
          return new
  end,
  setVar = function(self, var)
          self.var = var
  end,
  printVar = function(self)
          print(self.var)
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