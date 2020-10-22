<% //CREATE RESERVATION MADE BY: NICHOLAS MEEGAN %>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style><%@include file="./css/style.css"%></style>
<title>Create Reservation</title>
</head>
<body>
		<%
		try {
			String resNum = request.getParameter("resNum");
			String user = request.getParameter("person");
			String scheduleID = request.getParameter("schedID");
			String age = request.getParameter("age");
			String isDisabled =request.getParameter("isDisabled");
			String tripType = request.getParameter("tripType");
			String classType = request.getParameter("classType");
			String timeLength = request.getParameter("timeLength");
			String origin = request.getParameter("originStat");
			String destin = request.getParameter("destinStat");
			String startDate = request.getParameter("datetrav");
			double farePrice = 0;
			double bookingFee = 0;
			String time = "";
			String seatNumber = "";
			String maxSeats = "";
			String originID = "";
			String destinID = "";
			DBConnection db = new DBConnection();	
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			String str; 
			boolean canMake = true;
			if(age != null) {
				//Get origin ID of station name given
				str = String.format("SELECT stationID from Station where name = '%s'", origin);
				ResultSet result = stmt.executeQuery(str);
				while(result.next())
				{
					originID = result.getString(1);
				}
				//Get destination ID of station name given
				str = String.format("SELECT stationID from Station where name = '%s'", destin);
				result = stmt.executeQuery(str);
				while(result.next())
				{
					destinID = result.getString(1);
				}
				
				String multiplier = "";
				str = String.format("select count(*) from StopsAt where scheduleID = '%s' and stopNum between (select stopNum from StopsAt where scheduleID = '%s' and stationID = '%s') and (select stopNum from StopsAt where scheduleID = '%s' and stationID = '%s')", scheduleID, scheduleID, originID, scheduleID, destinID);
				result = stmt.executeQuery(str);
				while(result.next())
				{
					multiplier = result.getString(1);
				}
				if(multiplier.equals("0"))
				{
					canMake = false;
					session.setAttribute("message", "Invalid reservation! Not a valid origin and destination for this schedule!");
					response.sendRedirect("ViewResCustomerRep.jsp");
					return;
				}
				
				result.close();
				
				str = String.format("select 1 from dual where CURRENT_DATE <= '%s'", startDate);
				result = stmt.executeQuery(str);
				if(!result.next())
				{
					canMake = false;
					session.setAttribute("message", "Invalid reservation! Cannot make a reservation for a time in the past!");
					response.sendRedirect("ViewResCustomerRep.jsp");
					return;
				}
				
				result.close();
				
				if(canMake)
				{
					str = String.format("SELECT tl.fare, tl.disabilityDiscount, tl.seniorDiscount, tl.childDiscount, tl.twoWayDiscount, tl.weeklyDiscount, tl.monthlyDiscount FROM TransitLine tl, TrainSchedule ts where ts.transitLineName= tl.transitLineName and ts.scheduleID = '%s'", scheduleID);
					result = stmt.executeQuery(str);
					while(result.next())
					{
				farePrice = Double.parseDouble(result.getString(1));
					//Set the fare price
					
					farePrice = farePrice * Double.parseDouble(multiplier);
					if(timeLength.equals("One Week"))
					{
						farePrice = farePrice*7;
					}
					else if(timeLength.equals("One Month"))
					{
						farePrice = farePrice*30;
					} 
					
					if(tripType.equals("Round Trip"))
					{
						farePrice = farePrice - Double.parseDouble(result.getString(5))*farePrice;
					}
					
					if(classType.equals("Business"))
					{
						farePrice += farePrice;
					}
					
					if(classType.equals("First"))
					{
						farePrice += 1.5*farePrice;
					}
				
					//Apply the discounts
					
					if(age.equals("Child"))
					{
						farePrice = farePrice - Double.parseDouble(result.getString(4))*farePrice;
					}
					else if(age.equals("Senior"))
					{
						farePrice = farePrice - Double.parseDouble(result.getString(3))*farePrice;
					}
					
					if(isDisabled != null)
					{
						isDisabled = "Yes";
						farePrice = farePrice - Double.parseDouble(result.getString(2))*farePrice;
					}
					else
					{
						isDisabled = "No";
					}
					
					if(timeLength.equals("One Week"))
					{
						farePrice = farePrice - Double.parseDouble(result.getString(7))*farePrice;
					}
					else if(timeLength.equals("One Month"))
					{
						farePrice = farePrice - Double.parseDouble(result.getString(7))*farePrice;
					} 
					}
					farePrice = Math.round(farePrice * 100.0) / 100.0;
					bookingFee = (0.25)*farePrice;
					bookingFee = Math.round(bookingFee * 100.0) / 100.0;
					result.close();
					
					boolean checked = false; String curSeat = null;
					String curStart = null; String curLength = null; String curTrain = null;
					result = ReservationManagement.getReservation(resNum);
					while(result.next())
					{
						curStart = result.getString("reservationStartTime");
						curLength = result.getString("reservationLength");
						curTrain = result.getString("trainID");
						if(result.getString("wasChecked").equals("1")) {
							checked = true;
						}
						curSeat = result.getString("seatNumber");
					}
					String newTrain = null;
					result = ScheduleManagement.getSchedule(scheduleID);
					while(result.next())
					{
						newTrain = result.getString("trainID");
					}
					
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					Calendar c = Calendar.getInstance();
					c.setTime(sdf.parse(curStart));
					boolean curExpired = false;
					if(curLength.equals("One Day")) {
						c.add(Calendar.DATE, 1);
					}else if(curLength.equals("One Month")){
						c.add(Calendar.MONTH, 1);
					}else if(curLength.equals("One Week")){
						c.add(Calendar.DATE, 7);
					}
					
					DateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
					java.util.Date today = new java.util.Date();
					today = formatter.parse(formatter.format(today));
					
					if(!newTrain.equals(curTrain) && ((today.compareTo(c.getTime()) <= 0) || (!(today.compareTo(c.getTime()) <= 0) && checked))) {
						ReservationManagement.unoccupySeat(curTrain, curSeat);
					
					
					str = String.format("SELECT t.numSeats from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s'", scheduleID);
					result = stmt.executeQuery(str);
					
					while(result.next())
					{
						
						maxSeats = result.getString(1);
					}
					
					result.close();
					
				
				str = String.format("SELECT count(s.seatNum) from Seats s, TrainSchedule ts, Train t where s.trainID = ts.trainID and ts.trainID = t.trainID and ts.scheduleID = '%s' and s.isOccupied = 1", scheduleID);
				result = stmt.executeQuery(str);
				
				int size = 0;
				while(result.next())
				{
					size = Integer.parseInt(result.getString(1));
				}
				
				result.close();
				
				String[] seatNumbers = new String[size];
				
				int i = 0;
				str = String.format("SELECT s.seatNum from Seats s, TrainSchedule ts, Train t where s.trainID = ts.trainID and ts.trainID = t.trainID and ts.scheduleID = '%s' and s.isOccupied = 1", scheduleID);
				result = stmt.executeQuery(str);
				while(result.next())
				{
					seatNumbers[i] = result.getString(1);
					i++;
				}
				result.close();
				i = 0;
				while(i < size)
				{
					String tempSeatNum = "";
					String tempResNum = "";
					str = String.format("SELECT r.seatNumber, r.reservationNumber from Reservation r where r.scheduleID = '%s' and r.seatNumber = '%s' and r.reservationEndTime < CURRENT_TIMESTAMP and r.wasChecked = 0", scheduleID, seatNumbers[i]);
					result = stmt.executeQuery(str);
					while(result.next())
					{
						tempSeatNum = result.getString(1);
						tempResNum = result.getString(2);
					}
					result.close();
					str = String.format("UPDATE Seats set isOccupied = 0 where seatNum = '%s' and trainID = (SELECT t.trainID from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s')", tempSeatNum, scheduleID);
					stmt.execute(str);

					str = String.format("UPDATE Reservation set wasChecked = 1 where ReservationNumber = '%s'", tempResNum);
					stmt.execute(str);	
					i++;
				}
				
				str = String.format("SELECT min(s.seatNum) from Seats s, TrainSchedule ts, Train t where s.trainID = ts.trainID and ts.trainID = t.trainID and ts.scheduleID = '%s' and s.isOccupied = 0", scheduleID);
				result = stmt.executeQuery(str);
				
				while(result.next())
				{
					if(result != null)
					{
						seatNumber = result.getString(1);
					}
				}
						
				
					result.close();
					
					}else{
						seatNumber = curSeat;
					}
					sdf = new SimpleDateFormat("yyyy-MM-dd");
					c = Calendar.getInstance();
					c.setTime(sdf.parse(startDate));
					c.add(Calendar.DATE, 1);
					curExpired = false;
					if(timeLength.equals("One Day")) {
						c.add(Calendar.DATE, 1);
					}else if(timeLength.equals("One Month")){
						c.add(Calendar.MONTH, 1);
					}else if(timeLength.equals("One Week")){
						c.add(Calendar.DATE, 7);
					}
					
					formatter = new SimpleDateFormat("dd/MM/yyyy");
					today = new java.util.Date();
					today = formatter.parse(formatter.format(today));
					
					String wasChecked = "0";
					if(today.compareTo(c.getTime()) <= 0) {
						str = String.format("UPDATE Seats set isOccupied = 1 where seatNum = '%s' and trainID = (SELECT t.trainID from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s')", seatNumber, scheduleID);
						stmt.execute(str);
					}else{
						wasChecked = "1";
					}
				str = String.format("update Reservation set scheduleID = '%s', dateCreated = CURRENT_TIMESTAMP, username = '%s', class = '%s', personType = '%s', isDisabled = '%s', reservationLength = '%s', totalFare = '%s', bookingFee = '%s', origin = '%s', destination = '%s', seatNumber = '%s', wasChecked = '%s', reservationStartTime = '%s', reservationEndTime = if('%s' = 'One Day', '%s' + INTERVAL 1 DAY, if('%s' = 'One Week', '%s' + INTERVAL 1 WEEK, if('%s' = 'One Month', '%s' + INTERVAL 1 MONTH, NOW()))) where reservationNumber = '%s'", scheduleID, user, classType, age, isDisabled, timeLength, farePrice, bookingFee, originID, destinID, seatNumber, wasChecked, startDate, timeLength, startDate, timeLength, startDate, timeLength, startDate, resNum);
				stmt.execute(str);
				response.sendRedirect("ViewResCustomerRep.jsp");
				}
				//close the connection.
				conn.close();
			}else{ 
				
				resNum = request.getParameter("action");
				user = null;
				origin = null;
				destin = null;
				startDate = null;
				scheduleID = null;
				age = null;
				tripType = null;
				classType = null;
				isDisabled = null;
				timeLength = null;
				ResultSet rs = ReservationManagement.getReservation(resNum);
				while(rs.next()){
					user = rs.getString("username");
					origin = rs.getString("origin");
					destin = rs.getString("destination");
					startDate = rs.getString("reservationStartTime");
					scheduleID = rs.getString("scheduleID");
					age = rs.getString("personType");
					classType = rs.getString("class");
					isDisabled = rs.getString("isDisabled");
					tripType = rs.getString("tripType");
					timeLength = rs.getString("reservationLength");
				}
			
			
			%>
				<h1>Edit a Reservation</h1>
				<br>
				<br>
				<h2>You are editing a reservation for: <%= resNum%></h2>
				<form action='EditResCustomerRep.jsp' method='POST'>
				<input type="hidden" name="tripType" value="<%=tripType %>"/>
				<input type="hidden" name="resNum" value="<%=resNum %>"/>
		<label >Person: </label>
		
		<select name="person">
<%
		try {
					//Get the database connection
					db = new DBConnection();	
					conn = db.getConnection();
					stmt = conn.createStatement();
					str = ("SELECT * FROM Customer");
					ResultSet result = stmt.executeQuery(str);
					while(result.next()) {
						%>
						<option <%if(result.getString("username").equals(user)){out.print("selected");} %>><%=result.getString("username")%></option>
						<% 
					}conn.close();
		} catch (Exception e) {
		} 
		%> </select><br><br>
		<label >Length of reservation: </label>
		<select name="timeLength">
			<option value='One Day' <% if(timeLength.equals("One Day")) {out.print("selected");} %>>One Day</option>
			<option value='One Week' <% if(timeLength.equals("One Week")) {out.print("selected");} %>>One Week</option>
			<option value='One Month' <% if(timeLength.equals("One Month")) {out.print("selected");} %>>One Month</option>
		</select><br><br>
		
		
		<label for='orig'>Origin Station:</label>
		
		<select name="originStat">
<%
		try {
				//Get the database connection
				db = new DBConnection();	
				conn = db.getConnection();
				stmt = conn.createStatement();
				str = ("SELECT * FROM Station");
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option <%if(result.getString("stationID").equals(origin)){out.print("selected");} %>><%=result.getString("name")%></option>
					<% 
				}conn.close();
	} catch (Exception e) {
	} 
	%> </select><br><br>
	
	<label for='dest'>Destination Station:</label>
	<select name="destinStat">
<%
		
		try {
				//Get the database connection
				db = new DBConnection();	
				conn = db.getConnection();
				stmt = conn.createStatement();
				str = "SELECT * FROM Station";
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option <%if(result.getString("stationID").equals(destin)){out.print("selected");} %>><%=result.getString("name") %></option>
					<%
				}conn.close();	
				
	} catch (Exception e) {
	} %>		</select><br><br>
	
	<label for='datetrav'>Date of Travel:</label>
	<input required type="date" id='dateTravel' name='datetrav' value='<%=startDate %>'><br><br>
  	
	<label for='schedID'>With Schedule ID:</label>
	<input required value='<%=scheduleID %>' id='scheduleID' name='schedID'>

 <br>
				<h2>Is the passenger:</h2>
				

				<input type='radio' value='Child' name='age' <% if(age.equals("Child")) {out.print("checked = 'checked'");} %>> Child?
				<input type='radio' value='Adult' name='age' <% if(age.equals("Adult")) {out.print("checked = 'checked'");} %>> Adult?
				<input type='radio' value='Senior' name='age' <% if(age.equals("Senior")) {out.print("checked = 'checked'");} %>> Senior Citizen?
				<br><br>
				<input <% if(isDisabled.equals("Yes")) {out.print("checked = 'checked'");} %> type='checkbox' value='Disabled' name='isDisabled'> Disabled? <br><br>
				<br>
				<h2>Select a class:</h2>
				<input type='radio' value='First' name='classType' <% if(classType.equals("First")) {out.print("checked");} %>> First Class
				<input type='radio' value='Business' name='classType' <% if(classType.equals("Business")) {out.print("checked");} %>> Business Class
				<input type='radio' value='Economy' name='classType' <% if(classType.equals("Economy")) {out.print("checked");} %>> Economy Class<br><br>
							<input type = "submit" value="Edit Reservation">
		</form>
				<br><br>
				
				

			<% String message = (String)session.getAttribute("message");
			if(message != null) {
				session.removeAttribute("message");
				out.print(message);
			}
		}
	} catch (SQLException e) {
		session.setAttribute("message", String.format("Something went wrong while creating your reservation or the train you requested may be full."));
		response.sendRedirect("ViewResCustomerRep.jsp");
	} %>
</body>
</html>