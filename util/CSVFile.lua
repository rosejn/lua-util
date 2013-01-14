require 'torch'
local CSVFile = torch.class('CSVFile')

function CSVFile:__init(filename)
   self:open(filename)
   self.keys = {}
end

function CSVFile:writeHeader(strings)
   local header = ''
   self.keys = strings
   for _, v in pairs(self.keys) do
      header = header .. ',' .. v
   end
   self.file:write(string.sub(header .. '\n',2))
   self.file:flush()
end

function CSVFile:writeLine(args)
   local csv = ''
   for _, v in ipairs(self.keys) do
      csv = csv .. ',' .. args[v]
   end
   self.file:write(string.sub(csv .. '\n', 2))
   self.file:flush()
end


function CSVFile:close()
   io.close(self.file)
end

function CSVFile:open(filename)
   self.filename = filename
   self.file = assert(io.open(filename,'w'))
end
