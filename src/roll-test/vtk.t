#!/usr/bin/perl -w
# vtk roll installation test.  Usage:
# vtk.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend
my $compiler="ROLLCOMPILER";
my $mpi="ROLLMPI";

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my $output;

# vtk-install.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
    ok(-d "/opt/vtk", "vtk installed");
  } else {
   ok(! -d "/opt/vtk", "vtk not installed");
  }

# vtk
SKIP: {
  skip 'vtk not installed', 1 if ! -d '/opt/vtk';
  $output = `module load vtk;vtk -help 2>&1`;
  ok($output =~ /-geometry: Initial geometry for window/, 'vtk works');

}

SKIP: {
  skip 'vtk not installed', 1
    if $appliance !~ /$installedOnAppliancesPattern/;
    my $noVersion = "vtk";
    `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
    ok($? == 0, "vtk module installed");
    `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
    ok($? == 0, "vtk version module installed");
    ok(-l "/opt/modulefiles/applications/$noVersion/.version",
       "vtk version module link created");
}
