/* @author Saurav Pandey | CommerceBase */
package com.commercebase.filter;

import com.commercebase.dao.StoreConfigDAO;
import com.commercebase.model.StoreConfig;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.sql.SQLException;

@WebFilter(filterName = "StoreConfigFilter", urlPatterns = "/*")
public class StoreConfigFilter implements Filter {

    public static final String STORE_CONFIG_KEY = "storeConfig";

    private volatile boolean configLoaded = false;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        ServletContext ctx = httpReq.getServletContext();

        if (!configLoaded) {
            synchronized (this) {
                if (!configLoaded) {
                    try {
                        StoreConfigDAO dao = new StoreConfigDAO();
                        StoreConfig config = dao.getActiveConfig();

                        if (config != null) {
                            ctx.setAttribute(STORE_CONFIG_KEY, config);
                            System.out.println("[CommerceBase Branding] Store config loaded: " + config.getStoreName());
                        } else {
                            System.out.println("[CommerceBase Branding] No store config found in database, using defaults.");
                        }
                        configLoaded = true;

                    } catch (SQLException e) {
                        System.err.println("[CommerceBase Branding] Failed to load store config: " + e.getMessage());
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
