@ECHO OFF
ECHO Jekyll is building the site...
bundle exec jekyll build
IF %ERRORLEVEL% NEQ 0 (
    ECHO Build failed! Exiting...
    PAUSE
    EXIT /B %ERRORLEVEL%
)
ECHO Build completed successfully!
PAUSE
