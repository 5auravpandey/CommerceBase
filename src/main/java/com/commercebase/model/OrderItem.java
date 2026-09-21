/* @author Saurav Pandey | CommerceBase */
package com.commercebase.model;

import java.math.BigDecimal;

public class OrderItem {

    private int        itemId;
    private int        orderId;
    private int        productId;
    private int        quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;

    private String productName;

    public OrderItem() { }

    public OrderItem(int orderId, int productId,
                     int quantity, BigDecimal unitPrice) {
        this.orderId   = orderId;
        this.productId = productId;
        this.quantity  = quantity;
        this.unitPrice = unitPrice;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal calculateSubtotal() {
        if (unitPrice != null) {
            return unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
               "itemId=" + itemId +
               ", productId=" + productId +
               ", quantity=" + quantity +
               ", unitPrice=" + unitPrice +
               '}';
    }
}
