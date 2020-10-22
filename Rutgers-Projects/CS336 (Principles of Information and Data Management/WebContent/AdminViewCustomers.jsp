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
<h1>View Customer Details</h1>

<%try {
				//Get the database connection
		DBConnection db = new DBConnection();	
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = "SELECT * FROM Customer WHERE firstName is not NULL";
		ResultSet result = stmt.executeQuery(str); %>
		<table>
			<tr>
				<th>Username</th>
				<th>Customer First Name</th>
				<th>Customer Last Name</th>
				<th>Email Address</th>
				<th>Address</th>
				<th>Telephone</th>
				<th>Action</th>
			</tr>
		
		<% while(result.next()) { %>
		<tr>
			<td><%=result.getString("username") %> </td>
			<td><%= result.getString("firstName") %> </td>
			<td><%= result.getString("lastName") %> </td>
			<td><%= result.getString("emailAddress") %> </td>
			<td><%= result.getString("address") + ", " + result.getString("city") + ", " + result.getString("state") + " " + 
			result.getString("zipCode") %> </td>
			<td><%= result.getString("telephone") %>
			<td><a href="UpdateCus.jsp?username=<%=result.getString("username")%>">Update</a> or <a href="DeleteCus.jsp?username=<%=result.getString("username")%>">Delete
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
	<h1>Add a Customer</h1>
	<form method = "POST" action = "AddCus.jsp">
		Username:<br> <input type="text" name="username"> <br>
		Password:<br> <input type="password" name="password"><br> 
		First name:<br> <input type="text" name="first_name"><br> 
		Last name:<br> <input type="text" name="last_name"><br> 
		Email Address:<br> <input type="email" name="email"> <br>
		Street Address:<br> <input type="text" name="address"> <br>
		City:<br> <input type="text" name="city"> <br>
		State:<br> <input type="text" name="state"> <br>
		Zip Code:<br> <input type="number" name="zip"> <br>
		Telephone:<br> <input type="number" name="phone"> <br>
		<br> <input type="submit" value="Submit">
	</form>
</body>
</html>