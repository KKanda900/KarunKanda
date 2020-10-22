package com.cs336proj.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cs336proj.root.DBConnection;
import java.sql.*;

/**
 * Servlet implementation class QandA
 */
@WebServlet(asyncSupported = false, name = "qanda", urlPatterns = {"/qanda"})
public class QandA extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public QandA() {
        super();
    }
    //For Responding
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			DBConnection db = new DBConnection();	
			Connection conn = db.getConnection();
			Statement stmt = conn.createStatement();
			String str = String.format("select ssn from Employee where username='%s'", (String)request.getSession().getAttribute("LOGGED_IN"));
			ResultSet result = stmt.executeQuery(str);
			result.next();
			String ssn = result.getString("ssn");
			stmt = conn.createStatement();
			str = String.format("update Questions SET answer='%s', ssn='%s' where answer is null and questionID=%s", request.getParameter("answer"),ssn, request.getParameter("id"));
			stmt.executeUpdate(str);
			//close the connection.
			conn.close();
		}catch(Exception e) {}
		response.sendRedirect("qanda.jsp");
	}
}
