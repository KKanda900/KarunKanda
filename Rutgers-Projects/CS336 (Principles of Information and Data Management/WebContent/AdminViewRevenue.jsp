<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"%>
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
	<h1>View Revenue Details</h1>

	<h2>By Customer</h2>
	<form method="GET" action="#">
		Username:<br> <input type="text" name="username"> <br>
		<br> <input type="submit" value="Submit">
	</form>
	<table>
		<tr>
			<th>Username</th>
			<th>Total Revenue ($)</th>
		</tr>
	<%
		String user = request.getParameter("username");
		try {
			DBConnection db = new DBConnection();
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			Statement stmt4 = conn.createStatement();
			String str = String.format("Select Customer.username, SUM(Reservation.totalFare) FROM Customer LEFT JOIN Reservation ON Customer.username = Reservation.username WHERE Customer.username = '%s' GROUP BY Customer.username", user);
			String str4 = "Select Customer.username, SUM(Reservation.totalFare) FROM Customer LEFT JOIN Reservation ON Customer.username = Reservation.username GROUP BY Customer.username";
			ResultSet result = stmt.executeQuery(str);
			ResultSet result4 = stmt4.executeQuery(str4);
	%>
	

		<%
		if (request.getParameter("username") != null) {
			while (result.next()) {
		%>
		<tr>
			<td><%=result.getString("username")%></td>
			<% if (result.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
		<%
			}
		} else {
			while (result4.next()) {
				%>
				<tr>
			<td><%=result4.getString("username")%></td>
			<% if (result4.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result4.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
				<%
			}
			
		}
		}catch (Exception e) {
		%><p><%=e.getMessage()%></p>
		<%
			}
		%>
	</table>
	<h2>By Transit Line</h2>
	<form method="GET" action="#">
		Transit Line:<br> <input type="text" name="transit"> <br>
		<br> <input type="submit" value="Submit">
	</form>
	<table>
		<tr>
			<th>Transit Line</th>
			<th>Total Revenue ($)</th>
		</tr>
		<%
		try {
			DBConnection db1 = new DBConnection();
			Connection conn1 = db1.getConnection();
			Statement stmt1 = conn1.createStatement();
			Statement stmt3 = conn1.createStatement();
			String transit = request.getParameter("transit");
			String str1 = String.format("Select TransitLine.transitLineName, SUM(Reservation.totalFare) FROM TransitLine, TrainSchedule RIGHT JOIN Reservation ON TrainSchedule.scheduleID = Reservation.scheduleID WHERE TransitLine.transitLineName = '%s' AND TransitLine.transitLineName = TrainSchedule.transitLineName", transit);
			String str3 = "Select TransitLine.transitLineName, SUM(Reservation.totalFare) FROM TransitLine LEFT JOIN TrainSchedule ON TransitLine.transitLineName = TrainSchedule.transitLineName LEFT JOIN Reservation ON TrainSchedule.scheduleID = Reservation.scheduleID GROUP BY TransitLine.transitLineName";
			ResultSet result3 = stmt3.executeQuery(str3);
			ResultSet result1 = stmt1.executeQuery(str1);
			if (request.getParameter("transit") != null) {				
			while (result1.next()) {
		%>
		<tr>
			<td><%=result1.getString("transitLineName")%></td>
			<% if (result1.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result1.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
				<%
			}
		}
			else {
				while (result3.next()) {
					%>
					<tr>
						<td><%=result3.getString("transitLineName")%></td>
						<% if (result3.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result3.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
				<%
			}
			}
		} catch (Exception e) {
		%><p><%=e.getMessage()%></p>
		<%
			}
		%>
	</table>
	<h2>By Destination Station</h2>
	<form method="GET" action="#">
		Destination Station:<br> <input type="text" name="station">
		<br> <br> <input type="submit" value="Submit">
	</form>
	<table>
		<tr>
			<th>Destination</th>
			<th>Total Revenue ($)</th>
		</tr>
		<%
			try {
				String station = request.getParameter("station");
				DBConnection db2 = new DBConnection();
				Connection conn2 = db2.getConnection();
				Statement stmt2 = conn2.createStatement();
				Statement stmt5 = conn2.createStatement();
				String str2 = "Select Station.name, SUM(Reservation.totalFare) FROM Station RIGHT JOIN Reservation ON Reservation.destination = Station.stationID WHERE Station.name = '%s' GROUP BY Station.name";
				String query = String.format(str2, station);
				String str5 = "Select Station.name, SUM(Reservation.totalFare) FROM Station RIGHT JOIN Reservation ON Reservation.destination = Station.stationID GROUP BY Station.name";
				ResultSet result2 = stmt2.executeQuery(query);
				ResultSet result5 = stmt5.executeQuery(str5);
			if (request.getParameter("station") != null) {
			while (result2.next()) {
		%>
		<tr>
			<td><%=result2.getString("name")%></td>
			<% if (result2.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result2.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
				<%
			}
			}
			else {
				while (result5.next()) {
					%>
					<tr>
						<td><%=result5.getString("name")%></td>
						<% if (result5.getString("SUM(Reservation.totalFare)") == null) {%>
			<td>0</td>
			<%
			} else {%>
			<td><%=result5.getString("SUM(Reservation.totalFare)")%></td>
			<%} %>
		</tr>
				<%
						}
			}
		}catch (Exception e) {
		%><p><%=e.getMessage()%></p>
		<%
			}
		%>
	</table>
	<h2>View Revenue Reports By Month</h2>
	<form action="#">
	<div class = "select-style" style = "width:150px">
		<select name="month">
			<option value="1">January</option>
			<option value="2">February</option>
			<option value="3">March</option>
			<option value="4">April</option>
			<option value="5">May</option>
			<option value="6">June</option>
			<option value="7">July</option>
			<option value="8">August</option>
			<option value="9">September</option>
			<option value="10">October</option>
			<option value="11">November</option>
			<option value="12">December</option>
		</select>
		</div>
		<div class = "select-style" style = "width:150px">
		<select name="year">
			<option value="2020">2020</option>
			<option value="2019">2019</option>
		</select> 
		</div><input type="submit" value="Submit">
		
	</form>
	<%
		if (request.getParameter("month") != null && request.getParameter("year") != null) {
		int monthSelected = Integer.parseInt(request.getParameter("month"));
		int yearSelected = Integer.parseInt(request.getParameter("year"));
		try {
			DBConnection db1 = new DBConnection();
			Connection conn1 = db1.getConnection();
			Statement stmt3 = conn1.createStatement();
			String str3 = String.format(
			"Select SUM(r.totalFare) FROM Reservation r WHERE MONTH(r.dateCreated) = '%d' AND YEAR(r.dateCreated) = '%d'",
			monthSelected, yearSelected);
			ResultSet result3 = stmt3.executeQuery(str3);
			while (result3.next()) {
		if (result3.getString("SUM(r.totalFare)") != null) {
	%><p>
		Revenue: $<%=result3.getString("SUM(r.totalFare)")%>
	</p>
	<%
		} else {
	%><p>Revenue: $0</p>
	<%
		}
	}
	} catch (Exception e) {
	%><p><%=e.getMessage()%>
	</p>
	<%
		}
	}
	%>
</body>
</html>