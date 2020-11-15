<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="notes.controller.*" isELIgnored="false"%>

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

</head>
<body>

	<header id="headMenu">
		<h1 id="headTitle">Log In / Register</h1>
	</header>
	<main id="content">
		<aside id="leftSide" class="aside">
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
				<input type="submit" value="Log In" class="submit" />
			</form>
			
			<!-- Development mode only -->
			<form id="createDB">
							<input type="hidden"name="formType" value="createDB" /> 
			
				<input type="submit" value="Create DB" class="submit" />
			</form>
					<form id="deleteDB">
							<input type="hidden"name="formType" value="deleteDB" /> 
			
				<input type="submit" value="Delete DB" class="submit" />
			</form>
		</aside>
		<aside id="rightSide" class="aside">
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
				<input type="submit" value="Register" class="submit" />
			</form>
		</aside>
		<p id="displayName"></p>

	</main>
	<script>
	$(document).ready(function() {
	    $("#login").submit(function() {
	        $.ajax({
	            url: "NotesServlet",
	            type: "POST",
	            datatype: "json",
	            data: $("#login").serialize(),
	            success: function(data) {
	                if (data.isOkay) {
	                    $("#displayName").html("Your name is: " + data.name);
	                    alert("you logged in " + data.name);
	                } else {
	                    alert("there was an oopsie loggin in");
	                }
	            }
	        });
	        return false;
	    });
	})
	$(document).ready(function() {
	    $("#register").submit(function() {
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
	    });
	})
	$(document).ready(function() {

	    $("#deleteDB").submit(function() {
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
	        return false;
	    });
	})
	$(document).ready(function() {
	    $("#createDB").submit(function() {
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
	        return false;
	    });
	})
	</script>
</body>
</html>