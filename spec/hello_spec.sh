Describe 'hello'
  It 'says hello'
    When run ./atlas pull
    Dump
    The output should equal 'Hello ShellSpec!'
  End
End
