#!/bin/bash

#
# Generate a pair of .cpp & .hpp files. 
#

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

fname=$1
guid=`uuidgen | sed -s 's/-/_/g'`
year=`date +'%Y'`

# -----------------------------------------------------------------------------

sh -c "cat > ${fname}.hpp" <<EOFh
/*
 *  \$Id: $
 *
 *  Copyright ${year} Aurelian Melinte.
 *  Released under GPL 3.0 or later.
 *
 */

#ifndef INCLUDED_${fname}_hpp_${guid}
#define INCLUDED_${fname}_hpp_${guid}

#pragma once

namespace lpt {

/*
 *
 */
class ${fname}
{
public:

    ${fname}()  {}
    ~${fname}() {}

    ${fname}( const ${fname}& other );
    ${fname}& operator=( const ${fname}& other );

    ${fname}( ${fname}&& other );
    ${fname}& operator=( ${fname}&& other );
}; // ${fname}

} //namespace lpt


#endif //#define INCLUDED_${fname}_hpp_${guid}
EOFh

# -----------------------------------------------------------------------------


sh -c "cat > ${fname}.cpp" <<EOFcpp
/*
 *  \$Id: $
 *
 *  Copyright ${year} Aurelian Melinte.
 *  Released under GPL 3.0 or later.
 *
 */

#include <lpt/${fname}.hpp>

namespace lpt {

${fname}::${fname}()
{
}

} //namespace lpt

EOFcpp

# -----------------------------------------------------------------------------

