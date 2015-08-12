require 'httparty'

module Lita
	module Handlers
		class Deployer < Lita::Handler

			route(/^deploy\s+[a-zA-Z0-9-_]+\s*[a-zA-Z0-9-,_]*$/i, :deploy, command: true, help: { deployer: 'Deploys!' })

			def deploy(response)
				return unless response.message.command?
				response.reply 'Yesssir!'

				message = response.message.body
				args = message.gsub(/^deploy\s+/, '')
				parts = args.split(' ')
				stack_name = parts[0]
				if parts.size > 1
					modifier = parts[1]
				else
					modifier = ''
				end
				
				stack_envs = ENV.keys.select { |stack_env| stack_env =~ /#{stack_name}/i }
				response.reply "No no no... no stack found for \"#{stack_name}\"" and return if stack_envs.nil? || stack_envs.empty?
				response.reply "No no no... more than one stack found for \"#{stack_name}\"" and return if stack_envs.size > 1

				redeployment_hook_url = ENV.fetch(stack_envs.first)

				redeployment_hook_url = "#{redeployment_hook_url}?services=#{modifier}" unless modifier.empty?
				response = HTTParty.post(redeployment_hook_url, {})

				if response.code != 200
					response.reply 'No no no... got a non-200 response!'
				else
					response.reply 'Whoop whoop its going!'
				end
			end
		end

		Lita.register_handler(Deployer)
	end
end