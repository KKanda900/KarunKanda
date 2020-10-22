package com.cs336proj.root;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;

public class ScheduleManagement {
	public static void updateTravelTime(String schID, java.util.Date start, java.util.Date finish) throws Exception {
		DateFormat inDateFormat = new SimpleDateFormat("HH:mm");
		inDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		Date dif = new Date(finish.getTime() - start.getTime());
		String travelTime = inDateFormat.format(dif);
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		try {
			String str = "update TrainSchedule set travelTime = STR_TO_DATE(?, '%H:%i') where scheduleID = ?";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, travelTime);
			pstmt.setInt(2, Integer.parseInt(schID));
			pstmt.executeUpdate();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
	}

	public static ResultSet getSchedule(String sch_id) throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = String.format("select * from TrainSchedule ts where ts.scheduleID = %s", sch_id);
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}

	public static ResultSet getStops(String sch_id) throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = String.format(
				"select * from StopsAt sa join Station s on s.stationID = sa.stationID where sa.scheduleID = %s order by stopNum",
				sch_id);
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}

	public static String createSchedule(Date travelTime, String trainID, String transitLineName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DBConnection db = null;
		Connection conn = null;
		String returnMe = null;
		try {
			db = new DBConnection();
			conn = db.getConnection();
			String str = "insert into TrainSchedule(travelTime,trainID,transitLineName)values(?,?,?)";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setDate(1, null, null);
			pstmt.setInt(2, Integer.parseInt(trainID));
			pstmt.setString(3, transitLineName);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs != null && rs.next()) {
				returnMe = Integer.toString(rs.getInt(1));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
		return returnMe;
	}

	public static String updateSchedule(String sch_id, String trainID, String transitLineName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DBConnection db = null;
		Connection conn = null;
		String returnMe = null;
		try {
			db = new DBConnection();
			conn = db.getConnection();
			String str = "UPDATE TrainSchedule SET trainID=?, transitLineName=? where TrainSchedule.scheduleID = ?";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, trainID);
			pstmt.setString(2, transitLineName);
			pstmt.setString(3, sch_id);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if (rs != null && rs.next()) {
				returnMe = Integer.toString(rs.getInt(1));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
		return returnMe;
	}

	public static ResultSet getTrains() throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = "SELECT trainID FROM Train";
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}

	public static ResultSet getStations() throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = "select * from Station";
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}

	public static ResultSet getTLines() throws Exception {
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt;
		stmt = conn.createStatement();
		String str = "SELECT * FROM TransitLine";
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}

	public static ResultSet getSchedule(String origin, String destin) throws Exception {

		// String origin = "Atlantic City Station";
		// String destin = "Phildelphia Station";
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		Statement stmt = conn.createStatement();
		String str = String.format(
				"select distinct * from StopsAt sa join Station on Station.stationID = sa.stationID join TrainSchedule on TrainSchedule.scheduleID = sa.scheduleID where sa.scheduleID in (Select distinct StopsAt.scheduleID from StopsAt where StopsAt.scheduleID in (SELECT t.scheduleID from ((select StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))t join (SELECT DISTINCT StopsAt.scheduleID FROM StopsAt WHERE StopsAt.stationID IN (SELECT DISTINCT Station.stationID FROM Station WHERE name='%s'))s on t.scheduleID = s.scheduleID))) and sa.stopNum between (select se.stopNum from StopsAt se where se.scheduleID = sa.scheduleID and se.stationID =(select Station.stationID from Station where Station.name = '%s')) and (select se.stopNum from StopsAt se where se.scheduleID = sa.scheduleID and se.stationID =(select Station.stationID from Station where Station.name ='%s')) order by sa.scheduleID, sa.stopNum",
				origin, destin, origin, destin);
		RowSetFactory factory = RowSetProvider.newFactory();
		CachedRowSet rowset = factory.createCachedRowSet();
		rowset.populate(stmt.executeQuery(str));
		conn.close();
		return rowset;
	}
}
