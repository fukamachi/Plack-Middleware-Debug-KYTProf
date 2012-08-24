#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Plack::Middleware::Debug::KYTProf' ) || print "Bail out!\n";
}

diag( "Testing Plack::Middleware::Debug::KYTProf $Plack::Middleware::Debug::KYTProf::VERSION, Perl $], $^X" );
