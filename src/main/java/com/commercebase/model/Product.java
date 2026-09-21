/* @author Saurav Pandey | CommerceBase */
package com.commercebase.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Product {

    private int        productId;
    private int        categoryId;
    private String     productName;
    private String     description;
    private BigDecimal price;
    private int        stockQuantity;
    private String     imageUrl;
    private boolean    active;
    private Timestamp  createdAt;
    private Timestamp  updatedAt;

    private String     categoryName;

    public Product() { }

    public Product(int productId, int categoryId, String productName,
                   String description, BigDecimal price,
                   int stockQuantity, String imageUrl, boolean active) {
        this.productId     = productId;
        this.categoryId    = categoryId;
        this.productName   = productName;
        this.description   = description;
        this.price         = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl      = imageUrl;
        this.active        = active;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Product{" +
               "productId=" + productId +
               ", productName='" + productName + '\'' +
               ", price=" + price +
               ", stockQuantity=" + stockQuantity +
               '}';
    }
}
