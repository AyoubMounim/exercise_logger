#!/usr/bin/perl -I ./lib/

use strict;
use warnings;
use 5.01;

use CSVLogger;
use Reader;


# Args parse.
if ($#ARGV + 1 == 0){
  say "Give logger type and file.";
  die;
}
elsif ($#ARGV + 1 != 2){
  die "Wrong number of arguments.";
}

my ($logger_type, $file_name) = @ARGV;


# Initialization.
my $logger = create_logger($logger_type, $file_name);
if (!defined $logger){
  die "Logger creation failed.";
}
my $reader = Reader->new();

# Main loop.
my @history = ();
my $running = 1;
while ($running){
  my $input = $reader->readline("Enter command: ", \@history);
  push(@history, $input); 
  my @tokens = split(' ', $input);
  my $cmd = shift @tokens;
  if ($cmd eq "exit"){
    $running = 0;
  }
  elsif ($cmd eq "add_exercise"){
    my $res = $logger->add_exercise(@tokens);
    if (defined $res){
      say "Executed.";
    }
    else {
      say "Not Executed."
    }
  }
  else {
    say "\"$cmd\" not known.";
  }
}

say "Bye!";


sub create_logger {
  my $type = shift;
  my @args = @_;
  if ($type eq "CSV"){
    my $logger = CSVLogger->new();
    my $res = $logger->open_file($args[0]);
    if (defined $res){
      say "File opened.";
    }
    else {
      die "File open failed.";
    }
    return $logger;
  }
  say "Logger type \"$type\" unknown.";
  return undef;
}

