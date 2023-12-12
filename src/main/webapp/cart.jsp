<%@page import="connection.DbCon"%>
<%@page import="dao.ProductDao"%>
<%@page import="model.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="fav_language"
	value="${not empty param.fav_language ? param.fav_language : not empty fav_language ? fav_language : session.request.locale}"
	scope="session" />
<fmt:setLocale value="${fav_language}" scope="session" />
<fmt:setBundle basename="com.example.i18n.messages" />
<%
DecimalFormat dcf = new DecimalFormat("#.##");
request.setAttribute("dcf", dcf);
User auth = (User) request.getSession().getAttribute("auth");
if (auth != null) {
	request.setAttribute("person", auth);
}
ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
List<Cart> cartProduct = null;
if (cart_list != null) {
	ProductDao pDao = new ProductDao(DbCon.getConnection());
	cartProduct = pDao.getCartProducts(cart_list);
	request.setAttribute("cartProduct", cartProduct);
	double total = pDao.getTotalCartPrice(cart_list);
	request.setAttribute("total", total);
	request.setAttribute("cart_list", cart_list);
}
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/includes/head.jsp"%>
<title>E-Commerce Cart</title>
<style type="text/css">
.table tbody td {
	vertical-align: middle;
}

.btn-incre, .btn-decre {
	box-shadow: none;
	font-size: 25px;
}
</style>
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
					<li class="nav-item"><a class="nav-link" href="index.jsp"><fmt:message
								key="label.home" /></a></li>
					<li class="nav-item"><a class="nav-link" href="cart.jsp"><fmt:message
								key="label.cart" /> <span class="badge badge-danger">${cart_list.size()}</span>
					</a></li>
					<c:choose>
						<c:when test="${auth != null}">
							<li class="nav-item"><a class="nav-link" href="orders.jsp"><fmt:message
										key="label.order" /></a></li>
							<li class="nav-item"><a class="nav-link" href="log-out"><fmt:message
										key="label.logout" /></a></li>
						</c:when>
						<c:when test="${auth == null}">
							<li class="nav-item"><a class="nav-link" href="login.jsp"><fmt:message
										key="label.login" /></a></li>
										<li class="nav-item"><a class="nav-link" href="register.jsp"><fmt:message
										key="label.register" /></a></li>
						</c:when>
					</c:choose>
					<li class="nav-item"><a class="nav-link" href="#"><fmt:message
								key="label.lang" /></a>
						<form action="cart.jsp" method="post">

							<select id="fav_language" name="fav_language" onchange="submit()">
								<option value="en" ${fav_language=="en"? 'selected' : ''}>English</option>
								<option value="vi" ${fav_language=="vi"? 'selected' : ''}>VietNam</option>
							</select>
						</form></li>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container my-3">
		<div class="d-flex py-3">
			<h3><fmt:message key="label.total-price"/>: $ ${(total>0)?dcf.format(total):0}</h3>
			<a class="mx-3 btn btn-primary" href="${auth!=null ? 'infoOrder.jsp' : 'login.jsp'}"><fmt:message key="label.order"/></a>
		</div>
		<table class="table table-light">
			<thead>
				<tr>
					<th scope="col"><fmt:message key="label.name"/></th>
					<th scope="col"><fmt:message key="label.category"/></th>
					<th scope="col"><fmt:message key="label.price"/></th>
					<th scope="col"><fmt:message key="label.buy-now"/></th>
					<th scope="col"><fmt:message key="label.cancel"/></th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${cart_list!=null}">
					<c:forEach var="c" items="${cartProduct}">
						<tr>
							<td>${c.name}</td>
							<td>${c.category}</td>
							<td>$${dcf.format(c.price)}</td>
							<td>
								<form action="order-now" method="post" class="form-inline">
									<input type="hidden" name="id" value="${c.id}"
										class="form-input">
									<div class="form-group d-flex justify-content-between">
										<a class="btn bnt-sm btn-incre"
											href="quantity-inc-dec?action=inc&id=${c.id}"><i
											class="fas fa-plus-square"></i> </a> <input type="text"
											name="quantity" class="form-control" value="${c.quantity}"
											readonly> <a class="btn btn-sm btn-decre"
											href="quantity-inc-dec?action=dec&id=${c.id}"> <i
											class="fas fa-minus-square"></i>
										</a>
									</div>
									<button type="submit" class="btn btn-primary btn-sm"><fmt:message key="label.buy"/></button>
								</form>
							</td>
							<td><a href="remove-from-cart?id=${c.id}"
								class="btn btn-sm btn-danger"><fmt:message key="label.remove"/></a></td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
	</div>

	<%@include file="/includes/footer.jsp"%>
</body>
</html>