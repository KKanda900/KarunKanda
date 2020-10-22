<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Seat Reservations</title>
<style><%@include file="./css/style.css"%></style>
</head>
<% if(request.getParameter("train") != null && request.getParameter("tLine") != null) { 
	if(request.getParameter("train").equals("-1") || request.getParameter("tLine").equals("-1")){
		session.setAttribute("message", "Selection Invalid: Please Select Origin and Destination Stations");
		response.sendRedirect("ViewSeats.jsp");
	} else { String train = request.getParameter("train"); String tLine = request.getParameter("tLine");
	%>

<body>
	<h2>Seat Reservations for train <%=train%> and transit line <%=tLine%>:</h2>
	<p>*Monthly / Weekly reservers are free to ride on other trains and their schedules, however won't have a seat reserved there.</p>
	<table>
        <thead>
            <tr>
                <th>Train ID</th>
                <th>Transit Line</th>
                <th>Seat Number</th>
                <th>Username</th>
                <th>Transit Line</th>
                <th>Reservation Length</th>
            </tr>
        </thead>
        <tbody>
        <% 
			DBConnection db = new DBConnection();	
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			String str = String.format("SELECT trainID, transitLineName, seatNumber, username, class, reservationLength from Reservation r join TrainSchedule ts on r.scheduleID = ts.scheduleID where seatNumber is not null and transitLineName='%s' and trainID='%s' order by transitLineName, trainID",tLine,train);
			ResultSet result = stmt.executeQuery(str);
			while(result.next()) { %>
				<tr>
                    <td><%= result.getString("trainID")%></td>
                    <td><%= result.getString("transitLineName")%></td>
                    <td><%= result.getString("seatNumber")%></td>
                    <td><%= result.getString("username")%></td>
                    <td><%= result.getString("class")%></td>
                    <td><%= result.getString("reservationLength")%></td>
                </tr>
		<%	}
			//close the connection.
			conn.close();
		%>
        </tbody>
    </table>
</body>
<% }} else {%>
<body>
	<h2>Seat Reservations by train and transit line.</h2>
	 <form action='ViewSeats.jsp'>
		<label for='orig'>Train:</label>
		
		<select name="train">
                <option value="-1">Select Train</option>
<%
		
		try {
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = ("SELECT * FROM Train");
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option><%=result.getString("trainID")%></option>
					<% 
				}conn.close();
	} catch (Exception e) {
	} 
	%> </select><br><br>
	
	<label for='dest'>Transit Line:</label>
	<select name="tLine">
    <option value="-1">Select Transit Line</option>
<%
		
		try {
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = "SELECT * FROM TransitLine";
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option><%=result.getString("transitLineName") %></option>
					<%
				}conn.close();	
				
	} catch (Exception e) {
	} %>		</select><br><br>
  	
	<input type="submit" value="View Reservations">

  	</form> <br>
	<%String message = (String)session.getAttribute("message");
	if(message != null) {
		session.removeAttribute("message");
		out.print(message);
	}%>
</body>
<% } %>
</html>