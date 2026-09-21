/* @author Saurav Pandey | CommerceBase */
package com.commercebase.dao;

import com.commercebase.model.Category;
import com.commercebase.model.Product;
import com.commercebase.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String SQL_GET_ALL_PRODUCTS =
            "SELECT p.product_id, p.category_id, p.product_name, " +
            "       p.description, p.price, p.stock_quantity, " +
            "       p.image_url, p.is_active, p.created_at, p.updated_at, " +
            "       c.category_name " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.category_id = c.category_id " +
            "WHERE p.is_active = 1 " +
            "ORDER BY p.created_at DESC";

    private static final String SQL_GET_PRODUCTS_BY_CATEGORY =
            "SELECT p.product_id, p.category_id, p.product_name, " +
            "       p.description, p.price, p.stock_quantity, " +
            "       p.image_url, p.is_active, p.created_at, p.updated_at, " +
            "       c.category_name " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.category_id = c.category_id " +
            "WHERE p.is_active = 1 AND p.category_id = ? " +
            "ORDER BY p.created_at DESC";

    private static final String SQL_GET_PRODUCT_BY_ID =
            "SELECT p.product_id, p.category_id, p.product_name, " +
            "       p.description, p.price, p.stock_quantity, " +
            "       p.image_url, p.is_active, p.created_at, p.updated_at, " +
            "       c.category_name " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.category_id = c.category_id " +
            "WHERE p.product_id = ?";

    private static final String SQL_SEARCH_PRODUCTS =
            "SELECT p.product_id, p.category_id, p.product_name, " +
            "       p.description, p.price, p.stock_quantity, " +
            "       p.image_url, p.is_active, p.created_at, p.updated_at, " +
            "       c.category_name " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.category_id = c.category_id " +
            "WHERE p.is_active = 1 " +
            "  AND (p.product_name LIKE ? OR p.description LIKE ?) " +
            "ORDER BY p.created_at DESC";

    private static final String SQL_INSERT_PRODUCT =
            "INSERT INTO Products (category_id, product_name, description, price, stock_quantity, image_url, is_active) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE_PRODUCT =
            "UPDATE Products SET category_id = ?, product_name = ?, description = ?, price = ?, stock_quantity = ?, image_url = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP " +
            "WHERE product_id = ?";

    private static final String SQL_DELETE_PRODUCT =
            "DELETE FROM Products WHERE product_id = ?";

    private static final String SQL_GET_ALL_CATEGORIES =
            "SELECT category_id, category_name, description, created_at " +
            "FROM Categories ORDER BY category_name ASC";

    private static final String SQL_GET_ALL_PRODUCTS_ADMIN =
            "SELECT p.product_id, p.category_id, p.product_name, " +
            "       p.description, p.price, p.stock_quantity, " +
            "       p.image_url, p.is_active, p.created_at, p.updated_at, " +
            "       c.category_name " +
            "FROM Products p " +
            "LEFT JOIN Categories c ON p.category_id = c.category_id " +
            "ORDER BY p.created_at DESC";

    public void insertProduct(Product p) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT_PRODUCT)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setString(6, p.getImageUrl());
            ps.setBoolean(7, p.isActive());
            ps.executeUpdate();
        }
    }

    public void updateProduct(Product p) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_PRODUCT)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStockQuantity());
            ps.setString(6, p.getImageUrl());
            ps.setBoolean(7, p.isActive());
            ps.setInt(8, p.getProductId());
            ps.executeUpdate();
        }
    }

    public void deleteProduct(int productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE_PRODUCT)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    public List<Product> getAllProducts() throws SQLException {

        List<Product> products = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_PRODUCTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(mapProductRow(rs));
            }
        }
        return products;
    }

    public List<Product> getAllProductsForAdmin() throws SQLException {

        List<Product> products = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_PRODUCTS_ADMIN);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(mapProductRow(rs));
            }
        }
        return products;
    }

    public List<Product> getProductsByCategory(int categoryId) throws SQLException {

        List<Product> products = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_PRODUCTS_BY_CATEGORY)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProductRow(rs));
                }
            }
        }
        return products;
    }

    public Product getProductById(int productId) throws SQLException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_PRODUCT_BY_ID)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProductRow(rs);
                }
            }
        }
        return null;
    }

    public List<Product> searchProducts(String keyword) throws SQLException {

        List<Product> products = new ArrayList<>();
        String pattern = "%" + keyword + "%";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_SEARCH_PRODUCTS)) {

            ps.setString(1, pattern);
            ps.setString(2, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProductRow(rs));
                }
            }
        }
        return products;
    }

    public List<Category> getAllCategories() throws SQLException {

        List<Category> categories = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_CATEGORIES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setCategoryName(rs.getString("category_name"));
                cat.setDescription(rs.getString("description"));
                cat.setCreatedAt(rs.getTimestamp("created_at"));
                categories.add(cat);
            }
        }
        return categories;
    }

    private Product mapProductRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setProductName(rs.getString("product_name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setImageUrl(rs.getString("image_url"));
        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }
}
