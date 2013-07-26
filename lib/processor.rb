# -*- coding: utf-8 -*-

class Processor
	class NoDataFromGrabber < Exception; end
	class NoTemplateFound < Exception; end

	COMMENT = '<!-- обновляется ежемесячно ботом -->'

	def initialize(grabber, tmpl)
		@grabber = grabber
		@tmpl = tmpl
	end

	def process(src)
		found = false

		# No analytics data yet, we'll add data
		dest = src.gsub(/\{\{\s*#{@tmpl}\s*\|\s*([^{}|]+?)\s*\}\}/m) { |x|
			found = true
			template_call_with_data($1)
		}

		# Old data with bot comment exists, we'll update the data
		dest = dest.gsub(/\{\{\s*#{@tmpl}\s*\|\s*([^{}|]+?)\|[^{}|]+ <!--[^{}|]+-->\s*\}\}/m) { |x|
			found = true
			template_call_with_data($1)
		}

		raise NoTemplateFound.new unless found
		return dest
	end

	def template_call_with_data(id)
		stat = @grabber.run_id(id)

		# Check that we've got data we need
		raise NoDataFromGrabber.new unless stat[:visitors_mon]

		"{{#{@tmpl}|#{id}|#{humanize(stat[:visitors_mon])} посетителей/месяц #{COMMENT}}}"
	end

	def humanize(number)
		if number < 1_000
			number.to_s
		elsif number < 1_000_000
			sprintf '%.1f тыс.', number.to_f / 1_000
		elsif number < 1_000_000_000
			sprintf '%.1f млн', number.to_f / 1_000_000
		else
			sprintf '%.1f млрд', number.to_f / 1_000_000_000
		end
	end
end
