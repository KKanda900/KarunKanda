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
		try {
		String username = request.getParameter("username");
		String user = request.getParameter("user");
		String pass = request.getParameter("password");
		String email = request.getParameter("email") == null ? "" : request.getParameter("email");
		String fName = request.getParameter("first_name") == null ? "" : request.getParameter("first_name");
		String lName = request.getParameter("last_name") == null ? "" : request.getParameter("last_name");
		String address = request.getParameter("address") == null ? "" : request.getParameter("address");
		String state = request.getParameter("state") == null ? "" : request.getParameter("state");
		String zip = request.getParameter("zip") == null ? "" : request.getParameter("zip");
		String city = request.getParameter("city") == null ? "" : request.getParameter("city");
		String phone = request.getParameter("phone") == null ? "" : request.getParameter("phone");
		
		if (username != null && pass != null) {
		Validation.checkEmail(email);
		Validation.checkAddress(address);
		Validation.checkName(fName, lName);
		Validation.checkState(state);
		Validation.checkZipCode(zip);
		Validation.checkCity(city);
		Validation.checkPhoneNumber(phone);
		Validation.checkLength(address, email, fName, lName, zip, state, city, phone, username, pass);
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String sql = String.format(
		"Update Customer set username='%s', firstName='%s', lastName='%s', city='%s', zipCode='%s', emailAddress='%s', address ='%s', state='%s', password ='%s', telephone ='%s' where username='%s'",
		user, fName, lName, city, zip, email, address, state, pass, phone, username);

		stmt.execute(sql);
		
		//close the connection.
		conn.close();
		response.sendRedirect("AdminViewCustomers.jsp");
		}
	} catch (SQLException e) {
		%><p><%=e.getMessage() %></p><%
	}
	%>

</body>
</html>