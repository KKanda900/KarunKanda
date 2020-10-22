package com.cs336proj.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cs336proj.root.ReservationManagement;

/**
 * Servlet implementation class QandA
 */
@WebServlet(asyncSupported = false, name = "ReservationsCustomerRep", urlPatterns = { "/ReservationsCustomerRep" })
public class ReservationsCustomerRep extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ReservationsCustomerRep() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameter("delete") != null) {
			try {
				ReservationManagement.deleteReservation(request.getParameter("action"));
			} catch (Exception e) {
				request.getSession().setAttribute("message", "There was a problem deleting that reservation.");
			}
			response.sendRedirect("ViewResCustomerRep.jsp");
		} else {
			response.sendRedirect("ViewResCustomerRep.jsp");
		}
		switch (request.getParameter("action")) {
		case ("EDIT"):
			response.sendRedirect("ViewResCustomerRep.jsp?action=EDIT");
			break;
		}
	}
}
