<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" import="com.cs336proj.root.ReservationManagement"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>View Reservations</title>
</head>
<body>
<% 
	String user = (String)session.getAttribute("LOGGED_IN");
String resNum = request.getParameter("resNum");%>
		<h1>List of Reservations</h1>
		<p>*Monthly / Weekly reservers are free to ride on other trains and their schedules, however won't have a seat reserved there.</p>
	
		<%
		ResultSet result = ReservationManagement.getReservations();  %>
		<h2>
		<%
		out.print("All reservations:");
		%>
		</h2>
		<%String message = (String)session.getAttribute("message");
		if(message != null) {
			session.removeAttribute("message");
			out.print(message);
		}%>
		<br>
		<div>
	<form id="add" name="add" action=CreateResCustomerRep.jsp></form>
	<input type=hidden form="add" name="add" value="add"></input>
	<form id="edit" name="edit" action=EditResCustomerRep.jsp></form>
	<input type=hidden form="edit" name="edit" value="edit"></input>
	<form id="delete" name="delete" action=ReservationsCustomerRep></form>
	<input type=hidden form="delete" name="delete" value="delete"></input>
		<table style = "width: 100%">
<thead>
<tr>
<td><b>Reservation Number</b></td>
<td><b>Username</b></td>
<td><b>Seat Number</b></td>
<td><b>Reservation Length</b></td>
<td><b>Origin</b></td>
<td><b>Destination</b></td>
<td><b>Transit Line</b></td>
<td><b>Class</b></td>
<td><b>Trip Type</b></td>
<td><b>Person Type</b></td>
<td><b>Disabled?</b></td>
<td><b>Date Created</b></td>
<td><b>Total Fare</b></td>
<td><b>Sch. ID</b></td>
<td><b>Booking Fee</b></td>
</tr>
</thead>
<tbody>
<%		
while(result.next())
	{
%>
	
	<tr>

	    <td><%=result.getString("reservationnumber") %></td>
	    <td><%=result.getString("username") %></td>
	    <td><%=result.getString("seatNumber") %></td>
	    <td><%=result.getString("reservationLength") %></td>
	    <td><%=result.getString("origin") %></td>
	    <td><%=result.getString("destination") %></td>
	    <td><%=result.getString("transitLineName") %></td>
	    <td><%=result.getString("class") %></td>
	    <td><%=result.getString("triptype") %></td>
	    <td><%=result.getString("persontype") %></td>
	    <td><%=result.getString("isdisabled") %></td>
	    <td><%=result.getString("datecreated") %></td>
	    <td><%=result.getString("totalfare") %></td>
	    <td><%=result.getString("scheduleID") %></td>
	    <td><%=result.getString("bookingFee") %></td>
	    <td><button form="edit" type="submit" name="action" value="<%=result.getString("reservationnumber") %>">EDIT</button></td>
	    <td><button form="delete" type="submit" name="action" value="<%=result.getString("reservationnumber") %>">DELETE</button></td>
	    </tr>
	
	<%
	}
	%></tbody>
	    </table>
    </div>
		<br>
		<form><button form="add" type="submit">ADD</button></form>
</body>
<%result.close();%>
</html>