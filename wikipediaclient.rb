$LOAD_PATH << '../get-analytics'

require 'grabberutils'

class WikipediaClient
	include GrabberUtils

	def get_source(t)
		download("http://ru.wikipedia.org/w/index.php?title=#{t}&action=raw")
	end

	def put_source(t, src)
		puts src
	end
end
