This is a Wikipedia bot that updates web analytics statistics according to web analytics templates.

## Usage instructions

1. Install prerequisites:

* Ruby
* MediaWiki::Gateway gem (i.e. `gem install mediawiki-gateway`)

2. Write a config file:

    BOT_LOGIN = 'WebAnalyticsBot'
    BOT_PASSWORD = 'super secret password here'

3. Collect a list of pages to process:

    ./01-get-lists-of-pages

4. Do the changes:

    ./02-process-pages --manual

Note the `--manual` switch that enables additional safety checks (i.e. manual diffing and approval of each edit).
