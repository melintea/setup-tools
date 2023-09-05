# -------------------------------------------------------------------
# $Id: //users/aurelian.melinte_systest/config/sipr/controllers/zlast_controller.rb#1 $
# $Change: 157759 $
# $DateTime: 2014/02/14 15:24:56 $
# $Author: Aurelian.Melinte $
# Description:
#   This is the last controller so that it takes answers any call that didn't express an
#   interest with either interested_uri or interested?
# -------------------------------------------------------------------

# Located in SippperConfig[:ControllerLibPath]
require 'basegw_controller'

#  This is named this way to force it to be the last controller to chose
class ZLastController < ININ::BaseGWController
end
