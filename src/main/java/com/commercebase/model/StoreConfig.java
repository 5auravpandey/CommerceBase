/* @author Saurav Pandey | CommerceBase */
package com.commercebase.model;

import java.sql.Timestamp;

public class StoreConfig {

    private int       configId;
    private String    storeName;
    private String    logoUrl;
    private String    themeColor;
    private String    tagline;
    private String    contactEmail;
    private String    currencyCode;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public StoreConfig() { }

    public StoreConfig(int configId, String storeName, String logoUrl,
                       String themeColor, String tagline,
                       String contactEmail, String currencyCode) {
        this.configId     = configId;
        this.storeName    = storeName;
        this.logoUrl      = logoUrl;
        this.themeColor   = themeColor;
        this.tagline      = tagline;
        this.contactEmail = contactEmail;
        this.currencyCode = currencyCode;
    }

    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public String getThemeColor() {
        return themeColor;
    }

    public void setThemeColor(String themeColor) {
        this.themeColor = themeColor;
    }

    public String getTagline() {
        return tagline;
    }

    public void setTagline(String tagline) {
        this.tagline = tagline;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
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
        return "StoreConfig{" +
               "configId=" + configId +
               ", storeName='" + storeName + '\'' +
               ", themeColor='" + themeColor + '\'' +
               ", currencyCode='" + currencyCode + '\'' +
               '}';
    }
}
