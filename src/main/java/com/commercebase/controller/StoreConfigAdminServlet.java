/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.StoreConfigDAO;
import com.commercebase.model.StoreConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/settings")
public class StoreConfigAdminServlet extends HttpServlet {

    private StoreConfigDAO storeConfigDAO;

    @Override
    public void init() {
        storeConfigDAO = new StoreConfigDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            StoreConfig config = storeConfigDAO.getActiveConfig();
            req.setAttribute("config", config);
            req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
        } catch (SQLException e) {
            System.err.println("[CommerceBase Admin] Error fetching store config: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            StoreConfig config = new StoreConfig();
            config.setConfigId(Integer.parseInt(req.getParameter("configId")));
            config.setStoreName(req.getParameter("storeName"));
            config.setLogoUrl(req.getParameter("logoUrl"));
            config.setThemeColor(req.getParameter("themeColor"));
            config.setTagline(req.getParameter("tagline"));
            config.setContactEmail(req.getParameter("contactEmail"));
            config.setCurrencyCode(req.getParameter("currencyCode"));

            storeConfigDAO.updateStoreConfig(config);

            getServletContext().setAttribute("storeConfig", config);

            resp.sendRedirect(req.getContextPath() + "/admin/settings?success=1");
        } catch (Exception e) {
            System.err.println("[CommerceBase Admin] Error updating store config: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
