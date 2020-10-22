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
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		Statement stmt1 = conn.createStatement();
		String str = "Select * FROM " +
				"(Select c.username, c.firstName, c.lastName, sum(r.totalFare) as Total " +
					"FROM Customer c, Reservation r " +
					"WHERE c.username = r.username " +
					"GROUP BY c.username " +
					"ORDER BY Total desc) AS T1 " +
					"LIMIT 1";
		String str2 = "Select * FROM " +
				"(Select TransitLine.transitLineName, SUM(Reservation.totalFare) as Sales FROM TransitLine, TrainSchedule, Reservation " +
						"WHERE TrainSchedule.scheduleID = Reservation.scheduleID AND TransitLine.transitLineName = TrainSchedule.transitLineName " +
						"GROUP BY transitLineName) AS T1 " +
						"ORDER BY Sales DESC " +
						"LIMIT 5";
		ResultSet result1 = stmt1.executeQuery(str2);
		ResultSet result = stmt.executeQuery(str);
		%>
		<h1>Top Customer</h1>
		<table>
			<tr>
				<th>Customer Username</th>
				<th>Customer First Name</th>
				<th>Customer Last Name</th>
				<th>Sales Generated</th>
			</tr>
		<%
		while (result.next()) {
			%>
			<tr>
			<td><%=result.getString("username")%></td>
			<td><%=result.getString("firstName")%></td>
			<td><%=result.getString("lastName")%></td>
			<td><%=result.getString("Total")%></td>
			</tr>
			
			<%
			} %> 
		</table>
		<h1>Top Transit Lines</h1>
		<table>
			<tr>
				<th>Transit Line</th>
				<th>Sales Generated</th>
			</tr>
			 <%
		while (result1.next()) {
			%>
			
			
			<tr>
				<td><%=result1.getString("transitLineName") %></td>
				<td><%=result1.getString("Sales") %></td>
			</tr>
			
			<%
			}%>
			</table><%
	}
	catch (Exception e) {
		e.printStackTrace();
	}
%>
</body>
</html>