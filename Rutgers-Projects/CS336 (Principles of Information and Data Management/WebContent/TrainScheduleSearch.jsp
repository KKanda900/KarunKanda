<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/scheduletable.css"%></style>
<title>Train Schedule Search</title>
</head>
<body>
<h2>Search For Train Schedule</h2>
	 <form action='scheduleOutput.jsp' method='POST'>
		<label for='orig'>Origin Station:</label>
		
		<select name="originStat">
                <option value="-1">Select Station</option>
<%
		
		try {
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = ("SELECT * FROM Station order by name asc");
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option><%=result.getString("name")%></option>
					<% 
				}conn.close();
	} catch (Exception e) {
	} 
	%> </select><br><br>
	
	<label for='dest'>Destination Station:</label>
	<select name="destinStat">
    <option value="-1">Select Station</option>
<%
		
		try {
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = "SELECT * FROM Station order by name asc";
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option><%=result.getString("name") %></option>
					<%
				}conn.close();	
				
	} catch (Exception e) {
	} %>		</select><br><br>
	
	<label for='datetrav'>Date of Travel:</label>
	<input type="date" id='dateTravel' name='datetrav'><br><br>
  	 
      <a href="trainLineMap.html">Map of Transit Lines</a><br><br>
	
	<input type="submit" value="View Schedule">

  	</form> <br>
  	<%
String message = (String)session.getAttribute("message");
if(message != null) {
	session.removeAttribute("message");
	out.print(message);
}
%>
</body>
</html>