# Notes
 A barebones "*notebook*" web app built on JSP, JS and CSS for interfaces, JAVA for managing backend and SQLITE as server.
 
 This project was built using the  Eclipse IDE and its tools, and meant as a **learning project** it is** by no means **a functional or client-ready app, but by all means do feel free to check out and use the code.

## User manual
This is the main screen of the app, it will load up when no user is loaded in the cache, the functionalities are pretty self explanatory, but **be careful there are no confirmations**,  so **if you click on Delete DB it will delete it no questions asked**.
After registering a user or using one of the [default ones](https://github.com/wertons/Notes/blob/main/github/resources/preloaded_database.md "default ones") you can log in with the users credentials.
![Main screen](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/login_screen.bmp "The first screen you will se")

**Once logged in** the page is set to store the login for a day, after which you will have to login again. Once you log in succesfully you will see the following page:
![Main menu screenshot](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/main_menu.bmp "Main menu screenshot")
This is the main page of the app, it contains the menu with which you can access the apps main functionalities. The core of these functionalities, and the app itself, are the notes, in order to create a note we will access the following interface:
![Note creation interface](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/create_note.bmp "Note creation interface")
 The note interface needs a title, between 2 and 30 characters long to be filled in the top box, and the content, in the second box. When done you can submit the note with the "**Create Note**" button, you may also cancel at any time.

Accessing "My notes" or "Shared notes" will open a notes browser of either notes you have created or notes that have been shared with you respectively as seen here:
![Note browser screenshot](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/your_notes.bmp "Note browser screenshot")
You can filter notes in the browser with the box at the top and view/edit/delete them with the buttons at the side of each note.

The note editor has the same functionalities as the note creator as well as letting you share the notes with other users at the bottom:
![Note editor screenshot](https://raw.githubusercontent.com/wertons/Notes/main/github/resources/edit_note.bmp "Note editor screenshot")
To share the note simply add a name into the box and click the "+" at the side
### SQLITE and the database
This apps storage is done with [SQLITE](https://www.sqlite.org/index.html "SQLITE") which is a language very similar to SQL albeit with some minor differences, the app has built-in functions that **create a basic database and delete it**, if you wish to use this web app it is highly recommended that these functionalities are either removed or constraints are added to them so that only certain users can use them.

The database consists of 3 tables:
- **User**:  
	-**Name**: text, primary key
	-**Passhash**: text, not null
- **Note**:
	-**ID**:integer, auto increment, primary key
	-**Title**: text, not null
	-**Content**: text, not null
	-**Owner**: text, foreign key (User:name)
- **Users_Access_Notes**:
	-**Name**:text, foreign key (User:name)
	-**ID**: integer, foreign key (Note:ID)

[A relational model of the db](https://github.com/wertons/Notes/blob/main/github/resources/database_model.png "model")

### Back end
This web app uses **Java** to manage server-side operations. The code is separated with the following logic:
- **Servlet**: Which manages the interactions between the jsp page and the rest of the back end.
- **Model**: Which stores the custom classes we created for the app.
- **DAO**: Which manages interactions with the SQLITE database.
- **Controller**: Which serves as the central operation point which carries out the logic and functions.
The Java files manage the main functionalities of the app

