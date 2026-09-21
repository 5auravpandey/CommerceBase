/* @author Saurav Pandey | CommerceBase */
package com.commercebase.model;

import java.sql.Timestamp;

public class User {

    private int       userId;
    private String    fullName;
    private String    email;
    private String    passwordHash;
    private String    phone;
    private String    address;
    private String    role;
    private boolean   active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() { }

    public User(int userId, String fullName, String email,
                String passwordHash, String phone, String address,
                String role, boolean active) {
        this.userId       = userId;
        this.fullName     = fullName;
        this.email        = email;
        this.passwordHash = passwordHash;
        this.phone        = phone;
        this.address      = address;
        this.role         = role;
        this.active       = active;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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

    public boolean isAdmin() {
        return "Admin".equalsIgnoreCase(role);
    }

    @Override
    public String toString() {
        return "User{" +
               "userId=" + userId +
               ", fullName='" + fullName + '\'' +
               ", email='" + email + '\'' +
               ", role='" + role + '\'' +
               ", active=" + active +
               '}';
    }
}
