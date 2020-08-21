plan provision_ronin::test (
  TargetSpec $targets,
  String     $local_repo_dir = '/tmp/bolt_test',
  String     $code_environment = 'dev',
) {

  notice("Testing ${targets}")
  # Install puppet on the target and gather facts
  $targets.apply_prep

  # Compile the manifest block into a catalog
  $results = apply($targets) {
    file {'/etc/testing.txt':
        content => 'testing',
    }
  }

  $results.each |$result| {
    notice($result.report)
  }
}
