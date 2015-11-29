package Complete::Common;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our %EXPORT_TAGS = (
    all => [qw/
                  %arg_word
                  %args_common_opts
                  %args_path_opts
                  $OPT_CI
                  $OPT_WORD_MODE
                  $OPT_FUZZY
                  $OPT_MAP_CASE
                  $OPT_EXP_IM_PATH
                  $OPT_DIG_LEAF
    /],
);

our %arg_word = (
    word => {
        summary => 'Word to complete',
        schema => ['str', default=>''],
        pos=>0,
        req=>1,
    },
);

our %args_common_opts = (
    ci => {
        summary => 'Whether to do case-insensitive search',
        schema => 'bool',
    },
    word_mode => {
        summary => 'Whether to enable word-mode matching',
        schema => 'bool',
        description => <<'_',

If set to 1, enable word-mode matching. With this mode, the string to be
searched as well as each choice string are first split into words and matching
is tried for all available word even non-adjacent ones. For example, if you have
`a-b` and the choices are (`a-f-gan`, `a-f-bar`, `a-f-g-bar`) then `a-f-bar` and
`a-f-g-bar` will match because the `b` matches `bar` even though the word is not
adjacent. This is convenient when you have strings that are several or many
words long: you can just type the word that you remember even though the word is
positioned near the end of the string. Word mode matching is normally only done
when exact matching fails to return any candidate.

Word-mode matching normally will only be attempted when normal mode matching
fails to return any candidate.

_
    },
    fuzzy => {
        summary => 'The level of fuzzy matching',
        schema => ['int*', min=>0],
        description => <<'_',

If set to at least 1, will enable fuzzy matching (matching even though there are
some spelling mistakes). The greater the number, the greater the tolerance. To
disable fuzzy matching, set to 0.

Fuzzy matching is normally only done when exact matching and word-mode matching
fail to return any candidate.

_
    },
    map_case => {
        summary => 'Whether to treat _ (underscore) and - (dash) as the same',
        schema => 'bool',
        description => <<'_',

This is another convenience option like `ci`, where you can type `-` (without
pressing Shift, at least in US keyboard) and can still complete `_` (underscore,
which is typed by pressing Shift, at least in US keyboard).

This option mimics similar option in bash/readline: `completion-map-case`.

_
    },
);

our %args_path_opts = (
    exp_im_path => {
        summary => 'Whether to expand intermediate paths',
        schema  => 'bool',
        description => <<'_',

This option mimics feature in zsh where when you type something like `cd
/h/u/b/myscript` and get `cd /home/ujang/bin/myscript` as a completion answer.

_
        },
    dig_leaf => {
        summary => 'Whether to dig leafs',
        schema => 'bool',
        description => <<'_',

This feature mimics what's seen on GitHub. If a directory entry only contains a
single entry, it will directly show the subentry (and subsubentry and so on) to
save a number of tab presses.

_
        },
);

