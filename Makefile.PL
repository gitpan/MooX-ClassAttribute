use strict;
use ExtUtils::MakeMaker 6.17;

my $EUMM = 'ExtUtils::MakeMaker'->VERSION;

my $meta = {
  "abstract"           => "declare class attributes Moose-style... but without Moose",
  "author"             => ["Toby Inkster (TOBYINK) <tobyink\@cpan.org>"],
  "dynamic_config"     => 0,
  "generated_by"       => "Dist::Inkt::Profile::TOBYINK version 0.007, CPAN::Meta::Converter version 2.120921",
  "keywords"           => [],
  "license"            => ["perl_5"],
  "meta-spec"          => {
                            url => "http://search.cpan.org/perldoc?CPAN::Meta::Spec",
                            version => 2,
                          },
  "name"               => "MooX-ClassAttribute",
  "no_index"           => { directory => ["eg", "examples", "inc", "t", "xt"] },
  "prereqs"            => {
                            configure => { requires => { "ExtUtils::MakeMaker" => 6.17 } },
                            develop   => {
                                           recommends => { "Dist::Inkt" => 0 },
                                           requires   => { "Moose" => 0, "MooseX::ClassAttribute" => 0, "Sub::Exporter" => 0 },
                                         },
                            runtime   => {
                                           recommends => { "MooseX::ClassAttribute" => 0 },
                                           requires   => {
                                                           "Moo" => "1.000000",
                                                           "Role::Tiny" => "1.000000",
                                                           "Sub::Exporter::Progressive" => 0,
                                                         },
                                         },
                          },
  "provides"           => {
                            "Method::Generate::ClassAccessor"         => { file => "lib/Method/Generate/ClassAccessor.pm", version => 0.009 },
                            "MooX::CaptainHook"                       => { file => "lib/MooX/CaptainHook.pm", version => 0.009 },
                            "MooX::CaptainHook::HandleMoose::Hack"    => { file => "lib/MooX/CaptainHook.pm", version => 0.009 },
                            "MooX::CaptainHook::OnApplication"        => { file => "lib/MooX/CaptainHook.pm", version => 0.009 },
                            "MooX::CaptainHook::OnApplication::Moose" => { file => "lib/MooX/CaptainHook.pm", version => 0.009 },
                            "MooX::CaptainHook::OnInflation"          => { file => "lib/MooX/CaptainHook.pm", version => 0.009 },
                            "MooX::ClassAttribute"                    => { file => "lib/MooX/ClassAttribute.pm", version => 0.009 },
                            "MooX::ClassAttribute::HandleMoose"       => { file => "lib/MooX/ClassAttribute/HandleMoose.pm", version => 0.009 },
                          },
  "release_status"     => "stable",
  "resources"          => {
                            bugtracker   => {
                                              web => "http://rt.cpan.org/Dist/Display.html?Queue=MooX-ClassAttribute",
                                            },
                            homepage     => "https://metacpan.org/release/MooX-ClassAttribute",
                            license      => ["http://dev.perl.org/licenses/"],
                            repository   => {
                                              type => "git",
                                              web  => "https://github.com/tobyink/p5-moox-classattribute",
                                            },
                            X_identifier => "http://purl.org/NET/cpan-uri/dist/MooX-ClassAttribute/project",
                          },
  "version"            => 0.009,
  "x_contributors"     => ["Dinis Rebolo (DREBOLO) <drebolo\@cpan.org>"],
  "x_provides_scripts" => {},
};

my %dynamic_config;

my %WriteMakefileArgs = (
	ABSTRACT           => $meta->{abstract},
	AUTHOR             => ($EUMM >= 6.5702 ? $meta->{author} : $meta->{author}[0]),
	DISTNAME           => $meta->{name},
	VERSION            => $meta->{version},
	EXE_FILES          => [ map $_->{file}, values %{ $meta->{x_provides_scripts} || {} } ],
	NAME               => do { my $n = $meta->{name}; $n =~ s/-/::/g; $n },
	%dynamic_config,
);

$WriteMakefileArgs{LICENSE} => $meta->{license}[0] if $EUMM >= 6.3001;

sub deps
{
	my %r;
	for my $stage (@_)
	{
		for my $dep (keys %{$meta->{prereqs}{$stage}{requires}})
		{
			my $ver = $meta->{prereqs}{$stage}{requires}{$dep};
			$r{$dep} = $ver if !exists($r{$dep}) || $ver >= $r{$dep};
		}
	}
	\%r;
}

my ($build_requires, $configure_requires, $runtime_requires, $test_requires);
if ($EUMM >= 6.6303)
{
	$WriteMakefileArgs{BUILD_REQUIRES}     ||= deps('build');
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{TEST_REQUIRES}      ||= deps('test');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime');
}
elsif ($EUMM >= 6.5503)
{
	$WriteMakefileArgs{BUILD_REQUIRES}     ||= deps('build', 'test');
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime');	
}
elsif ($EUMM >= 6.52)
{
	$WriteMakefileArgs{CONFIGURE_REQUIRES} ||= deps('configure');
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('runtime', 'build', 'test');	
}
else
{
	$WriteMakefileArgs{PREREQ_PM}          ||= deps('configure', 'build', 'test', 'runtime');	
}

{
	my $minperl = delete $WriteMakefileArgs{PREREQ_PM}{perl};
	exists($WriteMakefileArgs{$_}) && delete($WriteMakefileArgs{$_}{perl})
		for qw(BUILD_REQUIRES TEST_REQUIRES CONFIGURE_REQUIRES);
	if ($minperl and $EUMM >= 6.48)
	{
		$WriteMakefileArgs{MIN_PERL_VERSION} ||= $minperl;
	}
	elsif ($minperl)
	{
		die "Need Perl >= $minperl" unless $] >= $minperl;
	}
}

sub FixMakefile
{
	return unless -d 'inc';
	my $file = shift;
	
	local *MAKEFILE;
	open MAKEFILE, "< $file" or die "FixMakefile: Couldn't open $file: $!; bailing out";
	my $makefile = do { local $/; <MAKEFILE> };
	close MAKEFILE or die $!;
	
	$makefile =~ s/\b(test_harness\(\$\(TEST_VERBOSE\), )/$1'inc', /;
	$makefile =~ s/( -I\$\(INST_ARCHLIB\))/ -Iinc$1/g;
	$makefile =~ s/( "-I\$\(INST_LIB\)")/ "-Iinc"$1/g;
	$makefile =~ s/^(FULLPERL = .*)/$1 "-Iinc"/m;
	$makefile =~ s/^(PERL = .*)/$1 "-Iinc"/m;
	
	open  MAKEFILE, "> $file" or die "FixMakefile: Couldn't open $file: $!; bailing out";
	print MAKEFILE $makefile or die $!;
	close MAKEFILE or die $!;
}

my $mm = WriteMakefile(%WriteMakefileArgs);
FixMakefile($mm->{FIRST_MAKEFILE} || 'Makefile');
exit(0);

