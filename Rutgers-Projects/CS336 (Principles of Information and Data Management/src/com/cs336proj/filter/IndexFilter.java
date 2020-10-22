package com.cs336proj.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "IndexFilter",
urlPatterns = {"/index.jsp"})
public class IndexFilter implements Filter {
    public IndexFilter() {
    }
	public void destroy() {
	}
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
	    HttpSession session = ((HttpServletRequest) request).getSession();
		if(session.getAttribute("LOGGED_IN") == null || (char)session.getAttribute("type") == 'C') {
			chain.doFilter(request, response);
		}else if((char)session.getAttribute("type") == 'R'){
			((HttpServletResponse) response).sendRedirect("CustomerRep.jsp");
		}else {
			((HttpServletResponse) response).sendRedirect("admin.jsp");
		}
	}
	public void init(FilterConfig fConfig) throws ServletException {
	}
}