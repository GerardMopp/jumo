# README

## Usage
* Upload the desired file to be processed. 
* File is save and queued for processing.
* on complation of processing the output is saved.

## Gems Used
* sidekiq: running background processes
* sinatra:  For the sidekiq web UI
* pusher: websockets as a service
* carrierwave: For file upload and saving 
* smarter_csv: parsing the csv file
* Boottrap for simple styling 

## Performance and Scaling Considerations
* Process file in background job, so we don't hang up the browser
* Websockets(using pusher) to notify user when file is done processing 

##Additional
* Production Link - http://jumo-gerard.herokuapp.com/
* One table to store the input and output files

###Views
* Root: uploading of files
* Show: links to download to input and output files
* List: View all past processed files

