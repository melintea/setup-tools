require 'base_controller'

class InviteUacController < SIP::BaseController 

  # change the directive below to true to enable transaction usage.
  # If you do that then make sure that your controller is also 
  # transaction aware. i.e does not try send ACK to non-2xx responses,
  # does not send 100 Trying response etc.

  transaction_usage :use_transactions=>false

  # change the directive below to true to start after loading.
  start_on_load false

  def initialize
    logd('Controller created')
  end

  def start
    logd("sending initial INVITE")
    session = create_udp_session(SipperConfigurator[:DefaultRIP], SipperConfigurator[:DefaultRP])
    session.make_new_offer();
    savedSdp = session.offer_answer.get_sdp().clone()
    r=session.create_initial_request('INVITE', 'sip:*@jeffbeltzpc2.dev2000.com')
    r.sdp=session.offer_answer.get_sdp()
    r.sdp.session_lines = {:c=>"IN IP4 0.0.0.0"}
    session.send(r)
    session.offer_answer.ourSdp = savedSdp
  end

  def on_success_res(session)
    logd("got 200")
    session.request_with('ACK')
    controller=StateReinvited.new
    session.controller=controller
    session.schedule_timer_for("reinvite", 5000)
  end

end

class StateConnected < SIP::BaseController
  transaction_usage :use_transactions=>false

  def initialize
    logd('Controller created')
  end

  def on_invite(session)
    logd("got INVITE, sending hold response")
    session.make_new_offer unless session.irequest.sdp
    r=session.create_response(200, 'OK')
#    r.sdp.session_lines = {:c=> "IN IP4 0.0.0.0"}
    session.send(r)
  end

  def on_ack(session)
    logd("got ACK")
    session.schedule_timer_for("reinvite", 500)
#    controller=StateReinvited.new
    session.controller=controller
  end

  def on_bye(session)
    logd("got BYE")
    session.respond_with(200)
    session.invalidate(true)
  end

  def on_timer(session, task)
    logd("timer "+task.tid+" expired, sending BYE")
    session.request_with('BYE')
  end

  def on_success_res(session)
    logd("200 received for BYE")
    session.invalidate(true)
  end

end

class StateReinvited < SIP::BaseController
  transaction_usage :use_transactions=>false

  def initialize
    logd('Controller created')
  end

  def on_timer(session, task)
    logd("timer "+task.tid+" expired")
    case task.tid
    when "reinvite"
      logd("sending reInvite")
      session.make_new_offer
      session.set_media_attributes(:play_spec=>'PLAY part_gocart.au' )
      r=session.create_subsequent_request('INVITE')
      session.send(r)
    when "disconnect"
      logd("sending BYE")
      session.request_with('BYE')
    end
  end

  def on_success_res(session)
    logd("200 received for INVITE")
    session.request_with('ACK')
    session.schedule_timer_for("disconnect", 20000)
    controller=StateWaitToDisconnect.new
    session.controller=controller
  end

  def on_bye(session)
    logd("got BYE")
    session.respond_with(200)
    session.invalidate(true)
  end  

end

class StateWaitToDisconnect < SIP::BaseController
  transaction_usage :use_transactions=>false

  def initialize
    logd('Controller created')
  end

  def on_timer(session, task)
    logd("timer "+task.tid+" expired")
    case task.tid
    when "disconnect"
      logd("sending BYE")
      session.request_with('BYE')
    end
  end

  def on_success_res(session)
    logd("200 received for BYE")
    session.invalidate(true)
  end

  def on_bye(session)
    logd("got BYE")
    session.respond_with(200)
    session.invalidate(true)
  end  

end
