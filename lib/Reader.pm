
package Reader;

use strict;


sub new {
  my ($class) = @_;
  my $self = {};
  bless($self, $class);
  return $self;
}

sub readline {
  my ($self, $prompt, $history) = @_;
  print "$prompt";
  my ($char, $line) = ("", "");
  do {
    read(STDIN, $char, 1);
    if (detect_up_arrow($char)){
      if (defined $history){
        $line = $history->[-1];
        return $line if defined $line;
      }
    }
    $line .= $char;
  } while ($char ne "\n");
  chomp($line);
  return $line;
}

sub detect_up_arrow {
  my ($first_char) = @_;
  return 0 if ($first_char ne "\033");
  my $sequence;
  read(STDIN, $sequence, 2);
  return 1 if ($sequence eq "[A");
  return 0;
}

1;

