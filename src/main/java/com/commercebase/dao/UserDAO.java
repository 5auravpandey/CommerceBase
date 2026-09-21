/* @author Saurav Pandey | CommerceBase */
package com.commercebase.dao;

import com.commercebase.model.User;
import com.commercebase.util.DBConnection;
import com.commercebase.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    private static final String SQL_AUTHENTICATE =
            "SELECT user_id, full_name, email, password_hash, phone, " +
            "       address, role, is_active, created_at, updated_at " +
            "FROM Users " +
            "WHERE email = ? AND password_hash = ? AND is_active = 1";

    private static final String SQL_GET_BY_ID =
            "SELECT user_id, full_name, email, password_hash, phone, " +
            "       address, role, is_active, created_at, updated_at " +
            "FROM Users WHERE user_id = ?";

    private static final String SQL_EMAIL_EXISTS =
            "SELECT COUNT(*) FROM Users WHERE email = ?";

    private static final String SQL_REGISTER =
            "INSERT INTO Users (full_name, email, password_hash, phone, address, role) " +
            "VALUES (?, ?, ?, ?, ?, 'Customer')";

    public User authenticateUser(String email, String password) throws SQLException {

        String hashedPassword = PasswordUtil.hashPassword(password);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_AUTHENTICATE)) {

            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public User getUserById(int userId) throws SQLException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws SQLException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_EMAIL_EXISTS)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean registerUser(User user) throws SQLException {

        String hashedPassword = PasswordUtil.hashPassword(user.getPasswordHash());

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_REGISTER)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());

            return ps.executeUpdate() > 0;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
}
