/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.ProductDAO;
import com.commercebase.model.OrderItem;
import com.commercebase.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = "/cart")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static final String CART_KEY = "cart";

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<OrderItem> cart = getCart(request);

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", calculateTotal(cart));
        request.setAttribute("cartItemCount", cartItemCount(cart));

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "remove":
                handleRemove(request, response);
                break;
            case "clear":
                handleClear(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleAdd(HttpServletRequest request,
                            HttpServletResponse response) throws IOException {

        String ctx = request.getContextPath();

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity  = parseQuantity(request.getParameter("quantity"));

            Product product = productDAO.getProductById(productId);
            if (product == null || !product.isActive()) {
                response.sendRedirect(ctx + "/products");
                return;
            }

            List<OrderItem> cart = getCart(request);

            boolean found = false;
            for (OrderItem item : cart) {
                if (item.getProductId() == productId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }

            if (!found) {
                OrderItem newItem = new OrderItem();
                newItem.setProductId(productId);
                newItem.setQuantity(quantity);
                newItem.setUnitPrice(product.getPrice());
                newItem.setProductName(product.getProductName());
                cart.add(newItem);
            }

            saveCart(request, cart);

        } catch (NumberFormatException | SQLException e) {
            System.err.println("[CommerceBase Cart] Failed to add product to cart: " + e.getMessage());
            e.printStackTrace();
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : ctx + "/cart");
    }

    private void handleUpdate(HttpServletRequest request,
                              HttpServletResponse response) throws IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity  = parseQuantity(request.getParameter("quantity"));

            List<OrderItem> cart = getCart(request);

            for (OrderItem item : cart) {
                if (item.getProductId() == productId) {
                    if (quantity <= 0) {
                        cart.remove(item);
                    } else {
                        item.setQuantity(quantity);
                    }
                    break;
                }
            }

            saveCart(request, cart);

        } catch (NumberFormatException e) {
            System.err.println("[CommerceBase Cart] Failed to update cart item quantity — invalid format: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest request,
                              HttpServletResponse response) throws IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));

            List<OrderItem> cart = getCart(request);
            Iterator<OrderItem> it = cart.iterator();
            while (it.hasNext()) {
                if (it.next().getProductId() == productId) {
                    it.remove();
                    break;
                }
            }

            saveCart(request, cart);

        } catch (NumberFormatException e) {
            System.err.println("[CommerceBase Cart] Failed to remove item from cart — invalid product ID: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleClear(HttpServletRequest request,
                             HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(CART_KEY);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    public static List<OrderItem> getCart(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        List<OrderItem> cart = (List<OrderItem>) session.getAttribute(CART_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_KEY, cart);
        }
        return cart;
    }

    private void saveCart(HttpServletRequest request, List<OrderItem> cart) {
        request.getSession(true).setAttribute(CART_KEY, cart);
    }

    public static BigDecimal calculateTotal(List<OrderItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        for (OrderItem item : cart) {
            total = total.add(item.calculateSubtotal());
        }
        return total;
    }

    public static int cartItemCount(List<OrderItem> cart) {
        int count = 0;
        for (OrderItem item : cart) {
            count += item.getQuantity();
        }
        return count;
    }

    private int parseQuantity(String param) {
        try {
            int q = Integer.parseInt(param);
            return q > 0 ? q : 1;
        } catch (NumberFormatException | NullPointerException e) {
            return 1;
        }
    }
}
