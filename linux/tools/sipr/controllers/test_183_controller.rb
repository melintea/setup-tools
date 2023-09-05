# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/test_183_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
# This processes only the #'s which end with 0183
require 'basegw_controller'

class Test183Controller < ININ::BaseGWController
    
    def on_initial_invite(session)
        logd("on_initial_invite")
        send_trying(session)
        session.make_new_offer
#        rsp = session.respond_reliably_with(183)
#        rsp = session.create_response(183, "Session Progress", session.irequest, true)
#        session.set_media_attributes(:play_spec=>'PLAY part_gocart.au, PLAY in_sipper.au' )
        session.set_media_attributes(:play_spec=>'PLAY part_gocart.au' )
        rsp = session.create_response(183)
        rsp.server = name
        session.send(rsp)
        session.schedule_timer_for("answer", 15000)
    end
    
    def interested_uri(uri)
        if (uri.user =~ /.*0183/)
            logd(" is interested in #{uri.user}")
            return true
        end
        return false
    end
end
