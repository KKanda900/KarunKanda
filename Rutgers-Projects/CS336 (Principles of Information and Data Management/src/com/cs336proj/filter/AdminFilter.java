package com.cs336proj.filter;
import java.io.IOException;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AdminFilter",
urlPatterns = {"/admin.jsp"})
public class AdminFilter extends IndexFilter {
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
	    HttpSession session = ((HttpServletRequest) request).getSession();
		if(session.getAttribute("LOGGED_IN") != null && (char)session.getAttribute("type") == 'A') {
			chain.doFilter(request, response);
		}else {
			((HttpServletResponse) response).sendRedirect("index.jsp");
		}
	}
}