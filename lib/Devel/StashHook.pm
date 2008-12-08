package Devel::StashHook;

use warnings;
use strict;
use Variable::Magic qw(wizard cast);

our $VERSION = '0.01_001';
my $packages;

sub import {
    my ($class, $info) = @_;
 
    for my $package (keys %$info){
        $packages->{$package} = $info->{$package};

        my $wizard = wizard(
            'store' => sub { 
                my ($stash,undef,$name) = @_;
                if(exists $stash->{$name}){
                    $packages->{$package}->({ name => $name, action => 'modify' });
                } else {
                    $packages->{$package}->({ name => $name, action => 'add' });
                }
            },
            'delete' => sub {
                my ($stash,undef,$name) = @_;
                $packages->{$package}->({ name => $name, action => 'remove' });
            },
        );

        {
            no strict 'refs';
            cast(%{"${package}::"}, $wizard);
        }
    }
}

1;
__END__

=head1 NAME

Devel::StashHook - Callbacks for changes to a packages symbol table 

=head1 SYNOPSIS

    use Devel::StashHook {
	'Package1' => sub { ... },
	'MyApp::Controller::Root' => \&hook,
    };

    sub hook {
	use Data::Dumper;
	warn Dumper([@_]);
    }

=head1 DESCRIPTION

This module provides the ability to have callbacks on addition, modification
and removal of symbols from a package.

NB: this module depends on uvar magic that was introduced in Perl 5.10

=head1 VERSION

Version 0.01_001

=head1 METHODS

=head2 import

Expects a hashref of package names as keys and code refs as variables

=head1 AUTHOR

Scott McWhirter, C<< <konobi at cpan.org> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Devel::StashHook

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Devel-StashHook>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Devel-StashHook>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Devel-StashHook>

=item * Search CPAN

L<http://search.cpan.org/dist/Devel-StashHook>

=back

Commercial support is available for this module from Cloudtone Studios:

L<http://www.cloudtone.ca/>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Scott McWhirter, all rights reserved.

This program is released under the following license: BSD

=cut
