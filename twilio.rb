require 'twilio-ruby'
require 'yaml'


# Loads creds from a YAML file not stored on Github for security. You can add your own credentials here
auth = YAML.load_file('auth.yml')
account_sid = auth["twilio_sid"]
auth_token = auth["twilio_auth"]

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

#This is the automatic reponse method. It receives a phone number to send a response to as an argument
def auto_response(to)
  @client.api.account.messages.create(
   from: '+13852090603',
   to: to,
   body: 'Thank you for texting Steve. I love you. Goodbye.'
 )
end

#This is the method that grabs the current list of messages. 
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

#Initialize the start_size variable based off the current list of messages at the outset of the service
start_size = getMessages.size

#This begins the monitoring service, on an interval passed in. Compares the different in current size vs start size, and if it's different, send a message to the number that most recently texted.
monitor_service(30) do
  puts  start_size
  message_arr = getMessages
  curr_size = message_arr.size
  puts curr_size

  if curr_size > start_size
    dif = curr_size - start_size
    puts dif
    if message_arr[dif-1].from != '+13852090603'
      while dif != 0 do 
        puts message_arr[dif-1].body 
        auto_response(message_arr[dif-1].from)
        dif -= 1 
      end
     start_size = curr_size
    end
  end
end

