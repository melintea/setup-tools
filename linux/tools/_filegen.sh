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

# -----------------------------------------------------------------------------

sh -c "cat > ${fname}.hpp" <<EOFh
/*
 *  \$Id: $
 *
 *  Copyright 2023 Aurelian Melinte.
 *  Released under GPL 3.0 or later.
 *
 *  You need a C++0x compiler.
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

    ${fname}( const ${fname}& other );
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
 *  Copyright 2023 Aurelian Melinte.
 *  Released under GPL 3.0 or later.
 *
 *  You need a C++0x compiler.
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

