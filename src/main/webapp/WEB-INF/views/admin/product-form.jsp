<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../header.jsp" />

<div class="w-full max-w-3xl mx-auto">
    <div class="bg-gray-50 rounded-md shadow-sm p-6 sm:p-8">
        <h2 class="text-2xl font-semibold text-gray-900 mb-6">
            <c:choose>
                <c:when test="${not empty product}">Edit Product</c:when>
                <c:otherwise>Add Product</c:otherwise>
            </c:choose>
        </h2>
        
        <form action="${pageContext.request.contextPath}/admin/products/manage" method="post" class="space-y-6">
            <input type="hidden" name="action" value="${not empty product ? 'update' : 'add'}">
            <c:if test="${not empty product}">
                <input type="hidden" name="productId" value="${product.productId}">
            </c:if>
            
            <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">
                <div class="sm:col-span-2">
                    <label for="productName" class="block text-sm font-medium text-gray-700">Product Name</label>
                    <input type="text" name="productName" id="productName" value="<c:out value="${product.productName}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>

                <div class="sm:col-span-2">
                    <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea name="description" id="description" rows="3" required
                              class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm"><c:out value="${product.description}"/></textarea>
                </div>
                
                <div>
                    <label for="categoryId" class="block text-sm font-medium text-gray-700">Category</label>
                    <select name="categoryId" id="categoryId" required
                            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${product.categoryId == c.categoryId ? 'selected' : ''}>
                                <c:out value="${c.categoryName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="price" class="block text-sm font-medium text-gray-700">Price</label>
                    <input type="number" step="0.01" name="price" id="price" value="<c:out value="${product.price}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                
                <div>
                    <label for="stockQuantity" class="block text-sm font-medium text-gray-700">Stock Quantity</label>
                    <input type="number" name="stockQuantity" id="stockQuantity" value="<c:out value="${product.stockQuantity}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>

                <div>
                    <label for="imageUrl" class="block text-sm font-medium text-gray-700">Image URL</label>
                    <input type="text" name="imageUrl" id="imageUrl" value="<c:out value="${product.imageUrl}"/>"
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                
                <div class="sm:col-span-2 flex items-center">
                    <input type="checkbox" name="isActive" id="isActive" value="true" ${empty product or product.active ? 'checked' : ''}
                           class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500">
                    <label for="isActive" class="ml-2 block text-sm text-gray-900">Active</label>
                </div>
            </div>

            <div class="pt-4 flex justify-end space-x-3">
                <a href="${pageContext.request.contextPath}/admin/products/manage" class="inline-flex justify-center rounded-md border border-gray-300 bg-white py-2 px-4 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2">
                    Cancel
                </a>
                <button type="submit" class="inline-flex justify-center rounded-md border border-transparent py-2 px-4 text-sm font-medium text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2" style="background-color: ${fn:escapeXml(storeConfig.themeColor)};">
                    Save Product
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../footer.jsp" />
