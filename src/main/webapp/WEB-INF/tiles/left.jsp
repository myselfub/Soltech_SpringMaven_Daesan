<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<div class="menu-wrap">
	<div class="menu">
		<ul>
			<li>
				<a>
					<img src="<%=request.getContextPath()%>/resources/images/com/menu/db.png" alt="종합관제">
				</a>
				<ul class="submenu">
					<li>
						<a href="<%=request.getContextPath()%>/db0102">종합관제</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/db0103">시설현황</a>
					</li>
				</ul>
			</li>
			<li>
				<a>
					<img src="<%=request.getContextPath()%>/resources/images/com/menu/em.png" alt="에너지관리">
				</a>
				<ul class="submenu">
					<li>
						<a href="<%=request.getContextPath()%>/em0105">전체 전력 현황</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/em0103?procs=contents1">공정별 전력 현황</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/em0104">전력량 단가 관리</a>
					</li>
				</ul>
				</li>
			<li>
				<a>
				<img src="<%=request.getContextPath()%>/resources/images/com/menu/qm.png" alt="데이터품질관리">
				</a>
				<ul class="submenu">
					<li>
						<a href="<%=request.getContextPath()%>/qm0101">데이터 개별 보정</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/qm0103">데이터 일괄 보정</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/qm0102">데이터 보정 이력</a>
					</li>
				</ul>
			</li>
			<li>
				<%-- <a href="http://[SERVERIP]:8080" target="_blank">
					<img src="<%=request.getContextPath()%>/resources/images/com/menu/ai.png" alt="데이터품질관리">
				</a> --%>
				<a>
				<img src="<%=request.getContextPath()%>/resources/images/com/menu/ai.png" alt="데이터전처리">
				</a>
				<ul class="submenu">
					<li>
						<a href="<%=request.getContextPath()%>/ai0101">이벤트 정보 관리</a>
					</li>
					<li>
						<a href="<%=request.getContextPath()%>/ai0102">이벤트 정보 검색</a>
					</li>
					<!-- <li>
						<a href="<%=request.getContextPath()%>/ai0103">태그 분류 관리</a>
					</li> -->
					<li>
						<!-- ST -->
						<!-- <a href="http://121.141.75.226:10085/admin/home" onclick="window.open(this.href); return false;" rel="noopener noreferrer">관리자</a> -->
						<!-- DSAN -->
						<a href="http://[SERVERIP]:8080" onclick="window.open(this.href); return false;" rel="noopener noreferrer">관리자</a>
					</li>
				</ul>
			</li>
		</ul>
	</div>
</div>
