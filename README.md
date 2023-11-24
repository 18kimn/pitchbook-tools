# Scripts to help work through Pitchbook

In-progress collection of functions to help quickly parse Pitchbook --
which can be difficult to share, unsortable, and generally not easily manipulable.

Since I'm too lazy and unconfident in Pitchbook being scraped via a Puppeteer 
instance and the data on it requires auth, these functions assume you are clicking 
"Save As..." and then saving thewebpage you are interested in as an HTML file.
You also may have to adjust tables before this step and ensure the maximum amount 
of rows are visible. Some functions can accept multiple filenames and will bind 
them together, so that you can (e.g.) parse a 1,240-row table by saving it in 
250-row chunked HTML files.
