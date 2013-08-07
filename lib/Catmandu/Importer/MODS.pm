package Catmandu::Importer::MODS;
our $VERSION = "0.2";
use Catmandu::Sane;
use Catmandu::Util qw(:is :array :check);
use MODS::Record;
use Moo;

with 'Catmandu::Importer';

has type => (
  is => 'ro',
  isa => sub {
    my $t = $_[0];
    is_string($t) && array_includes([qw(xml json)],$t) || die("type must be 'xml' or 'json'");
  },
  default => sub { 'xml'; },
  lazy => 1
);

sub generator {
  my($self) = @_;
  sub {  
    state $i = 0;
    #result: MODS::Record::Mods or MODS::Record::ModsCollection
    state $mods = do {
      #MODS::Record->from_json expects binary input (decode_json is applied)
#      if($self->type eq "json"){
#        $self->fh->binmode(":raw");
#      }
      my $m = $self->type eq "xml" ? MODS::Record->from_xml($self->fh) : MODS::Record->from_json($self->fh);
      my $res = ref($m) eq "MODS::Element::Mods" ? [$m] : $m->mods;
      $res;
    };
    return $i < scalar(@$mods) ? $mods->[$i++] : undef;
  };
}

=head1 NAME

Catmandu::Importer::MODS - Catmandu Importer for importing mods records

=head1 SYNOPSIS

  use Catmandu::Importer::MODS;
  
  my $importer = Catmandu::Importer::MODS->new(file => "modsCollection.xml",type => "xml");  
  
  my $numModsElements = $importer->each(sub{
    #$modsElement is a MODS::Element::Mods object
    my $modsElement = shift;    
  });

=head1 DESCRIPTION

MODS can be expressed in either XML or JSON. XML is the more common way to express.
This module reads from a file, and iterates over the elements 'mods'. In case
of a simple mods document, only one element is found. In case of a 'modsCollection',
several mods elements can be found.

These files SHOULD be expressed in UTF-8.

=head1 METHODS

=head2 Catmandu::Importer::MODS->new(file => "mods.xml",type => "xml")

Creates a new importer. 'file' can anything that can be transformed into
an IO::Handle by Catmandu::Util::io. See http://search.cpan.org/~nics/Catmandu-0.5004/lib/Catmandu/Util.pm for more information.

'type' can only be 'json' or 'xml'.

=head2 each(sub{ .. })

The importer transforms the input 'file' into an array of L<MODS::Element::Mods>. 
This method iterates over that list, and supplies the callback with one
MODS::Element::Mods at a time.

=head1 SEE ALSO

=over 4

=item * L<MODS::Record>

=item * Library Of Congress MODS pages (http://www.loc.gov/standards/mods/)

=back

=head1 DESIGN NOTES

=over 4

=item * This module is part of the LibreCat/Catmandu project http://librecat.org

=item * Make sure your files are expressed in UTF-8.

=back

=head1 AUTHORS

=over 4

=item * Nicolas Franck <Nicolas . Franck at UGent . be>

=back

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself. See L<http://dev.perl.org/licenses/>.

=cut


1;
