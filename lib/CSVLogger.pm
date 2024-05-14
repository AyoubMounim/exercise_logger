
package CSVLogger;

use feature "say";


sub new {
  my ($class) = @_;
  my $self = {
    fh => undef
  };
  bless $self, $class;
  return $self;
}

sub open_file {
  my ($self, $file_path) = @_;
  if (defined $self->{fh}){
    say "Another file session currently open.";
    return undef;
  }
  open($self->{fh}, '>>', $file_path);
  if (defined $self->{fh}){
    return 0;
  }
  say "File open failed.";
  return undef;
}

sub add_exercise {
  my $self = shift @_;
  if (!defined $self->{fh}){
    return undef;
  }
  my @args = @_;
  if (@args < 2 || @args > 3){
    return undef;
  }
  elsif (@args == 2){
    $args[2] = "NULL";
  }
  my $date = time();

  say "Adding exercise: @args";
  my $data = "$date,$args[0],$args[1],$args[2]\n";
  my $fh = $self->{fh};
  print $fh $data;
  return 0;
}

sub close_file {
  my $self = shift;
  if (defined $self->{fh}){
    close($self->{fh});
  }
  return;
}

sub DESTROY {
  my $self = shift;
  $self->close_file();
  return;
}

1;

