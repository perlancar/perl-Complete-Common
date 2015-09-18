package Complete::Args;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %args = (
    word => {
        summary => 'Word to complete',
        schema => ['str', default=>''],
        pos=>0,
        req=>1,
    },
    ci => {
        summary => 'Whether to do case-insensitive search',
        schema => 'bool',
    },
    fuzzy => {
        summary => 'The level of fuzzy matching',
        schema => ['int*', min=>0],
    },
    map_case => {
        summary => 'Whether to treat _ (underscore) and - (dash) as the same',
        schema => 'bool',
    },
);

1;
# ABSTRACT: Common arguments for complete_* routines
