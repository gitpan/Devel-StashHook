#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Devel::StashHook' );
}

diag( "Testing Devel::StashHook $Devel::StashHook::VERSION, Perl $], $^X" );
