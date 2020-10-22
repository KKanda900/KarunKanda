package com.cs336proj.root;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;

public class StopsAtManagement {

	public static void deleteStop(String sch_id, String stopNum) throws Exception {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DBConnection db = null;
		Connection conn = null;
		try {
			db = new DBConnection();
			conn = db.getConnection();
			String str = "DELETE FROM StopsAt WHERE stopNum = ? and scheduleID = ?";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, stopNum);
			pstmt.setString(2, sch_id);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

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
	}

	public static void updateStop(int stopNum, String scheduleID, String arrival, String dep, String station)
			throws Exception {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DBConnection db = null;
		Connection conn = null;
		try {
			db = new DBConnection();
			conn = db.getConnection();
			String str = "UPDATE StopsAt sa SET stationID = (select stationID from Station where name=?), arrDatetime = STR_TO_DATE(?, '%H:%i'), deptDatetime = STR_TO_DATE(?, '%H:%i') where sa.scheduleID = ? and sa.stopNum = ?";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, station);
			pstmt.setString(2, arrival);
			pstmt.setString(3, dep);
			pstmt.setInt(4, Integer.parseInt(scheduleID));
			pstmt.setInt(5, stopNum);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

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
	}

	public static void addStop(int stopNum, String scheduleID, String arrival, String dep, String station, String lTime)
			throws Exception {

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DBConnection db = null;
		Connection conn = null;
		java.util.Date arr = new SimpleDateFormat("HH:mm").parse(arrival);
		java.util.Date depa = new SimpleDateFormat("HH:mm").parse(dep);
		if (lTime != null) {
			java.util.Date lastTime = new SimpleDateFormat("HH:mm").parse(lTime);
			if (lastTime.compareTo(arr) > 0) {
				throw new Exception();
			}
		}
		if (arr.compareTo(depa) > 0) {
			throw new Exception();
		}
		try {
			db = new DBConnection();
			conn = db.getConnection();
			String str = "insert into StopsAt (stopNum, scheduleID, stationID, arrDatetime, deptDatetime ) select ?,?,stationID, STR_TO_DATE(?, '%H:%i'),  STR_TO_DATE(?, '%H:%i')  from Station where name= ?";
			pstmt = conn.prepareStatement(str, Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, stopNum);
			pstmt.setInt(2, Integer.parseInt(scheduleID));
			pstmt.setString(3, arrival);
			pstmt.setString(4, dep);
			pstmt.setString(5, station);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();

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
	}
}
