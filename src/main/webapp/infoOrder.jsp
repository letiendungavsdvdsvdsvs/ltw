<%@page import="model.*"%>
<%@page import="java.util.*"%>
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
User auth = (User) request.getSession().getAttribute("auth");

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
						<form action="infoOrder.jsp" method="post">

							<select id="fav_language" name="fav_language" onchange="submit()">
								<option value="en" ${fav_language=="en"? 'selected' : ''}>English</option>
								<option value="vi" ${fav_language=="vi"? 'selected' : ''}>VietNam</option>
							</select>
						</form></li>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
		<div class="card w-50 mx-auto my-5">
			<div class="card-header text-center">
				<fmt:message key="label.order" />
			</div>
			<div class="card-body">
				
				<form action="order-info" method="get">
					<div class="form-group">
						<label><fmt:message key="label.name" /></label> <input
							type="text" name="name" class="form-control"
							placeholder="<fmt:message key="label.name"/>" required="required">
					</div>
					<div class="form-group">
						<label><fmt:message key="label.phonenumber" /></label> <input
							type="text" name="phonenumber" class="form-control"
							placeholder="<fmt:message key="label.phonenumber"/>" required="required">
					</div>
					<div class="form-group">
						<label><fmt:message key="label.address" /></label> <input
							type="text" name="address" class="form-control"
							placeholder="<fmt:message key="label.address"/>" required="required">
					</div>
					<div class="text-center">
						<button type="submit" class="btn btn-primary">
							<fmt:message key="label.order" />
						</button>
					</div>
				</form>

			</div>
		</div>
	</div>

	<%@include file="/includes/footer.jsp"%>
</body>
</html>