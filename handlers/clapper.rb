module Handlers
	class Clapper < Lita::Handler

		route(/^clap/i, :clap, command: true, help: { clapper: 'Gives you the clap' })

		def clap(response)
			response.reply "clap clap clap clap clap... ...yes, you've got the clap now"
		end
	end

	Lita.register_handler(Clapper)
end