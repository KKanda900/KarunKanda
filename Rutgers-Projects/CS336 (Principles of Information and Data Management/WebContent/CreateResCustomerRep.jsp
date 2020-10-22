<% //CREATE RESERVATION MADE BY: NICHOLAS MEEGAN %>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336proj.root.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.SimpleDateFormat"%>
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
			boolean rndTripError = false;
			if(request.getAttribute("originStat") != null) {
				scheduleID = null;
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar c = Calendar.getInstance();
				c.setTime(sdf.parse(startDate));
				c.add(Calendar.DATE, 1);
				startDate = sdf.format(c.getTime());
				age = (String) request.getAttribute("age");
				isDisabled =(String) request.getAttribute("isDisabled");
				tripType = (String) request.getAttribute("tripType");
				classType = (String) request.getAttribute("classType");
				timeLength = (String) request.getAttribute("timeLength");
				origin = (String) request.getAttribute("originStat");
				destin = (String) request.getAttribute("destinStat");
			}
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
				//Checks if origin and destination are valid stations for this schedule
				if(scheduleID == null) {
					ResultSet rs = ScheduleManagement.getSchedule(origin, destin);
					while(rs.next()) {
						scheduleID = rs.getString("scheduleID");
					}
					if(scheduleID == null) {
						rndTripError = true;
						canMake = false;
					}
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
					response.sendRedirect("CreateResCustomerRep.jsp");
					return;
				}
				
				result.close();
				//Makes sure that you cant create a reservation in the past.
				str = String.format("select 1 from dual where CURRENT_DATE <= '%s'", startDate);
				result = stmt.executeQuery(str);
				if(!result.next())
				{
					canMake = false;
					session.setAttribute("message", "Invalid reservation! Cannot make a reservation for a time in the past!");
					response.sendRedirect("CreateResCustomerRep.jsp");
					return;
				}
				
				result.close();
				
				if(canMake) {
					//Grab the fare and discounts for the selected schedule ID. And calculate the fare using the base fare and apply the various discounts depending on the person and the trip
					str = String.format("SELECT tl.fare, tl.disabilityDiscount, tl.seniorDiscount, tl.childDiscount, tl.twoWayDiscount, tl.weeklyDiscount, tl.monthlyDiscount FROM TransitLine tl, TrainSchedule ts where ts.transitLineName= tl.transitLineName and ts.scheduleID = '%s'", scheduleID);
					result = stmt.executeQuery(str);
					while(result.next())
					{
					farePrice = Double.parseDouble(result.getString(1));
					farePrice = farePrice * Double.parseDouble(multiplier);
						//Set the fare price
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
						
						if(request.getAttribute("originStat") == null) {
							if(isDisabled != null)
							{
								isDisabled = "Yes";
								farePrice = farePrice - Double.parseDouble(result.getString(2))*farePrice;
							}
							else
							{
								isDisabled = "No";
							}
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
						//Calculate booking fee based on fare price.
						farePrice = Math.round(farePrice * 100.0) / 100.0;
						bookingFee = (0.25)*farePrice;
						bookingFee = Math.round(bookingFee * 100.0) / 100.0;
						farePrice += bookingFee;
						result.close();
					
						//Get the number of seats on the train who's schedule the user selected
						str = String.format("SELECT t.numSeats from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s'", scheduleID);
						result = stmt.executeQuery(str);
						
						while(result.next())
						{
							
							maxSeats = result.getString(1);
						}
						
						result.close();
						
					//Get the number of occupied seats in the train
					str = String.format("SELECT count(s.seatNum) from Seats s, TrainSchedule ts, Train t where s.trainID = ts.trainID and ts.trainID = t.trainID and ts.scheduleID = '%s' and s.isOccupied = 1", scheduleID);
					result = stmt.executeQuery(str);
					
					int size = 0;
					while(result.next())
					{
						size = Integer.parseInt(result.getString(1));
					}
					
					result.close();
					//get the seat numbers that are occupied and put them in this array
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
					{ //Out of the seats that are reserved... wht seat is expired... if its expired... unreserve it.
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
						//Toggle their wasChecked.
						str = String.format("UPDATE Reservation set wasChecked = 1 where ReservationNumber = '%s'", tempResNum);
						stmt.execute(str);	
						i++;
					}
					//grab the minimum seat number avaliable
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
						
					str = String.format("INSERT INTO Reservation(scheduleID, dateCreated, username, class, tripType, personType, isDisabled, reservationLength, totalFare, bookingFee, origin, destination, seatNumber, wasChecked, reservationStartTime, reservationEndTime) VALUES (%s, CURRENT_TIMESTAMP, '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', 0, '%s', if('%s' = 'One Day', '%s' + INTERVAL 1 DAY, if('%s' = 'One Week', '%s' + INTERVAL 1 WEEK, if('%s' = 'One Month', '%s' + INTERVAL 1 MONTH, NOW()))))", scheduleID, user, classType, tripType, age, isDisabled, timeLength, Double.toString(farePrice), Double.toString(bookingFee), originID, destinID, seatNumber, startDate, timeLength, startDate, timeLength, startDate, timeLength, startDate);
					stmt.execute(str); 
					if(tripType.equals("Round Trip") && request.getAttribute("originStat") == null)
					{
						request.setAttribute("originStat", destin);
						request.setAttribute("destinStat", origin);
						request.setAttribute("age", age);
						request.setAttribute("isDisabled", isDisabled);
						request.setAttribute("tripType", tripType);
						request.setAttribute("classType", classType);
						request.setAttribute("timeLength", timeLength);
						request.getRequestDispatcher("CreateResCustomerRep.jsp").forward(request, response);
						str = String.format("UPDATE Seats set isOccupied = 1 where seatNum = '%s' and trainID = (SELECT t.trainID from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s')", seatNumber, scheduleID);
						stmt.execute(str);
					}else{
						str = String.format("UPDATE Seats set isOccupied = 1 where seatNum = '%s' and trainID = (SELECT t.trainID from Train t, TrainSchedule ts where t.trainID = ts.trainID and ts.scheduleID = '%s')", seatNumber, scheduleID);
						stmt.execute(str);
						response.sendRedirect("ViewResCustomerRep.jsp");
					}
					}
				//close the connection.
				conn.close();
			}else{ 
			%>
				<h1>Make a Reservation</h1>
				<br>
				<br>
				<h2>You are creating a reservation for:</h2>
				<form action='CreateResCustomerRep.jsp' method='POST'>
				<label>Person: </label>
				<select name="person">
					<%
						try {
									//Get the database connection
									db = new DBConnection();	
									conn = db.getConnection();
									stmt = conn.createStatement();
									str = ("SELECT username FROM Customer");
									ResultSet result = stmt.executeQuery(str);
									while(result.next()) {
										%>
										<option><%=result.getString("username")%></option>
										<% 
									}conn.close();
						} catch (Exception e) {
					} 
					%>
				</select><br><br>
		<label for='orig'>Origin Station:</label>
		
		<select name="originStat">
                <option value="-1">Select Station</option>
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
				db = new DBConnection();	
				conn = db.getConnection();
				stmt = conn.createStatement();
				str = "SELECT * FROM Station";
				ResultSet result = stmt.executeQuery(str);
				while(result.next()) {
					%>
					<option><%=result.getString("name") %></option>
					<%
				}conn.close();	
				
	} catch (Exception e) {
	} %>		</select><br><br>
	
	<label for='datetrav'>Date of Travel:</label>
	<input required type="date" id='dateTravel' name='datetrav'><br><br>
  	
	<label for='schedID'>With Schedule ID:</label>
	<input required type="form" id='scheduleID' name='schedID'>

 <br>
				<h2>Is the passenger:</h2>
				

				<input type='radio' value='Child' name='age'> Child?
				<input type='radio' value='Adult' name='age' checked = 'checked'> Adult?
				<input type='radio' value='Senior' name='age'> Senior Citizen?
				<br><br>
				<input type='checkbox' value='Disabled' name='isDisabled'> Disabled? <br><br>
				<br>
				<h2>Should your trip be:</h2>
				<input type='radio' value='One-Way' name='tripType' checked = 'checked'> One Way?
				<input type='radio' value='Round Trip' name='tripType'> Next Day Round Trip?<br><br>
				<br>
				<h2>Select a class:</h2>
				<input type='radio' value='First' name='classType'> First Class
				<input type='radio' value='Business' name='classType'> Business Class
				<input type='radio' value='Economy' name='classType' checked = 'checked'> Economy Class<br><br>
				<h2>How long should your reservation last?</h2>
				<input type='radio' value='One Day' name='timeLength' checked = 'checked'> One Day
				<input type='radio' value='One Week' name='timeLength'> One Week
				<input type='radio' value='One Month' name='timeLength'> One Month<br><br>
							<input type = "submit" value="Create Reservation">
		</form>
				<br><br>
				
				

			<% String message = (String)session.getAttribute("message");
			if(message != null) {
				session.removeAttribute("message");
				out.print(message);
			}
		}
	} catch (SQLException e) {
		if(request.getAttribute("originStat") != null) {
			session.setAttribute("message", String.format("Something went wrong while creating your reservation or the train you requested may be full."));
		}else{
			session.setAttribute("message", String.format("Something went wrong while creating your round trip reservation or the train you requested may be full."));
		}
		response.sendRedirect("ViewResCustomerRep.jsp");
	} %>
</body>
</html>