<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Rep. Panel</title>
<style><%@include file="./css/style.css"%></style>
</head>
<body>
	<a href="CustomerRep.jsp"><button>Go back to Panel</button></a>
	<h2>Unanswered Questions</h2>
	<table>
        <thead>
            <tr>
                <th>User Name</th>
                <th>Question</th>
                <th>Respond</th>
            </tr>
        </thead>
        <tbody>
        <% 
			DBConnection db = new DBConnection();	
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			String str = "select * from Questions where answer is null";
			ResultSet result = stmt.executeQuery(str);
			while(result.next()) { %>
				<tr>
                    <td><%= result.getString("username")%></td>
                    <td><%= result.getString("question")%></td>
                    <form method="POST" action="qanda">
                    <input type="hidden" name=id value=<%= result.getInt("questionID")%>></input>
                    <td><input name="answer" type=text></input></td>
                    <td><button>Send</button></td>
                    </form>
                </tr>
		<%	}
			//close the connection.
			conn.close();
		%>
        </tbody>
    </table>
    <h2>Answered Questions</h2>
	<table>
        <thead>
            <tr>
                <th>User Name</th>
                <th>Question</th>
                <th>Answer</th>
            </tr>
        </thead>
        <tbody>
        <% 
			db = new DBConnection();	
			conn = db.getConnection();
			stmt = conn.createStatement();
			str = "select * from Questions where answer is not null";
			result = stmt.executeQuery(str);
			while(result.next()) { %>
				<tr>
                    <td><%= result.getString("username")%></td>
                    <td><%= result.getString("question")%></td>
                    <td><%= result.getString("answer")%></td>
                </tr>
		<%	}
			//close the connection.
			conn.close();
		%>
        </tbody>
    </table>
</body>
</html>