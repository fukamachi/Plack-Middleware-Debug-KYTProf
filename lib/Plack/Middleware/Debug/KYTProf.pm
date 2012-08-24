package Plack::Middleware::Debug::KYTProf;
use strict;
use warnings;
use parent qw(Plack::Middleware::Debug::Base);

use Plack::Util::Accessor qw(logger hfa template);
use Devel::KYTProf;
use HTML::FromANSI::Tiny;
use Text::MicroTemplate qw(encoded_string);
use Plack::Middleware::Debug::KYTProf::Logger;

our $VERSION = '0.01';

sub prepare_app {
    my ($self) = @_;

    my $logger = Plack::Middleware::Debug::KYTProf::Logger->new;
    $self->logger($logger);
    Devel::KYTProf->logger($logger);

    $self->hfa(
        HTML::FromANSI::Tiny->new(selector_prefix => '#plDebug td '),
    );

    my $line_template = $self->build_template(<<'EOTMPL');
<table>
    <tbody>
% my $i;
% if (defined $_[0]->{lines}) {
%   my @lines = ref $_[0]->{lines} eq 'ARRAY' ? @{$_[0]->{lines}} : split /\r?\n/, $_[0]->{lines};
%   for my $line (@lines) {
            <tr class="<%= ++$i % 2 ? 'plDebugEven' : 'plDebugOdd' %>">
                <td><%= encoded_string($line) %></td>
            </tr>
%   }
% }
    </tbody>
</table>
<%= encoded_string($_[0]->{style_tag}) %>
EOTMPL

    $self->template($line_template);
}

sub run {
    my ($self, $env, $panel) = @_;

    return sub {
        my ($res) = @_;

        my $logs = $self->logger->logs;
        $panel->nav_subtitle(scalar @$logs . ' Rows');
        $panel->content(
            $self->render(
                $self->template, {
                    lines => [ map { join '', $self->hfa->html($_) } @$logs ],
                    style_tag => scalar $self->hfa->style_tag,
                }
            )
        );
    };
}

1;

__END__

=head1 NAME

Plack::Middleware::Debug::KYTProf - debug panel for Devel::KYTProf

=head1 SYNOPSIS

 enable 'Debug::KYTProf';

=head1 AUTHOR

Eitarow Fukamachi, C<< <e.arrows at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Eitarow Fukamachi.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 SEE ALSO

L<Plack::Middleware::Debug>, L<Devel::KYTProf>

=cut

