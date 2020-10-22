<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" import = "com.cs336proj.root.ScheduleManagement"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*,java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/scheduletable.css"%></style>
<title>Insert title here</title>
<script src="https://www.w3schools.com/lib/w3.js"></script>
</head>
<body>

<h2>Train Schedule</h2>
<%= request.getParameter("originStat") %> to
<%= request.getParameter("destinStat") %> on
<%= request.getParameter("datetrav") %><br>

<form method="post">

<table id = "myTable">
<thead>
<tr>
<td>Schedule ID</td>
<td>Station ID</td>
<td>City</td>
<td onclick="w3.sortHTML('#myTable','.item', 'td:nth-child(4)')" style="cursor:pointer">Station</td>
<td>State</td>
<td onclick="w3.sortHTML('#myTable','.item', 'td:nth-child(6)')" style="cursor:pointer">Arrival Time</td>
<td onclick="w3.sortHTML('#myTable','.item', 'td:nth-child(7)')" style="cursor:pointer">Departure Time</td>
</tr>
</thead>

<%
ArrayList<Integer> schedID = new ArrayList<Integer>();
ArrayList<Integer> freq = new ArrayList<Integer>();
ArrayList<String> times = new ArrayList<String>();
ArrayList<Integer> statID = new ArrayList<Integer>();
ArrayList<Integer> stopNum = new ArrayList<Integer>();
ArrayList<String> transitName = new ArrayList<String>();
try
{
	
	String origin = request.getParameter("originStat");
	String destin = request.getParameter("destinStat");
	String date = request.getParameter("datetrav");
	if(origin==(null) || destin==(null) || date ==(null)){
		response.sendRedirect("TrainScheduleSearch.jsp");
	}
	else if(origin.equals("-1") || destin.equals("-1")){
		session.setAttribute("message", "Selection Invalid: Please Select Origin and Destination Stations");
		response.sendRedirect("TrainScheduleSearch.jsp");
	}
	else if(date.equals("")){
		session.setAttribute("message", "Selection Invalid: Please Enter Date of Travel");
		response.sendRedirect("TrainScheduleSearch.jsp");
	}
	else{
	DBConnection db = new DBConnection();	
	Connection conn = db.getConnection();
	Statement stmt = conn.createStatement();
	//String str = String.format("SELECT * FROM Station WHERE stationID BETWEEN(SELECT stationID FROM Station WHERE name='%s') AND (SELECT stationID FROM Station WHERE name='%s')",origin,destin,destin,origin);
	//String str = String.format("SELECT * FROM Station WHERE (stationID BETWEEN(SELECT stationID FROM Station WHERE name='%s') AND (SELECT stationID FROM Station WHERE name='%s')) AND ((SELECT TrainSchedule.scheduleID FROM TrainSchedule RIGHT OUTER JOIN StopsAt ON TrainSchedule.scheduleID IN (SELECT StopsAt.scheduleID FROM StopsAt INNER JOIN  Station ON StopsAt.stationID IN (SELECT stationID FROM Station WHERE Station.name= '%s'))) IN ((SELECT TrainSchedule.scheduleID FROM TrainSchedule INNER JOIN StopsAt ON TrainSchedule.scheduleId IN (SELECT StopsAt.scheduleID FROM StopsAt INNER JOIN  Station ON StopsAt.stationID IN (SELECT stationID FROM Station WHERE Station.name= '%s')));",origin,destin,origin,destin);
	//String str = String.format("SELECT * FROM StopsAt WHERE StopsAt.stationID IN (SELECT stationID FROM Station WHERE name = '%s');", origin);
	//String str = String.format("SELECT distinct scheduleID, Station.stationID,city,name, state FROM Station RIGHT OUTER JOIN StopsAt ON Station.stationID IN (SELECT StopsAt.stationID FROM StopsAt WHERE StopsAt.stopNum BETWEEN (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) AND (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) and StopsAt.stationID BETWEEN (SELECT DISTINCT StopsAt.stationID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) AND (SELECT DISTINCT StopsAt.stationID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) ) where Station.stationID is not null and StopsAt.scheduleID in (SELECT t.scheduleID from ((select StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))t join (SELECT DISTINCT StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))s on t.scheduleID = s.scheduleID)) group BY StopsAt.scheduleID, Station.stationID",origin,destin,origin,destin,origin,destin);
	//String str = String.format("SELECT Distinct * FROM StopsAt WHERE StopsAt.stopNum BETWEEN (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) AND (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s')) and StopsAt.scheduleID in (SELECT t.scheduleID from ((select StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))t join (SELECT DISTINCT StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))s on t.scheduleID = s.scheduleID))order by scheduleID, stopNum",origin,destin,origin,destin);
	
	///String str = String.format("select distinct * from StopsAt sa where sa.scheduleID in (Select distinct StopsAt.scheduleID from StopsAt where StopsAt.scheduleID in (SELECT t.scheduleID from ((select StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))t join (SELECT DISTINCT StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))s on t.scheduleID = s.scheduleID))) and sa.stopNum between (select se.stopNum from StopsAt se where se.scheduleID = sa.scheduleID and se.stationID =(select Station.stationID from Station where Station.name = '%s')) and (select se.stopNum from StopsAt se where se.scheduleID = sa.scheduleID and se.stationID =(select Station.stationID from Station where Station.name ='%s')) order by sa.scheduleID, sa.stopNum",origin,destin,origin,destin);
	
	///ResultSet result = stmt.executeQuery(str);

	//String str2 = String.format("select arrDatetime, deptDatetime, scheduleID, stationID FROM StopsAt where StopsAt.scheduleID in (select distinct scheduleID from Station JOIN StopsAt on Station.stationID in (select distinct StopsAt.stationID FROM StopsAt where StopsAt.stopNum between(select DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT stationID FROM Station WHERE name='%s')) AND (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT stationID FROM Station WHERE name='%s')))) and StopsAt.stationID in ((select distinct StopsAt.stationID FROM StopsAt where StopsAt.stopNum between(select DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT stationID FROM Station WHERE name='%s')) AND (SELECT DISTINCT StopsAt.stopNum FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT stationID FROM Station WHERE name='%s')))) order by scheduleID,stationID",origin,destin,origin,destin);
	//Statement stmt2 = conn.createStatement();
	//ResultSet result2 = stmt2.executeQuery(str2);
	ResultSet result = ScheduleManagement.getSchedule(origin, destin);
	while(result.next())
	{
	
		schedID.add(result.getInt("scheduleID"));
		statID.add(result.getInt("stationID"));
		stopNum.add(result.getInt("stopNum"));
	
	}
	
	for(int i = 0; i<schedID.size();i++){
		String str4 = String.format("select * FROM StopsAt where StopsAt.scheduleID = '%d' and StopsAt.stopNum = '%d'",schedID.get(i),stopNum.get(i));
		Statement stmt4 = conn.createStatement();
		ResultSet result4 = stmt4.executeQuery(str4);
		String str5 = String.format("select * From Station where Station.stationID = '%d'",statID.get(i));
		Statement stmt5 = conn.createStatement();
		ResultSet result5 = stmt5.executeQuery(str5);
		if(result4.next()&&result5.next()){
			//4,5,5,5,5,4,4
		%>
		<tbody>
		    <tr class= "item">
		     <td><%=result4.getInt("scheduleID") %></td>
		     <td><%=result5.getInt("stationID") %></td>
		     <td><%=result5.getString("city") %></td>
		     <td><%=result5.getString("name") %></td>
		     <td><%=result5.getString("state") %></td>
		     <td><%=result4.getTime("arrDatetime") %></td>
		     <td><%=result4.getTime("deptDatetime") %></td>
		 </tr>
		</tbody>        <%
		}
	}
		
		%>
		    </table>
		    <%
	
    result.close();
    stmt.close();
    conn.close();}
	
	Set<Integer> unique = new HashSet<Integer>(schedID);
	for (int key : unique) {
	  freq.add(Collections.frequency(schedID, key));
	}
}catch(Exception e)
{
    e.printStackTrace();
    }

