/* @author Saurav Pandey | CommerceBase */
package com.commercebase.dao;

import com.commercebase.model.StoreConfig;
import com.commercebase.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StoreConfigDAO {

    private static final String SQL_GET_ACTIVE_CONFIG =
            "SELECT config_id, store_name, logo_url, theme_color, " +
            "       tagline, contact_email, currency_code, " +
            "       created_at, updated_at " +
            "FROM StoreConfig ORDER BY config_id ASC LIMIT 1";

    private static final String SQL_UPDATE_CONFIG =
            "UPDATE StoreConfig SET store_name = ?, logo_url = ?, theme_color = ?, " +
            "tagline = ?, contact_email = ?, currency_code = ?, updated_at = CURRENT_TIMESTAMP " +
            "WHERE config_id = ?";

    public StoreConfig getActiveConfig() throws SQLException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ACTIVE_CONFIG);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    public void updateStoreConfig(StoreConfig config) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_CONFIG)) {
            ps.setString(1, config.getStoreName());
            ps.setString(2, config.getLogoUrl());
            ps.setString(3, config.getThemeColor());
            ps.setString(4, config.getTagline());
            ps.setString(5, config.getContactEmail());
            ps.setString(6, config.getCurrencyCode());
            ps.setInt(7, config.getConfigId());
            ps.executeUpdate();
        }
    }

    private StoreConfig mapRow(ResultSet rs) throws SQLException {
        StoreConfig config = new StoreConfig();
        config.setConfigId(rs.getInt("config_id"));
        config.setStoreName(rs.getString("store_name"));
        config.setLogoUrl(rs.getString("logo_url"));
        config.setThemeColor(rs.getString("theme_color"));
        config.setTagline(rs.getString("tagline"));
        config.setContactEmail(rs.getString("contact_email"));
        config.setCurrencyCode(rs.getString("currency_code"));
        config.setCreatedAt(rs.getTimestamp("created_at"));
        config.setUpdatedAt(rs.getTimestamp("updated_at"));
        return config;
    }
}
