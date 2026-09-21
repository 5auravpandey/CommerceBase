/* @author Saurav Pandey | CommerceBase */
package com.commercebase.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {

    private int        orderId;
    private int        userId;
    private BigDecimal totalAmount;
    private String     status;
    private String     shippingAddress;
    private String     paymentMethod;
    private Timestamp  orderedAt;
    private Timestamp  updatedAt;

    private List<OrderItem> items = new ArrayList<>();

    private String customerName;

    public Order() { }

    public Order(int userId, BigDecimal totalAmount,
                 String shippingAddress, String paymentMethod) {
        this.userId          = userId;
        this.totalAmount     = totalAmount;
        this.shippingAddress = shippingAddress;
        this.paymentMethod   = paymentMethod;
        this.status          = "Pending";
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getOrderedAt() {
        return orderedAt;
    }

    public void setOrderedAt(Timestamp orderedAt) {
        this.orderedAt = orderedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public void addItem(OrderItem item) {
        this.items.add(item);
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    @Override
    public String toString() {
        return "Order{" +
               "orderId=" + orderId +
               ", userId=" + userId +
               ", totalAmount=" + totalAmount +
               ", status='" + status + '\'' +
               ", items=" + items.size() +
               '}';
    }
}
