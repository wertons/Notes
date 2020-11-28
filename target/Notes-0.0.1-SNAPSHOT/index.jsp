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
      <script src="https://kit.fontawesome.com/44e5b3a6fe.js"></script>
      <%
         Cookie cookie = null;
         Cookie[] cookies = null;
         cookies = request.getCookies();
         if (cookies != null) {
         for (int i = 0; i < cookies.length; i++) {
         	cookie = cookies[i];
         	if (cookie.getName().equals("JSESSIONID")) {
         session.setAttribute("sessionID", cookie.getValue());
         	}
         	if (cookie.getName().equals("username")) {
         session.setAttribute("username", cookie.getValue());
         	}
         	if (cookie.getName().equals("password")) {
         session.setAttribute("password", cookie.getValue());
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
      <main id="content">
         <aside id="leftSide"></aside>
         <aside id="rightSide"></aside>
         <p id="displayName"></p>
      </main>
      <header id="headMenu">
         <h1 id="headTitle">The webapp is not loaded</h1>
      </header>
      <script>
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
         
                         loadPreset("main");
                     } else {
         
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
         	<input type="hidden" name="formType" value="createNote" id="noteFormType"/>
         	<input type="hidden" name="id">
         	<h2 id="noteHeader">
         		New Note
         	</h2>
         	<div id="noteTitle">
         		<input type="text" name="title" placeholder="Note title" maxlength="30" id="titleInput" >
         	</div>
         	<div id="noteBody">
         		<textarea  name="content"  class="editor"></textarea>
         	</div>
         	<input type="button" class="submit" value="Create Note" onclick="submitNote(this.value)" id="noteModelSubmit">
         	<input type="button" class="cancel" value="Cancel" onclick="loadPreset('main')" id="noteModelCancel">
         
         </form>
         `;
         
         
         
         }
         
         function createNote(){
         	selectMenu(document.querySelector("#createNote"));
         	document.querySelector("#rightSide").innerHTML = noteModel();
         	
         }
         
         function submitNote(value){
         	if(value=="Create Note"){
         	 $.ajax({
         	        url: "NotesServlet",
         	        type: "POST",
         	        data: $("#createNoteForm").serialize(),
         	        success: function(data) {
         	            if (data.isOkay) {
         	            } else {
         
         					alert("could not create note");
         	            }
                         loadPreset("main");
         
         	        }
         	    });
         	} else{
         		 $.ajax({
         		        url: "NotesServlet",
         		        type: "POST",
         		        data: $("#createNoteForm").serialize(),
         		        success: function(data) {
         		            if (data.isOkay) {
         		            } else {
         
         						alert("could not update note");
         		            }
         	                loadPreset("main");
         
         		        }
         		    });
         	}
         }
         function searchBar(list){
             var input, filter, ul, li, a, i, txtValue;
             input = document.getElementById("searchBar");
             filter = input.value.toUpperCase();
             ul = document.getElementById(list);
             li = ul.getElementsByTagName("li");
             for (i = 0; i < li.length; i++) {
                 p = li[i].getElementsByTagName("p")[0];
                 txtValue = p.textContent || p.innerText;
                 if (txtValue.toUpperCase().indexOf(filter) > -1) {
                     li[i].style.display = "";
                 } else {
                     li[i].style.display = "none";
                 }
             }
         }
         
         function loadMyNotes(){
         	selectMenu(document.querySelector("#loadNotes"));
         	document.querySelector("#rightSide").innerHTML = `
         	<h2>My notes</h2>
         	<form id="loadOwnerNotes">
         		<input type="hidden" name="formType" value="getOwnerNotes" />
         	</form>
         	<input type="text" placeholder="&#xf002; Search note..." id="searchBar" onkeyup="searchBar('notesList')">
         	<ul id="notesList">
         	</ul>
         	`;	
         	 $.ajax({
         	        url: "NotesServlet",
         	        type: "POST",
         	        data: $("#loadOwnerNotes").serialize(),
         	        success: function(data) {
         	            if (data.isOkay) {
         	  				loadNotes(data.notes,"own");      
         	            } else {
         
         					alert("there was an error getting notes");
         	            }
         	        }
         	    });
         
         	
         	
         }
         
         function loadAccessNotes(){
         	
         	selectMenu(document.querySelector("#loadAcNotes"));
         	document.querySelector("#rightSide").innerHTML = `
         	<h2>Shared Notes</h2>
         	<form id="getAcNotes">
         		<input type="hidden" name="formType" value="getAcNotes" />
         	</form>
         	<input type="text" placeholder="&#xf002; Search note..." id="searchBar" onkeyup="searchBar('notesList')">
         
         	<ul id="notesList">
         
         	</ul>
         	`;	
         	 $.ajax({
         	        url: "NotesServlet",
         	        type: "POST",
         	        data: $("#getAcNotes").serialize(),
         	        success: function(data) {
         	            if (data.isOkay) {
         	  				loadNotes(data.notes,"ac");    
         	            } else {
         
         					alert("error getting notes");
         	            }
         	        }
         	    });
         
         	
         	
         }
         
         function escape(raw) {
             return raw
                  .replace(/&/g, "&amp;")
                  .replace(/</g, "&lt;")
                  .replace(/>/g, "&gt;")
                  .replace(/"/g, "&quot;")
                  .replace(/'/g, "&#039;");
          }
         
         let myNotes = null;
         function loadNotes(notes,type){
            	let insert = "";
            	myNotes = notes;
         
            	if(type === "own"){
            	notes.forEach(function(note){
            	let title = note.title;
            	title = escape(title);
            	insert += '<li id="note'+note.id+'">'
            	+'<p class="noteName">'+ title + '</p>'
            	+'<a class="noteOpen cancel" id="'+note.id+'" onclick="deleteNote(this.id)"><i class="fas fa-trash"></i></a> '
            	+'<a class="noteOpen" id="'+note.id+'" onclick="loadNote(this.id)">Edit</a>'
            	+'<a class="noteOpen" id="'+note.id+'" onclick="displayNote(this.id)" ><i class="display fas fa-chevron-down"></i></a>'
         	+'<p id="preview'+note.id+'" class="previewText hidden"></p>'
            	+'</li>';
            	});
            	} else if( type === "ac"){
            		insert = "";
            		notes.forEach(function(note){
            	    	let title = note.title;
            	    	title = escape(title);
            	    	insert += '<li id="note'+note.id+'">'
            	    	+'<p class="noteName">'+title+'</p>'
            	    	+'<a class="noteOpen cancel" id="'+note.id+'" onclick="deleteAc(null,this.id)"><i class="fas fa-trash"></i></a> '
            	    	+'<a class="noteOpen" id="'+note.id+'" onclick="displayNote(this.id)" ><i class="display fas fa-chevron-down"></i></a>'
            	    	+'<p id="preview'+note.id+'" class="previewText hidden"></p>'
            	    	+'</li>';	
            		});
            	    	
            	}
            	
            	document.getElementById("notesList").innerHTML = insert;
         }
         function displayNote(id){
         let list =	document.querySelector("#note"+id);
         let note = myNotes.filter(note => {  
         return note.id == id
         })	
         
         
         $('.shown').addClass('hidden');
         $('.shown').removeClass('shown');
         
         let preview = document.querySelector("#preview"+id);
         if(list.classList.contains("open")){
             $('.shown').addClass('hidden');
             $('.shown').removeClass('shown');
          preview.classList.add("hidden");
          preview.classList.remove("shown");
          preview.innerHTML = "";
         } else{
          preview.classList.remove("hidden");
          preview.classList.add("shown");
          preview.innerHTML = note[0].body;
         }
         if(list.classList.contains("open")){
          	list.classList.remove("open");
          } else{
          	$('.open').removeClass('open');
          	list.classList.add("open");
          }
         
         	//currently trying to load mde to show only mode this is it  => https://codepen.io/bleutzinn/pen/KadBXo 
         
         
         }
         function loadNote(id){
         	let note = myNotes.filter(note => {  
         		return note.id == id
         		})	
         	document.querySelector("#rightSide").innerHTML = noteModel();
         	document.querySelector("#createNoteForm").elements["content"].innerHTML = note[0].body;
         	document.querySelector("#noteModelSubmit").value = "Save changes";
         	document.querySelector("#createNoteForm").elements["formType"].value = "updateNoteForm";
         	document.querySelector("#createNoteForm").elements["id"].value = note[0].id;
         	document.querySelector("#rightSide").innerHTML += `
         	<div id="accessMenu">
         		<div id="addAc">
         		<input type="text" placeholder="Share with..." id="addUser">
         		<button onclick="createAc()">+</button>
         		</div>
         		<ul id="acList"></ul>
         		</div>
         	`;
         	$.ajax({
         		url : "NotesServlet",
         		type : "POST",
         		data : {
         			"formType" : "getUserAc",
         			"id" : id
         		},
         		dataType: "json",
         		success : function(data){
         			if (data.isOkay){
         				printUsersAc(data.users);
         			}
         		}
         	});
         	document.querySelector("#titleInput").value = note[0].title;
         
         
         	
         }
         function printUsersAc(users){
         let insert = "";
         let id = document.querySelector("#createNoteForm").elements["id"].value;
         users.forEach( function(user){
         	if(user != "<%=session.getAttribute("username")%>"){
              		let ins =  '<li>'+user+'<a class="noteOpen cancel" onclick="deleteAc("'+user+'",'+id+')"><i class="fas fa-trash"></i></a></li>';
            		insert += ins;
         	}
         	}
         );
          
          document.querySelector("#acList").innerHTML = insert;
         }
         function deleteNote(id){
         	$.ajax({
         	    url : "NotesServlet",
         	    type : "POST",
         	    data : {
         	        "formType" : "deleteNote",
         	        "id" : id
         	    },
         	    dataType:'json',
         	    success : function(data) {    
         	    	if(data.isOkay){
         	    		loadMyNotes();
         
         	    	} else{
         	    		alert("could not delete note")
         	    	}
         	    }
         	});
         
         }
         
         function createAc(){
          let user = document.querySelector("#addUser").value;
         let id = document.querySelector("#createNoteForm").elements["id"].value;
         
          $.ajax({
           	    url : "NotesServlet",
           	    type : "POST",
           	    data : {
           	        "formType" : "grantAc",
           	        "user": user,
           	        "id" : id
           	    },
           	    dataType:'json',
           	    success : function(data) {    
           	    	if(data.isOkay){
           	    		loadNote(id);
           
           	    	} else{
           	    		alert("Could not create access")
           	    	}
           	    }
           	});
         }
         function deleteAc(user,id){
          if(!user){
         	 user = "";
          }
          $.ajax({
          	    url : "NotesServlet",
          	    type : "POST",
          	    data : {
          	        "formType" : "deleteAc",
          	        "user": user,
          	        "id" : id
          	    },
          	    dataType:'json',
          	    success : function(data) {    
          	    	if(data.isOkay){
          	    		loadPreset("main");
          
          	    	} else{
          	    		alert("could not delete access")
          	    	}
          	    }
          	});
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
         }	
      </script>
   </body>
</html>