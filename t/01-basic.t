#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;

our @ADDED;

BEGIN {
    use Devel::StashHook { 
        'DSH::TestPackage' => sub {
            return if $_[0]->{name} eq 'BEGIN';
            push @ADDED, @_;
        },
    };
}

basic_on_begin: {
    is_deeply [@ADDED], [
        { name => 'CONSTANT_WITH_NAME', action => 'add' },
        { name => 'sub_with_name', action => 'add' },
    ], q{Basic elements};
}

string_eval_constant: {
    local @ADDED;
    eval "package DSH::TestPackage; use constant FOO => 1;";
    is_deeply [@ADDED], [{ name => 'FOO', action => 'add' }], q{Constant added from eval};
}

sub_added_via_glob: {
    local @ADDED;
    no strict 'refs';
    *{"DSH::TestPackage::sub_glob_name"} = sub { 'hehe' };
    is_deeply [@ADDED], [{ name => 'sub_glob_name', action => 'add' }], q{Sub added via glob};
}

sub_removed_via_glob: {
    local @ADDED;
    no strict 'refs';
    delete ${"DSH::TestPackage::"}{sub_glob_name};
    is_deeply [@ADDED], [{ name => 'sub_glob_name', action => 'remove' }], q{Sub removed via glob};
}

modify_sub_via_glob: {
    local @ADDED;
    no strict 'refs';
    no warnings 'redefine';
    *{"DSH::TestPackage::sub_with_name"} = sub { 'changed' };
    is_deeply [@ADDED], [{ name => 'sub_with_name', action => 'modify' }], q{Sub modified via glob};
}

package # hide from pause
    DSH::TestPackage;

use constant CONSTANT_WITH_NAME => 1;
sub sub_with_name { 'howdy' };

1;
