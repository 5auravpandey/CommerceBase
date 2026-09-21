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

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm  = request.getParameter("confirmPassword");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");

        String error = validateInput(fullName, email, password, confirm);
        if (error != null) {
            preserveFormData(request, fullName, email, phone, address);
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                   .forward(request, response);
            return;
        }

        try {
            if (userDAO.emailExists(email.trim())) {
                preserveFormData(request, fullName, email, phone, address);
                request.setAttribute("errorMessage",
                        "An account with this email already exists.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                       .forward(request, response);
                return;
            }

            User newUser = new User();
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email.trim());
            newUser.setPasswordHash(password);
            newUser.setPhone(phone != null ? phone.trim() : null);
            newUser.setAddress(address != null ? address.trim() : null);

            boolean created = userDAO.registerUser(newUser);

            if (created) {
                response.sendRedirect(request.getContextPath()
                        + "/login?message=Registration+successful!+Please+log+in.");
            } else {
                request.setAttribute("errorMessage",
                        "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            System.err.println("[CommerceBase Auth] Registration failed — database unreachable: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "A system error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp")
                   .forward(request, response);
        }
    }

    private String validateInput(String fullName, String email,
                                 String password, String confirm) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        if (email == null || email.trim().isEmpty()) {
            return "Email address is required.";
        }
        if (!email.trim().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Please enter a valid email address.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        if (!password.equals(confirm)) {
            return "Passwords do not match.";
        }
        return null;
    }

    private void preserveFormData(HttpServletRequest request,
                                  String fullName, String email,
                                  String phone, String address) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
    }
}
