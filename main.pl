#!/usr/bin/perl

use strict;
use warnings;
use 5.01;
use DBI;


my $CREATE_TABLE = 0;
my $EXERCISE_TABLE_NAME = "EXERCISE";
my $DB_NAME = "test.db";

# Initialization .
my $dbh = open_db("SQLite", $DB_NAME);
if (defined $dbh){
  say "Database opened.";
}
else {
  die "Database open failed.";
}

if ($CREATE_TABLE == 1){
  my $outcome = &create_table($dbh, $EXERCISE_TABLE_NAME);
  if (defined $outcome){
    say "Table created.";
  }
  else {
    die "Table creation failed.";
  }
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
    my $res = add_exercise($dbh, @tokens);
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

$dbh->disconnect();
say "Bye!";


sub open_db {
  my ($driver, $database) = @_;
  my $dns = "DBI:$driver:dbname=$database";
  my $dbh = DBI->connect($dns, "", "", { RaiseError => 1 }) or die $DBI::errstr;
  return $dbh;
}

sub create_table {
  my ($dbh, $table_name) = @_;
  my $stmt = qq(create table $table_name(
      date int not null,
      exercise_name text not null,
      reps int not null,
      weight real
    ););
  my $rv = $dbh->do($stmt);
  if ($rv < 0){
    say $DBI::errstr;
    return undef;
  }
  return 0;
}

sub add_exercise {
  my $dbh = shift @_;
  my @args = @_;
  if (@args < 2 || @args > 3){
    return undef;
  }
  elsif (@args == 2){
    $args[2] = undef;
  }
  my $date = time();

  say "Adding exercise: @args";
  my $stmt = qq(
    INSERT INTO $EXERCISE_TABLE_NAME (DATE,EXERCISE_NAME,REPS,WEIGHT)
    VALUES ($date, $args[0], $args[1], $args[2]);
  );  # TODO: take care of the global variables.
  my $rv = $dbh->do($stmt) or die $DBI::errstr;
  if ($rv < 0){
    say $DBI::errstr;
    return undef;
  }
  return 0;
}

