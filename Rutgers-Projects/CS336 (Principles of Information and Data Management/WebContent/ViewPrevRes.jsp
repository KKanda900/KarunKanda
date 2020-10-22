<% //VIEW PREVIOUS RESERVATION MADE BY: NICHOLAS MEEGAN %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>View Reservation History</title>
</head>
<body>
<% 
	String user = (String)session.getAttribute("LOGGED_IN");
String resNum = request.getParameter("resNum");
	if(user == null) {%>
		<% response.sendRedirect("index.jsp"); %>
<% }else{ %>
		<h1>List of Reservations</h1>
		<% //Get the database connection
		DBConnection db = new DBConnection();	
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = String.format("SELECT r.ReservationNumber, r.seatNumber, o.name, d.name,  TIME(so.deptDatetime), t.trainID, tl.transitLineName, r.reservationStartTime, r.reservationEndTime, r.class, r.tripType, r.personType, r.isDisabled, r.reservationLength, r.dateCreated, r.totalFare from Reservation r, Station o, Station d, StopsAt so, StopsAt sd, TrainSchedule ts, TransitLine tl, Train t where r.username = '%s' and r.scheduleID = ts.scheduleID and ts.transitLineName = tl.transitLineName and ts.trainID = t.trainID and ts.scheduleID = so.scheduleID and ts.scheduleID = sd.scheduleID and o.stationID = (select o.stationID from Station o where o.stationID = r.origin and o.stationID = so.stationID) and d.stationID = (select d.stationID from Station d where d.stationID = r.destination and d.stationID = sd.stationID)", user);
		ResultSet result = stmt.executeQuery(str);  %>
		<h2>
		<%
		out.print("Your reservation history is:");
		%>
		</h2>
		<br>
		
		<div>	
		<table style = "width: 100%">
<thead>
<tr>
<td><b>Reservation Number</b></td>
<td><b>Seat Number</b></td>
<td><b>Origin Station</b></td>
<td><b>Destination Station</b></td>
<td><b>First Available Departure Time</b></td>
<td><b>Train Number</b></td>
<td><b>Transit Line</b></td>
<td><b>Starts On</b></td>
<td><b>Expires On</b></td>
<td><b>Class</b></td>
<td><b>Trip Type</b></td>
<td><b>Made For</b></td>
<td><b>Customer Disabled?</b></td>
<td><b>Reservation Type</b></td>
<td><b>Created On</b></td>
<td><b>Fare </b></td>
</tr>
</thead>
<%		while(result.next())
	{

%>
	
	<tbody>
	    <tr><td><%=result.getString(1) %></td>
	    <td><%=result.getString(2) %></td>
	    <td><%=result.getString(3) %></td>
	    <td><%=result.getString(4) %></td>
	    <td><%=result.getString(5) %></td>
	    <td><%=result.getString(6) %></td>
	    <td><%=result.getString(7) %></td>
	    <td><%=result.getString(8) %></td>
	    <td><%=result.getString(9) %></td>
	    <td><%=result.getString(10) %></td>
	    <td><%=result.getString(11) %></td>
	    <td><%=result.getString(12) %></td>
	    <td><%=result.getString(13) %></td>
	    <td><%=result.getString(14) %></td>
	    <td><%=result.getString(15) %></td>
	    <td><%=result.getString(16) %></td>
	    </tr>
	</tbody>        <%

	}
	%>
	    </table>
	    <%
    result.close();
	    conn.close();%>
    </div>
		<div>
		<h2> 
		<%
		out.print("Enter in a reservation number to delete a reservation.");
		%>
		</h2>
		<form action='ViewRes.jsp' method='POST'>
				<label for='resNum'>Reservation Number:</label>
				<input type='text' id='resNum' name='resNum'><br><br>
				<input type='submit' value='Submit'>
				</form>
			<% String message = (String)session.getAttribute("message");
			if(message != null) {
				session.removeAttribute("message");
				out.print(message);
			}
			
			db = new DBConnection();	
			conn = db.getConnection();
			stmt = conn.createStatement();
			str = String.format("UPDATE Seats set isOccupied = 0 where seatNum = (SELECT r.seatNumber from Reservation r, TrainSchedule ts, Train t where r.scheduleID = ts.scheduleID and t.trainID = ts.trainID and r.reservationNumber = '%s')", resNum);
			stmt.execute(str);
			result.close();
			str = String.format("DELETE FROM Reservation WHERE reservationNumber = '%s' and username = '%s'", resNum, user);
			stmt.executeUpdate(str);
			
			result.close();
			conn.close();
				%>
				<br><br>
				
		<%

}
%>
		</div>

</body>
</html>