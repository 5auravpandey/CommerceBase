/* @author Saurav Pandey | CommerceBase */
package com.commercebase.controller;

import com.commercebase.dao.ProductDAO;
import com.commercebase.model.Category;
import com.commercebase.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = "/products")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String productIdParam = request.getParameter("id");

            if (productIdParam != null && !productIdParam.isEmpty()) {
                showProductDetail(request, response, productIdParam);
                return;
            }

            showProductList(request, response);

        } catch (SQLException e) {
            System.err.println("[CommerceBase Catalog] Catalog query failed — database error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "Unable to load products. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/products.jsp")
                   .forward(request, response);
        }
    }

    private void showProductList(HttpServletRequest request,
                                 HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        String categoryParam = request.getParameter("category");
        String searchParam   = request.getParameter("search");

        List<Product> products;

        if (searchParam != null && !searchParam.trim().isEmpty()) {
            products = productDAO.searchProducts(searchParam.trim());
            request.setAttribute("searchKeyword", searchParam.trim());

        } else if (categoryParam != null && !categoryParam.isEmpty()) {
            int categoryId = Integer.parseInt(categoryParam);
            products = productDAO.getProductsByCategory(categoryId);
            request.setAttribute("selectedCategoryId", categoryId);

        } else {
            products = productDAO.getAllProducts();
        }

        List<Category> categories = productDAO.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/views/products.jsp")
               .forward(request, response);
    }

    private void showProductDetail(HttpServletRequest request,
                                   HttpServletResponse response,
                                   String productIdParam)
            throws SQLException, ServletException, IOException {

        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                request.setAttribute("errorMessage", "Product not found.");
                showProductList(request, response);
                return;
            }

            request.setAttribute("product", product);
            request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid product ID.");
            showProductList(request, response);
        }
    }
}
