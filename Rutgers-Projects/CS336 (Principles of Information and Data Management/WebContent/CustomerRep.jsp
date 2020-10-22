<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Rep. Panel</title>
<style>
<%@include file="./css/style.css"%>
</style>
</head>
<body>
	<h2>
		Hello
		<%
		out.print((String) session.getAttribute("LOGGED_IN"));
	%>!
	</h2>
	<a href="qanda.jsp"><p>View and answer customer questions.</p></a>
	<a href="TrainScheduleSearchCustomerRep.jsp"><p>Lookup Train
			Schedules.</p></a>
	<a href="ViewResCustomerRep.jsp"><p>Manage Reservations.</p></a>
	<a href="ViewSeats.jsp"><p>View customers that have reserved a seat for some transit line and train.</p></a>
	<a href="DisclaimerCustomerRep.jsp"><p>Send out a delay
			disclaimer for Train Schedule.</p></a>
	<br>
	<br>
	<form action="Logout.jsp" method="GET">
		<input type="submit" value="logout">
	</form>
</body>
</html>