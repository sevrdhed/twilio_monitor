require 'twilio-ruby'
require 'yaml'


# Loads creds from a YAML file not stored on Github for security. You can add your own credentials here
auth = YAML.load_file('auth.yml')
account_sid = auth["twilio_sid"]
auth_token = auth["twilio_auth"]

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

#@client.api.account.messages.create(
 # from: '+13852090603',
 # to: '+18016553900',
 # body: 'This took me 5 minutes. See? Twilio is easy.'
#)

def getMessages()
@client.api.account.messages.list
end

#This service loops for a duration in seconds passed in as an argument, indefinitely
def monitor_service(n)
  loop do
    before = Time.now
    yield
    interval = n-(Time.now-before)
    sleep(interval) if interval > 0
  end
end

monitor_service(10) do
  puts  getMessages()

end

