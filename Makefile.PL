use inc::Module::Install;

name     'Devel-StashHook';
all_from 'lib/Devel/StashHook.pm';
author   'Scott McWhirter <konobi@cpan.org>';

build_requires 'Test::More';
requires 'Variable::Magic';

auto_install;

WriteAll;

