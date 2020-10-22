<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Support Page</title>
</head>
<body>
<style>
title, h1, h2, label, p{
	font-family: "Raleway", sans-serif;	
}

.topnav {
  font-family: "Raleway", sans-serif;
  overflow: hidden;
}


form  { display: table;      }


input[type=text], input[type=password], input[type=email] {
  width: 100%;
  padding: 12px 14px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  box-sizing: border-box;
}
input[type=text]:focus, input[type=password]:focus, input[type=email]:focus {
  border: 3px solid #555;
}
input[type=submit] {
  width: 100%;
  background-color: #0080c0;
  border: none;
  color: white;
  padding: 16px 32px;
  text-decoration: none;
  margin: 4px 2px;
  cursor: pointer;
}


/* Add a hover effect for buttons */
submit:hover {
  opacity: 0.8;
}

table{
	border: solid 2px;
}

.split {
  height: 100%;
  width: 50%;
  position: fixed;
  z-index: 1;
  top: 0;
  overflow-x: hidden;
  padding-top: 20px;
  border: solid 1px;
}

.left {
  left: 0;
  background-color: #F0F8FF;
}

.right {
  right: 0;
  background-color: lightblue;
}

table, th, td{
	background-color: white;
}




</style>

<div class = "split left">
<div class = "topnav">
	<a class="active" href="index.jsp">Home</a>
  <a href="Logout.jsp">Logout</a>
</div>
<h1>Welcome <% String user = (String)session.getAttribute("LOGGED_IN"); /*String user = null; String admin = "Bob Saget";*/ out.print(user); %> to the Customer Support Page</h1>
	<b><i>Where the customer is always first! Write your question in the box and an employee will get back to you shortly.</i></b>
<p>
	<form action='getInput.jsp' method='GET'>
		Type your question here and don't forget to hit enter: <input type = "text" id = "Question" name = "Question" placeholder = "type your question here">
	</form>
</p>

<p>Check if your train is delayed below</p>
<%
String[] arr = new String[50];
String[] arr2 = new String[50];
String[] arr3  = new String[50];
int i = 0;
DBConnection db = new DBConnection();	
Connection conn = db.getConnection();
String str = String.format("SELECT TrainSchedule.isDelayed, TrainSchedule.transitLineName, Reservation.dateCreated FROM Reservation, TrainSchedule WHERE Reservation.username = '%s' AND Reservation.scheduleID = TrainSchedule.scheduleID", user);
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(str);
while(rs.next()){
	String delay = rs.getString("TrainSchedule.isDelayed");
	String train = rs.getString("TrainSchedule.transitLineName");
	String date = rs.getString("Reservation.dateCreated");
	if(delay != null && train != null && date != null){
		arr[i] = delay;
		arr2[i] = train;
		arr3[i] = date;
	} else {
		break;
	}
	i++;
}
%>
<p align = "center">
	<%
	if(arr[0] == null){
		out.print("All of your trains are running on time!");
	}
	for(int j = 0; j <= arr.length - 1; j++){
		if(arr[j] == null){
			break;
		} else {
			out.print("Your reservation that was reserved on" + " " + arr3[j] + "," + " " + arr2[j] + "is delayed" + " " + "because" + " " + arr[j] + "<br>");
		}
	} %>
</p>

</div>

<div class = "split right">
<p>Looking for a Question/Answer? Type it in the search bar.</p>
<input type ="text" id="myInput" onkeyup="lookAtTable()" placeholder="search for a question..." title = "Type in a question">
<form method="post">
<b><u>Forum Page:</u></b><br><table name = "Q&A" id="QuestionsTable">
	<tr>
	<th>Username</th>
	<th>Question</th>
	<th>Answer</th>
	</tr>
	<%
	db = new DBConnection();	
	conn = db.getConnection();
	str = "SELECT question, answer, username, questionID FROM Questions";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(str);
	while(rs.next()){ %>
		<tr>
		<td><%out.print(rs.getString("username")); %></td>
		<td><%out.print(rs.getString("question"));%></td>
		<td><%
		if(rs.getString("answer") == null){
			out.print("No Response");
		} else {
			out.print(rs.getString("answer")); 
		}
			%></td>
		</tr>
	<% 
	}
	%>
</table>
<%
rs.close();
stmt.close();
stmt.close();
conn.close();
%>
</form>
<script>
function lookAtTable(){
	var filter = document.getElementById('myInput').value.toLowerCase();
	var tableValue = document.getElementById('QuestionsTable');
	var tr = QuestionsTable.getElementsByTagName('tr');
	var on = 0;
	for(var i = 0; i <tr.length; i++){
		var td = tr[i].getElementsByTagName('td')[1];
		if(td){
			var textValue = td.textContent || td.innerHTML;
			if(textValue.toLowerCase().indexOf(filter) > -1){
				tr[i].style.display = "";
				on++;
			} else{
				tr[i].style.display = "none";
			}
		}
	}
	
}
</script>

</div>

</body>
</html>
