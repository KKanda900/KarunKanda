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
<h1>View Employee Details</h1>

<%try {
				//Get the database connection
		DBConnection db = new DBConnection();	
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = "SELECT * FROM Employee WHERE firstName is not NULL";
		ResultSet result = stmt.executeQuery(str); %>
		<table>
			<tr>
				<th>Username</th>
				<th>Employee First Name</th>
				<th>Employee Last Name</th>
				<th>Email Address</th>
				<th>SSN</th>
				<th>Action</th>
			</tr>
		
		<% while(result.next()) { %>
		<tr>
			<td><%=result.getString("username") %> </td>
			<td><%= result.getString("firstName") %> </td>
			<td><%= result.getString("lastName") %> </td>
			<td><%= result.getString("emailAddress") %> </td>
			<td><%= result.getString("ssn") %> </td>
			<td><a href="UpdateEmp.jsp?ssn=<%=result.getString("ssn")%>">Update</a> or <a href="DeleteEmp.jsp?ssn=<%=result.getString("ssn")%>">Delete
			</td>
		</tr>
		 
	<%
		}

		conn.close();
		result.close();
		stmt.close();	
	} 
	catch (Exception e) {
		e.printStackTrace();
	} 
	%>
	</table>
	<h1>Add an Employee</h1>
	<form method = "POST" action = "AddEmp.jsp">
		Username:<br> <input type="text" name="username"> <br>
		Password:<br> <input type="password" name="password"><br> 
		First name:<br> <input type="text" name="first_name"><br> 
		Last name:<br> <input type="text" name="last_name"><br> 
		Email Address:<br> <input type="email" name="email"> <br>
		SSN:<br> <input type="text" name="ssn"><br> 
		<br> <input type="submit" value="Submit">
	</form>
</body>
</html>