/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.OrderDAO;
import com.commercebase.dao.ProductDAO;
import com.commercebase.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO   orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        orderDAO   = new OrderDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Order> allOrders = orderDAO.getAllOrders();
            int totalProducts    = productDAO.getAllProducts().size();
            int totalCategories  = productDAO.getAllCategories().size();

            long pendingOrders   = allOrders.stream()
                    .filter(o -> "Pending".equals(o.getStatus())).count();
            long completedOrders = allOrders.stream()
                    .filter(o -> "Delivered".equals(o.getStatus())).count();

            request.setAttribute("orders", allOrders);
            request.setAttribute("totalOrders", allOrders.size());
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("completedOrders", completedOrders);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalCategories", totalCategories);

        } catch (SQLException e) {
            System.err.println("[CommerceBase Admin] Failed to load dashboard metrics and orders: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "Unable to load dashboard data.");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        String newStatus  = request.getParameter("status");

        if (orderIdStr != null && newStatus != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                orderDAO.updateOrderStatus(orderId, newStatus);
                request.getSession().setAttribute("successMessage",
                        "Order #" + orderId + " updated to " + newStatus + ".");
            } catch (SQLException | NumberFormatException e) {
                System.err.println("[CommerceBase Admin] Failed to update order status: " + e.getMessage());
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage",
                        "Failed to update order status.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
