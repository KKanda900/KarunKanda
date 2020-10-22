<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>Internal Login</title>
</head>
<body>
	<%
		try {
			String usrname = request.getParameter("username");
			String pass = request.getParameter("password");
			if(usrname != null && pass != null) {
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = String.format("(select distinct 'R' userType from Employee e, CustomerRepresentative cr where e.ssn = cr.ssn and username='%s' and password='%s') union (select distinct 'A' userType from Employee e, Admin a where e.ssn = a.ssn and username='%s' and password='%s')", usrname, pass, usrname, pass);
				ResultSet result = stmt.executeQuery(str);
				if(result.next()) {
					session.setAttribute("LOGGED_IN", usrname);
					session.setAttribute("type", result.getString("userType").charAt(0));
					response.sendRedirect("index.jsp");
				}else{
					session.setAttribute("message", "Wrong username or password!");
					response.sendRedirect("lLogin.jsp");
				}
				//close the connection.
				conn.close();
			}else{ 
			%>
				<h1>Internal Login</h1>
				<h3>(For admins, and Customer Reps only!)</h3>
				<form action='lLogin.jsp' method='POST'>
				<label for='username'>Username:</label>
				<input type='text' id='username' name='username'><br><br>
				<label for='pass'>Password:</label>
				<input type='password' id='pass' name='password'><br><br>
				<input type='submit' value='submit'>
				</form></br>
				<a href=Login.jsp><p>External Login?</p></a>
			<% String message = (String)session.getAttribute("message");
			if(message != null) {
				session.removeAttribute("message");
				out.print(message);
			}
		}
	} catch (Exception e) {
	} %>
</body>
</html>