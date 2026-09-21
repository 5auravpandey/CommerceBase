/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.UserDAO;
import com.commercebase.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            User user = (User) session.getAttribute("loggedInUser");
            redirectByRole(request, response, user);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }

        try {
            User user = userDAO.authenticateUser(email.trim(), password);

            if (user != null) {
                HttpSession session = request.getSession(true);

                session.invalidate();
                session = request.getSession(true);

                session.setAttribute("loggedInUser", user);
                session.setMaxInactiveInterval(30 * 60);

                String redirectURL = (String) session.getAttribute("redirectAfterLogin");
                if (redirectURL != null && !redirectURL.isEmpty()) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirectURL);
                } else {
                    redirectByRole(request, response, user);
                }

            } else {
                request.setAttribute("errorMessage",
                        "Invalid email or password. Please try again.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            System.err.println("[CommerceBase Auth] Login failed — database unreachable: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
        }
    }

    private void redirectByRole(HttpServletRequest request,
                                HttpServletResponse response,
                                User user) throws IOException {
        String ctx = request.getContextPath();
        if (user.isAdmin()) {
            response.sendRedirect(ctx + "/admin/dashboard");
        } else {
            response.sendRedirect(ctx + "/products");
        }
    }
}
