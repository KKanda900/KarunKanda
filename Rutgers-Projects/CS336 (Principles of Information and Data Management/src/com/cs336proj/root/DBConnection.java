package com.cs336proj.root;

import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnection {
	private static final String DB_URL = "jdbc:mysql://railwaybookingteam3.c4ery62b46ep.us-east-2.rds.amazonaws.com:3306/railwaybooking";
	private Connection conn = null;
public Connection getConnection() throws InvocationTargetException{
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			conn = DriverManager.getConnection(DBConnection.DB_URL,dontCommitMe.DB_USER, dontCommitMe.DB_PASS);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return this.conn;
	}
	public DBConnection(){
	}
	public void close(){
		try {
			if(conn != null) {
				this.conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
