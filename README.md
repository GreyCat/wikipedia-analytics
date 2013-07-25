This is a Wikipedia bot that updates web analytics statistics according to web analytics templates.

## Usage instructions

1. Install prerequisites:
    * Ruby
    * MediaWiki::Gateway gem (i.e. `gem install mediawiki-gateway`)
    * web_analytics_discovery gem (i.e. `gem install web_analytics_discovery`)
2. Write a config file:

        BOT_LOGIN = 'WebAnalyticsBot'
        BOT_PASSWORD = 'super secret password here'

3. Collect a list of pages to process:

        ./01-get-lists-of-pages

4. Do the changes:

        ./02-process-pages

    By default, it automatically runs in manual mode with additional safety checks (i.e. manual diffing and approval of each edit). Use `--auto` to run in full auto mode, without approving every edit.
