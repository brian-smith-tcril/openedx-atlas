Describe 'hello.sh'
  setup() { 
    mkdir bin;
    cp ../build/atlas ./bin;
    cp ../build/atlas.yml ./bin;
  }
  cleanup() { rm -rf ./bin; }
  # setup() { echo setup; }
  # cleanup() { echo cleanup; }
  BeforeAll 'setup'
  AfterAll 'cleanup'
  Include lib/hello.sh
  It 'says hello'
    When call hello ShellSpec
    The output should equal 'Hello ShellSpec!'
  End
End
