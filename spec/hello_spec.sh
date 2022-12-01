Describe 'hello'
  It 'says hello'
    When run source ./atlas pull
    The output should equal 'Hello ShellSpec!'
  End
End
