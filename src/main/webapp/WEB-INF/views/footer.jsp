<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</main>

<footer class="mt-auto py-8 bg-gray-900 text-gray-400 text-center text-sm border-t border-gray-800">
    <div class="max-w-7xl mx-auto px-5">
        <c:choose>
            <c:when test="${not empty applicationScope.storeConfig}">
                &copy; 2025 <c:out value="${applicationScope.storeConfig.storeName}"/> STORE.
                <c:if test="${not empty applicationScope.storeConfig.tagline}">
                    <br><span class="text-gray-500"><c:out value="${applicationScope.storeConfig.tagline}"/></span>
                </c:if>
            </c:when>
            <c:otherwise>&copy; 2025 COMMERCEBASE STORE.</c:otherwise>
        </c:choose>
        <div class="mt-4 pt-4 border-t border-gray-800 text-xs text-gray-500 flex justify-center items-center gap-2">
            <span>Built with Core Java</span> &bull;
            <span>Servlets</span> &bull;
            <span>JSP</span> &bull;
            <span>JDBC</span> &bull;
            <span>MySQL</span>
        </div>
    </div>
</footer>
</body>
</html>
