package Sub::Spec::HTTP;

our $VERSION = '1.0.3'; # VERSION

1;
# ABSTRACT: Specification for sub and spec operations over HTTP


=pod

=head1 NAME

Sub::Spec::HTTP - Specification for sub and spec operations over HTTP

=head1 VERSION

version 1.0.3

=head1 DESCRIPTION

B<NOTICE>: The Sub::Spec and Sub::Spec::HTTP specifications are deprecated as of
Jan 2012. L<Rinci> and L<Riap> are the new specifications to replace them. Rinci
is about 95% compatible with Sub::Spec, but corrects a few issues and is more
generic.

This is a specification for calling remote subroutines, or doing other
sub-/spec-related operations over HTTP. The specification should be implemented
by servers and clients written in Perl or other languages.

=head1 SPECIFICATION VERSION

1.0

=head1 TERMINOLOGIES

=over 4

=item * SS request

An SS request (SS being a short for Sub::Spec) is a hash containing some keys
like: C<command>, C<uri>, C<args>, C<output_format>, C<log_level>, C<mark_log>.
See L</"SS REQUEST">

=item * SS server

An SS server is an HTTP server. It should parse SS request from HTTP request and
then execute the SS request and return the result as HTTP response.
L<Sub::Spec::HTTP::Server> is the de facto Perl server implementation.

=item * SS client

An SS client is a library or program which sends requests to an SS server over
HTTP. It should provide some transparency to its user, creating some level of
illusion that the user is accessing a local sub/spec. L<Sub::Spec::URI::http> is
the de facto Perl client implementation.

=back

=head1 SS REQUEST

An SS request is a hashref containing some predefined keys, listed below. SS
server SHOULD return an HTTP 400 error code if client sends an unknown key. Not
all keys are required for each request.

=over 4

=item * command => STR

If not specified, default is 'call'. The list of all currently known commands is
written below. A server should implement some or all of the listed commands. At
the very least it MUST implement 'about' and 'call'. It SHOULD return HTTP 502
status if a command is unknown. It can implement new commands if deemed
necessary.

'about' command, to request information about the server and the request itself.
For this command, no other request key is necessary. The server MUST return a
hashref like this:

 {
  version        => [1, 0], # Sub::Spec::HTTP specification version
  input_formats  => [qw/json phps yaml/], # supported input formats
  output_formats => [qw/json pretty nopretty
                        yaml phps html/], # supported output formats
  # other extra keys are allowed, like ...
  server_url     => 'http://localhost:5000/api/',
  commands       => [...], # commands known by this server
 }

'call' command, to call a subroutine and return its result. For this command,
request C<uri> must be specified and contains at least module and subroutine
name.

'list_commands' command, to list known commands. No other request key is
necessary.

'list_mods' command, to list known modules. No other request key is necessary.

'list_subs' command, to list known subroutines in a module. Request key C<uri>
must be specified and contains at least module name.

'usage' command, to show subroutine's usage (like list of arguments and
description for each). Request key C<uri> is required and must contain at least
module and subroutine name.

'spec' command, to request spec for a subroutine. Request key C<uri> is required
and must contain at least module and subroutine name.

=item * uri => STR

Specify module and/or sub and/or arguments. See L<Sub::Spec::URI> for more
details. If invalid URI is found, server MUST return 400.

=item * args => HASH (default {})

To specify arguments. Must be a hashref, or the server MUST return 400.

=item * output_format => STR

To specify response format. Known formats are 'yaml', 'json', 'phps', 'pretty',
'simple', 'html'. A server can support more formats, but at least it MUST
support 'json'.

Server can pick default format as it deems necessary/convenient.

=item * log_level => INT|STR (default 0)

Am integer number between 0 (lowest, none) and 6 (highest, trace) or string
(either "none" [0], "fatal" [1], "error" [2], "warn" [3], "info" [4], "debug"
[5], "trace" [6]). Relevant only for 'call' command. When specified, a server
should return log messages (e.g. produced by L<Log::Any>) to the client in the
HTTP response.

=item * mark_log => BOOL (default 0)

If set to true, prepend each log message with "L" (and response with "R") in
each response chunk. Only useful/relevant when turning on log_level > 0, so
clients can parse/separate log message from response.

=back

=head1 SS SERVER

An SS server listens to HTTP requests, parses them into SS requests, and
executes the SS requests for clients.

=head2 Parsing SS request from HTTP request

Server at least MUST parse SS request keys from HTTP C<X-SS-Req-*> request
headers, e.g. C<X-SS-Req-Command> header for setting the C<command> request key.
In addition, the server MUST parse C<X-SS-Req-*-j-> for JSON-encoded value, e.g.

 X-SS-Req-Args-j-: {arg1:"val1",arg2:[1,2,3]}

should set C<args> request key to C<{arg1 => "val1", arg2 => [1, 2, 3]}>.

The server MUST also accept request body for C<args>. The server MUST accept at
least body of type C<application/json>. It can accept additional types if it
wants, e.g. C<text/yaml> or C<application/vnd.php.serialized>.

The server can also accept SS request keys or sub arguments using other means,
for example, Sub::Spec::HTTP::Server allows setting C<module> and C<sub> from
URI path, and arguments (as well as other SS request keys, using C<-ss-req-*>
syntax) from request variables. For example:

 http://HOST/api/MOD::SUBMOD/FUNC?a1=1&a2:j=[1,2]&-ss-req-command=spec

will result in the following SS request:

 {
  command => 'spec',
  uri     => 'pm://MOD::SUBMOD/FUNC',
  args    => {a1=>1, a2=>[1, 2]},
 }

=head1 SS CLIENT

=head1 SEE ALSO

L<Sub::Spec>

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

