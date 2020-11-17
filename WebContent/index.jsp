<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="notes.controller.*"
	isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Notes</title>
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<link rel="icon" href="/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="./CSS/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script src="https://kit.fontawesome.com/44e5b3a6fe.js"
	crossorigin="anonymous"></script>

<%
	Cookie cookie = null;
Cookie[] cookies = null;
cookies = request.getCookies();
if (cookies != null) {
	for (int i = 0; i < cookies.length; i++) {
		cookie = cookies[i];
		switch (cookie.getName()) {
	case "JSESSIONID" :
		session.setAttribute("sessionID", cookie.getValue());
		break;
	case "username" :
		session.setAttribute("username", cookie.getValue());
		break;
	case "password" :
		session.setAttribute("password", cookie.getValue());
		break;
		}

	}
}
%>
</head>
<body>
	<form id="startup">
		<input type="hidden" name="formType" value="startUp" />
	</form>
	<form id="logoutForm">
		<input type="hidden" name="formType" value="logout" />
	</form>
	<header id="headMenu">
		<h1 id="headTitle">The webapp is not loaded</h1>
	</header>
	<main id="content">
		<aside id="leftSide"></aside>
		<aside id="rightSide"></aside>
		<p id="displayName"></p>

	</main>

	<script>//listeners
	function login() {
	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        datatype: "json",
	        data: $("#login").serialize(),
	        success: function(data) {
	            if (data.isOkay) {
	            	window.location.reload()
	                loadPreset("main");

	            } else {}
	        }

	    });
	}

	function register() {
	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        datatype: "json",
	        data: $("#register").serialize(),
	        success: function(data) {
	            if (data.isOkay) {
	                $("#displayName").html("Your name is: " + data.name);
	                alert("you registered in " + data.name);
	            } else {
	                alert("there was an oopsie registering");
	            }
	        }
	    });
	    return false;
	}
	function createDB() {

	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        datatype: "json",
	        data: $("#createDB").serialize(),
	        success: function(data) {
	            if (data.isOkay) {
	                alert("createdDB");
	            } else {
	                alert("oopsie no db created");
	            }
	        }
	    });
	}

	function deleteDB() {
	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        datatype: "json",
	        data: $("#deleteDB").serialize(),
	        success: function(data) {
	            if (data.isOkay) {
	                alert("deleted db");
	            } else {
	                alert("oopsie no db deleted");
	            }
	        }
	    });
	}

	function logout() {
	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        datatype: "json",
	        data: $("#logoutForm").serialize(),
	        success: function(data) {

	        }
	    });
	    loadPreset("log");

	    return false;
	}

	//page load
	$(document).ready(function pageLoad() {
	    $.ajax({
	        url: "NotesServlet",
	        type: "POST",
	        data: $("#startup").serialize(),
	        success: function(data) {
	            if (data.isOkay) {

	                console.log("loading main preset");
	                loadPreset("main");
	            } else {
	                console.log("loading login preset");

	                loadPreset("log");
	            }
	        }
	    });
	});
	
	let selectedMenu = null;
	function selectMenu(menuOption){
		try{
		selectedMenu.classList.remove("selected");
		} catch(error){
			
		}
		selectedMenu = menuOption;
		selectedMenu.classList.add("selected");
	}
	
	function noteModel(){
		return `		
		<form id="createNoteForm" class="noteForm">
		<input type="hidden" name="formType" value="createNote" />
		<h2 id="noteHeader">
			New Note
		</h2>
		<div id="noteTitle">
			<input type="text" name="title" placeholder="Note title" maxlength="40">
		</div>
		<div id="noteBody">
			<textarea  name="content" placeholder="Note body"></textarea>
		</div>
		<input type="button" class="submit" value="Create Note" onclick="submitNote()">
	</form>
	`;
	}
	function createNote(){
		selectMenu(document.querySelector("#createNote"));
		document.querySelector("#rightSide").innerHTML = noteModel();
	}
	
	function submitNote(){
		 $.ajax({
		        url: "NotesServlet",
		        type: "POST",
		        data: $("#createNoteForm").serialize(),
		        success: function(data) {
		            if (data.isOkay) {
						alert("created note");
		            } else {

						alert("could not create note");
		            }
	                loadPreset("main");

		        }
		    });
	}
	
	function loadMyNotes(){
		selectMenu(document.querySelector("#loadNotes"));
		document.querySelector("#rightSide").innerHTML = `
		<h2>My notes</h2>
		<form id="loadOwnerNotes">
			<input type="hidden" name="formType" value="getOwnerNotes" />
		</form>
		<ul id="notesList">

		</ul>
		`;	
		 $.ajax({
		        url: "NotesServlet",
		        type: "POST",
		        data: $("#loadOwnerNotes").serialize(),
		        success: function(data) {
		            if (data.isOkay) {
		  				loadNotes(data.notes);      
		            } else {

						alert("error getting notes");
		            }
		        }
		    });

		
		
	}
	let myNotes = null;
	function loadNotes(notes){
    	let insert = "";
    	myNotes = notes;

    	notes.forEach(function(note){
    	let title = note.title;
    	insert+=  '<li><p class="noteName">'+title+'</p><a class="noteOpen">Open</a></li>';
    	});
    	
    	document.getElementById("notesList").innerHTML = insert;
	}
	function loadAccessNotes(){
		selectMenu(document.querySelector("#loadAcNotes"));
	}
	
	function loadPreset(preset) {
	    switch (preset) {
	        case 'log':
	            document.querySelector("#headTitle").innerHTML = "Log In / Register";
	            document.querySelector("#leftSide").innerHTML = `
					<h2 class="formTitle">Login</h2>
						<form id="login">
							<label for="name">
								Username:
							</label> 
							<input type="text" id="nameLog" name="name" placeholder="JohnDoe">
							<br> 
							<label for="password">
								Password:
							</label> 
							<input id="passwordLog" type="password" name="password" placeholder="Very secret">
							<br> 
							<input type="hidden"name="formType" value="login" /> 
							<br> 
							<input type="button" value="Log In" class="submit" onclick="login()" />
						</form>
						
						<!-- Development mode only -->
						<form id="createDB">
										<input type="hidden"name="formType" value="createDB" /> 
						
							<input type="button" value="Create DB" class="submit" onclick="createDB()"/>
						</form>
						<form id="deleteDB">
										<input type="hidden"name="formType" value="deleteDB" /> 
						
							<input type="button" value="Delete DB" class="submit" onclick="deleteDB()" />
						</form>
							`;

	            document.querySelector("#rightSide").innerHTML = `		
						<h2 class="formTitle">Register</h2>
							<form id="register">
							<label for="name">
								Username:
							</label> 
							<input type="text" id="nameReg" name="name" placeholder="JohnDoe">
							<br> 
							<label for="password">
								Password:
							</label> 
							<input id="password" type="password" name="password" placeholder="Very secret">
							<br> 
							<label for="passwordCheck">Password check:</label> 
							<input type="password" id="passwordCheck" name="passwordCheck" placeholder="Very secret check"> 
							<input type="hidden"name="formType" value="register" /> 
							<br> 
							<input type="button" value="Register" class="submit" onclick="register()") />
						</form> 
						`;
	            break;
	        case 'main':
	            const user = "<%=session.getAttribute("username")%>";
	            document.querySelector("#headTitle").innerHTML = "Welcome back " + user;
	            document.querySelector("#leftSide").innerHTML = `		

					<ul id="menu">
	            	<li id="createNote" onclick="createNote()"><a >New Note <i
					class="fas fa-arrow-right"></i></a></li>
					<li id="loadNotes"  onclick="loadMyNotes()"><a> My notes <i
							class="fas fa-arrow-right"></i></a></li>
					<li id="loadAcNotes" onclick="loadAccessNotes()"><a >Shared notes <i
							class="fas fa-arrow-right"></i></a></li>
					<li id="logout"  onclick="logout()"><a id="logout">Logout <i class="fas fa-arrow-right">
						</i></a></li>
				</ul>
				`;
	            document.querySelector("#rightSide").innerHTML = ``;

	            break;
	    }
	}	</script>

</body>
</html>