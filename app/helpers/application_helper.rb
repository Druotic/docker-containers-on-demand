module ApplicationHelper
	def selected?(path)
		return current_page?(path) ? "active" : ""
	end
end
