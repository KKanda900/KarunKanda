<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style>
<%@include file="./css/admin_style.css"%>
</style>
<title>View Reservations</title>
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
		String user = request.getParameter("username");
	if (user == null) {
	%>
	<%
		response.sendRedirect("AdminViewReservations.jsp");
	%>
	<%
		} else {
	%>
	<h1>List of Reservations</h1>
	<%
		//Get the database connection
	try {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = String.format("SELECT r.ReservationNumber, r.seatNumber, o.name, d.name,  TIME(so.deptDatetime), t.trainID, tl.transitLineName, " +
				"r.reservationStartTime, r.reservationEndTime, r.class, r.tripType, r.personType, r.isDisabled, r.reservationLength, r.dateCreated, " +
				"r.totalFare from Reservation r, Station o, Station d, StopsAt so, StopsAt sd, TrainSchedule ts, TransitLine tl, Train t where r.username = '%s' and r.scheduleID = ts.scheduleID and ts.transitLineName = tl.transitLineName and ts.trainID = t.trainID and ts.scheduleID = so.scheduleID and ts.scheduleID = sd.scheduleID and o.stationID = (select o.stationID from Station o where o.stationID = r.origin and o.stationID = so.stationID) and d.stationID = (select d.stationID from Station d where d.stationID = r.destination and d.stationID = sd.stationID)", user);
		ResultSet result = stmt.executeQuery(str);
	%>
	<h2>
		<%
			out.print("View Reservations for Customer " + user);
		%>
	</h2>
	<br>
	<table style="width: 100%">
		<thead>
			<tr>
				<th>Reservation Number</th>
				<th>Seat Number</th>
				<th>Origin Station</th>
				<th>Destination Station</th>
				<th>First Available Departure Time</th>
				<th>Train ID</th>
				<th>Transit Line</th>
				<th>Reservation Start</th>				
				<th>Expires On</th>
				<th>Class</th>
				<th>Trip Type</th>
				<th>Made For</th>
				<th>Reservation Type</th>
				<th>Reservation Length</th>
				<th>Created On</th>
				<th>Fare</th>
			</tr>
		</thead>
		<%
			while (result.next()) {
		%>
		<tbody>
			<tr>
				<td><%=result.getString(1)%></td>
				<td><%=result.getString(2)%></td>
				<td><%=result.getString(3)%></td>
				<td><%=result.getString(4)%></td>
				<td><%=result.getString(5)%></td>
				<td><%=result.getString(6)%></td>
				<td><%=result.getString(7)%></td>
				<td><%=result.getString(8)%></td>
				<td><%=result.getString(9)%></td>
				<td><%=result.getString(10)%></td>
				<td><%=result.getString(11)%></td>
				<td><%=result.getString(12)%></td>
				<td><%=result.getString(13)%></td>
				<td><%=result.getString(14)%></td>
				<td><%=result.getString(15)%></td>
				<td><%=result.getString(16)%></td>
			</tr>
		</tbody>

		<%
			}
		result.close();
		conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		}
		%>
	</table>
</body>
</html>