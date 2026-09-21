/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.ProductDAO;
import com.commercebase.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/products/manage")
public class ProductAdminServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Product p = productDAO.getProductById(id);
                req.setAttribute("product", p);
                req.setAttribute("categories", productDAO.getAllCategories());
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
            } else if ("add".equals(action)) {
                req.setAttribute("categories", productDAO.getAllCategories());
                req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
            } else {
                List<Product> products = productDAO.getAllProductsForAdmin();
                req.setAttribute("products", products);
                req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            System.err.println("[CommerceBase Admin] Error in product management GET: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                productDAO.deleteProduct(id);
                resp.sendRedirect(req.getContextPath() + "/admin/products/manage");
                return;
            }

            Product p = new Product();
            p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            p.setProductName(req.getParameter("productName"));
            p.setDescription(req.getParameter("description"));
            p.setPrice(new BigDecimal(req.getParameter("price")));
            p.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
            p.setImageUrl(req.getParameter("imageUrl"));
            p.setActive(req.getParameter("isActive") != null);

            if ("add".equals(action)) {
                productDAO.insertProduct(p);
            } else if ("update".equals(action)) {
                p.setProductId(Integer.parseInt(req.getParameter("productId")));
                productDAO.updateProduct(p);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/products/manage");
        } catch (Exception e) {
            System.err.println("[CommerceBase Admin] Error in product management POST: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
