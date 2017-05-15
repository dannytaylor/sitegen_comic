-- site.moon
sitegen = require "sitegen"
lfs = require 'lfs'

comicDir = 'www/img/comics/'
comicTable = {}
-- add all our comics to a table
for file in lfs.dir(comicDir)
	-- file is the current file or directory name
	if file != '.' and file != '..' 
		-- print( "Found file: " .. file )
		table.insert(comicTable, file)
-- sort comics by name
table.sort(comicTable)


sitegen.create =>
	lfs.mkdir('c')

	deploy_to "daniel@chilidog.faith", "www/sanic/"
	-- feed "feed.moon", "feed.xml"
	local prev,next

	prev = '01'
	for i=1,#comicTable

		comicNum = string.sub(comicTable[i], 1, string.find(comicTable[i],'.')+1)
		-- make empty markdown folder
		io.open('c/'..comicNum..'.md','w')
		io.flush()

		if i == 1
			prev = '01'
		else 
			prev = string.sub(comicTable[i - 1], 1, string.find(comicTable[i - 1],'.')+1)
		if i == #comicTable 
			next = tostring(#comicTable)
		else 
			next = string.sub(comicTable[i + 1], 1, string.find(comicTable[i + 1],'.')+1)

		add 'c/'..comicNum..'.md', {
			template: 'comic', 
			target:comicNum, 
			comicName:comicTable[i], l
			leftLink:prev, 
			rightLink:next,
			num:comicNum
		}
	add 'c/index.md', template:'index', latest:tostring(#comicTable), target:'index'