our $OPT_CI          = ($ENV{COMPLETE_OPT_CI}          // 1) ? 1:0;
our $OPT_WORD_MODE   = ($ENV{COMPLETE_OPT_WORD_MODE}   // 1) ? 1:0;
our $OPT_FUZZY       = ($ENV{COMPLETE_OPT_FUZZY}       // 1)+0;
our $OPT_MAP_CASE    = ($ENV{COMPLETE_OPT_MAP_CASE}    // 1) ? 1:0;
our $OPT_EXP_IM_PATH = ($ENV{COMPLETE_OPT_EXP_IM_PATH} // 1) ? 1:0;
our $OPT_DIG_LEAF    = ($ENV{COMPLETE_OPT_DIG_LEAF}    // 1) ? 1:0;

1;
#ABSTRACT: Common stuffs for completion routines

=head1 DESCRIPTION

This module defines some common arguments and settings. C<Complete::*> modules
should use the default from these settings, to make it convenient for users to
change some behaviors globally.

The defaults are optimized for convenience and laziness for user typing and
might change from release to release.

=head2 C<$Complete::Common::OPT_CI> => bool (default: from COMPLETE_OPT_CI or 1)

If set to 1, matching is done case-insensitively. This setting should be
consulted as the default for all C<ci> argument in the C<complete_*> functions.
But users can override this setting by providing value to C<ci> argument.

In bash/readline, this is akin to setting C<completion-ignore-case>.

=head2 C<$Complete::Common::OPT_WORD_MODE> => bool (default: from COMPLETE_OPT_WORD_MODE or 1)

If set to 1, enable word-mode matching. This setting should be consulted as the
default for all C<word_mode> argument in the C<complete_*> functions. But users
can override this setting by providing value to C<word_mode> argument.

Word mode matching is normally only done when exact matching fails to return any
candidate. To give you an idea of how word-mode matching works, you can run
Emacs and try its completion of filenames (C<C-x C-f>) or function names
(C<M-x>). Basically, each string is split into words and matching is tried for
all available word even non-adjacent ones. For example, if you have C<dua-d> and
the choices are (C<dua-tiga>, C<dua-empat>, C<dua-lima-delapan>) then
C<dua-lima-delapan> will match because C<d> matches C<delapan> even though the
word is not adjacent. This is convenient when you have strings that are several
or many words long: you can just type the word that you remember even though the
word is positioned near the end of the string.

=head2 C<$Complete::Common::OPT_FUZZY> => int (default: from COMPLETE_OPT_FUZZY or 1)

Enable fuzzy matching. The greater the number, the greater the tolerance. To
disable fuzzy matching, set to 0. This setting should be consulted for every
C<fuzzy> argument in the C<complete_*> functions. But users can override this
setting by providing value to C<fuzzy> argumnt.

Fuzzy matching is normally only done when exact matching and word-mode matching
fail to return any candidate.

=head2 C<$Complete::Common::OPT_MAP_CASE> => bool (default: from COMPLETE_OPT_MAP_CASE or 1)

This is exactly like C<completion-map-case> in readline/bash to treat C<_> and
C<-> as the same when matching.

All L<Complete::Path>-based modules (like L<Complete::File>,
L<Complete::Module>, or L<Complete::Riap>) respect this setting.

=head2 C<$Complete::Common::OPT_EXP_IM_PATH> => bool (default: from COMPLETE_OPT_EXP_IM_PATH or 1)

Whether to "expand intermediate paths". What is meant by this is something like
zsh: when you type something like C<cd /h/u/b/myscript> it can be completed to
C<cd /home/ujang/bin/myscript>.

All L<Complete::Path>-based modules (like L<Complete::File>,
L<Complete::Module>, or L<Complete::Riap>) respect this setting.

=head2 C<$Complete::Common::OPT_DIG_LEAF> => bool (default: from COMPLETE_OPT_DIG_LEAF or 1)

(Experimental) When enabled, this option mimics what's seen on GitHub. If a
directory entry only contains a single subentry, it will directly show the
subentry (and subsubentry and so on) to save a number of tab presses.

Suppose you have files like this:

 a
 b/c/d/e
 c

If you complete for C<b> you will directly get C<b/c/d/e> (the leaf).

This is currently experimental because if you want to complete only directories,
you won't get b or b/c or b/c/d. Need to think how to solve this.


=head1 ENVIRONMENT

=head2 COMPLETE_OPT_CI => bool

Set default for C<$Complete::Common::OPT_CI>.

=head2 COMPLETE_OPT_FUZZY => int

Set default for C<$Complete::Common::OPT_FUZZY>.

=head2 COMPLETE_OPT_WORD_MODE => bool

Set default for C<$Complete::Common::OPT_WORD_MODE>.

=head2 COMPLETE_OPT_MAP_CASE => bool

Set default for C<$Complete::Common::OPT_MAP_CASE>.

=head2 COMPLETE_OPT_EXP_IM_PATH => bool

Set default for C<$Complete::Common::OPT_EXP_IM_PATH>.

=head2 COMPLETE_OPT_DIG_LEAF => bool

Set default for C<$Complete::Common::OPT_DIG_LEAF>.


=head1 SEE ALSO

L<Complete>

=cut
