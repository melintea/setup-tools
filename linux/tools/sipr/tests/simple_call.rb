require 'driven_sip_test_case'

class SimpleCall < DrivenSipTestCase 

  def self.description
    "Callflow is > INVITE, < 100 {0,}, < 180 {0,}, < 200, > ACK, > INVITE, < 200, > ACK, < INVITE, > 200, < ACK, < BYE, > 200" 
  end

  def setup
    super
    SipperConfigurator[:SessionRecord]='msg-info'
    SipperConfigurator[:WaitSecondsForTestCompletion] = 180
    str = <<-EOF
# FLOW : > INVITE, < 100 {0,}, < 180 {0,}, < 200, > ACK, > INVITE, < 200, > ACK, < INVITE, > 200, < ACK, < BYE, > 200
#
require 'base_controller'

class SimpleCallController < SIP::SipTestDriverController 

  # change the directive below to true to enable transaction usage.
  # If you do that then make sure that your controller is also 
  # transaction aware. i.e does not try send ACK to non-2xx responses,
  # does not send 100 Trying response etc.

  transaction_usage :use_transactions=>false

  def initialize
    logd('Controller created')
  end

  def on_invite(session)
    # Recording: fine; Playing: fine
    session.set_media_attributes(:play_spec =>'PLAY hello_sipper.au', :rec_spec=>'_recording.au')
    session.respond_with(200)
  end

  def on_bye(session)
    session.respond_with(200)
    session.invalidate(true)
    session.flow_completed_for('SimpleCall')
  end

  def on_provisional_res(session)
    if !session['1xx']
      session['1xx'] = 1
    elsif session['1xx'] == 1

    end
  end

  def start
    #session = create_udp_session(SipperConfigurator[:DefaultRIP], SipperConfigurator[:DefaultRP])
    #session.request_with('INVITE', 'sip:nasir@sipper.com')

    fromHdr = "sip:" + SipperConfigurator[:LocalSipperTN].to_s + "@" + SipperConfigurator[:LocalSipperIP] + ":" + SipperConfigurator[:LocalSipperPort].to_s
    toHdr   = "sip:" + SipperConfigurator[:DefaultRTN].to_s + "@" + SipperConfigurator[:DefaultRIP] + ":" + SipperConfigurator[:DefaultRP].to_s

    ses = create_udp_session(SipperConfigurator[:DefaultRIP], SipperConfigurator[:DefaultRP])
    req = ses.create_initial_request("INVITE", toHdr, 
                                     :from=>fromHdr, 
                                     :to=>toHdr,
                                     :p_session_record=>"msg-debug")

    req.p_asserted_identity = "Testing with Sipper <sip:888@sipper.me>"
    #req.p_asserted_identity = "" #SIP engine error

    # Fails: I do not hear anything
    ses.make_new_offer
    ses.set_media_attributes(:play_spec =>'PLAY hello_sipper.au')

    ses.send(req)
  end

  def on_success_res(session)
    if !session['2xx']
      session.request_with('ACK')
    session.request_with('INVITE')
      session['2xx'] = 1
    elsif session['2xx'] == 1
      session.request_with('ACK')

    end
  end

  def on_ack(session)
  end

end
    EOF
    define_controller_from(str)
    set_controller('SimpleCallController')
  end

  def test_case_1
    self.expected_flow = ['> INVITE','< 100 {0,}','< 180 {0,}','< 200','> ACK','> INVITE','< 200','> ACK','< INVITE','> 200','< ACK','< BYE','> 200']
    start_controller
    if SipperConfigurator[:RunLoad] 
      k = SipperConfigurator[:NumCalls]-1 
    else 
      k = 0 
    end 
    0.upto(k) {|x| verify_call_flow(x)}
  end
end
