<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
</head>
<%
String message = (String)session.getAttribute("message");
if(message != null) {
	session.removeAttribute("message");
	out.print(message);
}
%>
<% if (request.getParameter("ByStations") != null && request.getParameter("ByStations").equals("true")) {%>
<body>

<h2>All train schedules that go from 
<%= request.getParameter("originStat") %> to
<%= request.getParameter("destinStat") %></h2><br>

<table style="border-collapse:collapse">
<thead>
<tr>
<td>Transit Line</td>
<td>Schedule ID</td>
<td>Train ID</td>
<td>Station ID</td>
<td>City</td>
<td>Station</td>
<td>State</td>
<td>Arrival Time</td>
<td>Departure Time</td>
</tr>
</thead>
<tbody>
<%
try
{
	String origin = request.getParameter("originStat");
	String destin = request.getParameter("destinStat");
	if(origin==(null) || destin==(null)){
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else if(origin.equals("-1") || destin.equals("-1")){
		session.setAttribute("message", "Selection Invalid: Please Select Origin and Destination Stations");
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else{
	ResultSet result = ScheduleManagement.getSchedule(origin, destin);
	String curTLine = "";
	while(result.next())
	{
	%>
	
	    <tr style="<% if (!curTLine.equals(result.getString("transitLineName"))) {
		    curTLine = result.getString("transitLineName");
	    %>
	    	border-top: 1pt solid black;
	    <%}%>
	    ">
	     <td><%=curTLine %></td>
	     <td><%=result.getInt("scheduleID") %></td>
	     <td><%=result.getInt("trainID") %></td>
	     <td><%=result.getInt("stationID") %></td>
	     <td><%=result.getString("city") %></td>
	     <td><%=result.getString("name") %></td>
	     <td><%=result.getString("state") %></td>
	     <td><%=result.getTime("arrDateTime") %></td>
	     <td><%=result.getTime("deptDateTime") %></td></tr>
	     <%

	}
	
    result.close();}
}catch(Exception e)
{
    e.printStackTrace();
    }
%>
</tbody>
</table>
</body>
<%} else if (request.getParameter("ByStations") == null) {%>
<body>

<h2>All train schedules</h2><br>
<form action='ManageSchedules.jsp'>
	<button name="create" value="">Add</button>
</form>
<form id="editForm" action='ManageSchedules.jsp'></form>
<form action='SchedulesCustomerRep' id="manageForm">
<table style="border-collapse:collapse">
<thead>
<tr>
<td>Transit Line</td>
<td>Schedule ID</td>
<td>Train ID</td>
<td>Travel Time</td>
</tr>
</thead>
<tbody>
<%
try
{
	DBConnection db = new DBConnection();	
	Connection conn = db.getConnection();
	Statement stmt = conn.createStatement();
	String str = "SELECT DISTINCT trainID, scheduleID, transitLineName, travelTime FROM TrainSchedule";
	ResultSet result = stmt.executeQuery(str);
	String curTLine = "";
	while(result.next())
	{
	%>
	
	    <tr style="<% if (!curTLine.equals(result.getString("scheduleID"))) {%>
	    	border-top: 1pt solid black;
	    <%}%>
	    ">
	     <td><%=result.getString("transitLineName") %></td>
	     <td><%=result.getInt("scheduleID") %></td>
	     <td><%=result.getInt("trainID") %></td>
	     <td><%=result.getTime("travelTime") %></td>
	     <% if (!curTLine.equals(result.getString("scheduleID"))) {
		    curTLine = result.getString("scheduleID");
	    %>
	    	<td><button type="submit" form="editForm" name="edit" value=<%=curTLine%>>EDIT</button></td>
	     	<td><button type="submit" form="manageForm" name="DELETE" value=<%=curTLine%>>DELETE</button></td>
	    <%}%>
	     
	     </tr>
	     <%

	}//curTLine = result.getString("scheduleID");
	
    result.close();
    stmt.close();
    conn.close();
}catch(Exception e)
{
    e.printStackTrace();
    }
%>
</tbody>
</table>
</form>

</body>
<%} else {%>
<body>

<h2>All train schedules who's destination is
<%= request.getParameter("originStat") %></h2><br>

<table style="border-collapse:collapse">
<thead>
<tr>
<td>Transit Line</td>
<td>Schedule ID</td>
<td>Train ID</td>
<td>Station ID</td>
<td>City</td>
<td>Station</td>
<td>State</td>
<td>Arrival Time</td>
<td>Departure Time</td>
</tr>
</thead>
<tbody>
<%
try
{
	String station = request.getParameter("originStat");
	if(station==(null)){
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else if(station.equals("-1")){
		session.setAttribute("message", "Selection Invalid: Please Select Station.");
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else{
	DBConnection db = new DBConnection();	
	Connection conn = db.getConnection();
	Statement stmt = conn.createStatement();
	String str = String.format("SELECT DISTINCT trainID, city, Station.name name, state, sa.scheduleID scheduleID, transitLineName, sa.stationID stationID, arrDateTime, deptDateTime FROM StopsAt sa join Station on Station.stationID = sa.stationID join TrainSchedule on TrainSchedule.scheduleID = sa.scheduleID WHERE sa.StopNum <= (select stopNum from StopsAt join Station on Station.stationID=StopsAt.stationID where Station.name = '%s' and StopsAt.scheduleID = sa.scheduleID) order by sa.scheduleID, sa.stopNum",station);
	ResultSet result = stmt.executeQuery(str);
	String curTLine = "";
	while(result.next())
	{
	%>
	
	    <tr style="<% if (!curTLine.equals(result.getString("transitLineName"))) {
		    curTLine = result.getString("transitLineName");
	    %>
	    	border-top: 1pt solid black;
	    <%}%>
	    ">
	     <td><%=curTLine %></td>
	     <td><%=result.getInt("scheduleID") %></td>
	     <td><%=result.getInt("trainID") %></td>
	     <td><%=result.getInt("stationID") %></td>
	     <td><%=result.getString("city") %></td>
	     <td><%=result.getString("name") %></td>
	     <td><%=result.getString("state") %></td>
	     <td><%=result.getTime("arrDateTime") %></td>
	     <td><%=result.getTime("deptDateTime") %></td></tr>
	     <%

	}
	
    result.close();
    stmt.close();
    conn.close();}
}catch(Exception e)
{
    e.printStackTrace();
    }
%>
</tbody>
</table>

<h2>All train schedules who's origin is
<%= request.getParameter("originStat") %></h2><br>

<table style="border-collapse:collapse">
<thead>
<tr>
<td>Transit Line</td>
<td>Schedule ID</td>
<td>Train ID</td>
<td>Station ID</td>
<td>City</td>
<td>Station</td>
<td>State</td>
<td>Arrival Time</td>
<td>Departure Time</td>
</tr>
</thead>
<tbody>
<%
try
{
	String station = request.getParameter("originStat");
	if(station==(null)){
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else if(station.equals("-1")){
		session.setAttribute("message", "Selection Invalid: Please Select Station.");
		response.sendRedirect("TrainScheduleSearchCustomerRep.jsp");
	}
	else{
	DBConnection db = new DBConnection();	
	Connection conn = db.getConnection();
	Statement stmt = conn.createStatement();
	String str = String.format("SELECT DISTINCT trainID, city, Station.name name, state, sa.scheduleID scheduleID, transitLineName, sa.stationID stationID, arrDateTime, deptDateTime FROM StopsAt sa join Station on Station.stationID = sa.stationID join TrainSchedule on TrainSchedule.scheduleID = sa.scheduleID WHERE sa.StopNum >=(select stopNum from StopsAt join Station on Station.stationID=StopsAt.stationID where Station.name = '%s' and StopsAt.scheduleID = sa.scheduleID) order by sa.scheduleID, sa.stopNum",station);
	ResultSet result = stmt.executeQuery(str);
	String curTLine = "";
	while(result.next())
	{
	%>
	
	    <tr style="<% if (!curTLine.equals(result.getString("transitLineName"))) {
		    curTLine = result.getString("transitLineName");
	    %>
	    	border-top: 1pt solid black;
	    <%}%>
	    ">
	     <td><%=curTLine %></td>
	     <td><%=result.getInt("scheduleID") %></td>
	     <td><%=result.getInt("trainID") %></td>
	     <td><%=result.getInt("stationID") %></td>
	     <td><%=result.getString("city") %></td>
	     <td><%=result.getString("name") %></td>
	     <td><%=result.getString("state") %></td>
	     <td><%=result.getTime("arrDateTime") %></td>
	     <td><%=result.getTime("deptDateTime") %></td></tr>
	     <%

	}
	
    result.close();
    stmt.close();
    conn.close();}
}catch(Exception e)
{
    e.printStackTrace();
    }
%>
</tbody>
</table>


</body>
<% } %>
</html>