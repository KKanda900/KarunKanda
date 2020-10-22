<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" import="com.cs336proj.root.Validation" %>
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
		String ssn = "";
		ssn = request.getParameter("ssn");
		try {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = String.format("select * from Employee where ssn='%s'", ssn);
		
		ResultSet result = stmt.executeQuery(str);
		while (result.next()) {
	%>
	<h1>Edit Employee Details</h1>
	<form method = "POST" action = "updateEmpAction.jsp">
		<input type="hidden" name="ssnum"
			value="<%=result.getString("ssn")%>"> <br>
		Username:<br> <input type="text" name="username"
			value="<%=result.getString("username")%>"> <br>
		Password:<br> <input type="password" name="password"
			value="<%=result.getString("password")%>"> <br> 
		First name:<br> <input type="text" name="first_name"
			value="<%=result.getString("firstName")%>"> <br> 
		Last name:<br> <input type="text" name="last_name"
			value="<%=result.getString("lastName")%>"> <br> 
		Email Address:<br> <input type="email" name="email"
			value="<%=result.getString("emailAddress")%>"> <br>
		SSN:<br> <input type="text" name="ssn"
			value="<%=result.getString("ssn")%>"> <br>
		<br> <input type="submit" value="Submit">
	</form>
	<%
		}
	conn.close();
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>

</body>
</html>