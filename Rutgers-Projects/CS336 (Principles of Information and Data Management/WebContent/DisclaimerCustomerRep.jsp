<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="ISO-8859-1">
		<style>
			<%@ include file="./css/style.css"%>
		</style>
		<title>Train Schedule Delay Notification Panel</title>
	</head>
	<body>
		<%
			String user = (String) session.getAttribute("LOGGED_IN");
		%>
		<h1>List of Train Schedules</h1>
		<%
			//Get the database connection
			DBConnection db = new DBConnection();
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			String str = "SELECT scheduleID, trainID, transitLineName, travelTime, isDelayed from TrainSchedule";
			ResultSet result = stmt.executeQuery(str);
		%>
		<br>
	
		<div>
			<form action="SchedulesCustomerRep" id="DELETE_FORM"></form>
			<form action="SchedulesCustomerRep" method=POST id="POST_FORM"></form>
			<table style="width: 100%">
				<thead>
					<tr>
						<td><b>Schedule ID</b></td>
						<td><b>Train ID</b></td>
						<td><b>Transit Line Name</b></td>
						<td><b>Total Travel Time</b></td>
						<td><b>Delay Message</b></td>
					</tr>
				</thead>
				<tbody>
					<%
						while (result.next()) {
							String sch_id = result.getString(1);
					%>
	
					<%
						String message = result.getString(5);
							if (message != null) {
					%>
	
					<tr>
						<td><%=sch_id%></td>
						<td><%=result.getString(2)%></td>
						<td><%=result.getString(3)%></td>
						<td><%=result.getString(4)%></td>
						<td><%=message%></td>
						<td><input type="hidden" form="DELETE_FORM" name="action"
							value="DELETEDELAY" />
						<button form="DELETE_FORM" name="sch_id" value="<%=sch_id%>">Remove
								Delay</button></td>
					</tr>
					<%
						} else {
					%>
	
					<tr>
						<td><%=sch_id%></td>
						<td><%=result.getString(2)%></td>
						<td><%=result.getString(3)%></td>
						<td><%=result.getString(4)%></td>
						<td><input form="POST_FORM" name="message<%=sch_id%>" type=text></input></td>
						<td><button form="POST_FORM" name="sch_id" value="<%=sch_id%>">Send
								Delay</button></td>
					</tr>
					<%
						}
						}
					%>
				</tbody>
			</table>
			<%
				result.close();
				conn.close();
			%>
		</div>
		<br>
	</body>
</html>