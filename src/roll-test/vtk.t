#!/usr/bin/perl -w
# vtk roll installation test.  Usage:
# vtk.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my $isInstalled = -d "/opt/vtk";
my $output;

# vtk-install.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
    ok($isInstalled, "vtk installed");
  } else {
   ok(! $isInstalled, "vtk not installed");
  }

SKIP: {

  skip 'vtk not installed', 4 if ! $isInstalled;
  $output = `module load vtk;vtk -help 2>&1`;
  ok($output =~ /-geometry: Initial geometry for window/, 'vtk works');

  my $noVersion = "vtk";
  `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
  ok($? == 0, "vtk module installed");
  `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
  ok($? == 0, "vtk version module installed");
  ok(-l "/opt/modulefiles/applications/$noVersion/.version",
     "vtk version module link created");

}
