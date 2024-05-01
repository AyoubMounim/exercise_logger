#!/usr/bin/perl -I ./lib/

use strict;
use warnings;
use 5.01;

use SqlLogger;
use CSVLogger;


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

# Main loop.
my $running = 1;
while ($running){
  print "Enter command: ";
  my $input = <STDIN>;
  chomp($input);
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
  if ($type eq "SQL"){
    my $CREATE_TABLE = 0;
    my $DB_NAME = "test.db";
    my $logger = SqlLogger->new("SQLite");
    my $res = $logger->open_db($DB_NAME);
    if (defined $res){
      say "Database opened.";
    }
    else {
      die "Database open failed.";
    }
    if ($CREATE_TABLE == 1){
      my $outcome = $logger->create_exercise_table();
      if (defined $outcome){
        say "Table created.";
      }
      else {
        die "Table creation failed.";
      }
    }
    return $logger;
  }
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

