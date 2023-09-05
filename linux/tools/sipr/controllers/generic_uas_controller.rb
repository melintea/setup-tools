require 'base_controller'

class GenericUasController < SIP::BaseController 

  # change the directive below to true to enable transaction usage.
  # If you do that then make sure that your controller is also 
  # transaction aware. i.e does not try send ACK to non-2xx responses,
  # does not send 100 Trying response etc.

  transaction_usage :use_transactions=>false

  # change the directive below to true to start after loading.
  start_on_load false

  attr_accessor :uripattern

  def initialize
    logd('Controller created')
  end

  def interested?(initial_request)
    if !self.uripattern.nil?
      regex=Regexp.new(self.uripattern)
      match=(regex === initial_request.uri)
      if match.nil?
        match=true
      end
      logd("request.uri="+initial_request.uri+" pattern="+self.uripattern+" match?="+match.to_s)
      match
    else
      false
    end
  end

  def request_specific_response_dispatch(session, response_method)
    request_m = session.iresponse.get_request_method.downcase
    handler = (sprintf("%s_for_%s", response_method, request_m)).to_sym
    
    if self.respond_to?(handler)
      self.send(handler, session)
    else
      super.send(handler, session)
    end
  end

  def on_bye(session)
    session.respond_with(200)
    session.invalidate(true)
  end

  def on_cancel(session)
    session.invalidate(true)
  end

  def change_state(session, state_class)
    controller=state_class.new
    logd("changing state to "+state_class.name)
    session.controller=controller
  end
end

