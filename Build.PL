
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Module::Build' => '0.3601'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Specification for sub and spec operations over HTTP',
  'dist_author' => [
    'Steven Haryanto <stevenharyanto@gmail.com>'
  ],
  'dist_name' => 'Sub-Spec-HTTP',
  'dist_version' => '1.0.2',
  'license' => 'perl',
  'module_name' => 'Sub::Spec::HTTP',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Sub::Spec' => '1.0.0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
