use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '5.10.0', 
  Carp => 0,
  'Catmandu' => '0.5004',
  'MODS::Record' => '0.06',
  'Moo' => 0
};
my $recommends = {
  'Term::ReadKey' => 0
};
my $build = Module::Build->new(
  module_name => 'Catmandu::Importer::MODS',
  dist_author => [
    'Nicolas Franck <nicolas.franck@ugent.be>'
  ],
  dist_abstract => 'Catmandu importer for mods records in xml or json',
  requires => $requires,
  recommends => $recommends,
  build_requires => {
    'Software::License' => 0,
    'Test::Exception' => 0,
    'Test::More' => 0,
  },
  create_license => 1,
  license => 'perl',
  dist_version_from => 'lib/Catmandu/Importer/MODS.pm',
  create_makefile_pl => 'traditional'  
);
$build->create_build_script;
