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

@WebFilter(filterName = "LoginFilter",
urlPatterns = {"/Login.jsp", "/Register.jsp", "/lLogin.jsp"})
public class LoginFilter implements Filter {
    public LoginFilter() {
    }
	public void destroy() {
	}
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
	    HttpSession session = ((HttpServletRequest) request).getSession();
		if(session.getAttribute("LOGGED_IN") == null) {
			chain.doFilter(request, response);
		}else {
			((HttpServletResponse) response).sendRedirect("index.jsp");
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
