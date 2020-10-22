<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>Log out</title>
</head>
<body>
	<%
		session.invalidate();
		response.sendRedirect("index.jsp");
	%>
</body>
</html>