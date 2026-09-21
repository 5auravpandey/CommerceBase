/* @author Saurav Pandey | CommerceBase */
package com.commercebase.dao;

import com.commercebase.model.Order;
import com.commercebase.model.OrderItem;
import com.commercebase.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private static final String SQL_INSERT_ORDER =
            "INSERT INTO Orders (user_id, total_amount, status, " +
            "                    shipping_address, payment_method) " +
            "VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_INSERT_ORDER_ITEM =
            "INSERT INTO OrderItems (order_id, product_id, quantity, unit_price) " +
            "VALUES (?, ?, ?, ?)";

    private static final String SQL_UPDATE_STOCK =
            "UPDATE Products SET stock_quantity = stock_quantity - ? " +
            "WHERE product_id = ? AND stock_quantity >= ?";

    private static final String SQL_GET_ORDERS_BY_USER =
            "SELECT order_id, user_id, total_amount, status, " +
            "       shipping_address, payment_method, ordered_at, updated_at " +
            "FROM Orders WHERE user_id = ? ORDER BY ordered_at DESC";

    private static final String SQL_GET_ALL_ORDERS =
            "SELECT o.order_id, o.user_id, o.total_amount, o.status, " +
            "       o.shipping_address, o.payment_method, o.ordered_at, " +
            "       o.updated_at, u.full_name AS customer_name " +
            "FROM Orders o " +
            "JOIN Users u ON o.user_id = u.user_id " +
            "ORDER BY o.ordered_at DESC";

    private static final String SQL_GET_ORDER_ITEMS =
            "SELECT oi.item_id, oi.order_id, oi.product_id, oi.quantity, " +
            "       oi.unit_price, oi.subtotal, p.product_name " +
            "FROM OrderItems oi " +
            "JOIN Products p ON oi.product_id = p.product_id " +
            "WHERE oi.order_id = ?";

    private static final String SQL_UPDATE_ORDER_STATUS =
            "UPDATE Orders SET status = ? WHERE order_id = ?";

    public boolean createOrder(Order order) throws SQLException {

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(
                    SQL_INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, order.getUserId());
                ps.setBigDecimal(2, order.getTotalAmount());
                ps.setString(3, order.getStatus() != null ? order.getStatus() : "Pending");
                ps.setString(4, order.getShippingAddress());
                ps.setString(5, order.getPaymentMethod() != null ? order.getPaymentMethod() : "COD");
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                        order.setOrderId(orderId);
                    } else {
                        throw new SQLException("Failed to retrieve generated order ID.");
                    }
                }
            }

            try (PreparedStatement psItem  = conn.prepareStatement(SQL_INSERT_ORDER_ITEM);
                 PreparedStatement psStock = conn.prepareStatement(SQL_UPDATE_STOCK)) {

                for (OrderItem item : order.getItems()) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setBigDecimal(4, item.getUnitPrice());
                    psItem.addBatch();

                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    psStock.addBatch();
                }

                psItem.executeBatch();

                int[] stockResults = psStock.executeBatch();
                for (int result : stockResults) {
                    if (result == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) { }
            }
            throw e;

        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) { }
                try { conn.close(); }             catch (SQLException ignored) { }
            }
        }
    }

    public List<Order> getOrdersByUser(int userId) throws SQLException {

        List<Order> orders = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ORDERS_BY_USER)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderRow(rs, false));
                }
            }
        }
        return orders;
    }

    public List<Order> getAllOrders() throws SQLException {

        List<Order> orders = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(mapOrderRow(rs, true));
            }
        }
        return orders;
    }

    public List<OrderItem> getOrderItems(int orderId) throws SQLException {

        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ORDER_ITEMS)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    item.setProductName(rs.getString("product_name"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_ORDER_STATUS)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        }
    }

    private Order mapOrderRow(ResultSet rs, boolean includeCustomerName) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setOrderedAt(rs.getTimestamp("ordered_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));

        if (includeCustomerName) {
            order.setCustomerName(rs.getString("customer_name"));
        }
        return order;
    }
}
