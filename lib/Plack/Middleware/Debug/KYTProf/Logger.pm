package Plack::Middleware::Debug::KYTProf::Logger;
use strict;
use warnings;

use Class::Accessor::Lite (
    ro  => [qw(logs)],
);

sub new {
    return bless { logs => [] }, $_[0];
}

sub log {
    my ($self, %args) = @_;
    push @{ $self->{logs} }, $args{message};
}

1;
