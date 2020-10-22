package com.cs336proj.root;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;

public class ReservationManagement {

	public static void unoccupySeat(String train, String seat) throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = String.format("UPDATE Seats SET isOccupied = 0 WHERE trainID = %s and seatNum = %s", train, seat);
		stmt.executeUpdate(str);
		try {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception ex) {
		}
	}

	public static ResultSet getReservation(String res_id) throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = String.format(
				"select * from Reservation r join TrainSchedule ts on ts.scheduleID = r.scheduleID where r.ReservationNumber = %s",
				res_id);
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		try {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception ex) {
		}
		return rowset;
	}

	public static void deleteReservation(String res_num) throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		ResultSet result = ReservationManagement.getReservation(res_num);
		result.next();
		String train = result.getString("trainID");
		String seat = result.getString("seatNumber");
		String str = String.format("DELETE FROM Reservation WHERE ReservationNumber = %s", res_num);
		stmt.executeUpdate(str);
		str = String.format(
				"select * from Reservation r join Seats s on s.seatNum = r.seatNumber join TrainSchedule ts on ts.scheduleID = r.scheduleID where ts.trainID = s.trainID and wasChecked = 0 and r.seatNumber = %s and s.trainID = %s",
				seat, train);
		result = stmt.executeQuery(str);
		if (!result.next())
			unoccupySeat(train, seat);
		try {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
			if (result != null)
				result.close();
		} catch (Exception ex) {
		}
	}

	public static ResultSet getReservations() throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = "SELECT r.reservationnumber, r.username, r.seatNumber, r.reservationlength, r.origin, r.destination, s.transitLineName, r.class, r.triptype, r.persontype, r.isdisabled, r.datecreated, r.totalfare, r.scheduleID, r.bookingFee FROM Reservation r join TrainSchedule s on s.scheduleID = r.scheduleID";
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		try {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception ex) {
		}
		return rowset;
	}
}
