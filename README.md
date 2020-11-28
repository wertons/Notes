# Notes
 A barebones "*notebook*" web app built on JSP, JS and CSS for interfaces, JAVA for managing backend and SQLITE as server.
 
 This project was built using the  Eclipse IDE and its tools, and meant as a **learning project** it is** by no means **a functional or client-ready app, but by all means do feel free to check out and use the code.

## User manual
This is the main screen of the app, it will load up when no user is loaded in the cache, the functionalities are pretty self explanatory, but **be careful there are no confirmations**,  so **if you click on Delete DB it will delete it no questions asked**.
After registering a user or using one of the default ones
![Main screen](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/login_screen.bmp "The first screen you will se")

### SQLITE and the database
This apps storage is done with [SQLITE](https://www.sqlite.org/index.html "SQLITE") which is a language very similar to SQL albeit with some minor differences, the app has built-in functions that **create a basic database and delete it**, if you wish to use this web app it is highly recommended that these functionalities are either removed or constraints are added to them so that only certain users can use them.
