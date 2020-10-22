<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
</head>
<body>
<% if(request.getParameter("create") != null) {
	if(request.getParameter("stops") != null) {%>
	<h2>Creating new schedule.</h2>
		<form action='SchedulesCustomerRep' method=POST>
			<label>Train: </label>
				<select name="train">
				<%ResultSet Trains = ScheduleManagement.getTrains(); while(Trains.next()) {%>
					<option><%=Trains.getString("trainID")%></option>
				<% } %>
				</select><br><br>
			<label>Transit Line (used for fee calculation and line association.): </label>
				<select name="tLine">
				<%ResultSet tLines = ScheduleManagement.getTLines(); while(tLines.next()) {%>
					<option><%=tLines.getString("transitLineName")%></option>
				<% } %>
				</select>
			<br><br><label>Stops / Stations: </label><br><br>
			<% for(int i = 0; i<Integer.parseInt(request.getParameter("stops")); i++) { %>
				<label>Stop / Station <%=(i+1) %> : </label>
				<select name="s<%=(i+1) %>">
				<%ResultSet Stations = ScheduleManagement.getStations(); while(Stations.next()) {%>
					<option><%=Stations.getString("name")%></option>
				<% } %>
				</select>
				<label> Arrival: </label><input required type=time name="at<%=(i+1) %>"></input>
				<label> Departure: </label><input required type=time name="dt<%=(i+1) %>"></input>
				<br><br>
			<% } %>
			<button type=submit name="create" value="">Continue</button>
		</form>
	<% }else{%>
		<form action='ManageSchedules.jsp'>
			<label>Number of stops: </label>
			<input required name="stops" type="number" min="2" max="20"></input>
			<button type=submit name="create" value="">Continue</button>
		</form>
	<% }%>

<% }else if(request.getParameter("edit") != null) { %>
		<h2>Now editing Schedule <%=request.getParameter("edit") %>.</h2>
		<form action='SchedulesCustomerRep' method=POST>
			<input type="hidden" name="edit" value=""></input>
			<input type="hidden" name="schID" value="<%=request.getParameter("edit") %>"></input>
			<label>Train: </label>
				<select name="train">
				<%ResultSet sch = ScheduleManagement.getSchedule(request.getParameter("edit")); sch.next(); ResultSet Trains = ScheduleManagement.getTrains(); while(Trains.next()) {%>
					<option <% if(sch.getString("trainID").equals(Trains.getString("trainID"))) {out.print("selected");} %>><%=Trains.getString("trainID")%></option>
				<% } %>
				</select><br><br>
			<label>Transit Line (used for fee calculation and line association.): </label>
				<select name="tLine">
				<%ResultSet tLines = ScheduleManagement.getTLines(); while(tLines.next()) {%>
					<option <% if(sch.getString("transitLineName").equals(tLines.getString("transitLineName"))) {out.print("selected");} %>><%=tLines.getString("transitLineName")%></option>
				<% } %>
				</select>
			<br><br><label>Stops / Stations: </label><br><br>
			<% ResultSet result = ScheduleManagement.getStops(request.getParameter("edit")); int i = 0; String lTime = "0:00";while(result.next()) { %>
				<label>Stop / Station <%=(i+1) %> : </label>
				<select name="s<%=(i+1) %>">
				<%ResultSet Stations = ScheduleManagement.getStations(); while(Stations.next()) {%>
					<option <% if(Stations.getString("name").equals(result.getString("name"))) {out.print("selected");} %>><%=Stations.getString("name")%></option>
				<% } DateFormat df = new SimpleDateFormat("HH:mm:ss"); lTime = df.format(result.getDate("deptDatetime"));%>
				</select>
				<label> Arrival: </label><input value=<%= df.format(result.getDate("arrDatetime")) %> required type=time name="at<%=(i+1) %>"></input>
				<label> Departure: </label><input value=<%= lTime %> required type=time name="dt<%=(i+1) %>"></input>
				<br><br>
			<% i++; } %>
			<button type="submit" name="DELETE" value=<%=i%>>DELETE LAST STOP</button>
			<button type=submit name="update" value="">Continue</button>
		</form>
		<form action='SchedulesCustomerRep' method=POST>
			<input type="hidden" name="edit" value=""></input>
			<input type="hidden" name="schID" value="<%=request.getParameter("edit") %>"></input>
			<input type="hidden" name="lastTime" value=<%=lTime %>>></input>
			<label>Stop / Station <%=(i+1) %> : </label>
				<select name="s<%=(i+1) %>">
				<%ResultSet Stations = ScheduleManagement.getStations(); while(Stations.next()) {%>
					<option><%=Stations.getString("name")%></option>
				<% } %>
				</select>
				<label> Arrival: </label><input required type=time name="at<%=(i+1) %>"></input>
				<label> Departure: </label><input required type=time name="dt<%=(i+1) %>"></input>
				<button type=submit name="add" value="<%=(i+1) %>">Add</button>
				<br><br>
		</form>
 <% } 
String message = (String)session.getAttribute("message");
if(message != null) {
	session.removeAttribute("message");
	out.print(message);
 } %>
</body>
</html>