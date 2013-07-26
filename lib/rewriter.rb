# -*- coding: utf-8 -*-

class Rewriter
	def initialize(options)
		@options = options
		@wc = MediaWiki::Gateway.new('http://ru.wikipedia.org/w/api.php')
		@wc.login(BOT_LOGIN, BOT_PASSWORD)

		@log = Logger.new($stdout)
		@log.level = @options[:verbose] ? Logger::INFO : Logger::WARN
	end

	def run(grabber, tmpl, list)
		processor = Processor.new(grabber, tmpl)
		File.open(list).each_line { |title|
			title.chomp!
			t = title.gsub(/ /, '_')
			prefix = "#{grabber.class.to_s.gsub(/^.*::/, '')} - #{t} - "

			@log.info "#{prefix}processing"

			src = @wc.get(t)
			@log.info "#{prefix}downloaded Wikipedia article"

			begin
				dest = processor.process(src)
			rescue Processor::NoDataFromGrabber
				@log.warn "#{prefix}got no data from external web analytics system"
				next
			rescue Processor::NoTemplateFound
				@log.warn "#{prefix}unable to match & update template"
				next
			end

			if src != dest
				confirmed = @options[:auto] ? true : manual_confirmation(src, dest)
				if confirmed
					@wc.edit(t, dest, :summary => "[[Участник:WebAnalyticsBot|Web Analytics Bot]]: актуализирована #{tmpl}", :minor => 1)
					@log.info "#{prefix}updated Wikipedia article"
				else
					@log.warn "#{prefix}modification not confirmed"
				end
			else
				@log.warn "#{prefix}not modified"
			end
		}
	end

	def manual_confirmation(src, dest)
		File.open('page-before', 'w') { |f| f.write(src) }
		File.open('page-after', 'w') { |f| f.write(dest) }
		system("diff -u page-before page-after")
		print 'Confirm? (y/n) '
		answer = gets
	end
end