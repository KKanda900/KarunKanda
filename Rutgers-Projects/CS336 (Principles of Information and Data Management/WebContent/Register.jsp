<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" import="com.cs336proj.root.Validation" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>Customer Register</title>
</head>
<body>
	<%
		try {
			String usrname = request.getParameter("username");
			String pass = request.getParameter("password");
			String email = request.getParameter("email") == null ? "" : request.getParameter("email");
			String fName = request.getParameter("fName") == null ? "" : request.getParameter("fName");
			String lName = request.getParameter("lName") == null ? "" : request.getParameter("lName");
			String address = request.getParameter("address") == null ? "" : request.getParameter("address");
			String state = request.getParameter("state") == null ? "" : request.getParameter("state");
			String zip = request.getParameter("zip") == null ? "" : request.getParameter("zip");
			String city = request.getParameter("city") == null ? "" : request.getParameter("city");
			String phone = request.getParameter("phone") == null ? "" : request.getParameter("phone");
			if(usrname != null && pass != null) {
				Validation.checkEmail(email);
				Validation.checkAddress(address);
				Validation.checkName(fName, lName);
				Validation.checkState(state);
				Validation.checkZipCode(zip);
				Validation.checkCity(city);
				Validation.checkPhoneNumber(phone);
				Validation.checkLength(address, email, fName, lName, zip, state, city, phone, usrname, pass);
				//Get the database connection
				DBConnection db = new DBConnection();	
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = String.format("INSERT INTO Customer(username, password, emailAddress, firstName, lastName, address, state, zipCode, city, telephone) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')", usrname, pass, email, fName, lName, address, state, zip, city, phone);
				stmt.execute(str);
				session.setAttribute("LOGGED_IN", usrname);
				response.sendRedirect("index.jsp");
				//close the connection.
				conn.close();
			}else{ 
			%>
				<h1>Customer Register</h1>
				<form action='Register.jsp' method='POST'>
				<label for='email'>Email:</label>
				<input type='email' id='email' name='email'><br><br>
				<label for='fName'>First Name:</label>
				<input type='text' id='fName' name='fName'><br><br>
				<label for='lName'>Last Name:</label>
				<input type='text' id='lName' name='lName'><br><br>
				<label for='address'>Address:</label>
				<input type='text' id='address' name='address'><br><br>
				<label for='state'>State:</label>
				<input type='text' id='state' name='state' maxlength='2' minlength='2' size='2'><br><br>
				<label for='zip'>Zip Code:</label>
				<input type='text' id='zip' name='zip' maxlength='5' minlength='5' size='5'><br><br>
				<label for='city'>City:</label>
				<input type='text' id='city' name='city'><br><br>
				<label for='phone'>Phone Number:</label>
				<input type='text' id='phone' name='phone' maxlength='10' minlength='10'><br><br>
				<label for='username'>Username:</label>
				<input type='text' id='username' name='username'><br><br>
				<label for='pass'>Password:</label>
				<input type='password' id='pass' name='password'><br><br>
				<input type='submit' value='Submit'>
				</form></br>
			<% String message = (String)session.getAttribute("message");
			if(message != null) {
				session.removeAttribute("message");
				out.print(message);
			}
		}
	} catch (SQLException e) {
		session.setAttribute("message", String.format("%s [%s]","Err... Something went wrong while creating your account... ",e.getMessage()));
		response.sendRedirect("Register.jsp");
	} %>
</body>
</html>