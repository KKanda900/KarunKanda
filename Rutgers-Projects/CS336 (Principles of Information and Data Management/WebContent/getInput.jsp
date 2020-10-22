<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*, java.util.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Get Question</title>
</head>
<body>
<%
	String question = request.getParameter("Question");
	String answer = null;
	int id = (int)Math.random();
	String username = (String)session.getAttribute("LOGGED_IN");
	String user = username;
	String SSN = "111-11-1112";
%>
<%
	DBConnection db = new DBConnection();
	Connection conn = db.getConnection();
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement("INSERT INTO Questions (questionID, question, answer, username, ssn) VALUES (?, ?, ?, ?, ?)");
	stmt.setInt(1, id);
	stmt.setString(2, question);
	stmt.setString(3, answer);
	stmt.setString(4, user);
	stmt.setString(5, SSN);
	stmt.executeUpdate();
	stmt.clearParameters();
	stmt.close();
	conn.close();
	response.sendRedirect("QuestionsPage.jsp");
%>
</body>
</html>