Describe 'Test silent flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    git() {
      if [ "$quiet" ];
      then
        GIT_CALLED_QUIETLY=true
      else
        GIT_CALLED_NOT_QUIETLY=true
      fi
      %preserve GIT_CALLED_QUIETLY
      %preserve GIT_CALLED_NOT_QUIETLY
    }

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }
  }

  It 'pulls translations with no output (full flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    When run source ./atlas pull --silent
    The lines of output should equal 0
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
  End

  It 'pulls translations with no output (short flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    When run source ./atlas pull -s
    The lines of output should equal 0
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
  End
End
