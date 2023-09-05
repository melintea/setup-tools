# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/testG11AReinvite_1200_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
# This processes only the #'s which end with 0183
require 'basegw_controller'

class TestG11aReinvite_1200_Controller < ININ::BaseGWController
    
    def on_initial_invite(session)
        logd("on_initial_invite")
        session.make_new_offer
        session.offer_answer.our_answer_codecs(['G711U'])
        session.set_media_attributes(:play_spec=>'PLAY part_gocart.au' )
        session.schedule_timer_for("reinvite", 10000)
        session.schedule_timer_for("disconnect", 60000)
        super
    end
    
    def on_timer_reinvite(session, task)
        logd("timer "+task.tid+" sending reInvite")
        session.offer_answer.our_answer_codecs(['G711A'])
        session.make_new_offer(['G711A'])
        rsp=session.create_subsequent_request('INVITE')
        session.send(rsp)
    end

    def on_timer_disconnect(session, task)
        logd("timer "+task.tid+" sending disconnect")
        rsp=session.create_subsequent_request('BYE')
        session.send(rsp)
    end

    def interested_uri(uri)
        if (uri.user =~ /.*1200/)
            logd("is interested in #{uri.user}")
            return true
        end
        return false
    end
end
