require 'torch'
require 'util/CSVFile'

function tests.testCreate()
   local csv = CSVFile('test.csv')
   csv:writeHeader({'a','b','c'})
   csv:writeLine{a=1,b=1,c=3.4}
   csv:writeLine{c=19,a=2,b=3}
   csv:close()

   local f = torch.DiskFile('test.csv', 'r', true)
   tester:assert(f, 'File was not created')
   tester:asserteq(f:readString('*l'),'a,b,c','Headers not written correctly')
   tester:asserteq(f:readString('*l'),'1,1,3.4','wrong first line')
   tester:asserteq(f:readString('*l'),'2,3,19','wrong second line')
   os.execute('rm test.csv')
end

