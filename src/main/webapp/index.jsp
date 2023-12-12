<%@page import="connection.DbCon"%>
<%@page import="dao.ProductDao"%>
<%@page import="model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="fav_language" value="${not empty param.fav_language ? param.fav_language : not empty fav_language ? fav_language : session.request.locale}" scope="session"/>
<fmt:setLocale value="${fav_language}" scope="session"/>
<fmt:setBundle basename="com.example.i18n.messages"/>
<%
User auth = (User) request.getSession().getAttribute("auth");
if (auth != null) {
	request.setAttribute("person", auth);
}
ProductDao pd = new ProductDao(DbCon.getConnection());
List<Product> products = pd.getAllProducts();
request.setAttribute("products", products);
ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
if (cart_list != null) {
	request.setAttribute("cart_list", cart_list);
}
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/includes/head.jsp"%>
<title>E-Commerce Cart</title>
</head>
<body>
	


<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<div class="container">
		<a class="navbar-brand" href="index.jsp">E-Commerce Cart</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link" href="index.jsp"><fmt:message key="label.home"/></a></li>
				<li class="nav-item"><a class="nav-link" href="cart.jsp"><fmt:message key="label.cart"/>
						<span class="badge badge-danger">${cart_list.size()}</span>
				</a></li>
				<c:choose>
					<c:when test="${auth != null}">
						<li class="nav-item"><a class="nav-link" href="orders.jsp"><fmt:message key="label.order"/></a></li>
						<li class="nav-item"><a class="nav-link" href="log-out"><fmt:message key="label.logout"/></a></li>
					</c:when>
					<c:when test="${auth == null}">
						<li class="nav-item"><a class="nav-link" href="login.jsp"><fmt:message key="label.login"/></a></li>
						<li class="nav-item"><a class="nav-link" href="register.jsp"><fmt:message
										key="label.register" /></a></li>
					</c:when>
				</c:choose>
				<li class="nav-item"><a class="nav-link" href="#"><fmt:message key="label.lang"/></a>
					<form action="index.jsp" method="post">
						
						<select id="fav_language" name="fav_language" onchange="submit()">
								<option value="en" ${fav_language=="en"? 'selected' : ''}>English</option>
								<option value="vi" ${fav_language=="vi"? 'selected' : ''}>VietNam</option>
						</select>
					</form>
				</li>
			</ul>
		</div>
	</div>
</nav>

	<div class="container">
		<div class="card-header my-3"><fmt:message key="label.all-product"/></div>
		<div class="row">
			<c:if test="${!products.isEmpty()}"></c:if>
			<c:forEach var="p" items="${products}">
				<div class="col-md-3 my-3">
					<div class="card w-100">
						<img class="card-img-top" src="product-image/${p.image}"
							alt="Card image cap">
						<div class="card-body">
							<h5 class="card-title">${p.name}</h5>
							<h6 class="price"><fmt:message key="label.price"/>: $${p.price}</h6>
							<h6 class="category"><fmt:message key="label.category"/>: ${p.category}</h6>
							<div class="mt-3 d-flex justify-content-between">
								<a class="btn btn-dark" href="add-to-cart?id=${p.id}"><fmt:message key="label.add-to-cart"/></a> <a class="btn btn-primary"
									href="order-now?quantity=1&id=${p.id}"><fmt:message key="label.buy-now"/></a>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>

		</div>
	</div>

	<%@include file="/includes/footer.jsp"%>
</body>
</html>