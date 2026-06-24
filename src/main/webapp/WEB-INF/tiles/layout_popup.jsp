<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대산해수담수화</title>
<link rel="icon" type="image/x-icon"
	href="<%=request.getContextPath()%>/resources/images/com/favicon.png">

<script
	src="<%=request.getContextPath()%>/resources/js/jquery/jquery-3.5.1.min.js"></script>
<script
	src="<%=request.getContextPath()%>/resources/js/jquery/jquery.validate.min.js"></script>
<script
	src="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.min.js"></script>

<link rel="stylesheet"
	href="<%=request.getContextPath()%><tiles:getAsString name = "page_css"/>" />

<style>
.data-box .values .value .tit {
	min-width: 120px;
	text-wrap: wrap;
}

.data-box .values .value .value-arr {
	display: flex;
	column-gap: 5px;
	width: 90%
}
</style>
</head>
<body>
	<c:set var="URL"
		value="${requestScope['javax.servlet.forward.servlet_path']}" />
	<script>
		const dataObj = {
			popupSize: {
				"WJ" : [1820, 555],
				"SJ" : [1820, 600],
				"rest" : [1820, 980]
			},
			url: "${URL}"
		};

		function onChngProcsPop(value) {
			location.href = "/popup/db/" + value;
		};
	</script>
	<div class="dataground">
		<div class="sel-procs-box">
			<select id="selProc" onchange="onChngProcsPop(this.value);">
				<option value="CS"
					<c:if test="${URL eq '/popup/db/CS'}">selected</c:if>>취수구</option>
				<option value="WJ"
					<c:if test="${URL eq '/popup/db/WJ'}">selected</c:if>>원수저류조</option>
				<option value="DAF"
					<c:if test="${URL eq '/popup/db/DAF'}">selected</c:if>>전전처리(DAF)</option>
				<option value="DMGF"
					<c:if test="${URL eq '/popup/db/DMGF'}">selected</c:if>>전처리(DMGF)</option>
				<option value="RO"
					<c:if test="${URL eq '/popup/db/RO'}">selected</c:if>>RO(SW,BW)</option>
				<option value="SJ"
					<c:if test="${URL eq '/popup/db/SJ'}">selected</c:if>>생산수</option>
				<option value="PS"
					<c:if test="${URL eq '/popup/db/PS'}">selected</c:if>>폐수/탈수</option>
			</select>
		</div>
		<tiles:insertAttribute name="body" />
	</div>
</body>
</html>