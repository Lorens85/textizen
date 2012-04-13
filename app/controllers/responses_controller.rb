class ResponsesController < ApplicationController

  #post /responses/receive_message
  def receive_message
    @session = Tropo::Generator.parse params
    puts @session

    puts params
    if params[:session]
      puts params[:session]
    end
    # if params[:session][:to][:network] == "IM" #debug mode
    @to = params[:session]['to']['id']
    @from = params[:session]['from']['id']
    
    puts 'tropo session'
    puts @session[:session][:to][:id]
    puts @session[:session][:from][:id]
    puts @session[:session][:initialText]

    @poll = get_poll_by_phone(@from)
    @response = params[:session]['initialText']

    if @poll
      @poll.responses.create(:from => normalize_phone(@from), :response => @response)
      render :text=>say("Thanks for your response")
    else
      render :text=>reject("poll not found")
    end
  end

  def say(message)
    return Tropo::Generator.say message
  end

  # reject the message
  def reject(message)
    return say("Sorry, " + message)
  end

  def get_poll_by_phone(phone)
    return Poll.where(:phone=>phone)[0]
  end

  def normalize_phone(phone)
    unless phone.match(/^\+/)
      phone = "+" + phone
    end
    return phone
  end
end
