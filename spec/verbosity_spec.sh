Describe 'Test full silent flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      echo "output from pull_translations"
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'pulls translations with no output'
    When run source ./atlas pull --silent
    The lines of output should equal 4
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: Not Specified'
    The line 3 of output should equal ' - repository: openedx/openedx-translations'
    The line 4 of output should equal ' - branch: main'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test short silent flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'pulls translations with no output'
    When run source ./atlas pull -s
    The lines of output should equal 4
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: Not Specified'
    The line 3 of output should equal ' - repository: openedx/openedx-translations'
    The line 4 of output should equal ' - branch: main'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End
