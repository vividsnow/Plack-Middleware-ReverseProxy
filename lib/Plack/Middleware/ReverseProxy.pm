package Plack::Middleware::ReverseProxy;

use strict;
use warnings;
use 5.008_001;
use parent qw(Plack::Middleware);
our $VERSION = '0.16';

sub call {
    my ($self, $env) = @_;
    $env->{'psgi.url_scheme'} = 'https' if $env->{HTTP_X_FORWARDED_PROTO} && $env->{HTTP_X_FORWARDED_PROTO} eq 'https';
    $env->{REMOTE_ADDR} = ($env->{HTTP_X_FORWARDED_FOR} =~ /([^,\s]+)$/)[0] if $env->{HTTP_X_FORWARDED_FOR};
    $self->app->($env);
}

1;

__END__

=head1 NAME

Plack::Middleware::ReverseProxy - Supports app to run as a reverse proxy backend

=head1 SYNOPSIS

  builder {
      enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } 
          "Plack::Middleware::ReverseProxy";
      $app;
  };

=head1 DESCRIPTION

Plack::Middleware::ReverseProxy resets some HTTP headers, which changed by
reverse-proxy. You can specify the reverse proxy address and stop fake requests
using 'enable_if' directive in your app.psgi.

=head1 LICENSE

This software is licensed under the same terms as Perl itself.

=head1 COPYRIGHT

Copyright 2009-2019 Tatsuhiko Miyagawa

=head1 AUTHOR

This module is originally written by Kazuhiro Osawa as L<HTTP::Engine::Middleware::ReverseProxy> for L<HTTP::Engine>.

Nobuo Danjou

Masahiro Nagano

Tatsuhiko Miyagawa

=head1 SEE ALSO

L<HTTP::Engine::Middleware::ReverseProxy> 

L<Plack>

L<Plack::Middleware>

L<Plack::Middleware::Conditional>

=cut
