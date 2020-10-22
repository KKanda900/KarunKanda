<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Panel</title>
<style><%@include file="./css/admin_style.css"%></style>
</head>
<body>
<div id="navbar">
<ul id= "navbarList">
	<li id="navbarItem"><a id = "navtext" href = './admin.jsp'>Home</a></li>
	<li id="navbarItem"><a id = "navtext" href = './AdminViewCustomers.jsp'>Customers</a></li>
  	<li id = "navbarItem"><a id = "navtext" href = './AdminViewEmployee.jsp'>Employees</a></li>
  	<li id = "navbarItem"><a id = "navtext" href = './TopSales.jsp'>Top Sales</a></li>
  	<li id = "navbarItem"><a id = "navtext" href = './AdminViewRevenue.jsp'>Revenue Reports</a></li>
  	<li id = "navbarItem"><a id = "navtext" href = './AdminViewReservations.jsp'>Reservations</a></li>
  	<li style="float:right"> <a id = "navtext" href = './Logout.jsp'>Logout</a></li>
</ul>
</div>
<h1>View Reservations</h1>

	<h1>Search by Customer</h1>
	<form method = "POST" action = "SearchByCust.jsp">
		Username:<br> <input type="text" name="username"> <br>
		<br> <input type="submit" value="Submit">
	</form>
	<h1>Search by Transit Line & Train Number</h1>
	<form method = "POST" action = "SearchByTrain.jsp">
		Transit Line:<br> <input type="text" name="transit"> <br>
		Train Number:<br> <input type="text" name="train"> <br>
		<br> <input type="submit" value="Submit">
	</form>
</body>
</html>