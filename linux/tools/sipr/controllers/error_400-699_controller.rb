# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/error_400-699_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
# This processes only the #'s which end with 0400-0699 and generate the appropriate error response
require 'basegw_controller'

class Error400Thru699Controller < ININ::BaseGWController
    
    def on_initial_invite(session)
        logd("on_initial_invite")
        send_trying(session)
        uri = URI::SipUri.new.assign(session.local_uri)
        if (uri.user =~ /.*0([4-6][0-9][0-9])/)
            rsp = session.create_response($1.to_i)
            rsp.server = name
            session.send(rsp)
        end
    end
    
    def interested_uri(uri)
        if (uri.user =~ /.*0[4-6][0-9][0-9]/)
            logd(" is interested in #{uri.user}")
            return true
        end
        return false
    end
end
