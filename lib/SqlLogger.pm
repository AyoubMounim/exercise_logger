
package SqlLogger;

use DBI;
use feature "say";


my $EXERCISE_TABLE_NAME = "EXERCISE";


sub new {
  my ($class, $driver) = @_;
  my $self = {
    driver => $driver,
    dbh => undef
  };
  bless $self, $class;
  return $self;
}

sub open_db {
  my ($self, $db_name) = @_;
  if (defined $self->{dbh}){
    say "Another database session currently open.";
    return undef;
  }
  my $dns = "DBI:$self->{driver}:dbname=$db_name";
  $self->{dbh} = DBI->connect($dns, "", "", { RaiseError => 1 });
  if (defined $self->{dbh}){
    return 0;
  }
  say DBI::errstr;
  return undef;
}

sub create_exercise_table {
  my $self = shift;
  if (!defined $self->{dbh}){
    return undef;
  }
  my $stmt = qq(create table $EXERCISE_TABLE_NAME(
      date int not null,
      exercise_name text not null,
      reps int not null,
      weight real
    ););
  my $rv = ($self->{dbh})->do($stmt);
  if ($rv < 0){
    say $DBI::errstr;
    return undef;
  }
  return 0;
}

sub add_exercise {
  my $self = shift @_;
  if (!defined $self->{dbh}){
    return undef;
  }
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
  my $rv = ($self->{dbh})->do($stmt); 
  if ($rv < 0){
    say $DBI::errstr;
    return undef;
  }
  return 0;
}

sub close_db {
  my $self = shift;
  if (defined $self->{dbh}){
    ($self->{dbh})->disconnect();
  }
  return;
}

sub DESTROY {
  my $self = shift;
  $self->close_db();
  return;
}

1;

