<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Railway Booking</title>
<style><%@include file="./css/style.css"%></style>
</head>
<body>
<% 
	String user = (String)session.getAttribute("LOGGED_IN");
	if(user == null) {%>
		<h1>Railway Booking</h1>
		<h3>Click to register now!</h3>
		<form action="Register.jsp" method="GET">
		    <input type="submit" value="Register" />
		</form>
		<br>
		<h3>Already a member, click below to login</h3>
		<form action="Login.jsp" method="GET">
		    <input type="submit" value="Login" />
		</form>
		<br>
		<h3>Click Below To View Schedule of Trains</h3>
		<form action="TrainScheduleSearch.jsp" method="GET">
		    <input type="submit" value="Search" />
		</form>
<% }else{ %>
		<h1>Railway Booking Dashboard</h1>
		<br>
		<i>Welcome <% out.print(user); %></i>
		<br>
				<h3>Click Below To View Schedule of Trains</h3>
		<form action="TrainScheduleSearch.jsp" method="GET">
		    <input type="submit" value="Search" />
		</form>
		
				<h3> Create a reservation:</h3>
		<form action = "CreateRes.jsp" method="GET">
			<input type = "submit" value="Create Reservation">
		</form>
		
				<h3> View your reservations:</h3>
				
		<form action = "ViewRes.jsp" method="GET">
			<input type = "submit" value="View Reservations">
		</form>
		
				<h3> Customer Support Page </h3>
				
		<form action = "QuestionsPage.jsp" method="GET">
			<input type = "submit" value="Customer Support Page">
		</form>
		<br><br><br><br>
		<form action = "Logout.jsp" method="GET">
			<input type = "submit" value="logout">
		</form>
<% } %>
</body>
</html>
