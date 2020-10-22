package com.cs336proj.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cs336proj.root.DBConnection;
import com.cs336proj.root.ScheduleManagement;
import com.cs336proj.root.StopsAtManagement;

/**
 * Servlet implementation class QandA
 */
@WebServlet(asyncSupported = false, name = "SchedulesCustomerRep", urlPatterns = { "/SchedulesCustomerRep" })
public class SchedulesCustomerRep extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SchedulesCustomerRep() {
		super();
	}

	// Used for posting delays to schedules and creating schedules, editing
	// schedules
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameter("create") != null || request.getAttribute("update") != null) {
			try {
				DateFormat inDateFormat = new SimpleDateFormat("HH:mm");
				String tLine = request.getParameter("tLine");
				String train = request.getParameter("train");
				LinkedHashSet<String> stops = new LinkedHashSet<String>();
				LinkedHashSet<Date> arrivals = new LinkedHashSet<Date>();
				LinkedHashSet<Date> deps = new LinkedHashSet<Date>();
				int i = 1;
				Date last = new Date((long) 0);
				while (true) {
					String stop = request.getParameter("s" + i);
					if (stop != null) {
						Date arr = inDateFormat.parse(request.getParameter("at" + i));
						Date dep = inDateFormat.parse(request.getParameter("dt" + i));
						if (stops.contains(stop) || last.compareTo(arr) > 0 || arr.compareTo(dep) > 0) {
							throw new Exception();
						}
						stops.add(stop);
						arrivals.add(arr);
						deps.add(dep);
						last = dep;
					} else {
						break;
					}
					i++;
				}
				String schID = null;
				if (request.getAttribute("update") == null) {
					schID = ScheduleManagement.createSchedule(null, train, tLine);
				} else {
					schID = (String) request.getAttribute("update");
					ScheduleManagement.updateSchedule(schID, train, tLine);
				}
				Iterator<String> stopsI = stops.iterator();
				Iterator<Date> arrivalsI = arrivals.iterator();
				Iterator<Date> depsI = deps.iterator();
				int j = 1;
				Date start = null;
				Date finish = null;
				while (stopsI.hasNext()) {
					String sto = stopsI.next();
					Date arr = arrivalsI.next();
					if (j == 1) {
						start = arr;
					}
					Date dep = depsI.next();
					if (request.getAttribute("update") == null) {
						StopsAtManagement.addStop(j, schID, inDateFormat.format(arr), inDateFormat.format(dep), sto,
								null);
					} else {
						StopsAtManagement.updateStop(j, schID, inDateFormat.format(arr), inDateFormat.format(dep), sto);
					}
					j++;
					finish = arr;
				}
				ScheduleManagement.updateTravelTime(schID, start, finish);
			} catch (Exception e) {
				request.getSession().setAttribute("message",
						"There was a problem. Ensure your stops and times make sense.");
			}
			response.sendRedirect("schedulesCustomerRep.jsp");
		} else if (request.getParameter("edit") != null) {
			try {
				if (request.getParameter("DELETE") != null) {
					StopsAtManagement.deleteStop(request.getParameter("schID"), request.getParameter("DELETE"));
					response.sendRedirect("ManageSchedules.jsp?edit=" + request.getParameter("schID"));
				} else if (request.getParameter("update") != null) {
					request.setAttribute("update", request.getParameter("schID"));
					request.getRequestDispatcher("SchedulesCustomerRep").forward(request, response);
				} else if (request.getParameter("add") != null) {
					String stopNum = request.getParameter("add");
					StopsAtManagement.addStop(Integer.parseInt(stopNum), request.getParameter("schID"),
							request.getParameter("at" + stopNum), request.getParameter("dt" + stopNum),
							request.getParameter("s" + stopNum), request.getParameter("lastTime"));
					response.sendRedirect("ManageSchedules.jsp?edit=" + request.getParameter("schID"));
				}
			} catch (Exception e) {
				request.getSession().setAttribute("message", "There was a problem editing the schedule.");
				response.sendRedirect("schedulesCustomerRep.jsp");
			}
		} else {
			try {
				String id = request.getParameter("sch_id");
				String message = request.getParameter("message" + id);
				DBConnection db = new DBConnection();
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = String.format("UPDATE TrainSchedule SET isDelayed = '%s' WHERE scheduleID = %s", message,
						id);
				stmt.executeUpdate(str);
				// close the connection.
				conn.close();
			} catch (Exception e) {
			}
			response.sendRedirect("DisclaimerCustomerRep.jsp");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameter("action") != null) {
			switch (request.getParameter("action")) {
			case ("DELETEDELAY"):
				try {
					DBConnection db = new DBConnection();
					Connection conn = db.getConnection();
					Statement stmt = conn.createStatement();
					String str = String.format("UPDATE TrainSchedule SET isDelayed = NULL WHERE scheduleID = %s",
							request.getParameter("sch_id"));
					int result = stmt.executeUpdate(str);
					// close the connection.
					conn.close();
				} catch (Exception e) {
				}
				response.sendRedirect("DisclaimerCustomerRep.jsp");
				break;
			case ("DELETE"):
				try {
					DBConnection db = new DBConnection();
					Connection conn = db.getConnection();
					Statement stmt = conn.createStatement();
					String str = String.format("UPDATE TrainSchedule SET isDelayed = NULL WHERE scheduleID = %s",
							request.getParameter("sch_id"));
					stmt.executeUpdate(str);
					// close the connection.
					conn.close();
				} catch (Exception e) {
				}
				response.sendRedirect("DisclaimerCustomerRep.jsp");
				break;
			default:
				response.sendRedirect("DisclaimerCustomerRep.jsp");
				break;
			}
		} else if (request.getParameter("DELETE") != null) {
			try {
				DBConnection db = new DBConnection();
				Connection conn = db.getConnection();
				Statement stmt = conn.createStatement();
				String str = String.format("DELETE from TrainSchedule where scheduleID = %s",
						request.getParameter("DELETE"));
				stmt.executeUpdate(str);
				// close the connection.
				conn.close();
			} catch (Exception e) {
			}
			response.sendRedirect("schedulesCustomerRep.jsp");
		} else {
			response.sendRedirect("schedulesCustomerRep.jsp");
		}
	}
}
