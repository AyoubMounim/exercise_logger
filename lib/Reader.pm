
package Reader;

use strict;


sub new {
  my ($class) = @_;
  my $self = {};
  bless($self, $class);
  return $self;
}

sub readline {
  my ($self, $prompt) = @_;
  print "$prompt";
  chomp(my $input = <STDIN>);
  return $input;
}

1;