%>
<h2>Fares for this Trip</h2>
<table id = "secondTable">
<thead>
<tr>
<td>Schedule ID</td>
<td>Transit Line</td>
<td>Train ID</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(4)')" style="cursor:pointer">Total Travel Time</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(5)')" style="cursor:pointer" >Adult One Way</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(6)')" style="cursor:pointer" >Adult Business Class</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(7)')" style="cursor:pointer" >Adult First Class</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(8)')" style="cursor:pointer">Senior One Way</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(9)')" style="cursor:pointer">Disabled One Way</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(10)')" style="cursor:pointer">Child One Way</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(11)')" style="cursor:pointer">Weekly One Way</td>
<td onclick="w3.sortHTML('#secondTable','.item', 'td:nth-child(12)')" style="cursor:pointer">Monthly One Way</td>
</tr>
</thead>
<%

try{
	String origin = request.getParameter("originStat");
	String destin = request.getParameter("destinStat");
	
	int freqIndex = 0;
	NumberFormat formatter = NumberFormat.getCurrencyInstance();
	Set<Integer> unique = new HashSet<Integer>(schedID);
	for(int key : unique){
	DBConnection db = new DBConnection();	
	Connection conn = db.getConnection();
	Statement stmt = conn.createStatement();
	String str = String.format("SELECT* FROM TrainSchedule WHERE scheduleID ='%d'",key);
	String str5 = String.format("SELECT * FROM TransitLine join TrainSchedule on TransitLine.transitLineName=TrainSchedule.transitLineName where TrainSchedule.scheduleID = '%d'",key);
	String str3 = String.format("SELECT StopsAt.scheduleID, timestampdiff(Minute ,(Select arrDatetime from StopsAt where StopsAt.stationID = (Select Station.stationID From Station where name = '%s') and scheduleID='%d'), (Select StopsAt.arrDatetime from StopsAt where StopsAt.stationID = (Select Station.stationID From Station where name = '%s') and scheduleID='%d')) as diff FROM StopsAt Group by scheduleID",origin,key,destin,key);
	ResultSet result = stmt.executeQuery(str);
	
	Statement stmt3 = conn.createStatement();
	ResultSet result3 = stmt3.executeQuery(str3);
	
	Statement stmt5 = conn.createStatement();
	ResultSet result5 = stmt5.executeQuery(str5);
	
	int k=0;
	while(result.next())
	{
	schedID.add(result.getInt("scheduleID"));
	if(result3.next() && result5.next()){
	
	%>
	<tbody>
	    <tr class = item>
	     <td><%=result.getInt("scheduleID") %></td>
	     <td><%=result5.getString("transitLineName") %></td>
	     <td><%=result.getInt("trainID") %></td>
	     <td><%=(result3.getInt("diff")/60)+" Hour(s) "+(result3.getInt("diff")%60)+" Minutes" %></td>
	     <td><%=formatter.format(result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     <td><%=formatter.format(result5.getDouble("fare")*freq.get(freqIndex)*1.5) %></td>
	     <td><%=formatter.format(result5.getDouble("fare")*freq.get(freqIndex)*2) %></td>
	     <td><%=formatter.format((1-result5.getDouble("seniorDiscount"))*result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     <td><%=formatter.format((1-result5.getDouble("disabilityDiscount"))*result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     <td><%=formatter.format((1-result5.getDouble("childDiscount"))*result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     <td><%=formatter.format((1-result5.getDouble("weeklyDiscount"))*7*result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     <td><%=formatter.format((1-result5.getDouble("monthlyDiscount"))*30*result5.getDouble("fare")*freq.get(freqIndex)) %></td>
	     </tr>
	</tbody>        <%
	k++;
	}}
	freqIndex++;
    result.close();
    stmt.close();
    conn.close();
	}
}catch(Exception e)
{
    e.printStackTrace();
    }

%>
</table>
<%

%></form>
</body>
</html>