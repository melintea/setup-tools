# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/testDelayReinvite_1250_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
# This processes only the #'s which end with 0183
require 'basegw_controller'

class TestDelayAnswer1250Controller < ININ::BaseGWController
    
    def initialize
        super
        @mediaAttr = { :play_spec => "PLAY part_gocart.au" }
    end
    def on_initial_invite(session)
        logd("on_initial_invite")
#        session.make_new_offer
#        session.offer_answer.our_answer_codecs(['G711U'])
#        session.set_media_attributes(:play_spec=>'PLAY part_gocart.au' )
        session.schedule_timer_for("disconnect", 80000)
        session.schedule_timer_for("answer", 5000)
    end
    
    def on_reinvite(session)
        logd("on_reinvite")
        session.schedule_timer_for("answer", 10000)
    end

    def on_timer_disconnect(session, task)
        logd("timer "+task.tid+" sending disconnect")
        rsp=session.create_subsequent_request('BYE')
        session.send(rsp)
    end

    def on_timer_answer(session, task)
        logd("timer "+task.tid+" sending 200 OK")
        rsp = session.create_response(200)
        rsp.server = name
        session.send(rsp)
    end

    def interested_uri(uri)
        if (uri.user =~ /.*1250/)
            logd(" interested in #{uri.user}")
            return true
        end
        return false
    end
end
