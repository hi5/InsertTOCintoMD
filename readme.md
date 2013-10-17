# InsertTOCintoMD() - v0.1

AutoHotkey script to add a Table of Contents to a Markdown document.

**Introduction**

GitHub automatically inserts anchors into your Markdown files when browsing a 
GH repository. This AutoHotkey script inserts a table of contents into your
Markdown file - a table of contents can be updated by simply calling the script
again.

Place a marker in the document where you would like the table of contents to appear.
Then, a nested list of all the headers in the document will replace the marker. The 
marker defaults to <!-- [toc] --> [...] <!-- [/toc] --> so the following document:

   ```markdown
   <!-- [toc] -->
   ...
   <!-- [/toc] -->

   # Header 1

   ## Header 2
   ```

would generate the following output:

   ```markdown
   <!-- [toc] -->
   1. [Header 1](#header1)
      * [Header 2](#header2)
   <!-- [/toc] -->

   # Header 1

   ## Header 2
   ```

Further documentation in the script https://github.com/hi5/InsertTOCintoMD/
