# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/test_outFaxReINVITE_1300_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
# This processes only the #'s which end with 0183
require 'basegw_controller'

class TestOutFaxReINVITE1300Controller < ININ::BaseGWController
    
    def initialize
        super
        @mediaAttr = { :play_spec => "PLAY faxcall.au" }
    end
    def on_initial_invite(session)
        logd("on_initial_invite")
#        session.make_new_offer
#        session.offer_answer.our_answer_codecs(['G711U'])
#        session.set_media_attributes(:play_spec=>'PLAY part_gocart.au' )
        session.schedule_timer_for("disconnect", 60000)
        super
    end
    
    def on_reinvite(session)
        logd("on_reinvite")
		sdp = session.offer_answer.get_sdp();
        if (sdp != nil && SDP.check_codec_in_media(sdp.media_lines[0], 'T38')) 
            session.offer_answer.our_answer_codecs(['T38'])
        end
        rsp = session.create_response(200)
        rsp.server = name
        session.send(rsp)
    end

    def on_timer_disconnect(session, task)
        logd("timer "+task.tid+" sending disconnect")
        rsp=session.create_subsequent_request('BYE')
        session.send(rsp)
    end

    def interested_uri(uri)
        if (uri.user =~ /.*1300/)
            logd(" interested in #{uri.user}")
            return true
        end
        return false
    end
end
