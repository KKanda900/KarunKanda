<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
<h1>Welcome to the Administrative Control Panel</h1>
<p>You can:</p>
<ul>
	<li>Add, view, and edit Customer Details in the Customers Page</li>
	<li>Add, view, and edit Employee Details in the Employees Page</li>
	<li>View Reservations by Customer or Train in the Reservations Page</li>
	<li>View Revenue by Customer, Transit Line, or Month in the Revenue Page</li>
	<li>View Top Customer and Top Transit Lines in the Top Sales Page</li>
</ul>
</body>
</html>