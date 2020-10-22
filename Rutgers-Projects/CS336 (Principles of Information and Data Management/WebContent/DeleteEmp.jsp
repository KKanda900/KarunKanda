<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"
	import="com.cs336proj.root.Validation"%>
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

	<%
		String ssn =request.getParameter("ssn");
		try {
			DBConnection db = new DBConnection();
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
		String sql = String.format("Delete FROM Employee WHERE ssn = '%s'", ssn);
		stmt.execute(sql);
		
		//close the connection.
		conn.close();
		response.sendRedirect("AdminViewEmployee.jsp");
	} catch (SQLException e) {
		%><p><%=e.getMessage() %></p><%
	}%>
</body>
</html>