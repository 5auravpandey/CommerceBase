/* @author Saurav Pandey | CommerceBase */
package com.commercebase.filter;

import com.commercebase.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter",
           urlPatterns = {"/admin/*", "/checkout"})
public class AuthFilter implements Filter {

    public static final String SESSION_USER_KEY = "loggedInUser";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  httpReq  = (HttpServletRequest)  request;
        HttpServletResponse httpResp = (HttpServletResponse) response;
        HttpSession         session  = httpReq.getSession(false);

        String contextPath = httpReq.getContextPath();
        String requestURI  = httpReq.getRequestURI();

        User user = null;
        if (session != null) {
            user = (User) session.getAttribute(SESSION_USER_KEY);
        }

        if (user == null) {
            System.err.println("[CommerceBase Security] Unauthorized access attempt blocked at: " + requestURI);
            session = httpReq.getSession(true);
            session.setAttribute("redirectAfterLogin", requestURI);
            session.setAttribute("errorMessage",
                    "Please log in to access this page.");
            httpResp.sendRedirect(contextPath + "/login");
            return;
        }

        if (requestURI.startsWith(contextPath + "/admin")) {
            if (!user.isAdmin()) {
                System.err.println("[CommerceBase Security] Unauthorized access attempt blocked at: " + requestURI);
                session.setAttribute("errorMessage",
                        "Access denied. Administrator privileges required.");
                httpResp.sendRedirect(contextPath + "/products");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
