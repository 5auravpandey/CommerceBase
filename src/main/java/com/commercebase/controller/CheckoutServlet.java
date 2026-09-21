/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.OrderDAO;
import com.commercebase.model.Order;
import com.commercebase.model.OrderItem;
import com.commercebase.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = "/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<OrderItem> cart = CartServlet.getCart(request);

        if (cart.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage",
                    "Your cart is empty. Add some products before checking out.");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        BigDecimal cartTotal = CartServlet.calculateTotal(cart);

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("userAddress", user.getAddress());

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");
        List<OrderItem> cart = CartServlet.getCart(request);

        if (cart.isEmpty()) {
            session.setAttribute("errorMessage",
                    "Your cart is empty. Nothing to checkout.");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod   = request.getParameter("paymentMethod");

        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("errorMessage",
                    "Shipping address is required.");
            request.setAttribute("cart", cart);
            request.setAttribute("cartTotal", CartServlet.calculateTotal(cart));
            request.setAttribute("userAddress", shippingAddress);
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                   .forward(request, response);
            return;
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        BigDecimal totalAmount = CartServlet.calculateTotal(cart);

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setTotalAmount(totalAmount);
        order.setShippingAddress(shippingAddress.trim());
        order.setPaymentMethod(paymentMethod.trim());
        order.setStatus("Pending");
        order.setItems(cart);

        try {
            boolean success = orderDAO.createOrder(order);

            if (success) {
                session.removeAttribute(CartServlet.CART_KEY);

                session.setAttribute("lastOrderId", order.getOrderId());
                session.setAttribute("successMessage",
                        "Order #" + order.getOrderId()
                        + " placed successfully! Thank you for your purchase.");

                response.sendRedirect(request.getContextPath()
                        + "/order-success");

            } else {
                request.setAttribute("errorMessage",
                        "One or more items in your cart are out of stock. "
                        + "Please update quantities and try again.");
                request.setAttribute("cart", cart);
                request.setAttribute("cartTotal", totalAmount);
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            System.err.println("[CommerceBase Checkout] Order creation failed — rolling back: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "A system error occurred while placing your order. "
                    + "Please try again later.");
            request.setAttribute("cart", cart);
            request.setAttribute("cartTotal", totalAmount);
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                   .forward(request, response);
        }
    }
}
